package og.patch;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import og.patch.HGTTile;

import java.lang.String;
import java.lang.Integer;
import java.lang.Double;
import java.lang.Float;
import java.util.Arrays;

import java.io.IOException;

import java.io.*;
import java.nio.*;

import java.util.zip.ZipFile;
import java.util.zip.ZipEntry;

public class DTM {

    public static DTM m_Instance = null;
    public static String ms_settings_path = "/mnt/sdcard/DJI/settings.json";
    //public static String ms_settings_path = "settings.json";

    private float m_AltitudeOffset = 0.0f;
    private int m_AlgoChoice = 1;
    private String[] m_DTM_tiles_paths = null;
    private HGTTile[] m_Tiles = null;

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

            //  Load actual tiles data
            int n_tiles = DTM.m_Instance.getDTMTilesPaths().length;
            DTM.m_Instance.m_Tiles = new HGTTile[n_tiles];
            for(int index=0;index<n_tiles;++index) {
                 DTM.m_Instance.m_Tiles[index] = new HGTTile(DTM.m_Instance.getDTMTilesPaths()[index]);
            }
        }
        return DTM.m_Instance;
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

    public float getAircraft_HMSL(double aircraftLatDeg, double aircraftLngDeg, double homeLatDeg, double homeLngDeg,
                                  float delta_altitude, float ultrasonicHeight, boolean isUltrasonicInUse) {

       if (Double.isNaN(aircraftLatDeg) || Double.isNaN(aircraftLngDeg) || Double.isNaN(homeLngDeg) || Double.isNaN(delta_altitude) )  {

            //  At least one of Aircraft of HomePoint does not have position...
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

            if (isUltrasonicInUse && !Float.isNaN(ultrasonicHeight)) {
                //  Still use ultrasonic if available
                //  Compute offset to "dtm computations" as long as we have ultrasonic data to compare, so we get smooth transition and correct local bias
                if (!Float.isNaN(aircraft_hAGL_from_dtm)) {
                    this.setAltitudeOffset(ultrasonicHeight - aircraft_hAGL_from_dtm);
                }
                return ultrasonicHeight;
            } else if (!isUltrasonicInUse && !Float.isNaN(delta_altitude))  {
                //  If ultrasonic sensor is not providing data, then switch to the DTM computed height
                return aircraft_hAGL_from_dtm + this.getAltitudeOffset();
            } else {
                return 0.0f;
            }
        }
    }

/*
    public static void main(String[] args) throws IOException {

        DTM theDTM = DTM.getInstance();
        DTM theDTM2 = DTM.getInstance();
        System.out.println(theDTM);
        System.out.println(theDTM2);

        System.out.println(theDTM.getDTM_HMSL(46.25,2.75));
    }
*/

}

