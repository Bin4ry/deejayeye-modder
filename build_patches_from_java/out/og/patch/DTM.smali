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

.field private m_LastultrasonicValidTime:J

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

.field private m_ResultType:Ljava/lang/String;

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

    .line 64
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 37
    iput-boolean v2, p0, Log/patch/DTM;->m_DoLogging:Z

    .line 38
    const/4 v0, 0x0

    iput v0, p0, Log/patch/DTM;->m_AltitudeOffset:F

    .line 39
    const/4 v0, 0x3

    iput v0, p0, Log/patch/DTM;->m_AlgoChoice:I

    .line 52
    const/4 v0, 0x7

    new-array v0, v0, [F

    fill-array-data v0, :array_26

    iput-object v0, p0, Log/patch/DTM;->m_AlgoParams:[F

    .line 53
    iput-object v1, p0, Log/patch/DTM;->m_DTM_tiles_paths:[Ljava/lang/String;

    .line 54
    iput-object v1, p0, Log/patch/DTM;->m_Tiles:[Log/patch/HGTTile;

    .line 56
    iput-object v1, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    .line 57
    iput v2, p0, Log/patch/DTM;->m_CallCounter:I

    .line 59
    iput-object v1, p0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    .line 61
    iput-object v1, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 62
    const-wide/16 v0, -0x1

    iput-wide v0, p0, Log/patch/DTM;->m_LastultrasonicValidTime:J

    .line 65
    return-void

    .line 52
    :array_26
    .array-data 4
        0x41f00000    # 30.0f
        0x40a00000    # 5.0f
        0x41700000    # 15.0f
        0x40400000    # 3.0f
        0x42480000    # 50.0f
        0x41a00000    # 20.0f
        0x455ac000    # 3500.0f
    .end array-data
.end method

.method public static close()V
    .registers 4

    .prologue
    const/4 v0, 0x0

    .line 111
    sget-object v1, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    if-eqz v1, :cond_25

    sget-object v1, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v1, v1, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    if-eqz v1, :cond_25

    .line 112
    sget-object v1, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iput-boolean v0, v1, Log/patch/DTM;->m_DoLogging:Z

    .line 113
    sget-object v1, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v1, v1, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/util/logging/Logger;->getHandlers()[Ljava/util/logging/Handler;

    move-result-object v1

    array-length v2, v1

    :goto_18
    if-ge v0, v2, :cond_25

    aget-object v3, v1, v0

    .line 114
    invoke-virtual {v3}, Ljava/util/logging/Handler;->flush()V

    .line 115
    invoke-virtual {v3}, Ljava/util/logging/Handler;->close()V

    .line 113
    add-int/lit8 v0, v0, 0x1

    goto :goto_18

    .line 118
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

    .line 68
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    if-nez v0, :cond_ba

    .line 69
    new-instance v0, Lcom/google/gson/GsonBuilder;

    invoke-direct {v0}, Lcom/google/gson/GsonBuilder;-><init>()V

    .line 70
    invoke-virtual {v0}, Lcom/google/gson/GsonBuilder;->create()Lcom/google/gson/Gson;

    move-result-object v0

    .line 72
    new-instance v2, Ljava/io/File;

    sget-object v3, Log/patch/DTM;->ms_settings_path:Ljava/lang/String;

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v2

    .line 74
    new-instance v4, Ljava/io/FileInputStream;

    sget-object v5, Log/patch/DTM;->ms_settings_path:Ljava/lang/String;

    invoke-direct {v4, v5}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    .line 75
    long-to-int v2, v2

    new-array v2, v2, [B

    .line 76
    invoke-virtual {v4, v2}, Ljava/io/FileInputStream;->read([B)I

    .line 78
    new-instance v3, Ljava/lang/String;

    const-string v4, "ISO-8859-1"

    invoke-direct {v3, v2, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 80
    const-class v2, Log/patch/DTM;

    invoke-virtual {v0, v3, v2}, Lcom/google/gson/Gson;->fromJson(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Log/patch/DTM;

    sput-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    .line 82
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    .line 85
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    invoke-virtual {v0}, Log/patch/DTM;->getDTMTilesPaths()[Ljava/lang/String;

    move-result-object v0

    array-length v2, v0

    .line 86
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    new-array v3, v2, [Log/patch/HGTTile;

    iput-object v3, v0, Log/patch/DTM;->m_Tiles:[Log/patch/HGTTile;

    move v0, v1

    .line 87
    :goto_4e
    if-ge v0, v2, :cond_66

    .line 88
    sget-object v3, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v3, v3, Log/patch/DTM;->m_Tiles:[Log/patch/HGTTile;

    new-instance v4, Log/patch/HGTTile;

    sget-object v5, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    invoke-virtual {v5}, Log/patch/DTM;->getDTMTilesPaths()[Ljava/lang/String;

    move-result-object v5

    aget-object v5, v5, v0

    invoke-direct {v4, v5}, Log/patch/HGTTile;-><init>(Ljava/lang/String;)V

    aput-object v4, v3, v0

    .line 87
    add-int/lit8 v0, v0, 0x1

    goto :goto_4e

    .line 91
    :cond_66
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-boolean v0, v0, Log/patch/DTM;->m_DoLogging:Z

    if-eqz v0, :cond_ba

    .line 93
    new-instance v0, Ljava/util/Date;

    invoke-direct {v0}, Ljava/util/Date;-><init>()V

    .line 94
    new-instance v2, Ljava/text/SimpleDateFormat;

    const-string v3, "yyyy-MM-dd_HH-mm-ss"

    invoke-direct {v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 96
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

    .line 98
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    const-class v2, Log/patch/DTM;

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v2

    iput-object v2, v0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    .line 99
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v0, v0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0, v3}, Ljava/util/logging/Logger;->addHandler(Ljava/util/logging/Handler;)V

    .line 100
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v0, v0, Log/patch/DTM;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->setUseParentHandlers(Z)V

    .line 104
    :cond_ba
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iget-object v0, v0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    .line 105
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    iput v1, v0, Log/patch/DTM;->m_CallCounter:I

    .line 107
    sget-object v0, Log/patch/DTM;->m_Instance:Log/patch/DTM;

    return-object v0
.end method


# virtual methods
.method public addCalibrationPoint(FF)V
    .registers 6

    .prologue
    .line 503
    invoke-static {p1}, Ljava/lang/Float;->isNaN(F)Z

    move-result v0

    if-nez v0, :cond_58

    .line 504
    iget-object v0, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    new-instance v1, Ljava/lang/Float;

    invoke-direct {v1, p2}, Ljava/lang/Float;-><init>(F)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 505
    new-instance v0, Ljava/lang/Float;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/lang/Float;-><init>(F)V

    .line 506
    iget-object v1, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    move-object v1, v0

    :goto_1d
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_38

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Float;

    .line 507
    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v1

    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    add-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v0

    move-object v1, v0

    .line 508
    goto :goto_1d

    .line 509
    :cond_38
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

    .line 510
    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    invoke-virtual {p0, v0}, Log/patch/DTM;->setAltitudeOffset(F)V

    .line 512
    :cond_58
    return-void
.end method

.method public appendResultTypeToUnit(Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    .prologue
    .line 121
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 122
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 123
    iget-object v1, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    if-eqz v1, :cond_11

    .line 124
    iget-object v1, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 126
    :cond_11
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public getAircraft_HAGL(DDDDFFZ)F
    .registers 19

    .prologue
    .line 211
    .line 212
    iget v0, p0, Log/patch/DTM;->m_AlgoChoice:I

    packed-switch v0, :pswitch_data_6c

    .line 230
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HAGL_algo0(DDDDFFZ)F

    move-result v0

    .line 234
    :goto_9
    iget-boolean v1, p0, Log/patch/DTM;->m_DoLogging:Z

    if-eqz v1, :cond_56

    .line 235
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

    .line 238
    :cond_56
    return v0

    .line 214
    :pswitch_57
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HAGL_algo3(DDDDFFZ)F

    move-result v0

    goto :goto_9

    .line 218
    :pswitch_5c
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HAGL_algo2(DDDDFFZ)F

    move-result v0

    goto :goto_9

    .line 222
    :pswitch_61
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HAGL_algo1(DDDDFFZ)F

    move-result v0

    goto :goto_9

    .line 226
    :pswitch_66
    invoke-virtual/range {p0 .. p11}, Log/patch/DTM;->getAircraft_HAGL_algo0(DDDDFFZ)F

    move-result v0

    goto :goto_9

    .line 212
    nop

    :pswitch_data_6c
    .packed-switch 0x0
        :pswitch_66
        :pswitch_61
        :pswitch_5c
        :pswitch_57
    .end packed-switch
.end method

.method public getAircraft_HAGL_algo0(DDDDFFZ)F
    .registers 14

    .prologue
    const/4 v0, 0x0

    .line 246
    if-eqz p11, :cond_12

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_12

    cmpl-float v1, p10, v0

    if-lez v1, :cond_12

    .line 247
    const-string v0, "-AGL"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 255
    :goto_11
    return p10

    .line 249
    :cond_12
    if-nez p11, :cond_20

    invoke-static {p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_20

    .line 251
    const-string v0, "-QFE"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move p10, p9

    .line 252
    goto :goto_11

    .line 254
    :cond_20
    const-string v1, "-err"

    iput-object v1, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move p10, v0

    .line 255
    goto :goto_11
.end method

.method public getAircraft_HAGL_algo1(DDDDFFZ)F
    .registers 17

    .prologue
    const/4 v0, 0x0

    .line 272
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

    if-eqz v1, :cond_3b

    .line 276
    :cond_1a
    if-eqz p11, :cond_27

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_27

    .line 277
    const-string v0, "-AGL"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 309
    :goto_26
    return p10

    .line 279
    :cond_27
    if-nez p11, :cond_35

    invoke-static {p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_35

    .line 280
    const-string v0, "-QFE"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move p10, p9

    .line 281
    goto :goto_26

    .line 283
    :cond_35
    const-string v1, "-err"

    iput-object v1, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move p10, v0

    .line 284
    goto :goto_26

    .line 290
    :cond_3b
    invoke-virtual {p0, p5, p6, p7, p8}, Log/patch/DTM;->getDTM_HAGL(DD)F

    move-result v1

    .line 291
    invoke-virtual {p0, p1, p2, p3, p4}, Log/patch/DTM;->getDTM_HAGL(DD)F

    move-result v2

    .line 293
    sub-float v1, v2, v1

    sub-float v1, p9, v1

    .line 295
    if-eqz p11, :cond_63

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v2

    if-nez v2, :cond_63

    cmpl-float v2, p10, v0

    if-lez v2, :cond_63

    .line 298
    invoke-static {v1}, Ljava/lang/Float;->isNaN(F)Z

    move-result v0

    if-nez v0, :cond_5e

    .line 299
    sub-float v0, p10, v1

    invoke-virtual {p0, v0}, Log/patch/DTM;->setAltitudeOffset(F)V

    .line 301
    :cond_5e
    const-string v0, "-AGL"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    goto :goto_26

    .line 303
    :cond_63
    if-nez p11, :cond_79

    invoke-static {p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v2

    if-nez v2, :cond_79

    .line 305
    const-string v2, "-DTM"

    iput-object v2, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 306
    invoke-virtual {p0}, Log/patch/DTM;->getAltitudeOffset()F

    move-result v2

    add-float/2addr v1, v2

    invoke-static {v0, v1}, Ljava/lang/Math;->max(FF)F

    move-result p10

    goto :goto_26

    .line 308
    :cond_79
    const-string v1, "-err"

    iput-object v1, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move p10, v0

    .line 309
    goto :goto_26
.end method

.method public getAircraft_HAGL_algo2(DDDDFFZ)F
    .registers 17

    .prologue
    .line 329
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

    if-eqz v0, :cond_3f

    .line 333
    :cond_19
    if-eqz p11, :cond_2b

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v0

    if-nez v0, :cond_2b

    const/4 v0, 0x0

    cmpl-float v0, p10, v0

    if-lez v0, :cond_2b

    .line 334
    const-string v0, "-AGL"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 378
    :goto_2a
    return p10

    .line 336
    :cond_2b
    if-nez p11, :cond_39

    invoke-static {p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v0

    if-nez v0, :cond_39

    .line 337
    const-string v0, "-QFE"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move p10, p9

    .line 338
    goto :goto_2a

    .line 340
    :cond_39
    const-string v0, "-err"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 341
    const/4 p10, 0x0

    goto :goto_2a

    .line 347
    :cond_3f
    invoke-virtual {p0, p5, p6, p7, p8}, Log/patch/DTM;->getDTM_HAGL(DD)F

    move-result v0

    .line 348
    invoke-virtual {p0, p1, p2, p3, p4}, Log/patch/DTM;->getDTM_HAGL(DD)F

    move-result v1

    .line 350
    sub-float v0, v1, v0

    sub-float v0, p9, v0

    .line 351
    sub-float v1, p10, v0

    .line 352
    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v2

    .line 354
    if-eqz p11, :cond_d3

    invoke-static {p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v3

    if-nez v3, :cond_d3

    const/4 v3, 0x0

    cmpl-float v3, p10, v3

    if-lez v3, :cond_d3

    .line 358
    invoke-static {v0}, Ljava/lang/Float;->isNaN(F)Z

    move-result v0

    if-nez v0, :cond_cd

    iget-object v0, p0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v3, 0x1

    aget v0, v0, v3

    cmpg-float v0, v2, v0

    if-gtz v0, :cond_cd

    .line 359
    iget-object v0, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    iget-object v2, p0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v3, 0x0

    aget v2, v2, v3

    float-to-int v2, v2

    if-ge v0, v2, :cond_cd

    .line 360
    iget-object v0, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    new-instance v2, Ljava/lang/Float;

    invoke-direct {v2, v1}, Ljava/lang/Float;-><init>(F)V

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 361
    new-instance v0, Ljava/lang/Float;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/lang/Float;-><init>(F)V

    .line 362
    iget-object v1, p0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    move-object v1, v0

    :goto_92
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_ad

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Float;

    .line 363
    invoke-virtual {v1}, Ljava/lang/Float;->floatValue()F

    move-result v1

    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    add-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v0

    move-object v1, v0

    .line 364
    goto :goto_92

    .line 365
    :cond_ad
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

    .line 366
    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F

    move-result v0

    invoke-virtual {p0, v0}, Log/patch/DTM;->setAltitudeOffset(F)V

    .line 370
    :cond_cd
    const-string v0, "-AGL"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    goto/16 :goto_2a

    .line 372
    :cond_d3
    if-nez p11, :cond_f1

    invoke-static {v0}, Ljava/lang/Float;->isNaN(F)Z

    move-result v1

    if-nez v1, :cond_f1

    .line 374
    const-string v1, "-DTM"

    iput-object v1, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 375
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

    goto/16 :goto_2a

    .line 377
    :cond_f1
    const-string v0, "-err"

    iput-object v0, p0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 378
    const/4 p10, 0x0

    goto/16 :goto_2a
.end method

.method public getAircraft_HAGL_algo3(DDDDFFZ)F
    .registers 31

    .prologue
    .line 401
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v8

    .line 402
    const-wide/16 v6, 0x0

    .line 404
    if-eqz p11, :cond_63

    move-object/from16 v0, p0

    iget-wide v10, v0, Log/patch/DTM;->m_LastultrasonicValidTime:J

    const-wide/16 v12, -0x1

    cmp-long v10, v10, v12

    if-nez v10, :cond_63

    invoke-static/range {p10 .. p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v10

    if-nez v10, :cond_63

    const/4 v10, 0x0

    cmpl-float v10, p10, v10

    if-ltz v10, :cond_63

    .line 405
    move-object/from16 v0, p0

    iput-wide v8, v0, Log/patch/DTM;->m_LastultrasonicValidTime:J

    .line 412
    :goto_21
    invoke-static/range {p1 .. p2}, Ljava/lang/Double;->isNaN(D)Z

    move-result v8

    if-nez v8, :cond_3c

    invoke-static/range {p3 .. p4}, Ljava/lang/Double;->isNaN(D)Z

    move-result v8

    if-nez v8, :cond_3c

    invoke-static/range {p7 .. p8}, Ljava/lang/Double;->isNaN(D)Z

    move-result v8

    if-nez v8, :cond_3c

    move/from16 v0, p9

    float-to-double v8, v0

    invoke-static {v8, v9}, Ljava/lang/Double;->isNaN(D)Z

    move-result v8

    if-eqz v8, :cond_a0

    .line 416
    :cond_3c
    if-eqz p11, :cond_88

    invoke-static/range {p10 .. p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v8

    if-nez v8, :cond_88

    const/4 v8, 0x0

    cmpl-float v8, p10, v8

    if-lez v8, :cond_88

    const-wide v8, 0x3fd3333333333333L    # 0.3

    move-object/from16 v0, p0

    iget-object v10, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v11, 0x6

    aget v10, v10, v11

    float-to-double v10, v10

    mul-double/2addr v8, v10

    double-to-long v8, v8

    cmp-long v6, v6, v8

    if-lez v6, :cond_88

    .line 417
    const-string v6, "-AGL"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 496
    :goto_62
    return p10

    .line 406
    :cond_63
    if-eqz p11, :cond_81

    move-object/from16 v0, p0

    iget-wide v10, v0, Log/patch/DTM;->m_LastultrasonicValidTime:J

    const-wide/16 v12, 0x0

    cmp-long v10, v10, v12

    if-ltz v10, :cond_81

    invoke-static/range {p10 .. p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v10

    if-nez v10, :cond_81

    const/4 v10, 0x0

    cmpl-float v10, p10, v10

    if-ltz v10, :cond_81

    .line 407
    move-object/from16 v0, p0

    iget-wide v6, v0, Log/patch/DTM;->m_LastultrasonicValidTime:J

    sub-long v6, v8, v6

    goto :goto_21

    .line 409
    :cond_81
    const-wide/16 v8, -0x1

    move-object/from16 v0, p0

    iput-wide v8, v0, Log/patch/DTM;->m_LastultrasonicValidTime:J

    goto :goto_21

    .line 419
    :cond_88
    invoke-static/range {p9 .. p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v6

    if-nez v6, :cond_97

    .line 420
    const-string v6, "-QFE"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move/from16 p10, p9

    .line 421
    goto :goto_62

    .line 423
    :cond_97
    const-string v6, "-err"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 424
    const/16 p10, 0x0

    goto :goto_62

    .line 431
    :cond_a0
    move-object/from16 v0, p0

    move-wide/from16 v1, p5

    move-wide/from16 v3, p7

    invoke-virtual {v0, v1, v2, v3, v4}, Log/patch/DTM;->getDTM_HAGL(DD)F

    move-result v8

    .line 432
    invoke-virtual/range {p0 .. p4}, Log/patch/DTM;->getDTM_HAGL(DD)F

    move-result v9

    .line 433
    const/4 v10, 0x0

    sub-float v8, v9, v8

    sub-float v8, p9, v8

    invoke-static {v10, v8}, Ljava/lang/Math;->max(FF)F

    move-result v12

    .line 435
    sub-float v13, p10, v12

    .line 437
    invoke-static {v13}, Ljava/lang/Math;->abs(F)F

    move-result v11

    .line 438
    sub-float v8, p10, p9

    invoke-static {v8}, Ljava/lang/Math;->abs(F)F

    move-result v14

    .line 440
    invoke-virtual/range {p0 .. p8}, Log/patch/DTM;->pseudo_dist(DDDD)D

    move-result-wide v8

    .line 441
    move-object/from16 v0, p0

    iget-object v10, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v15, 0x4

    aget v10, v10, v15

    float-to-double v0, v10

    move-wide/from16 v16, v0

    cmpg-double v8, v8, v16

    if-gez v8, :cond_171

    const/4 v8, 0x1

    .line 443
    :goto_d6
    move-object/from16 v0, p0

    iget-object v9, v0, Log/patch/DTM;->m_OffsetCalibrationValues:Ljava/util/ArrayList;

    invoke-virtual {v9}, Ljava/util/ArrayList;->size()I

    move-result v9

    move-object/from16 v0, p0

    iget-object v10, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v15, 0x0

    aget v10, v10, v15

    float-to-int v10, v10

    if-ne v9, v10, :cond_174

    const/4 v9, 0x1

    .line 445
    :goto_e9
    invoke-static {v12}, Ljava/lang/Float;->isNaN(F)Z

    move-result v10

    if-nez v10, :cond_177

    invoke-static {v13}, Ljava/lang/Float;->isNaN(F)Z

    move-result v10

    if-nez v10, :cond_177

    invoke-static/range {p9 .. p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v10

    if-nez v10, :cond_177

    move-object/from16 v0, p0

    iget-object v10, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v15, 0x1

    aget v10, v10, v15

    cmpg-float v10, v11, v10

    if-lez v10, :cond_111

    move-object/from16 v0, p0

    iget-object v10, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v15, 0x1

    aget v10, v10, v15

    cmpg-float v10, v14, v10

    if-gtz v10, :cond_177

    :cond_111
    const/4 v10, 0x1

    .line 449
    :goto_112
    invoke-static {v12}, Ljava/lang/Float;->isNaN(F)Z

    move-result v15

    if-nez v15, :cond_179

    invoke-static {v13}, Ljava/lang/Float;->isNaN(F)Z

    move-result v15

    if-nez v15, :cond_179

    invoke-static/range {p9 .. p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v15

    if-nez v15, :cond_179

    move-object/from16 v0, p0

    iget-object v15, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/16 v16, 0x2

    aget v15, v15, v16

    cmpg-float v11, v11, v15

    if-lez v11, :cond_13b

    move-object/from16 v0, p0

    iget-object v11, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v15, 0x2

    aget v11, v11, v15

    cmpg-float v11, v14, v11

    if-gtz v11, :cond_179

    :cond_13b
    const/4 v11, 0x1

    .line 454
    :goto_13c
    if-eqz p11, :cond_1d3

    invoke-static/range {p10 .. p10}, Ljava/lang/Float;->isNaN(F)Z

    move-result v14

    if-nez v14, :cond_1d3

    const/4 v14, 0x0

    cmpl-float v14, p10, v14

    if-lez v14, :cond_1d3

    .line 457
    if-nez v9, :cond_152

    if-eqz v10, :cond_152

    .line 458
    move-object/from16 v0, p0

    invoke-virtual {v0, v12, v13}, Log/patch/DTM;->addCalibrationPoint(FF)V

    .line 462
    :cond_152
    if-eqz v8, :cond_17b

    invoke-static/range {p9 .. p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v8

    if-nez v8, :cond_17b

    invoke-static/range {p9 .. p9}, Ljava/lang/Math;->abs(F)F

    move-result v8

    move-object/from16 v0, p0

    iget-object v9, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v13, 0x5

    aget v9, v9, v13

    cmpg-float v8, v8, v9

    if-gez v8, :cond_17b

    .line 465
    const-string v6, "-AGL"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    goto/16 :goto_62

    .line 441
    :cond_171
    const/4 v8, 0x0

    goto/16 :goto_d6

    .line 443
    :cond_174
    const/4 v9, 0x0

    goto/16 :goto_e9

    .line 445
    :cond_177
    const/4 v10, 0x0

    goto :goto_112

    .line 449
    :cond_179
    const/4 v11, 0x0

    goto :goto_13c

    .line 469
    :cond_17b
    const/4 v8, 0x0

    .line 470
    move-object/from16 v0, p0

    iget-object v9, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v13, 0x6

    aget v9, v9, v13

    float-to-long v14, v9

    cmp-long v6, v6, v14

    if-ltz v6, :cond_20d

    .line 471
    const/4 v6, 0x1

    .line 474
    :goto_189
    if-nez v6, :cond_18d

    if-nez v10, :cond_191

    :cond_18d
    if-eqz v6, :cond_199

    if-eqz v11, :cond_199

    .line 475
    :cond_191
    const-string v6, "-AGL"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    goto/16 :goto_62

    .line 477
    :cond_199
    invoke-static {v12}, Ljava/lang/Float;->isNaN(F)Z

    move-result v6

    if-nez v6, :cond_1b9

    .line 478
    const-string v6, "-DTM"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 479
    const/4 v6, 0x0

    invoke-virtual/range {p0 .. p0}, Log/patch/DTM;->getAltitudeOffset()F

    move-result v7

    add-float/2addr v7, v12

    move-object/from16 v0, p0

    iget-object v8, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v9, 0x3

    aget v8, v8, v9

    sub-float/2addr v7, v8

    invoke-static {v6, v7}, Ljava/lang/Math;->max(FF)F

    move-result p10

    goto/16 :goto_62

    .line 480
    :cond_1b9
    invoke-static/range {p9 .. p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v6

    if-nez v6, :cond_1c9

    .line 481
    const-string v6, "-QFE"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move/from16 p10, p9

    .line 482
    goto/16 :goto_62

    .line 484
    :cond_1c9
    const-string v6, "-err"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 485
    const/16 p10, 0x0

    goto/16 :goto_62

    .line 487
    :cond_1d3
    invoke-static {v12}, Ljava/lang/Float;->isNaN(F)Z

    move-result v6

    if-nez v6, :cond_1f3

    .line 489
    const-string v6, "-DTM"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 490
    const/4 v6, 0x0

    invoke-virtual/range {p0 .. p0}, Log/patch/DTM;->getAltitudeOffset()F

    move-result v7

    add-float/2addr v7, v12

    move-object/from16 v0, p0

    iget-object v8, v0, Log/patch/DTM;->m_AlgoParams:[F

    const/4 v9, 0x3

    aget v8, v8, v9

    sub-float/2addr v7, v8

    invoke-static {v6, v7}, Ljava/lang/Math;->max(FF)F

    move-result p10

    goto/16 :goto_62

    .line 491
    :cond_1f3
    invoke-static/range {p9 .. p9}, Ljava/lang/Float;->isNaN(F)Z

    move-result v6

    if-nez v6, :cond_203

    .line 492
    const-string v6, "-QFE"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    move/from16 p10, p9

    .line 493
    goto/16 :goto_62

    .line 495
    :cond_203
    const-string v6, "-err"

    move-object/from16 v0, p0

    iput-object v6, v0, Log/patch/DTM;->m_ResultType:Ljava/lang/String;

    .line 496
    const/16 p10, 0x0

    goto/16 :goto_62

    :cond_20d
    move v6, v8

    goto/16 :goto_189
.end method

.method public getAlgoChoice()I
    .registers 2

    .prologue
    .line 146
    iget v0, p0, Log/patch/DTM;->m_AlgoChoice:I

    return v0
.end method

.method public getAlgoParams()[F
    .registers 2

    .prologue
    .line 154
    iget-object v0, p0, Log/patch/DTM;->m_AlgoParams:[F

    return-object v0
.end method

.method public getAltitudeOffset()F
    .registers 2

    .prologue
    .line 138
    iget v0, p0, Log/patch/DTM;->m_AltitudeOffset:F

    return v0
.end method

.method public getDTMTilesPaths()[Ljava/lang/String;
    .registers 2

    .prologue
    .line 162
    iget-object v0, p0, Log/patch/DTM;->m_DTM_tiles_paths:[Ljava/lang/String;

    return-object v0
.end method

.method public getDTM_HAGL(DD)F
    .registers 12

    .prologue
    const/4 v0, 0x0

    .line 170
    invoke-static {p1, p2}, Ljava/lang/Double;->isNaN(D)Z

    move-result v1

    if-nez v1, :cond_d

    invoke-static {p3, p4}, Ljava/lang/Double;->isNaN(D)Z

    move-result v1

    if-eqz v1, :cond_e

    .line 180
    :cond_d
    :goto_d
    return v0

    .line 174
    :cond_e
    iget-object v2, p0, Log/patch/DTM;->m_Tiles:[Log/patch/HGTTile;

    array-length v3, v2

    const/4 v1, 0x0

    :goto_12
    if-ge v1, v3, :cond_d

    aget-object v4, v2, v1

    .line 175
    invoke-virtual {v4, p1, p2, p3, p4}, Log/patch/HGTTile;->isPointInTile(DD)Z

    move-result v5

    if-eqz v5, :cond_21

    .line 176
    invoke-virtual {v4, p1, p2, p3, p4}, Log/patch/HGTTile;->getAltAtLatLng(DD)F

    move-result v0

    goto :goto_d

    .line 174
    :cond_21
    add-int/lit8 v1, v1, 0x1

    goto :goto_12
.end method

.method public getDoLogging()Z
    .registers 2

    .prologue
    .line 130
    iget-boolean v0, p0, Log/patch/DTM;->m_DoLogging:Z

    return v0
.end method

.method public pseudo_dist(DDDD)D
    .registers 34

    .prologue
    .line 516
    const-wide v0, 0x400921fb54442d18L    # Math.PI

    mul-double v0, v0, p1

    const-wide v2, 0x4066800000000000L    # 180.0

    div-double/2addr v0, v2

    .line 517
    const-wide v2, 0x400921fb54442d18L    # Math.PI

    mul-double v2, v2, p3

    const-wide v4, 0x4066800000000000L    # 180.0

    div-double/2addr v2, v4

    .line 518
    const-wide v4, 0x400921fb54442d18L    # Math.PI

    mul-double v4, v4, p5

    const-wide v6, 0x4066800000000000L    # 180.0

    div-double/2addr v4, v6

    .line 519
    const-wide v6, 0x400921fb54442d18L    # Math.PI

    mul-double v6, v6, p7

    const-wide v8, 0x4066800000000000L    # 180.0

    div-double/2addr v6, v8

    .line 521
    invoke-static {v4, v5}, Ljava/lang/Math;->cos(D)D

    move-result-wide v8

    .line 522
    invoke-static {v0, v1}, Ljava/lang/Math;->cos(D)D

    move-result-wide v10

    .line 523
    invoke-static {v4, v5}, Ljava/lang/Math;->sin(D)D

    move-result-wide v12

    .line 524
    invoke-static {v0, v1}, Ljava/lang/Math;->sin(D)D

    move-result-wide v14

    .line 526
    invoke-static {v6, v7}, Ljava/lang/Math;->cos(D)D

    move-result-wide v16

    .line 527
    invoke-static {v2, v3}, Ljava/lang/Math;->cos(D)D

    move-result-wide v18

    .line 528
    invoke-static {v6, v7}, Ljava/lang/Math;->sin(D)D

    move-result-wide v6

    .line 529
    invoke-static {v2, v3}, Ljava/lang/Math;->sin(D)D

    move-result-wide v2

    .line 531
    const-wide v20, 0x3fb4f21a3cdaafbfL    # 0.081819190842622

    const-wide/high16 v22, 0x3fe0000000000000L    # 0.5

    add-double/2addr v0, v4

    mul-double v0, v0, v22

    invoke-static {v0, v1}, Ljava/lang/Math;->sin(D)D

    move-result-wide v0

    mul-double v0, v0, v20

    .line 533
    mul-double v4, v10, v18

    mul-double v16, v16, v8

    sub-double v4, v4, v16

    .line 534
    mul-double/2addr v2, v10

    mul-double/2addr v6, v8

    sub-double/2addr v2, v6

    .line 535
    sub-double v6, v14, v12

    .line 537
    const-wide v8, 0x415854a640000000L    # 6378137.0

    const-wide/high16 v10, 0x3ff0000000000000L    # 1.0

    mul-double/2addr v0, v0

    sub-double v0, v10, v0

    invoke-static {v0, v1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v0

    div-double v0, v8, v0

    .line 539
    mul-double/2addr v4, v4

    mul-double/2addr v2, v2

    add-double/2addr v2, v4

    mul-double v4, v6, v6

    add-double/2addr v2, v4

    invoke-static {v2, v3}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v2

    mul-double/2addr v0, v2

    return-wide v0
.end method

.method public setAlgoChoice(I)V
    .registers 2

    .prologue
    .line 150
    iput p1, p0, Log/patch/DTM;->m_AlgoChoice:I

    .line 151
    return-void
.end method

.method public setAlgoParams([F)V
    .registers 2

    .prologue
    .line 158
    iput-object p1, p0, Log/patch/DTM;->m_AlgoParams:[F

    .line 159
    return-void
.end method

.method public setAltitudeOffset(F)V
    .registers 2

    .prologue
    .line 142
    iput p1, p0, Log/patch/DTM;->m_AltitudeOffset:F

    .line 143
    return-void
.end method

.method public setDTMTilesPaths([Ljava/lang/String;)V
    .registers 2

    .prologue
    .line 166
    iput-object p1, p0, Log/patch/DTM;->m_DTM_tiles_paths:[Ljava/lang/String;

    .line 167
    return-void
.end method

.method public setDoLogging(Z)V
    .registers 2

    .prologue
    .line 134
    iput-boolean p1, p0, Log/patch/DTM;->m_DoLogging:Z

    .line 135
    return-void
.end method
