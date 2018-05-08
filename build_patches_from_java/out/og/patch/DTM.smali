.class public Log/patch/DTM;
.super Ljava/lang/Object;
.source "DTM.java"


# static fields
.field public static m_Instance:Log/patch/DTM;

.field public static ms_settings_path:Ljava/lang/String;


# instance fields
.field private m_AlgoChoice:I

.field private m_AlgoParams:[F

.field private m_AltitudeOffset:F

.field private m_CallCounter:I

.field private m_DTM_tiles_paths:[Ljava/lang/String;

.field private m_DoLogging:Z

.field private m_OffsetCalibrationValues:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation
.end field

.field private m_Tiles:[Log/patch/HGTTile;

.field private m_logger:Ljava/util/logging/Logger;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .prologue
    .line 33
    const/4 v0, 0x0

    sput-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    .line 34
    const-string v0, "/mnt/sdcard/DJI/dtm.settings.json"

    sput-object v0, Log/patch/DTM;->ms_settings_path:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 4

    .prologue
    const/4 v2, 0x0

    const/4 v1, 0x0

    .line 49
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 37
    iput-boolean v2, p0, Log/patch/DTM;->m_DoLogging:Z

    .line 38
    const/4 v0, 0x0

    iput v0, p0, Log/patch/DTM;->m_AltitudeOffset:F

    .line 39
    const/4 v0, 0x2

    iput v0, p0, Log/patch/DTM;->m_AlgoChoice:I

    .line 40
    const/4 v0, 0x3

    new-array v0, v0, [F

    fill-array-data v0, :array_20

    iput-object v0, p0, Log/patch/DTM;->m_AlgoParams:[F

    .line 41
    iput-object v1, p0, Log/patch/DTM;->m_DTM_tiles_paths:[Ljava/lang/String;

    .line 42
    iput-object v1, p0, Log/patch/DTM;->m_Tiles:[Log/patch/HGTTile;

    .line 44
    iput-object v1, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    .line 45
    iput v2, p0, Log/patch/DTM;->m_CallCounter:I

    .line 47
    iput-object v1, p0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    .line 50
    return-void

    .line 40
    :array_20
    .array-data 4
        0x41f00000    # 30.0f
        0x41a00000    # 20.0f
        0x40400000    # 3.0f
    .end array-data
.end method

.method public static close()V
    .registers 4

    .prologue
    const/4 v0, 0x0

    .line 96
    sget-object v1, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    if-eqz v1, :cond_25

    sget-object v1, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v1, v1, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    if-eqz v1, :cond_25

    .line 97
    sget-object v1, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iput-boolean v0, v1, Log/patch/DTM;->m_DoLogging:Z

    .line 98
    sget-object v1, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v1, v1, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/util/logging/Logger;->getHandlers()[Ljava/util/logging/Handler;

    move-result-object v1

    array-length v2, v1

    :goto_18
    if-ge v0, v2, :cond_25

    aget-object v3, v1, v0

    .line 99
    invoke-virtual {v3}, Ljava/util/logging/Handler;->flush()V

    .line 100
    invoke-virtual {v3}, Ljava/util/logging/Handler;->close()V

    .line 98
    add-int/lit8 v0, v0, 0x1

    goto :goto_18

    .line 103
    :cond_25
    return-void
.end method

.method public static getInstance()Log/patch/DTM;
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    const/4 v1, 0x0

    .line 53
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    if-nez v0, :cond_ba

    .line 54
    new-instance v0, Lcom/google/gson/GsonBuilder;

    invoke-direct {v0}, Lcom/google/gson/GsonBuilder;-><init>()V

    .line 55
    invoke-virtual {v0}, Lcom/google/gson/GsonBuilder;->create()Lcom/google/gson/Gson;

    move-result-object v0

    .line 57
    new-instance v2, Ljava/io/File;

    sget-object v3, Log/patch/DTM;->ms_settings_path:Ljava/lang/String;

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v2

    .line 59
    new-instance v4, Ljava/io/FileInputStream;

    sget-object v5, Log/patch/DTM;->ms_settings_path:Ljava/lang/String;

    invoke-direct {v4, v5}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    .line 60
    long-to-int v2, v2

    new-array v2, v2, [B

    .line 61
    invoke-virtual {v4, v2}, Ljava/io/FileInputStream;->read([B)I

    .line 63
    new-instance v3, Ljava/lang/String;

    const-string v4, "ISO-8859-1"

    invoke-direct {v3, v2, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 65
    const-class v2, Log/patch/DTM;

    invoke-virtual {v0, v3, v2}, Lcom/google/gson/Gson;->fromJson(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Log/patch/DTM;

    sput-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    .line 67
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    .line 70
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    invoke-virtual {v0}, Log/patch/DTM;->getDTMTilesPaths()[Ljava/lang/String;

    move-result-object v0

    array-length v2, v0

    .line 71
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    new-array v3, v2, [Log/patch/HGTTile;

    iput-object v3, v0, Log/patch/DTM;->m_Tiles:[Log/patch/HGTTile;

    move v0, v1

    .line 72
    :goto_4e
    if-ge v0, v2, :cond_66

    .line 73
    sget-object v3, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v3, v3, Log/patch/DTM;->m_Tiles:[Log/patch/HGTTile;

    new-instance v4, Log/patch/HGTTile;

    sget-object v5, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    invoke-virtual {v5}, Log/patch/DTM;->getDTMTilesPaths()[Ljava/lang/String;

    move-result-object v5

    aget-object v5, v5, v0

    invoke-direct {v4, v5}, Log/patch/HGTTile;-><init>(Ljava/lang/String;)V

    aput-object v4, v3, v0

    .line 72
    add-int/lit8 v0, v0, 0x1

    goto :goto_4e

    .line 76
    :cond_66
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-boolean v0, v0, Log/patch/DTM;->m_DoLogging:Z

    if-eqz v0, :cond_ba

    .line 78
    new-instance v0, Ljava/util/Date;

    invoke-direct {v0}, Ljava/util/Date;-><init>()V

    .line 79
    new-instance v2, Ljava/text/SimpleDateFormat;

    const-string v3, "yyyy-MM-dd_HH-mm-ss"

    invoke-direct {v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 81
    new-instance v3, Ljava/util/logging/FileHandler;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "/mnt/sdcard/DJI/og_logs/DTM-"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v2, v0}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ".log"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v3, v0}, Ljava/util/logging/FileHandler;-><init>(Ljava/lang/String;)V

    .line 83
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    const-class v2, Log/patch/DTM;

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v2

    iput-object v2, v0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    .line 84
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v0, v0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0, v3}, Ljava/util/logging/Logger;->addHandler(Ljava/util/logging/Handler;)V

    .line 85
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v0, v0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->setUseParentHandlers(Z)V

    .line 89
    :cond_ba
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v0, v0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    .line 90
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iput v1, v0, Log/patch/DTM;->m_CallCounter:I

    .line 92
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    return-object v0
.end method


# virtual methods
.method public getAircraft_HMSL(DDDDFFZ)F
    .registers 19

    .prologue
    .line 187
    .line 188
    iget v0, p0, Log/patch/DTM;->m_AlgoChoice:I

    packed-switch v0, :pswitch_data_66

    .line 202
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HMSL_algo0(DDDDFFZ)F

    move-result v0

    .line 206
    :goto_9
    iget-boolean v1, p0, Log/patch/DTM;->m_DoLogging:Z

    if-eqz v1, :cond_56

    .line 207
    iget-object v1, p0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    sget-object v2, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-string v3, "%.12f %.12f %.12f %.12f %.3f %.3f %b result = %.3f"

    const/16 v4, 0x8

    new-array v4, v4, [Ljava/lang/Object;

    const/4 v5, 0x0

    invoke-static {p1, p2}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x1

    invoke-static {p3, p4}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x2

    invoke-static {p5, p6}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x3

    invoke-static {p7, p8}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x4

    invoke-static/range {p9 .. p9}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x5

    invoke-static/range {p10 .. p10}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x6

    invoke-static/range {p11 .. p11}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v6

    aput-object v6, v4, v5

    const/4 v5, 0x7

    invoke-static {v0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v6

    aput-object v6, v4, v5

    invoke-static {v2, v3, v4}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 210
    :cond_56
    return v0

    .line 190
    :pswitch_57
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HMSL_algo0(DDDDFFZ)F

    move-result v0

    goto :goto_9

    .line 194
    :pswitch_5c
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HMSL_algo1(DDDDFFZ)F

    move-result v0

    goto :goto_9

    .line 198
    :pswitch_61
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HMSL_algo2(DDDDFFZ)F

    move-result v0

    goto :goto_9

    .line 188
    :pswitch_data_66
    .packed-switch 0x0
        :pswitch_57
        :pswitch_5c
        :pswitch_61
    .end packed-switch
.end method

.method public getAircraft_HMSL_algo0(DDDDFFZ)F
    .registers 14

    .prologue
    const/4 v0, 0x0

    .line 218
    if-eqz p11, :cond_e

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_e

    cmpl-float v1, p10, v0

    if-lez v1, :cond_e

    .line 224
    :goto_d
    return p10

    .line 220
    :cond_e
    if-nez p11, :cond_18

    invoke-static {p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_18

    move p10, p9

    .line 222
    goto :goto_d

    :cond_18
    move p10, v0

    .line 224
    goto :goto_d
.end method

.method public getAircraft_HMSL_algo1(DDDDFFZ)F
    .registers 17

    .prologue
    const/4 v0, 0x0

    .line 237
    invoke-static {p1, p2}, Ljava/lang/Double;->isNaN(D)Z

    move-result v1

    if-nez v1, :cond_1a

    invoke-static {p3, p4}, Ljava/lang/Double;->isNaN(D)Z

    move-result v1

    if-nez v1, :cond_1a

    invoke-static {p7, p8}, Ljava/lang/Double;->isNaN(D)Z

    move-result v1

    if-nez v1, :cond_1a

    float-to-double v2, p9

    invoke-static {v2, v3}, Ljava/lang/Double;->isNaN(D)Z

    move-result v1

    if-eqz v1, :cond_2f

    .line 241
    :cond_1a
    if-eqz p11, :cond_23

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_23

    .line 268
    :cond_22
    :goto_22
    return p10

    .line 243
    :cond_23
    if-nez p11, :cond_2d

    invoke-static {p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_2d

    move p10, p9

    .line 244
    goto :goto_22

    :cond_2d
    move p10, v0

    .line 246
    goto :goto_22

    .line 252
    :cond_2f
    invoke-virtual {p0, p5, p6, p7, p8}, Log/patch/DTM;->getDTM_HMSL(DD)F

    move-result v1

    .line 253
    invoke-virtual {p0, p1, p2, p3, p4}, Log/patch/DTM;->getDTM_HMSL(DD)F

    move-result v2

    .line 255
    sub-float v1, v2, v1

    sub-float v1, p9, v1

    .line 257
    if-eqz p11, :cond_53

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v2

    if-nez v2, :cond_53

    cmpl-float v2, p10, v0

    if-lez v2, :cond_53

    .line 260
    invoke-static {v1}, Ljava/lang/Float;->isNaN(F)Z

    move-result v0

    if-nez v0, :cond_22

    .line 261
    sub-float v0, p10, v1

    invoke-virtual {p0, v0}, Log/patch/DTM;->setAltitudeOffset(F)V

    goto :goto_22

    .line 264
    :cond_53
    if-nez p11, :cond_65

    invoke-static {p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v2

    if-nez v2, :cond_65

    .line 266
    invoke-virtual {p0}, Log/patch/DTM;->getAltitudeOffset()F

    move-result v2

    add-float/2addr v1, v2

    invoke-static {v0, v1}, Ljava/lang/Math;->max(FF)F

    move-result p10

    goto :goto_22

    :cond_65
    move p10, v0

    .line 268
    goto :goto_22
.end method

.method public getAircraft_HMSL_algo2(DDDDFFZ)F
    .registers 17

    .prologue
    .line 288
    invoke-static {p1, p2}, Ljava/lang/Double;->isNaN(D)Z

    move-result v0

    if-nez v0, :cond_19

    invoke-static {p3, p4}, Ljava/lang/Double;->isNaN(D)Z

    move-result v0

    if-nez v0, :cond_19

    invoke-static {p7, p8}, Ljava/lang/Double;->isNaN(D)Z

    move-result v0

    if-nez v0, :cond_19

    float-to-double v0, p9

    invoke-static {v0, v1}, Ljava/lang/Double;->isNaN(D)Z

    move-result v0

    if-eqz v0, :cond_33

    .line 292
    :cond_19
    if-eqz p11, :cond_27

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v0

    if-nez v0, :cond_27

    const/4 v0, 0x0

    cmpl-float v0, p10, v0

    if-lez v0, :cond_27

    .line 329
    :cond_26
    :goto_26
    return p10

    .line 294
    :cond_27
    if-nez p11, :cond_31

    invoke-static {p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v0

    if-nez v0, :cond_31

    move p10, p9

    .line 295
    goto :goto_26

    .line 297
    :cond_31
    const/4 p10, 0x0

    goto :goto_26

    .line 303
    :cond_33
    invoke-virtual {p0, p5, p6, p7, p8}, Log/patch/DTM;->getDTM_HMSL(DD)F

    move-result v0

    .line 304
    invoke-virtual {p0, p1, p2, p3, p4}, Log/patch/DTM;->getDTM_HMSL(DD)F

    move-result v1

    .line 306
    sub-float v0, v1, v0

    sub-float v0, p9, v0

    .line 308
    if-eqz p11, :cond_c5

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_c5

    const/4 v1, 0x0

    cmpl-float v1, p10, v1

    if-lez v1, :cond_c5

    .line 312
    invoke-static {v0}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_26

    sub-float v1, p10, v0

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v1

    iget-object v2, p0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v3, 0x1

    aget v2, v2, v3

    cmpg-float v1, v1, v2

    if-gtz v1, :cond_26

    .line 313
    iget-object v1, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    iget-object v2, p0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v3, 0x0

    aget v2, v2, v3

    float-to-int v2, v2

    if-ge v1, v2, :cond_26

    .line 314
    iget-object v1, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    new-instance v2, Ljava/lang/Float;

    sub-float v0, p10, v0

    invoke-direct {v2, v0}, Ljava/lang/Float;-><init>(F)V

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 315
    new-instance v0, Ljava/lang/Float;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/lang/Float;-><init>(F)V

    .line 316
    iget-object v1, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    move-object v1, v0

    :goto_88
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_a3

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Float;

    .line 317
    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v1

    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    add-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v0

    move-object v1, v0

    .line 318
    goto :goto_88

    .line 319
    :cond_a3
    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v0

    new-instance v1, Ljava/lang/Float;

    iget-object v2, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    int-to-float v2, v2

    invoke-direct {v1, v2}, Ljava/lang/Float;-><init>(F)V

    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v1

    div-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v0

    .line 320
    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    invoke-virtual {p0, v0}, Log/patch/DTM;->setAltitudeOffset(F)V

    goto/16 :goto_26

    .line 325
    :cond_c5
    if-nez p11, :cond_df

    invoke-static {v0}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_df

    .line 327
    const/4 v1, 0x0

    invoke-virtual {p0}, Log/patch/DTM;->getAltitudeOffset()F

    move-result v2

    add-float/2addr v0, v2

    iget-object v2, p0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v3, 0x2

    aget v2, v2, v3

    sub-float/2addr v0, v2

    invoke-static {v1, v0}, Ljava/lang/Math;->max(FF)F

    move-result p10

    goto/16 :goto_26

    .line 329
    :cond_df
    const/4 p10, 0x0

    goto/16 :goto_26
.end method

.method public getAlgoChoice()I
    .registers 2

    .prologue
    .line 122
    iget v0, p0, Log/patch/DTM;->m_AlgoChoice:I

    return v0
.end method

.method public getAlgoParams()[F
    .registers 2

    .prologue
    .line 130
    iget-object v0, p0, Log/patch/DTM;->m_AlgoParams:[F

    return-object v0
.end method

.method public getAltitudeOffset()F
    .registers 2

    .prologue
    .line 114
    iget v0, p0, Log/patch/DTM;->m_AltitudeOffset:F

    return v0
.end method

.method public getDTMTilesPaths()[Ljava/lang/String;
    .registers 2

    .prologue
    .line 138
    iget-object v0, p0, Log/patch/DTM;->m_DTM_tiles_paths:[Ljava/lang/String;

    return-object v0
.end method

.method public getDTM_HMSL(DD)F
    .registers 12

    .prologue
    const/4 v0, 0x0

    .line 146
    invoke-static {p1, p2}, Ljava/lang/Double;->isNaN(D)Z

    move-result v1

    if-nez v1, :cond_d

    invoke-static {p3, p4}, Ljava/lang/Double;->isNaN(D)Z

    move-result v1

    if-eqz v1, :cond_e

    .line 156
    :cond_d
    :goto_d
    return v0

    .line 150
    :cond_e
    iget-object v2, p0, Log/patch/DTM;->m_Tiles:[Log/patch/HGTTile;

    array-length v3, v2

    const/4 v1, 0x0

    :goto_12
    if-ge v1, v3, :cond_d

    aget-object v4, v2, v1

    .line 151
    invoke-virtual {v4, p1, p2, p3, p4}, Log/patch/HGTTile;->isPointInTile(DD)Z

    move-result v5

    if-eqz v5, :cond_21

    .line 152
    invoke-virtual {v4, p1, p2, p3, p4}, Log/patch/HGTTile;->getAltAtLatLng(DD)F

    move-result v0

    goto :goto_d

    .line 150
    :cond_21
    add-int/lit8 v1, v1, 0x1

    goto :goto_12
.end method

.method public getDoLogging()Z
    .registers 2

    .prologue
    .line 106
    iget-boolean v0, p0, Log/patch/DTM;->m_DoLogging:Z

    return v0
.end method

.method public setAlgoChoice(I)V
    .registers 2

    .prologue
    .line 126
    iput p1, p0, Log/patch/DTM;->m_AlgoChoice:I

    .line 127
    return-void
.end method

.method public setAlgoParams([F)V
    .registers 2

    .prologue
    .line 134
    iput-object p1, p0, Log/patch/DTM;->m_AlgoParams:[F

    .line 135
    return-void
.end method

.method public setAltitudeOffset(F)V
    .registers 2

    .prologue
    .line 118
    iput p1, p0, Log/patch/DTM;->m_AltitudeOffset:F

    .line 119
    return-void
.end method

.method public setDTMTilesPaths([Ljava/lang/String;)V
    .registers 2

    .prologue
    .line 142
    iput-object p1, p0, Log/patch/DTM;->m_DTM_tiles_paths:[Ljava/lang/String;

    .line 143
    return-void
.end method

.method public setDoLogging(Z)V
    .registers 2

    .prologue
    .line 110
    iput-boolean p1, p0, Log/patch/DTM;->m_DoLogging:Z

    .line 111
    return-void
.end method
