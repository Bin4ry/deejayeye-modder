package og.patch;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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

import java.util.logging.Logger;
import java.util.logging.Handler;
import java.util.logging.FileHandler;
import java.util.Locale;

public class URLHook {

    public static URLHook m_Instance = null;
    public static String ms_settings_path = "/mnt/sdcard/DJI/urlhook.settings.json";
    private boolean m_DoLogging = false;
    private Logger m_logger = null;

    public URLHook() {
    }

    public static URLHook getInstance() throws IOException {
        if (URLHook.m_Instance == null) {
            GsonBuilder builder = new GsonBuilder();
		    Gson gson = builder.create();

            long fileSize = new File(URLHook.ms_settings_path).length();

            FileInputStream settings = new FileInputStream(URLHook.ms_settings_path);
            byte[] data = new byte[(int)fileSize];
            int n = settings.read(data);

            String content = new String(data,"ISO-8859-1");

            URLHook.m_Instance = gson.fromJson(content, URLHook.class);

            URLHook.m_Instance = new URLHook();
            SimpleDateFormat formater = null;
            Date now = new Date();
            formater = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
            FileHandler fh;   
            fh = new FileHandler("/mnt/sdcard/DJI/URLHook-"+formater.format(now).toString()+".log");
            //fh = new FileHandler("DTM-"+formater.format(now).toString()+".log");
            URLHook.m_Instance.m_logger = Logger.getLogger(URLHook.class.getName());
            URLHook.m_Instance.m_logger.addHandler(fh);
            URLHook.m_Instance.m_logger.setUseParentHandlers(false);
        }
        return URLHook.m_Instance;
    }

    public static void close() {
        if (URLHook.m_Instance != null && URLHook.m_Instance.m_logger != null) {
            for(Handler h:URLHook.m_Instance.m_logger.getHandlers())  {
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

    public static String checkURL_S(String spec) throws IOException {
        if (URLHook.m_Instance == null) {
            URLHook.m_Instance = URLHook.getInstance();
        }
        if (URLHook.m_Instance.m_DoLogging) {
            URLHook.m_Instance.m_logger.info(spec);
        }
        return spec;
    }

    public static String checkURL_SS(String protocol, String host) throws IOException {
        if (URLHook.m_Instance == null) {
            URLHook.m_Instance = URLHook.getInstance();
        }
        if (URLHook.m_Instance.m_DoLogging) {
            StringBuilder sb = new StringBuilder();
            sb.append("protocol : ");
            sb.append(protocol);
            sb.append("\nhost : ");
            sb.append(host);
            URLHook.m_Instance.m_logger.info(sb.toString());
        }
        return host;
    }

    public static String checkURL_SSS(String protocol, String host, String filename) throws IOException {
        if (URLHook.m_Instance == null) {
            URLHook.m_Instance = URLHook.getInstance();
        }
        if (URLHook.m_Instance.m_DoLogging) {
            StringBuilder sb = new StringBuilder();
            sb.append("protocol : ");
            sb.append(protocol);
            sb.append("\nhost : ");
            sb.append(host);
            sb.append("\nfile : ");
            sb.append(filename);
            URLHook.m_Instance.m_logger.info(sb.toString());
        }
        return host;
    }

    public static String checkURL_SSIS(String protocol, String host, int port, String filename) throws IOException {
        if (URLHook.m_Instance == null) {
            URLHook.m_Instance = URLHook.getInstance();
        }
        if (URLHook.m_Instance.m_DoLogging) {
            StringBuilder sb = new StringBuilder();
            sb.append("protocol : ");
            sb.append(protocol);
            sb.append("\nhost : ");
            sb.append(host);
            sb.append("\nport : ");
            sb.append(port);
            sb.append("\nfile : ");
            sb.append(filename);
            URLHook.m_Instance.m_logger.info(sb.toString());
        }
        return host;
    }
}

