package og.patch;

import java.lang.String;
import java.lang.Math;
import java.util.Arrays;

import java.io.*;
import java.nio.*;

import java.util.zip.ZipFile;
import java.util.zip.ZipEntry;

public class HGTTile {

    public short[] m_TileData = null;

    double ref_lat = 90.0;      //  ref point is the South West corner of tile
    double ref_lng = 0.0;       //  Altough data is stored from North West corner...

    HGTTile() {
    }

    HGTTile(String tile_path) throws IOException {
        this.load(tile_path);
    }

    public void load(String tile_path) throws IOException {
        //  Parse filename for ref lat/lng i.e. tile South West coordinates
        String delims = String.format("((?<=%1$s)|(?=%1$s))","[/.EWNS]");
        String[] tokens = tile_path.split(delims);

        this.ref_lng = tokens[tokens.length - 9].equals("W") ? -1.0d : 1.0d;
        this.ref_lng *= Double.parseDouble(tokens[tokens.length - 8]);
        this.ref_lat = tokens[tokens.length - 11].equals("S") ? -1.0d : 1.0d;
        this.ref_lat *= Double.parseDouble(tokens[tokens.length - 10]);

        //  Read the hgt file data
        //  Data is stored latitude line by latitude line and by increasing longitude in each line
        //  Northest line first

        ZipFile zipfile = new ZipFile(tile_path);
        String entryName = new String(tokens[tokens.length-11]+tokens[tokens.length-10]+tokens[tokens.length-9]+tokens[tokens.length-8]+".hgt");
        ZipEntry entry = zipfile.getEntry(entryName);
        InputStream inputStream = zipfile.getInputStream(entry);
        int entrySize = (int)entry.getSize();
        byte[] rawDataAsBytes = new byte[entrySize];
        int totalBytesRead = 0;
        int remainingBytes = 0;
        while((remainingBytes=inputStream.available()) > 0)  {
            totalBytesRead += inputStream.read(rawDataAsBytes,totalBytesRead,remainingBytes);
        }

        this.m_TileData = new short[rawDataAsBytes.length/2];
        ByteBuffer.wrap(rawDataAsBytes).order(ByteOrder.BIG_ENDIAN).asShortBuffer().get(this.m_TileData);
    }

    public float getAltAtIndexes(int col, int line) {
        if (this.m_TileData != null && this.m_TileData.length == 12967201 && 0 <= col && col <= 3600 && 0 <= line && line <= 3600) {
            short val = this.m_TileData[(line*3601)+col];
            return (val!=-32768)?(float)val:0.0f;
        } else  {
            return 0.0f;
        }
    }

    public boolean isPointInTile(double latDeg, double lngDeg) {
        double delta_lat = latDeg - this.ref_lat;
        double delta_lng = lngDeg - this.ref_lng;
        return (this.m_TileData != null && this.m_TileData.length == 12967201 && 0.0d < delta_lat && delta_lat <= 1.0d && 0.0d <= delta_lng && delta_lng < 1.0d);
    }

    public float getAltAtLatLng(double latDeg, double lngDeg) {
        double delta_lat = 1.0d - (latDeg - this.ref_lat);
        double delta_lng = (lngDeg - this.ref_lng);

        int lat_index = (int)Math.floor(delta_lat*3600.0d);
        int lng_index = (int)Math.floor(delta_lng*3600.0d);

        //  DTM altitude of 4 grid points surrounding query point
        float alt_nw = getAltAtIndexes(lng_index,lat_index);
        float alt_ne = getAltAtIndexes(lng_index+1,lat_index);
        float alt_se = getAltAtIndexes(lng_index+1,lat_index+1);
        float alt_sw = getAltAtIndexes(lng_index,lat_index+1);

        //  Bilinear interpolation
        double a00 = (double)alt_sw;
        double a10 = (double)alt_se - (double)alt_sw;
        double a01 = (double)alt_nw - (double)alt_sw;
        double a11 = (double)alt_sw - (double)alt_se - (double)alt_nw + (double)alt_ne;

        double q = 1.0d - (delta_lat*3600.0d - (double)lat_index);
        double p = delta_lng*3600.0d - (double)lng_index;

        return (float)(a00 + a10*p + a01*q + a11*p*q);
    }
}

