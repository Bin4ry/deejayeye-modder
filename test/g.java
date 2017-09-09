package dji.pilot.publics.util;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Application$ActivityLifecycleCallbacks;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap$Config;
import android.net.Uri;
import android.os.Build$VERSION;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Process;
import android.util.Log;
import android.widget.Toast;
import com.dji.frame.c.d;
import com.dji.k.a.a.a;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions$Builder;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.display.FadeInBitmapDisplayer;
import com.tencent.bugly.crashreport.CrashReport$CrashHandleCallback;
import com.tencent.bugly.crashreport.CrashReport$UserStrategy;
import com.tencent.bugly.crashreport.CrashReport;
import dji.midware.data.config.P3.ProductType;
import dji.midware.data.forbid.util.FlyfrbLaunchUtil;
import dji.midware.data.manager.P3.k;
import dji.midware.data.model.P3.DataOsdGetPushCommon$MotorStartFailedCause;
import dji.pilot.countrycode.a.c$b;
import dji.pilot.flyforbid.e;
import dji.pilot.fpv.control.DJIGenSettingDataManager;
import dji.pilot.fpv.control.x;
import dji.pilot.home.cs.activity.DJICsMainActivity;
import dji.pilot.home.rc.activity.DJIRcMainActivity;
import dji.pilot.publics.c.i;
import dji.pilot.publics.objects.j;
import dji.pilot.reflect.SetReflect;
import dji.pilot.upgrade.f;
import dji.pilot2.main.activity.DJIMainFragmentActivity;
import dji.pilot2.mine.controller.SettingController;
import dji.pilot2.publics.object.DJINotificationDialog;
import dji.publics.DJIUI.DJIOriLayout$DJIDeviceType;
import dji.publics.DJIUI.DJIOriLayout;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.ref.WeakReference;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.security.SignatureException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.regex.Pattern;
import org.greenrobot.eventbus.EventBus;

