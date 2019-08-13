package og.patch;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.lang.Thread;
import java.lang.String;
import java.lang.Integer;
import java.lang.Double;
import java.lang.Float;
import java.util.Arrays;
import java.util.List;
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
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class URLHook {

    public static URLHook m_Instance = null;
    public static String ms_settings_path = "/mnt/sdcard/DJI/urlhook.settings.json";
    //public static String ms_settings_path = "urlhook.settings.json";
    private boolean m_DoLogging = false;
    private Logger m_logger = null;
    private int m_UrlFilteringType = 0;
    private String[] m_AllowedURLs = null;
    private String[] m_ForbiddenURLs = null;
    private String[] m_HardcodedAllowed = { ".*gnss_assist.*", ".*\\.ubx.*", ".*192.168.42.1.*", ".*192.168.42.2.*", ".*192.168.42.3.*", ".*localhost.*"};

    private ArrayList<Pattern> m_AllowedURLsPatterns = null;
    private ArrayList<Pattern> m_ForbiddenURLsPatterns = null;
    private ArrayList<Pattern> m_HardcodedAllowedPatterns = null;

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

            URLHook.m_Instance.m_AllowedURLsPatterns = new ArrayList<Pattern>();
            URLHook.m_Instance.m_ForbiddenURLsPatterns = new ArrayList<Pattern>();
            URLHook.m_Instance.m_HardcodedAllowedPatterns = new ArrayList<Pattern>();

            for(String s : URLHook.m_Instance.m_HardcodedAllowed) {
                URLHook.m_Instance.m_HardcodedAllowedPatterns.add(Pattern.compile(s));
            }

            for(String s : URLHook.m_Instance.m_AllowedURLs) {
                URLHook.m_Instance.m_AllowedURLsPatterns.add(Pattern.compile(s));
            }

            for(String s : URLHook.m_Instance.m_ForbiddenURLs) {
                URLHook.m_Instance.m_ForbiddenURLsPatterns.add(Pattern.compile(s));
            }


            if (URLHook.m_Instance.m_DoLogging) {
                SimpleDateFormat formater = null;
                Date now = new Date();
                formater = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
                FileHandler fh;
                fh = new FileHandler("/mnt/sdcard/DJI/og_logs/URLHook-"+ formater.format(now).toString()+".log");
                //fh = new FileHandler("URLHook-"+ formater.format(now).toString()+".log");
                URLHook.m_Instance.m_logger = Logger.getLogger(URLHook.class.getName());
                URLHook.m_Instance.m_logger.addHandler(fh);
                URLHook.m_Instance.m_logger.setUseParentHandlers(false);
            }
        }
        return URLHook.m_Instance;
    }

    public static void close() {
        if (URLHook.m_Instance != null && URLHook.m_Instance.m_logger != null) {
            URLHook.m_Instance.m_logger.info("closing");
            //URLHook.m_Instance.m_DoLogging = false;
            for(Handler h:URLHook.m_Instance.m_logger.getHandlers())  {
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

    public String[] getAllowedURLs() {
        return this.m_AllowedURLs;
    }

    public void setAllowedURLs(String[] allowedurls) {
        this.m_AllowedURLs = allowedurls;
    }

    public String[] getForbiddenURLs() {
        return this.m_ForbiddenURLs;
    }

    public void setForbiddenURLs(String[] forbiddenurls) {
        this.m_ForbiddenURLs = forbiddenurls;
    }

    public int getUrlFilteringType() {
        return this.m_UrlFilteringType;
    }

    public void setUrlFilteringType(int value) {
        this.m_UrlFilteringType = value;
    }

    private static boolean stringMatchPatternList(String test_token, ArrayList<Pattern> patternlist) {
        for(Pattern p : patternlist) {
            Matcher m = p.matcher(test_token);
            if (m.matches()) {
                return true;
            }
        }
        return false;
    }

    private static String checkHost(String inputstr,int test_token) {
        String res;  
        String delim = String.format("((?<=%1$s)|(?=%1$s))","[/:]");
        String[] tokens = inputstr.split(delim);
        boolean test_allow = false;
        for(String token : tokens) {
            for(Pattern p : URLHook.m_Instance.m_HardcodedAllowedPatterns) {
                Matcher m = p.matcher(token);
                if (m.matches()) {
                    test_allow = true;
                    break;
                }
            }
            if (test_allow) {
                break;
            }
        }

        if (tokens.length >= test_token) {

            switch (URLHook.m_Instance.m_UrlFilteringType) {
                // 1 = online if allowed only (default to block)
                case 1:
                test_allow |= stringMatchPatternList(tokens[test_token],URLHook.m_Instance.m_AllowedURLsPatterns);
                break;

                //  2 = blocked if forbidden only (default to pass)
                case 2:
                test_allow = true;
                test_allow &= !stringMatchPatternList(tokens[test_token],URLHook.m_Instance.m_ForbiddenURLsPatterns);
                break;
                
                // 3 = double check if allowed and NOT forbidden (default to block)
                case 3: 
                test_allow |= (stringMatchPatternList(tokens[test_token],URLHook.m_Instance.m_AllowedURLsPatterns) && !stringMatchPatternList(tokens[test_token],URLHook.m_Instance.m_ForbiddenURLsPatterns));
                default:
                break;
            }

            if (test_allow) {
                res = inputstr;
            } else {
                StringBuilder url_sb = new StringBuilder();
                for(int i=0;i<tokens.length;++i) {
                    url_sb.append(((i==test_token)?"127.0.0.1":tokens[i]));
                }
                res = url_sb.toString();
            }
        } else {
            // Issue with tokenization, spec does not respect "protocol://url" format
            res = inputstr;
        }
        return res;
    }

    public static String checkURL_S(String spec) throws IOException {
        if (URLHook.m_Instance == null) {
            URLHook.m_Instance = URLHook.getInstance();
        }

        String res;

        if (URLHook.m_Instance.m_UrlFilteringType == 0) {
        // 0 = full online
            res = spec;
        } else {
            res = checkHost(spec,4);
        }

        if (URLHook.m_Instance.m_DoLogging) {
            StringBuilder log_sb = new StringBuilder();
            log_sb.append("orig_url = ");
            log_sb.append(spec);
            log_sb.append(", subst_url = ");
            log_sb.append(res);
            URLHook.m_Instance.m_logger.info(log_sb.toString());
        }
        return res;
    }

    public static String checkURL_SS(String protocol, String host) throws IOException {
        if (URLHook.m_Instance == null) {
            URLHook.m_Instance = URLHook.getInstance();
        }

        String res;

        if (URLHook.m_Instance.m_UrlFilteringType == 0) {
        // 0 = full online
            res = host;
        } else {
            res = checkHost(host,0);
        }

        if (URLHook.m_Instance.m_DoLogging) {
            StringBuilder sb = new StringBuilder();
            sb.append("protocol = ");
            sb.append(protocol);
            sb.append(", orig host = ");
            sb.append(host);
            sb.append(", subst host = ");
            sb.append(res);
            URLHook.m_Instance.m_logger.info(sb.toString());
        }
        return res;
    }

    public static String checkURL_SSS(String protocol, String host, String filename) throws IOException {
        if (URLHook.m_Instance == null) {
            URLHook.m_Instance = URLHook.getInstance();
        }

        String res;

        if (URLHook.m_Instance.m_UrlFilteringType == 0) {
        // 0 = full online
            res = host;
        } else {
            res = checkHost(host,0);
        }

        if (URLHook.m_Instance.m_DoLogging) {
            StringBuilder sb = new StringBuilder();
            sb.append("protocol = ");
            sb.append(protocol);
            sb.append(", orig host = ");
            sb.append(host);
            sb.append(", subst host = ");
            sb.append(res);
            sb.append(", file = ");
            sb.append(filename);
            URLHook.m_Instance.m_logger.info(sb.toString());
        }
        return res;
    }

    public static String checkURL_SSIS(String protocol, String host, int port, String filename) throws IOException {
        if (URLHook.m_Instance == null) {
            URLHook.m_Instance = URLHook.getInstance();
        }

        String res;

        if (URLHook.m_Instance.m_UrlFilteringType == 0) {
        // 0 = full online
            res = host;
        } else {
            res = checkHost(host,0);
        }

        if (URLHook.m_Instance.m_DoLogging) {
            StringBuilder sb = new StringBuilder();
            sb.append("protocol = ");
            sb.append(protocol);
            sb.append(", orig host = ");
            sb.append(host);
            sb.append(", subst host = ");
            sb.append(res);
            sb.append(", port = ");
            sb.append(port);
            sb.append(", file = ");
            sb.append(filename);
            URLHook.m_Instance.m_logger.info(sb.toString());
        }
        return res;
    }
/*
    public static void main(String[] args) throws IOException {

        String s1 = checkURL_S("http://titi.here.com");
        System.out.println(s1);
        String s2 = checkURL_S("http://titi.dji.com");
        System.out.println(s2);
   }
*/
}

