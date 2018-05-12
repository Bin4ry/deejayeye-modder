package og.patch;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import og.patch.HGTTile;

import java.lang.Thread;
import java.lang.String;
import java.lang.Integer;
import java.lang.Double;
import java.lang.Float;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Date;
import java.text.SimpleDateFormat;

import java.io.IOException;

import java.io.*;
import java.nio.*;

import java.util.zip.ZipFile;
import java.util.zip.ZipEntry;

import java.util.logging.Logger;
import java.util.logging.Handler;
import java.util.logging.FileHandler;
import java.util.Locale;

public class DTM {

    public static DTM m_Instance = null;
    public static String ms_settings_path = "/mnt/sdcard/DJI/dtm.settings.json";
    //public static String ms_settings_path = "settings.json";

    private boolean m_DoLogging = false;
    private float m_AltitudeOffset = 0.0f;
    private int m_AlgoChoice = 3;
/*
    1 st : Initial Offset Averaging Count
    2 nd : Max allowed difference "ultrasonic vs. DTM" (quality filter) (meters) for quality 1 (tight requierement)
    3 rd : Max allowed difference "ultrasonic vs. DTM" (quality filter) (meters) for quality 2 (relaxed requierement)
    4 th : Safety Margin a static offset substracted to the displayed value so you're always a little higher than you think
           (Unless you set a negative value and then you'll have a displayed value greater than reality. May be usefull if you
           have a ATM area above you starting at a given height) (meters)
    5 th : Max radius around home where ultrasonic/Ultrasonic sensor for some tests (meters)
    6 th : Max delta height to consider that ultrasonic/Ultrasonic sensor can be valid when close to Home (meters)
    7 th : Time threshold for Ultrasonic valid in a row to consider it reliable (ms)
*/

    private float[] m_AlgoParams = { 30.0f, 5.0f, 15.0f, 3.0f, 50.0f, 20.0f, 3500.0f }; //  Preset default for Algo 3
    private String[] m_DTM_tiles_paths = null;
    private HGTTile[] m_Tiles = null;

    private ArrayList<Float> m_OffsetCalibrationValues = null;
    private int m_CallCounter = 0;

    private Logger m_logger = null;

    private String m_ResultType = null;
    private long m_LastultrasonicValidTime = -1;

    private DTM() {
    }

    public static DTM getInstance() throws IOException {
        if (DTM.m_Instance == null) {
		    GsonBuilder builder = new GsonBuilder();
		    Gson gson = builder.create();

            long fileSize = new File(DTM.ms_settings_path).length();

            FileInputStream settings = new FileInputStream(DTM.ms_settings_path);
            byte[] data = new byte[(int)fileSize];
            int n = settings.read(data);

            String content = new String(data,"ISO-8859-1");

            DTM.m_Instance = gson.fromJson(content, DTM.class);

            DTM.m_Instance.m_OffsetCalibrationValues = new ArrayList<Float>();

            //  Load actual tiles data
            int n_tiles = DTM.m_Instance.getDTMTilesPaths().length;
            DTM.m_Instance.m_Tiles = new HGTTile[n_tiles];
            for(int index=0;index<n_tiles;++index) {
                 DTM.m_Instance.m_Tiles[index] = new HGTTile(DTM.m_Instance.getDTMTilesPaths()[index]);
            }

            if (DTM.m_Instance.m_DoLogging) {
                SimpleDateFormat formater = null;
                Date now = new Date();
                formater = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
                FileHandler fh;   
                fh = new FileHandler("/mnt/sdcard/DJI/og_logs/DTM-"+formater.format(now).toString()+".log");
                //fh = new FileHandler("DTM-"+formater.format(now).toString()+".log");
                DTM.m_Instance.m_logger = Logger.getLogger(DTM.class.getName());
                DTM.m_Instance.m_logger.addHandler(fh);
                DTM.m_Instance.m_logger.setUseParentHandlers(false);
            }
        }

        DTM.m_Instance.m_OffsetCalibrationValues.clear();
        DTM.m_Instance.m_CallCounter = 0;

        return DTM.m_Instance;
    }

    public static void close() {
        if (DTM.m_Instance != null && DTM.m_Instance.m_logger != null) {
            DTM.m_Instance.m_DoLogging = false;
            for(Handler h:DTM.m_Instance.m_logger.getHandlers())  {
               h.flush();
               h.close();
            }
        }
    }

    public String appendResultTypeToUnit(String unitStr) {
        StringBuilder sb = new StringBuilder();
        sb.append(unitStr);
        if (this.m_ResultType != null) {
            sb.append(this.m_ResultType);
        }
        return sb.toString();
    }