public class g {
    class dji.pilot.publics.util.g$3 {
        static {
            dji.pilot.publics.util.g$3.a = new int[MotorStartFailedCause.values().length];
            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.CompassError.ordinal()] = 1;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.AssistantProtected.ordinal()] = 2;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.DeviceLocked.ordinal()] = 3;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.DistanceLimit.ordinal()] = 4;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.IMUNeedCalibration.ordinal()] = 5;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.IMUSNError.ordinal()] = 6;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.IMUWarning.ordinal()] = 7;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.CompassCalibrating.ordinal()] = 8;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.AttiError.ordinal()] = 9;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.NoviceProtected.ordinal()] = 10;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BatteryCellError.ordinal()] = 11;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BatteryCommuniteError.ordinal()] = 12;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.SeriouLowVoltage.ordinal()] = 13;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.SeriouLowPower.ordinal()] = 14;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.LowVoltage.ordinal()] = 15;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.TempureVolLow.ordinal()] = 0x10;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.SmartLowToLand.ordinal()] = 17;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BatteryNotReady.ordinal()] = 18;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.SimulatorMode.ordinal()] = 19;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.PackMode.ordinal()] = 20;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.AttitudeAbNormal.ordinal()] = 21;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.UnActive.ordinal()] = 22;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.FlyForbiddenError.ordinal()] = 23;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BiasError.ordinal()] = 24;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.EscError.ordinal()] = 25;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.ImuInitError.ordinal()] = 26;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.SystemUpgrade.ordinal()] = 27;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.SimulatorStarted.ordinal()] = 28;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.ImuingError.ordinal()] = 29;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.AttiAngleOver.ordinal()] = 30;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GyroscopeError.ordinal()] = 31;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.AcceletorError.ordinal()] = 0x20;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.CompassFailed.ordinal()] = 33;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BarometerError.ordinal()] = 34;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BarometerNegative.ordinal()] = 35;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.CompassBig.ordinal()] = 36;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GyroscopeBiasBig.ordinal()] = 37;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.AcceletorBiasBig.ordinal()] = 38;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.CompassNoiseBig.ordinal()] = 39;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BarometerNoiseBig.ordinal()] = 40;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.AircraftTypeMismatch.ordinal()] = 41;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.M600_BAT_AUTH_ERR.ordinal()] = 42;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.M600_BAT_COMM_ERR.ordinal()] = 43;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.M600_BAT_TOO_LITTLE.ordinal()] = 44;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.M600_BAT_DIF_VOLT_LARGE_1.ordinal()] = 45;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.M600_BAT_DIF_VOLT_LARGE_2.ordinal()] = 46;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.TOPOLOGY_ABNORMAL.ordinal()] = 47;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.FoundUnfinishedModule.ordinal()] = 0x30;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.IMUNoconnection.ordinal()] = 49;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.IMUcCalibrationFinished.ordinal()] = 50;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.NS_ABNORMAL.ordinal()] = 51;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.RCCalibration.ordinal()] = 52;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.RCCalibrationException.ordinal()] = 53;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.RCCalibrationException2.ordinal()] = 54;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.RCCalibrationException3.ordinal()] = 55;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.RC_NEED_CALI.ordinal()] = 56;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.RCCalibrationUnfinished.ordinal()] = 57;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.SDCardException.ordinal()] = 58;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.INVALID_FLOAT.ordinal()] = 59;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.INVALID_VERSION.ordinal()] = 60;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BARO_ABNORMAL.ordinal()] = 61;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.COMPASS_ABNORMAL.ordinal()] = 62;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.FLASH_OPERATING.ordinal()] = 63;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GPS_ABNORMAL.ordinal()] = 0x40;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GPS_DISCONNECT.ordinal()] = 65;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_GYRO_ABNORMAL.ordinal()] = 66;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_ESC_PITCH_NON_DATA.ordinal()] = 67;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_ESC_ROLL_NON_DATA.ordinal()] = 68;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_ESC_YAW_NON_DATA.ordinal()] = 69;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_FIRM_IS_UPDATING.ordinal()] = 70;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_DISORDER.ordinal()] = 71;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_PITCH_SHOCK.ordinal()] = 72;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_ROLL_SHOCK.ordinal()] = 73;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_YAW_SHOCK.ordinal()] = 74;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.BatVersionError.ordinal()] = 75;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.RTK_BAD_SIGNAL.ordinal()] = 76;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.RTK_DEVIATION_ERROR.ordinal()] = 77;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GIMBAL_IS_CALIBRATING.ordinal()] = 78;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.ESC_CALIBRATING.ordinal()] = 79;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.GPS_SIGN_INVALID.ordinal()] = 80;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.LOCK_BY_APP.ordinal()] = 81;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.START_FLY_HEIGHT_ERROR.ordinal()] = 82;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.ESC_VERSION_NOT_MATCH.ordinal()] = 83;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.IMU_ORI_NOT_MATCH.ordinal()] = 84;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.STOP_BY_APP.ordinal()] = 85;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.COMPASS_IMU_ORI_NOT_MATCH.ordinal()] = 86;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.ESC_ECHOING.ordinal()] = 87;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.LOW_VERSION_OF_BATTERY.ordinal()] = 88;
            }
            catch(NoSuchFieldError v0) {
            }

            try {
                dji.pilot.publics.util.g$3.a[MotorStartFailedCause.VOLTAGE_OF_BATTERY_IS_TOO_HIGH.ordinal()] = 89;
            }
            catch(NoSuchFieldError v0) {
            }
        }
    }

    public static final String a = null;
    public static final String b = null;
    public static final String c = null;
    public static final String d = null;
    public static final String e = null;
    public static final String f = null;
    private static final String g = null;
    private static final int h = 0x1E00000;
    private static boolean i;
    private static boolean j;
    private static final String k;
    private static WeakReference l;
    private static ProductType m;
    private static String n;

    static {
        g.g = ("[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+(?:[-.][a-zA-Z0-9]+)*.[A-Za-z]{2,4}");

        g.a = ("http://chat10.live800.com/live800/chatClient/chatbox.jsp?jid=2964301564&companyID=409811&prechatinfoexist=1&subject=%E6%89%8B%E6%9C%BAAPP");

        g.b = ("Inspire1@dji.com");

        g.c = ("http://chat32.live800.com/live800/chatClient/chatbox.jsp?companyID=493623&configID=72904&jid=5418788219");

        g.d = ("support@dji.com");

        g.e = ("/LOG/NATIVE_CRASH/");

        g.f = ("Expired_App_Version");

        g.k = ("strIsProductImproveProject");

        g.i = false;
        g.j = false;
        g.m = null;
        g.n = ("DJI Device");

    }

    public g() {
        super();
    }

    public static boolean a(String arg1) {
        return h.a(arg1);
    }

    public static void a(String arg0, long arg1, String arg3) {
    }

    public static int a(int[] arg3, int arg4, int arg5) {
        int v0 = 0;
        int v1 = arg3.length;
        while(v0 < v1) {
            if(arg4 == arg3[v0]) {
                arg5 = v0;
            }
            else {
                ++v0;
                continue;
            }

            return arg5;
        }

        return arg5;
    }

    public static String a(Context arg4) {
        String v0;
        PackageManager v1 = arg4.getPackageManager();
        try {
            v0 = v1.getPackageInfo(arg4.getPackageName(), 0).versionName + (".") + dji.pilot.configs.a.b(arg4);

        }
        catch(Exception v1_1) {
            v1_1.printStackTrace();
        }

        return v0;
    }

    public static int[] a(MotorStartFailedCause arg5) {
        int[] v0 = new int[]{0, 0};
        switch(dji.pilot.publics.util.g$3.a[arg5.ordinal()]) {
            case 1: {
                v0[0] = 0x7F0910CB;
                break;
            }
            case 2: {
                v0[0] = 0x7F0910BF;
                break;
            }
            case 3: {
                v0[0] = 0x7F0910CE;
                break;
            }
            case 4: {
                v0[0] = 0x7F0910CF;
                break;
            }
            case 5: {
                v0[0] = 0x7F0910D4;
                break;
            }
            case 6: {
                v0[0] = 0x7F0910D5;
                break;
            }
            case 7: {
                v0[0] = 0x7F0910D6;
                break;
            }
            case 8: {
                v0[0] = 0x7F0910CA;
                break;
            }
            case 9: {
                v0[0] = 0x7F0910C0;
                break;
            }
            case 10: {
                v0[0] = 0x7F0910DB;
                break;
            }
            case 11: {
                v0[0] = 0x7F09169A;
                v0[1] = 0x7F091C8F;
                break;
            }
            case 12: {
                v0[0] = 0x7F0910C6;
                break;
            }
            case 13: {
                v0[0] = 0x7F0910DE;
                break;
            }
            case 14: {
                v0[0] = 0x7F0910DD;
                break;
            }
            case 15: {
                v0[0] = 0x7F0910DA;
                break;
            }
            case 16: {
                v0[0] = 0x7F0910E3;
                break;
            }
            case 17: {
                v0[0] = 0x7F0910E1;
                break;
            }
            case 18: {
                v0[0] = 0x7F0910C7;
                break;
            }
            case 19: {
                v0[0] = 0x7F0910DF;
                break;
            }
            case 20: {
                v0[0] = 0x7F0910DC;
                break;
            }
            case 21: {
                v0[0] = 0x7F0910C2;
                break;
            }
            case 22: {
                v0[0] = 0x7F0910E4;
                break;
            }
            case 23: {
                v0[0] = 0x7F091C8E;
                break;
            }
            case 24: {
                v0[0] = 0x7F0910C8;
                break;
            }
            case 25: {
                v0[0] = 0x7F0910D0;
                break;
            }
            case 26: {
                v0[0] = 0x7F0910D3;
                break;
            }
            case 27: {
                v0[0] = 0x7F0910E2;
                break;
            }
            case 28: {
                v0[0] = 0x7F0910E0;
                break;
            }
            case 29: {
                v0[0] = 0x7F0910D7;
                break;
            }
            case 30: {
                v0[0] = 0x7F0910C1;
                break;
            }
            case 31: {
                v0[0] = 0x7F0910D2;
                break;
            }
            case 32: {
                v0[0] = 0x7F0910BE;
                break;
            }
            case 33: {
                v0[0] = 0x7F0910CC;
                break;
            }
            case 34: {
                v0[0] = 0x7F0910C3;
                break;
            }
            case 35: {
                v0[0] = 0x7F0910C4;
                break;
            }
            case 36: {
                v0[0] = 0x7F0910C9;
                break;
            }
            case 37: {
                v0[0] = 0x7F0910D1;
                break;
            }
            case 38: {
                v0[0] = 0x7F0910BD;
                break;
            }
            case 39: {
                v0[0] = 0x7F0910CD;
                break;
            }
            case 40: {
                v0[0] = 0x7F0910C5;
                break;
            }
            case 41: {
                v0[0] = 0x7F0902C7;
                v0[1] = 0x7F0902C6;
                break;
            }
            case 42: {
                v0[0] = 0x7F0902CA;
                v0[1] = 0x7F0902C9;
                break;
            }
            case 43: {
                v0[0] = 0x7F0902CC;
                v0[1] = 0x7F0902CB;
                break;
            }
            case 44: {
                v0[0] = (c.e()) || (c.k(null)) ? 0x7F0918AB : 0x7F0902CE;
                v0[1] = 0x7F0902CD;
                break;
            }
            case 45: {
                v0[0] = 0x7F0902D0;
                v0[1] = 0x7F0902CF;
                break;
            }
            case 46: {
                v0[0] = 0x7F0902D2;
                v0[1] = 0x7F0902D1;
                break;
            }
            case 47: {
                v0[0] = 0x7F0902D5;
                v0[1] = 0x7F0902D4;
                break;
            }
            case 48: {
                v0[0] = 0x7F0902D8;
                v0[1] = 0x7F0902D7;
                break;
            }
            case 49: {
                v0[0] = 0x7F0902F1;
                v0[1] = 0x7F0902F0;
                break;
            }
            case 50: {
                v0[0] = 0x7F0902EF;
                v0[1] = 0x7F0902EE;
                break;
            }
            case 51: {
                v0[0] = 0x7F0902F3;
                v0[1] = 0x7F0902F2;
                break;
            }
            case 52: {
                v0[0] = 0x7F0902FD;
                v0[1] = 0x7F0902F4;
                break;
            }
            case 53: {
                v0[0] = 0x7F0902FC;
                v0[1] = 0x7F0902FB;
                break;
            }
            case 54: {
                v0[0] = 0x7F0902F6;
                v0[1] = 0x7F0902F5;
                break;
            }
            case 55: {
                v0[0] = 0x7F0902F8;
                v0[1] = 0x7F0902F7;
                break;
            }
            case 56: {
                v0[0] = 0x7F0902FA;
                v0[1] = 0x7F0902F9;
                break;
            }
            case 57: {
                v0[0] = 0x7F0902FF;
                v0[1] = 0x7F0902FE;
                break;
            }
            case 58: {
                v0[0] = 0x7F090303;
                v0[1] = 0x7F090302;
                break;
            }
            case 59: {
                v0[0] = 0x7F090305;
                v0[1] = 0x7F090304;
                break;
            }
            case 60: {
                v0[0] = 0x7F090307;
                v0[1] = 0x7F090306;
                break;
            }
            case 61: {
                v0[0] = 0x7F0902C8;
                break;
            }
            case 62: {
                v0[0] = 0x7F0902D3;
                break;
            }
            case 63: {
                v0[0] = 0x7F0902D6;
                break;
            }
            case 64: {
                v0[0] = 0x7F0902EC;
                break;
            }
            case 65: {
                v0[0] = 0x7F0902ED;
                break;
            }
            case 66: {
                v0[0] = 0x7F0902D9;
                v0[1] = 0x7F0902DA;
                break;
            }
            case 67: {
                v0[0] = 0x7F0902DD;
                v0[1] = 0x7F0902DE;
                break;
            }
            case 68: {
                v0[0] = 0x7F0902DF;
                v0[1] = 0x7F0902E0;
                break;
            }
            case 69: {
                v0[0] = 0x7F0902E1;
                v0[1] = 0x7F0902E2;
                break;
            }
            case 70: {
                v0[0] = 0x7F0902E4;
                v0[1] = 0x7F0902E5;
                break;
            }
            case 71: {
                v0[0] = 0x7F0902DB;
                v0[1] = 0x7F0902DC;
                break;
            }
            case 72: {
                v0[0] = 0x7F0902E6;
                v0[1] = 0x7F0902E7;
                break;
            }
            case 73: {
                v0[0] = 0x7F0902E8;
                v0[1] = 0x7F0902E9;
                break;
            }
            case 74: {
                v0[0] = 0x7F0902EA;
                v0[1] = 0x7F0902EB;
                break;
            }
            case 75: {
                v0[0] = 0x7F091826;
                break;
            }
            case 76: {
                v0[0] = 0x7F090300;
                break;
            }
            case 77: {
                v0[0] = 0x7F090301;
                break;
            }
            case 78: {
                v0[0] = 0x7F0902E3;
                break;
            }
            case 79: {
                v0[0] = 0x7F09182A;
                v0[1] = 0x7F09182B;
                break;
            }
            case 80: {
                v0[0] = 0x7F09182F;
                break;
            }
            case 81: {
                v0[0] = 0x7F091832;
                break;
            }
            case 82: {
                v0[0] = 0x7F09183C;
                v0[1] = 0x7F09183D;
                break;
            }
            case 83: {
                v0[0] = 0x7F09182D;
                v0[1] = 0x7F09182E;
                break;
            }
            case 84: {
                v0[0] = 0x7F091830;
                v0[1] = 0x7F091831;
                break;
            }
            case 85: {
                v0[0] = 0x7F09183E;
                break;
            }
            case 86: {
                v0[0] = 0x7F091827;
                v0[1] = 0x7F091828;
                break;
            }
            case 87: {
                v0[0] = 0x7F09182C;
                break;
            }
            case 88: {
                v0[0] = 0x7F091841;
                break;
            }
            case 89: {
                v0[0] = 0x7F091829;
                break;
            }
        }

        return v0;
    }

    public static long a(byte[] arg6, int arg7, int arg8) {
        long v0 = 0;
        if(arg6 != null && arg6.length >= arg7 + arg8) {
            int v2 = arg7 + arg8 - 1;
            while(v2 >= arg7) {
                long v4 = (((long)(arg6[v2] & 255))) + v0 * 0x100;
                --v2;
                v0 = v4;
            }
        }

        return v0;
    }

    public static int a() {
        return TimeZone.getDefault().getOffset(new Date().getTime()) / 360000;
    }

    private static Object a(Object arg6, String arg7, Class arg8, Object[] arg9) throws Exception {
        String v0_2;
        Class v1 = arg6.getClass();
        String v2 = arg7.substring(0, 1).toUpperCase() + arg7.substring(1);
        Method v0 = null;
        try {
            if(arg8 == Boolean.TYPE) {
                v0 = v1.getMethod(("is") + v2);

                goto label_24;
            }

            v0 = v1.getMethod(("get") + v2);

        }
        catch(NoSuchMethodException v0_1) {
            v0_2 = (" can't find 'get") + v2 + ("fgokJxM2NgA=");

            return v0_2;
        }
        catch(SecurityException v1_1) {
            v1_1.printStackTrace();
        }

    label_24:
        Object v0_3 = v0.invoke(arg6);
        return v0_2;
    }

    public static String a(ProductType arg2) {
        String v0 = g.d;
        if(ProductType.Orange == arg2 || ProductType.BigBanana == arg2 || ProductType.OrangeRAW == arg2 || ProductType.Olives == arg2 || ProductType.OrangeCV600 == arg2) {
            v0 = g.b;
        }

        return v0;
    }

    public static String a(Object arg2) {
        StringBuffer v0 = new StringBuffer();
        if(arg2 != null) {
            try {
                g.a(arg2, v0);
            }
            catch(Exception v1) {
                v1.printStackTrace();
            }
        }

        return v0.toString();
    }

    private static String a(Object arg8, StringBuffer arg9) throws Exception {
        Field[] v3 = arg8.getClass().getDeclaredFields();
        arg9.append(("------  begin ------"));

        int v4 = v3.length;
        int v2;
        for(v2 = 0; v2 < v4; ++v2) {
            Field v0 = v3[v2];
            arg9.append(v0.getName());
            arg9.append((" : "));

            Object v5 = g.a(arg8, v0.getName(), v0.getType(), null);
            if(v5 != null) {
                if(v5.getClass().isArray()) {
                    int v0_1;
                    for(v0_1 = 0; v0_1 < Array.getLength(v5); ++v0_1) {
                        Object v6 = Array.get(v5, v0_1);
                        if(v6.getClass().isPrimitive()) {
                            arg9.append(v6.toString());
                        }
                        else if((v6 instanceof String)) {
                            arg9.append(v6.toString());
                        }
                        else if((v6 instanceof Date)) {
                            arg9.append(v6.toString());
                        }
                        else if((v6 instanceof Number)) {
                            arg9.append(v6.toString());
                        }
                        else {
                            g.a(v6, arg9);
                        }
                    }
                }

                if(v5.getClass().getName().indexOf(("com.cignacmb.core.model.")) <= 0xFFFFFFFF) {

                    goto label_60;
                }

                g.a(v5, arg9);
            }

        label_60:
            arg9.append(v5);
            arg9.append("\n");
        }

        arg9.append(("------  end ------"));

        return arg9.toString();
    }

    static String a(String arg1, String arg2, String arg3) {
        return g.b(arg1, arg2, arg3);
    }

    static WeakReference a(WeakReference arg0) {
        g.l = arg0;
        return arg0;
    }

    static void a(Context arg0, String arg1) {
        g.b(arg0, arg1);
    }

    public static void a(Context arg3, String arg4, String arg5, String arg6, boolean arg7) {
        Intent v0 = new Intent(("android.intent.action.SENDTO"));

        v0.setData(Uri.parse(("mailto:") + arg4));

        v0.putExtra(("android.intent.extra.SUBJECT"), arg5);

        v0.putExtra(("android.intent.extra.TEXT"), arg6);

        v0.setFlags(0x10000000);
        if(v0.resolveActivity(arg3.getPackageManager()) != null) {
            arg3.startActivity(v0);
        }
        else if(arg7) {
            Toast.makeText(arg3.getApplicationContext(), 0x7F090403, 0).show();
        }
    }

    public static void a(Context arg3, String arg4, boolean arg5) {
        Intent v0 = new Intent(("android.intent.action.VIEW"));

        v0.setData(Uri.parse(arg4));
        v0.setFlags(0x10000000);
        if(v0.resolveActivity(arg3.getPackageManager()) != null) {
            arg3.startActivity(v0);
        }
        else if(arg5) {
            Toast.makeText(arg3.getApplicationContext(), 0x7F090107, 0).show();
        }
    }

    public static void a(Context arg3, boolean arg4) {
        Intent v0 = new Intent(("android.settings.WIRELESS_SETTINGS"));

        if(v0.resolveActivity(arg3.getPackageManager()) != null) {
            arg3.startActivity(v0);
        }
        else if(arg4) {
            Toast.makeText(arg3.getApplicationContext(), 0x7F090403, 0).show();
        }
    }

    public static boolean a(String arg1, String arg2) {
        boolean v0 = arg1 == arg2 ? true : false;
        if(!v0 && arg1 != null) {
            v0 = arg1.equals(arg2);
        }

        return v0;
    }

    public static boolean a(String[] arg3) {
        boolean v1 = false;
        int v0 = 0;
        while(v0 < arg3.length) {
            if(g.a(arg3[v0])) {
                v1 = true;
            }
            else {
                ++v0;
                continue;
            }

            return v1;
        }

        return v1;
    }

    public static void b(Context arg3, boolean arg4) {
        Intent v0 = new Intent(("android.settings.SETTINGS"));

        if(v0.resolveActivity(arg3.getPackageManager()) != null) {
            arg3.startActivity(v0);
        }
        else if(arg4) {
            Toast.makeText(arg3.getApplicationContext(), 0x7F090403, 0).show();
        }
    }

    public static void b() {
        int v0 = 0;
        String[] v2 = new String[]{("metadata"), ("OEk9KxE7BgI1Sy5sBTc3")};

        String v1 = "";
        int v3 = v2.length;
        while(v0 < v3) {
            v1 = v1 + File.separator + v2[v0];
            ++v0;
        }

        if(!new File(v1).exists()) {
            g.i = true;
        }
    }

    private static String b(String arg3, String arg4, String arg5) {
        StringBuilder v0 = new StringBuilder();
        v0.append(("Model：")).append(Build.MODEL).append("
");

        v0.append(("OS-Version：")).append(Build$VERSION.RELEASE).append("
");

        v0.append(("APP-Version：")).append(SetReflect.getAppVersion()).append("
").append("
");

        v0.append(arg3).append("\n").append(arg4).append("\n").append(arg5);
        return v0.toString();
    }

    private static void b(Context arg5, String arg6) {
        String v0 = dji.pilot.usercenter.f.c.a(new String[]{d.a(arg5, g.e), ("crash-native-") + new SimpleDateFormat(("IFMwO0oTFEk9TmQKL3M0CXRZOg=="), Locale.CHINA).format(new Date()) + ("d14xNg==")});

        if(Environment.getExternalStorageState().equals(("mounted"))) {

            File v1 = new File(v0);
            try {
                dji.pilot.usercenter.f.c.a(v1, arg6, ("UTF-8"));

            }
            catch(IOException v0_1) {
                v0_1.printStackTrace();
            }
        }
    }

    public static String b(ProductType arg2) {
        String v0 = g.a;
        if(dji.pilot.fpv.f.c.j(arg2)) {
            v0 = g.c;
        }

        return v0;
    }

    public static void b(Context arg6) {
        int v1 = 0x1E00000;
        DisplayImageOptions v2 = new Builder().imageScaleType(ImageScaleType.EXACTLY).displayer(new FadeInBitmapDisplayer(200)).cacheInMemory(true).cacheOnDisc(true).considerExifParams(true).bitmapConfig(Bitmap$Config.RGB_565).build();
        int v0 = ((int)((((float)Runtime.getRuntime().maxMemory())) * 0.16f));
        if(v0 > v1) {
            v0 = v1;
        }

        ImageLoader.getInstance().init(new com.nostra13.universalimageloader.core.ImageLoaderConfiguration$Builder(arg6).threadPoolSize(3).denyCacheImageMultipleSizesInMemory().discCacheSize(v1).memoryCacheSize(v0).discCacheFileNameGenerator(new Md5FileNameGenerator()).defaultDisplayImageOptions(v2).build());
    }

    public static void b(Context arg3, String arg4, boolean arg5) {
        Intent v0 = new Intent(("android.intent.action.DIAL"));

        v0.setData(Uri.parse(("tel:") + arg4));

        v0.setFlags(0x10000000);
        if(v0.resolveActivity(arg3.getPackageManager()) != null) {
            arg3.startActivity(v0);
        }
        else if(arg5) {
            Toast.makeText(arg3.getApplicationContext(), 0x7F090403, 0).show();
        }
    }

    public static boolean b(String arg2) {
        boolean v0 = false;
        if(arg2 != null && arg2.length() > 0) {
            v0 = Pattern.compile(g.g).matcher(arg2.trim()).matches();
        }

        return v0;
    }

    public static boolean c() {
        boolean v0 = !g.i || !g.j ? false : true;
        return v0;
    }

    public static String c(ProductType arg1) {
        if(arg1 == null) {
            arg1 = k.getInstance().c();
        }

        if(arg1 != g.m) {
            g.n = dji.pilot.publics.c.d.getInstance().a(arg1).activeName;
        }

        return g.n;
    }

    public static long c(String arg8) {
        String[] v1 = arg8.split(("."));

        long v2 = 0;
        int v0;
        for(v0 = 0; v0 < v1.length; ++v0) {
            v2 = v2 * 0x100 + (((long)Integer.parseInt(v1[v0], 10)));
        }

        return v2;
    }

    public static void c(Context arg5) {
        b v4 = null;
        if((dji.midware.data.manager.Dpad.a.getInstance().b()) || (dji.midware.data.manager.Dpad.a.getInstance().d())) {
            DJIOriLayout.getDeviceType();
            DJIOriLayout.setDeviceType(DJIDeviceType.DJI5_5);
            g.b();
            g.g();
        }

        dji.pilot.popup.a.a.getInstance();
        dji.pilot.configs.a.a(arg5);
        dji.sdksharedlib.a.getInstance().a(arg5);
        dji.d.a.getInstance().b(arg5);
        dji.pilot.server.b v0 = new dji.pilot.server.b();
        try {
            v0.b();
        }
        catch(SignatureException v0_1) {
            v0_1.printStackTrace();
        }

        x.getInstance().a(arg5);
        dji.pilot.publics.c.a.a(arg5);
        dji.velib.h.c.a(arg5);
        dji.pilot.publics.control.upgrade.b.getInstance().a(arg5);
        dji.pilot.publics.control.rc.b.getInstance().a(arg5);
        dji.pilot.publics.control.a.getInstance(arg5);
        DJIGenSettingDataManager.getInstance().a(arg5);
        dji.pilot.fpv.camera.more.a.getInstance().a(arg5);
        dji.pilot.fpv.camera.more.a.getInstance().q();
        e.a();
        dji.pilot2.publics.b.a.a();
        dji.pilot.usercenter.b.g.getInstance().a(arg5);
        dji.pilot.battery.a.a.getInstance().a(arg5);
        dji.pilot.publics.c.d.a(arg5);
        i.getInstance(arg5);
        g.b(arg5);
        dji.pilot2.c.a(arg5);
        dji.pilot.publics.c.c.getInstance();
        DJINotificationDialog.a = j.b(arg5, ("tips"), false);

        dji.pilot.upgrade.b.getInstance().a();
        dji.pilot.upgrade.e.getInstance().a(arg5);
        f.getInstance().a(arg5);
        dji.pilot.upgrade.a.getInstance().a(arg5);
        dji.pilot.fpv.flightmode.b.getInstance();
        dji.logic.c.b.getInstance();
        if(!dji.assets.c.a(arg5)) {
            FlyfrbLaunchUtil.init(arg5);
        }

        dji.pilot2.publics.a.a.a(arg5);
        int v0_2 = (((int)Runtime.getRuntime().maxMemory())) / 20;
        g.h(arg5);
        com.dji.frame.c.c.a(arg5).e(v0_2);
        if(arg5.getString(0x7F091E58).compareTo(j.b(arg5, g.f, "")) == 0) {
            EventBus.getDefault().post(dji.pilot.flyforbid.FlyforbidUpdateService$a.b);
        }

        dji.pilot.fpv.control.a.e.getInstance().a();
        dji.publics.b.b.a(arg5, false, SettingController.getInstance().getIsEnableCellular(), ("gpPhone"));

        dji.pilot.fpv.f.f.a(arg5);
        dji.pilot.fpv.f.b.getInstance().a(arg5);
        dji.pilot.fpv.control.a.b.getInstance().a(arg5);
        dji.velib.h.c.a(arg5);
        dji.pilot.countrycode.a.c.getInstance().a(arg5, v4);
        dji.pilot.fpv.control.a.a.a.getInstance().b();
        dji.pilot2.usercenter.control.c.a.a(arg5);
        dji.pilot.usercenter.b.g.getInstance().b(((Context)v4));
    }

    public static void c(Context arg3, boolean arg4) {
        Intent v0 = new Intent(("android.settings.WIFI_SETTINGS"));

        if(v0.resolveActivity(arg3.getPackageManager()) != null) {
            arg3.startActivity(v0);
        }
        else if(arg4) {
            Toast.makeText(arg3.getApplicationContext(), 0x7F090403, 0).show();
        }
    }

    public static Class d() {
        Class v0_1;
        dji.midware.data.config.a.a v0 = dji.midware.data.manager.Dpad.a.getInstance().a();
        if(v0 == dji.midware.data.config.a.a.b) {
            v0_1 = DJIRcMainActivity.class;
        }
        else {
            if(v0 != dji.midware.data.config.a.a.c && v0 != dji.midware.data.config.a.a.d) {
                return DJIMainFragmentActivity.class;
            }

            v0_1 = DJICsMainActivity.class;
        }

        return v0_1;
    }

    public static boolean d(Context arg2) {
        return j.b(arg2, g.k, true);
    }

    public static void d(Context arg1, boolean arg2) {
        dji.publics.DJIObject.b.getInstance().a(arg2);
        j.a(arg1, g.k, arg2);
    }

    private static void d(String arg1) {
        Log.e(("DJIPublicUtil"), arg1);

    }

    public static Activity e() {
        Activity v0;
        if(g.l == null) {
            v0 = null;
        }
        else {
            Object v0_1 = g.l.get();
        }

        return v0;
    }

    public static void e(Context arg3) {
        if(g.d(arg3)) {
            CrashReport.setIsDevelopmentDevice(arg3, com.dji.frame.c.b.c(arg3));
            UserStrategy v0 = new UserStrategy(arg3);
            v0.setUploadProcess(true);
            v0.setAppVersion(SetReflect.getAppVersion());
            v0.setCrashHandleCallback(new CrashHandleCallback(arg3) {
                public Map onCrashHandleStart(int arg3, String arg4, String arg5, String arg6) {
                    Map v0_1;
                    __monitor_enter(this);
                    if(arg3 == 2) {
                        try {
                            dji.pilot.publics.e.a.a(dji.pilot.publics.e.a$a.d).execute(new Runnable(arg4, arg5, arg6) {
                                public void run() {
                                    g.a(this.d.a, g.a(this.a, this.b, this.c));
                                }
                            });
                        label_8:
                            v0_1 = super.onCrashHandleStart(arg3, arg4, arg5, arg6);
                            goto label_9;
                        }
                        catch(Throwable v0) {
                            __monitor_exit(this);
                            throw v0;
                        }
                    }

                    goto label_8;
                label_9:
                    __monitor_exit(this);
                    return v0_1;
                }

                public byte[] onCrashHandleStart2GetExtraDatas(int arg2, String arg3, String arg4, String arg5) {
                    byte[] v0_1;
                    __monitor_enter(this);
                    try {
                        v0_1 = super.onCrashHandleStart2GetExtraDatas(arg2, arg3, arg4, arg5);
                    }
                    catch(Throwable v0) {
                        __monitor_exit(this);
                        throw v0;
                    }

                    __monitor_exit(this);
                    return v0_1;
                }
            });
            CrashReport.initCrashReport(arg3, ("900019054"), com.dji.frame.c.b.c(arg3), v0);

        }
    }

    public static void f(Context arg7) {
        int v3 = 0;
        Object v0 = arg7.getApplicationContext().getSystemService(("activity"));

        List v4 = ((ActivityManager)v0).getRunningAppProcesses();
        g.d(("killMySelf: packagename = ") + arg7.getPackageName());

        int v2;
        for(v2 = 0; v2 < v4.size(); ++v2) {
            g.d(("killMySelf: ") + v2 + " " + v4.get(v2).processName);

            if(v4.get(v2).processName.contains(("dji.Here.Map.Service.v2"))) {

                ((ActivityManager)v0).killBackgroundProcesses(v4.get(v2).processName);
                Process.killProcess(v4.get(v2).pid);
                g.d(("killMySelf dji.Here.Map.Service.v2"));

            }

            if(v4.get(v2).processName.contains(arg7.getPackageName() + (":"))) {

                ((ActivityManager)v0).killBackgroundProcesses(v4.get(v2).processName);
                Process.killProcess(v4.get(v2).pid);
                g.d(("killMySelf ") + v4.get(v2).processName);

            }
        }

        while(v3 < v4.size()) {
            if(v4.get(v3).processName.equals(arg7.getPackageName())) {
                ((ActivityManager)v0).killBackgroundProcesses(v4.get(v3).processName);
                Process.killProcess(v4.get(v3).pid);
                g.d(("killMySelf ") + arg7.getPackageName());

            }

            ++v3;
        }
    }

    static WeakReference f() {
        return g.l;
    }

    private static void g() {
        boolean v0_4;
        FileInputStream v0_3;
        FileInputStream v1;
        File v0 = new File(("/mnt/external_sd/extra.rar"));

        if(!v0.exists()) {
            v0 = new File(("/mnt/external_sd1/extra.rar"));

        }

        FileInputStream v2 = null;
        try {
            v1 = new FileInputStream(v0);
        }
        catch(Throwable v0_1) {
            v1 = v2;
            goto label_46;
        }
        catch(Exception v0_2) {
            v0_3 = v2;
            goto label_38;
        }

        try {
            if(System.currentTimeMillis() / 1000 <= Long.parseLong(dji.pilot.publics.util.b.b(new BufferedReader(new InputStreamReader(((InputStream)v1))).readLine(), ("extra")))) {

                v0_4 = true;
            }
            else {
                goto label_31;
            }

            goto label_27;
        }
        catch(Throwable v0_1) {
            goto label_53;
        }
        catch(Exception v0_2) {
            goto label_55;
        }

    label_31:
        v0_4 = false;
        try {
        label_27:
            g.j = v0_4;
            if(v1 == null) {
                return;
            }

            goto label_29;
        }
        catch(Throwable v0_1) {
        label_53:
        }
        catch(Exception v0_2) {
        label_55:
            v0_3 = v1;
        label_38:
            if(v0_3 == null) {
                return;
            }

            try {
                v0_3.close();
            }
            catch(IOException v0_5) {
                v0_5.printStackTrace();
            }

            return;
        }

    label_46:
        if(v1 != null) {
            try {
                v1.close();
            }
            catch(IOException v1_1) {
                v1_1.printStackTrace();
            }
        }

        throw v0_1;
        try {
        label_29:
            v1.close();
        }
        catch(IOException v0_5) {
            v0_5.printStackTrace();
        }
    }

    private static void g(Context arg5) {
        try {
            Class v0_1 = Class.forName(("dji.pilot.fpv.DJICameraDataManagerCompat"));

            v0_1.getMethod(("initEventBus"), Context.class).invoke(v0_1, arg5);

        }
        catch(Exception v0) {
            v0.printStackTrace();
        }
    }

    private static void h(Context arg1) {
        if(arg1 != null) {
            ((Application)arg1).registerActivityLifecycleCallbacks(new Application$ActivityLifecycleCallbacks() {
                public void onActivityCreated(Activity arg1, Bundle arg2) {
                }

                public void onActivityDestroyed(Activity arg1) {
                }

                public void onActivityPaused(Activity arg2) {
                    if(g.f() != null) {
                        g.f().clear();
                    }
                }

                public void onActivityResumed(Activity arg3) {
                    g.a(new WeakReference(arg3));
                    EventBus.getDefault().post(dji.pilot.publics.model.a.a);
                }

                public void onActivitySaveInstanceState(Activity arg1, Bundle arg2) {
                }

                public void onActivityStarted(Activity arg1) {
                }

                public void onActivityStopped(Activity arg1) {
                }
            });
        }
    }
}

