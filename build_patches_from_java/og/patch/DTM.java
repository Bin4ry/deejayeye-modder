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
    private int m_AlgoChoice = 2;
    private float[] m_AlgoParams = { 30.0f, 20.0f, 3.0f };
    private String[] m_DTM_tiles_paths = null;
    private HGTTile[] m_Tiles = null;

    private ArrayList<Float> m_OffsetCalibrationValues = null;
    private int m_CallCounter = 0;

    private Logger m_logger = null;

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

    public float getDTM_HMSL(double latDeg, double lonDeg) {
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
    k() is dealing with VPS / ultrasonic values and is called last so will "override" the result from m()
    l() is dealing with velocities
    n() is dealing with satellite count, max distance, Home and Aircraft positions
    
    still this method will be called allowing (e.g. to calibrate some offset between the different existing values)
*/
    public float getAircraft_HMSL(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {
        float result = 0.0f;
        switch (this.m_AlgoChoice) {
            case 0:
                result = getAircraft_HMSL_algo0(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
                break;

            case 1:
                result = getAircraft_HMSL_algo1(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
                break;

            case 2:
                result = getAircraft_HMSL_algo2(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
                break;

            default:
                result = getAircraft_HMSL_algo0(aircraftLatDeg, aircraftLngDeg, homeLatDeg, homeLngDeg, delta_altitude, ultrasonicHeight, isUltrasonicInUse);
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
    public float getAircraft_HMSL_algo0(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {
        if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {
            return ultrasonicHeight;
        } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude))  {
            //  If ultrasonic sensor is not providing data, then switch to the delta_altitude value
            return delta_altitude;
        } else {
            return 0.0f;
        }
    }

/*
    Algo 1 : Reset offset as soon as an ultrasonic measurement is available
    was first trial...
    May work properly if not flying close to vegetation (where ultrasonic measurement would set a wrong offset)
    Is probably not very robust to "isolated" ultrasonic measurement
*/
    public float getAircraft_HMSL_algo1(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {

       if (Double.isNaN(aircraftLatDeg) || Double.isNaN(aircraftLngDeg) || Double.isNaN(homeLngDeg) || Double.isNaN(delta_altitude) )  {

            //  At least one of Aircraft of HomePoint does not have position... use FC provided data "as is"
            //  as there is no mean to access the DTM values
            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight)) {
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude)) {
                return delta_altitude;
            } else {
                return 0.0f;
            }

       } else {

            //  Aircraft and HomePoint have positions, let's try to use them on DTM
            float dtm_height_at_home = this.getDTM_HMSL(homeLatDeg,homeLngDeg);
            float dtm_height_at_aircraft = this.getDTM_HMSL(aircraftLatDeg,aircraftLngDeg);

            float aircraft_hAGL_from_dtm = delta_altitude - ( dtm_height_at_aircraft - dtm_height_at_home );

            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {
                //  Still use ultrasonic if available
                //  Compute offset to "dtm computations" as long as we have ultrasonic data to compare, so we get smooth transition and correct local bias
                if (!Float.isNaN(aircraft_hAGL_from_dtm)) {
                    this.setAltitudeOffset(ultrasonicHeight - aircraft_hAGL_from_dtm);
                }
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude))  {
                //  If ultrasonic sensor is not providing data, then switch to the DTM computed height
                return Math.max(0.0f, aircraft_hAGL_from_dtm + this.getAltitudeOffset());
            } else {
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
    public float getAircraft_HMSL_algo2(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {

       if (Double.isNaN(aircraftLatDeg) || Double.isNaN(aircraftLngDeg) || Double.isNaN(homeLngDeg) || Double.isNaN(delta_altitude) )  {

            //  At least one of Aircraft of HomePoint does not have position... use FC provided data "as is"
            //  as there is no mean to access the DTM values
            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude)) {
                return delta_altitude;
            } else {
                return 0.0f;
            }

       } else {

            //  Aircraft and HomePoint have positions, let's try to use them on DTM
            float dtm_height_at_home = this.getDTM_HMSL(homeLatDeg,homeLngDeg);
            float dtm_height_at_aircraft = this.getDTM_HMSL(aircraftLatDeg,aircraftLngDeg);

            float aircraft_hAGL_from_dtm = delta_altitude - ( dtm_height_at_aircraft - dtm_height_at_home );

            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight) && ultrasonicHeight > 0.0f) {
                //  Ultrasonic data is available and seems valid, let's use it to calibrate an initial offset
                //  Compute offset to "dtm computations" as long as we have ultrasonic data to compare, and error to "DTM" height is within acceptable error margin
                //  This should prevent later "sporadic" ultrasonic measurements from influencing the computations
                if (!Float.isNaN(aircraft_hAGL_from_dtm) && Math.abs(ultrasonicHeight - aircraft_hAGL_from_dtm) <= this.m_AlgoParams[1] ) {
                    if (this.m_OffsetCalibrationValues.size() < (int)(this.m_AlgoParams[0]) )   {
                        this.m_OffsetCalibrationValues.add(new Float(ultrasonicHeight - aircraft_hAGL_from_dtm));
                        Float offset = new Float(0.0f);                        
                        for(Float elem : this.m_OffsetCalibrationValues) {
                            offset += elem;
                        }
                        offset /= new Float(this.m_OffsetCalibrationValues.size());
                        this.setAltitudeOffset(offset.floatValue());
                    } 
                }
                //  Still returns ultrasonicHeight if it here and valid
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(aircraft_hAGL_from_dtm))  {
                //  If ultrasonic sensor is not providing data, then switch to the DTM computed height
                return Math.max(0.0f, aircraft_hAGL_from_dtm + this.getAltitudeOffset() - this.m_AlgoParams[2]);
            } else {
                return 0.0f;
            }
        }
    }

/*
    public static void main(String[] args) throws IOException {

        DTM theDTM = DTM.getInstance();

        System.out.println(Arrays.toString(theDTM.getAlgoParams()));

        //System.out.println(theDTM.getDTM_HMSL(46.25,2.75));
        StackTraceElement[] stackTraceElements = Thread.currentThread().getStackTrace(); 
        System.out.println(Arrays.toString(stackTraceElements));
   }
*/

}