    public boolean getDoLogging() {
        return this.m_DoLogging;
    }

    public void setDoLogging(boolean doLog) {
        this.m_DoLogging = doLog;
    }

    public float getAltitudeOffset() {
        return this.m_AltitudeOffset;
    }

    public void setAltitudeOffset(float offset) {
        this.m_AltitudeOffset = offset;
    }

    public int getAlgoChoice() {
        return this.m_AlgoChoice;
    }

    public void setAlgoChoice(int choice) {
        this.m_AlgoChoice = choice;
    }

    public float[] getAlgoParams() {
        return this.m_AlgoParams;
    }

    public void setAlgoParams(float[] params) {
            this.m_AlgoParams = params;
    }

    public String[] getDTMTilesPaths() {
        return this.m_DTM_tiles_paths;
    }

    public void setDTMTilesPaths(String[] paths) {
            this.m_DTM_tiles_paths = paths;
    }

    public float getDTM_HAGL(double latDeg, double lonDeg) {
       if (Double.isNaN(latDeg) || Double.isNaN(lonDeg)) {
            return 0.0f;
       } else {
            float res = 0.0f;
            for(HGTTile tile : this.m_Tiles) {
                if (tile.isPointInTile(latDeg,lonDeg)) {
                    res = tile.getAltAtLatLng(latDeg,lonDeg);
                    break;
                }
            }
            return res;
       }
    }

/*
    This is the method called from either :
    - classes5/fpv/view/SimpleAttitudeView.smali (Spark)
    - classes5/newfpv/view/WholeAttitudeView.smali (Mavic, P4)

    to refresh the "altitude" displayed value within GO4 app

    This method will only act as a routing to a specific algo depending on the value found inside DJI/settings.json
    This allows having several methods and being able to switch on the field.

    On Spark, the existing logics is handled by classes5/fpv/view/SimpleAttitudeView.smali method j() ,
    which is called from method i(). i() is calling i nthat order j(), k(), l()
    j() is dealing with height / altitude stuff
    k() is dealing with velocity
    l() is dealing with satellite count, max distance, Home and Aircraft positions

    On Mavic / P4, the existing logics will always switch to ultrasonic when available (could be changed in
    classes5/newfpv/view/WholeAttitudeView.smali, methods involved are m() and k() both called from j() in this order :
        m(), l(), n(), k()
    k() is dealing with ultrasonic / ultrasonic values and is called last so will "override" the result from m()
    l() is dealing with velocities
    n() is dealing with satellite count, max distance, Home and Aircraft positions
    
    still this method will be called allowing (e.g. to calibrate some offset between the different existing values)
*/
    public float getAircraft_HAGL(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {
        float result = 0.0f;
        switch (this.m_AlgoChoice) {
            case 3:
                result = getAircraft_HAGL_algo3(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
                break;

            case 2:
                result = getAircraft_HAGL_algo2(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
                break;

            case 1:
                result = getAircraft_HAGL_algo1(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
                break;

            case 0:
                result = getAircraft_HAGL_algo0(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
                break;

            default:
                result = getAircraft_HAGL_algo0(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
                break;
        }

        if (m_DoLogging) {
            this.m_logger.info(String.format(Locale.US, "%.12f %.12f %.12f %.12f %.3f %.3f %b result = %.3f", aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse,result));
        }

        return result;
    }

/*
    Algo 0 : Behave as DJI default implementation
*/
    public float getAircraft_HAGL_algo0(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {
        if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {
            this.m_ResultType = "-AGL";
            return ultrasonicHeight;
        } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude))  {
            //  If ultrasonic sensor is not providing data, then switch to the delta_altitude value
            this.m_ResultType = "-QFE";
            return delta_altitude;
        } else {
            this.m_ResultType = "-err";
            return 0.0f;
        }
    }

/*
    Algo 1 : Reset offset as soon as an ultrasonic measurement is available
    was first trial...
    May work properly if not flying close to vegetation (where ultrasonic measurement would set a wrong offset)
    Is probably not very robust to "isolated" ultrasonic measurement

    DO NOT USE BECAUSE VERY SENSITIVE TO OUTLIER ULTRASONIC MEASUREMENTS
    WILL BE REMOVED SOON    

*/
    public float getAircraft_HAGL_algo1(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {

       if (Double.isNaN(aircraftLatDeg) || Double.isNaN(aircraftLngDeg) || Double.isNaN(homeLngDeg) || Double.isNaN(delta_altitude) )  {

            //  At least one of Aircraft of HomePoint does not have position... use FC provided data "as is"
            //  as there is no mean to access the height above DTM values without valid positions for both AC and Home
            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight)) {
                this.m_ResultType = "-AGL";
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude)) {
                this.m_ResultType = "-QFE";
                return delta_altitude;
            } else {
                this.m_ResultType = "-err";
                return 0.0f;
            }

       } else {

            //  Aircraft and HomePoint have positions, let's try to use them on DTM
            float dtm_height_at_home = this.getDTM_HAGL(homeLatDeg,homeLngDeg);
            float dtm_height_at_aircraft = this.getDTM_HAGL(aircraftLatDeg,aircraftLngDeg);

            float aircraft_hAGL_from_dtm = delta_altitude - ( dtm_height_at_aircraft - dtm_height_at_home );

            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {
                //  Still use ultrasonic if available
                //  Compute offset to "dtm computations" as long as we have ultrasonic data to compare, so we get smooth transition and correct local bias
                if (!Float.isNaN(aircraft_hAGL_from_dtm)) {
                    this.setAltitudeOffset(ultrasonicHeight - aircraft_hAGL_from_dtm);
                }
                this.m_ResultType = "-AGL";
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude))  {
                //  If ultrasonic sensor is not providing data, then switch to the DTM computed height
                this.m_ResultType = "-DTM";
                return Math.max(0.0f, aircraft_hAGL_from_dtm + this.getAltitudeOffset());
            } else {
                this.m_ResultType = "-err";
                return 0.0f;
            }
        }
    }

/*
    Algo 2 :
    Algo Params (from settings.json)
    1 st : Initial Offset Averaging Count
    2 nd : Max allowed difference "ultrasonic vs. DTM" (quality filter)
    3 rd : Safety Margin a static offset substracted to the displayed value so you're always a little higher than you think
           (Unless you set a negative value and then you'll have a displayed value greater than reality. May be usefull if you
           have a ATM area above you starting at a given height)

    This version will calibrate an offset only at take off for a few values and then this value will not be changed anymore
    
*/
    public float getAircraft_HAGL_algo2(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {

       if (Double.isNaN(aircraftLatDeg) || Double.isNaN(aircraftLngDeg) || Double.isNaN(homeLngDeg) || Double.isNaN(delta_altitude))  {

            //  At least one of Aircraft of HomePoint does not have position... use FC provided data "as is"
            //  as there is no mean to access the height above DTM values without valid positions for both AC and Home
            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {
                this.m_ResultType = "-AGL";
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude)) {
                this.m_ResultType = "-QFE";
                return delta_altitude;
            } else {
                this.m_ResultType = "-err";
                return 0.0f;
            }

       } else {

            //  Aircraft and HomePoint have positions, let's try to use them on DTM
            float dtm_height_at_home = this.getDTM_HAGL(homeLatDeg,homeLngDeg);
            float dtm_height_at_aircraft = this.getDTM_HAGL(aircraftLatDeg,aircraftLngDeg);

            float aircraft_hAGL_from_dtm = delta_altitude - ( dtm_height_at_aircraft - dtm_height_at_home );
            float delta_DTM_ultrasonic = ultrasonicHeight - aircraft_hAGL_from_dtm;
            float absdelta_DTM_ultrasonic = Math.abs(delta_DTM_ultrasonic);

            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {
                //  Ultrasonic data is available and seems valid, let's use it to calibrate an initial offset
                //  Compute offset to "dtm computations" as long as we have ultrasonic data to compare, and error to "DTM" height is within acceptable error margin
                //  This should prevent later "sporadic" ultrasonic measurements from influencing the computations
                if (!Float.isNaN(aircraft_hAGL_from_dtm) && absdelta_DTM_ultrasonic <= this.m_AlgoParams[1] ) {
                    if (this.m_OffsetCalibrationValues.size() < (int)(this.m_AlgoParams[0]) )   {
                        this.m_OffsetCalibrationValues.add(new Float(delta_DTM_ultrasonic));
                        Float offset = new Float(0.0f);                        
                        for(Float elem : this.m_OffsetCalibrationValues) {
                            offset += elem;
                        }
                        offset /= new Float(this.m_OffsetCalibrationValues.size());
                        this.setAltitudeOffset(offset.floatValue());
                    } 
                }
                //  Still returns ultrasonicHeight if it here and valid
                this.m_ResultType = "-AGL";
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(aircraft_hAGL_from_dtm))  {
                //  If ultrasonic sensor is not providing data, then switch to the DTM computed height
                this.m_ResultType = "-DTM";
                return Math.max(0.0f, aircraft_hAGL_from_dtm + this.getAltitudeOffset() - this.m_AlgoParams[2]);
            } else {
                this.m_ResultType = "-err";
                return 0.0f;
            }
        }
    }

/*
    Algo 3 : Evolution of Algo2 trying to filter out wrong ultrasonic measurements
    Algo Params (from settings.json)

    1 st : Initial Offset Averaging Count
    2 nd : Max allowed difference "ultrasonic vs. DTM" (quality filter) (meters) for quality 1 (tight requierement)
    3 rd : Max allowed difference "ultrasonic vs. DTM" (quality filter) (meters) for quality 2 (relaxed requierement)
    4 th : Safety Margin a static offset substracted to the displayed value so you're always a little higher than you think
           (Unless you set a negative value and then you'll have a displayed value greater than reality. May be usefull if you
           have a ATM area above you starting at a given height) (meters)
    5 th : Max radius around home where ultrasonic/Ultrasonic sensor for some tests (meters)
    6 th : Max delta height to consider that ultrasonic/Ultrasonic sensor can be valid when close to Home (meters)
    7 th : Time threshold for Ultrasonic valid in a row to consider it reliable (ms)
*/
    public float getAircraft_HAGL_algo3(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {

       //  Calculate time since the ultrasonic / Ultrasonic sensor has been declared valid by FC.
       long now = System.currentTimeMillis();
       long ultrasonic_is_valid_since_ms = 0;

       if (isUltrasonicInUse && this.m_LastultrasonicValidTime == -1 && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight >= 0.0f) {
            this.m_LastultrasonicValidTime = now;
       } else if (isUltrasonicInUse && this.m_LastultrasonicValidTime >= 0 && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight >= 0.0f) {
            ultrasonic_is_valid_since_ms = now - this.m_LastultrasonicValidTime;
       } else {
            this.m_LastultrasonicValidTime = -1;
       } 

       if (Double.isNaN(aircraftLatDeg) || Double.isNaN(aircraftLngDeg) || Double.isNaN(homeLngDeg) || Double.isNaN(delta_altitude))  {

            //  At least one of Aircraft of HomePoint does not have position... use FC provided data "as is"
            //  as there is no mean to access the height above DTM values without valid positions for both AC and Home
            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f && ultrasonic_is_valid_since_ms > (long)(0.3*this.m_AlgoParams[6])) {
                this.m_ResultType = "-AGL";
                return ultrasonicHeight;
            } else if (!Float.isNaN(delta_altitude)) {
                this.m_ResultType = "-QFE";
                return delta_altitude;
            } else {
                this.m_ResultType = "-err";
                return 0.0f;
            }

       } else {

            //  Aircraft and HomePoint have positions, let's try to use them on DTM

            float dtm_height_at_home = this.getDTM_HAGL(homeLatDeg,homeLngDeg);
            float dtm_height_at_aircraft = this.getDTM_HAGL(aircraftLatDeg,aircraftLngDeg);
            float aircraft_hAGL_from_dtm = Math.max(0.0f, delta_altitude - ( dtm_height_at_aircraft - dtm_height_at_home ));
            //float corr_ultrasonicHeigth = Math.max(0.0f,ultrasonicHeight) ;
            float delta_DTM_ultrasonic = ultrasonicHeight - aircraft_hAGL_from_dtm;

            float absdelta_DTM_ultrasonic = Math.abs(delta_DTM_ultrasonic);
            float absdelta_QFE_ultrasonic = Math.abs(ultrasonicHeight - delta_altitude);

            double pseudodist = this.pseudo_dist(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg);
            boolean isCloseToHome = (pseudodist < (double)this.m_AlgoParams[4]);

            boolean isCalibrated = (this.m_OffsetCalibrationValues.size() == (int)(this.m_AlgoParams[0]));

            boolean test_Q1 = !Float.isNaN(aircraft_hAGL_from_dtm) && !Float.isNaN(delta_DTM_ultrasonic) && !Float.isNaN(delta_altitude) &&
                              (absdelta_DTM_ultrasonic <= this.m_AlgoParams[1] ||
                               absdelta_QFE_ultrasonic <= this.m_AlgoParams[1]);

            boolean test_Q2 = !Float.isNaN(aircraft_hAGL_from_dtm) && !Float.isNaN(delta_DTM_ultrasonic) && !Float.isNaN(delta_altitude) &&
                              (absdelta_DTM_ultrasonic <= this.m_AlgoParams[2] ||
                               absdelta_QFE_ultrasonic <= this.m_AlgoParams[2]);

            //  Ultrasonic basic filter : don't try to use an obvisously invalid value as AGL sensor source
            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {

                // If not calibrated and tight requierements are met, then use this point for calib
                if (!isCalibrated && test_Q1) {
                    addCalibrationPoint(aircraft_hAGL_from_dtm,delta_DTM_ultrasonic);
                }

                // We're close to home, at low QFE alt
                if (isCloseToHome && !Float.isNaN(delta_altitude) && Math.abs(delta_altitude) < this.m_AlgoParams[5]) {

                    //  Use AGL sensor anyway in those conditions
                    this.m_ResultType = "-AGL";
                    return ultrasonicHeight;
                }
                
                boolean ultrasonicReliabilityDelayPassed = false;
                if (ultrasonic_is_valid_since_ms >= (long)this.m_AlgoParams[6]) {
                    ultrasonicReliabilityDelayPassed = true;
                }
                
                if ((!ultrasonicReliabilityDelayPassed && test_Q1) || (ultrasonicReliabilityDelayPassed && test_Q2)) {
                    this.m_ResultType = "-AGL";
                    return ultrasonicHeight;
                } else if (!Float.isNaN(aircraft_hAGL_from_dtm)) {
                    this.m_ResultType = "-DTM";
                    return Math.max(0.0f, aircraft_hAGL_from_dtm + this.getAltitudeOffset() - this.m_AlgoParams[3]);
                } else if (!Float.isNaN(delta_altitude)) {
                    this.m_ResultType = "-QFE";
                    return delta_altitude;
                } else {
                    this.m_ResultType = "-err";
                    return 0.0f;
                }
            } else if (!Float.isNaN(aircraft_hAGL_from_dtm))  {
                //  If ultrasonic sensor is not providing data, then switch to the DTM computed height
                this.m_ResultType = "-DTM";
                return Math.max(0.0f, aircraft_hAGL_from_dtm + this.getAltitudeOffset() - this.m_AlgoParams[3]);
            } else if (!Float.isNaN(delta_altitude)) {
                this.m_ResultType = "-QFE";
                return delta_altitude;
            } else {
                this.m_ResultType = "-err";
                return 0.0f;
            }
        }
    }

    public void addCalibrationPoint(float aircraft_hAGL_from_dtm, float delta_DTM_ultrasonic) {

        if (!Float.isNaN(aircraft_hAGL_from_dtm)) {
            this.m_OffsetCalibrationValues.add(new Float(delta_DTM_ultrasonic));
            Float offset = new Float(0.0f);                        
            for(Float elem : this.m_OffsetCalibrationValues) {
                offset += elem;
            }
            offset /= new Float(this.m_OffsetCalibrationValues.size());
            this.setAltitudeOffset(offset.floatValue());
        }
    }

    public double pseudo_dist(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg) {

        double aircraftLatRad = Math.PI * aircraftLatDeg/180.0;
        double aircraftLngRad = Math.PI * aircraftLngDeg/180.0;
        double homeLatRad = Math.PI * homeLatDeg/180.0;
        double homeLngRad = Math.PI * homeLngDeg/180.0;

        double cosphi1 = Math.cos(homeLatRad);
        double cosphi2 = Math.cos(aircraftLatRad);
        double sinphi1 = Math.sin(homeLatRad);
        double sinphi2 = Math.sin(aircraftLatRad);

        double coslambda1 = Math.cos(homeLngRad);
        double coslambda2 = Math.cos(aircraftLngRad);
        double sinlambda1 = Math.sin(homeLngRad);
        double sinlambda2 = Math.sin(aircraftLngRad);        

        double esinphim = 0.081819190842622*Math.sin(0.5*(homeLatRad+aircraftLatRad));

        double dx = cosphi2*coslambda2-cosphi1*coslambda1;
        double dy = cosphi2*sinlambda2-cosphi1*sinlambda1;
        double dz = sinphi2-sinphi1;

        double Rn = 6378137.0/ Math.sqrt(1.0-esinphim*esinphim);

        return Rn*Math.sqrt(dx*dx+dy*dy+dz*dz);
    }

/*
    public static void main(String[] args) throws IOException {

        DTM theDTM = DTM.getInstance();

        System.out.println(Arrays.toString(theDTM.getAlgoParams()));

        //System.out.println(theDTM.getDTM_HAGL(46.25,2.75));
        StackTraceElement[] stackTraceElements = Thread.currentThread().getStackTrace(); 
        System.out.println(Arrays.toString(stackTraceElements));
   }
*/

}

