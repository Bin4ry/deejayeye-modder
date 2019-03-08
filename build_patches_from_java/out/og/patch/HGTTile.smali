.class public Log/patch/HGTTile;
.super Ljava/lang/Object;
.source "HGTTile.java"


# instance fields
.field public m_TileData:[S

.field ref_lat:D

.field ref_lng:D


# direct methods
.method constructor <init>()V
    .registers 3

    .prologue
    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 15
    const/4 v0, 0x0

    iput-object v0, p0, Log/patch/HGTTile;->m_TileData:[S

    .line 17
    const-wide v0, 0x4056800000000000L    # 90.0

    iput-wide v0, p0, Log/patch/HGTTile;->ref_lat:D

    .line 18
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Log/patch/HGTTile;->ref_lng:D

    .line 21
    return-void
.end method

.method constructor <init>(Ljava/lang/String;)V
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 15
    const/4 v0, 0x0

    iput-object v0, p0, Log/patch/HGTTile;->m_TileData:[S

    .line 17
    const-wide v0, 0x4056800000000000L    # 90.0

    iput-wide v0, p0, Log/patch/HGTTile;->ref_lat:D

    .line 18
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Log/patch/HGTTile;->ref_lng:D

    .line 24
    invoke-virtual {p0, p1}, Log/patch/HGTTile;->load(Ljava/lang/String;)V

    .line 25
    return-void
.end method


# virtual methods
.method public getAltAtIndexes(II)F
    .registers 7

    .prologue
    const/16 v3, 0xe10

    const/4 v0, 0x0

    .line 58
    iget-object v1, p0, Log/patch/HGTTile;->m_TileData:[S

    if-eqz v1, :cond_23

    iget-object v1, p0, Log/patch/HGTTile;->m_TileData:[S

    array-length v1, v1

    const v2, 0xc5dd21

    if-ne v1, v2, :cond_23

    if-ltz p1, :cond_23

    if-gt p1, v3, :cond_23

    if-ltz p2, :cond_23

    if-gt p2, v3, :cond_23

    .line 59
    iget-object v1, p0, Log/patch/HGTTile;->m_TileData:[S

    mul-int/lit16 v2, p2, 0xe11

    add-int/2addr v2, p1

    aget-short v1, v1, v2

    .line 60
    const/16 v2, -0x8000

    if-eq v1, v2, :cond_23

    int-to-float v0, v1

    .line 62
    :cond_23
    return v0
.end method

.method public getAltAtLatLng(DD)F
    .registers 26

    .prologue
    .line 73
    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    move-object/from16 v0, p0

    iget-wide v4, v0, Log/patch/HGTTile;->ref_lat:D

    sub-double v4, p1, v4

    sub-double/2addr v2, v4

    .line 74
    move-object/from16 v0, p0

    iget-wide v4, v0, Log/patch/HGTTile;->ref_lng:D

    sub-double v4, p3, v4

    .line 76
    const-wide v6, 0x40ac200000000000L    # 3600.0

    mul-double/2addr v6, v2

    invoke-static {v6, v7}, Ljava/lang/Math;->floor(D)D

    move-result-wide v6

    double-to-int v6, v6

    .line 77
    const-wide v8, 0x40ac200000000000L    # 3600.0

    mul-double/2addr v8, v4

    invoke-static {v8, v9}, Ljava/lang/Math;->floor(D)D

    move-result-wide v8

    double-to-int v7, v8

    .line 80
    move-object/from16 v0, p0

    invoke-virtual {v0, v7, v6}, Log/patch/HGTTile;->getAltAtIndexes(II)F

    move-result v8

    .line 81
    add-int/lit8 v9, v7, 0x1

    move-object/from16 v0, p0

    invoke-virtual {v0, v9, v6}, Log/patch/HGTTile;->getAltAtIndexes(II)F

    move-result v9

    .line 82
    add-int/lit8 v10, v7, 0x1

    add-int/lit8 v11, v6, 0x1

    move-object/from16 v0, p0

    invoke-virtual {v0, v10, v11}, Log/patch/HGTTile;->getAltAtIndexes(II)F

    move-result v10

    .line 83
    add-int/lit8 v11, v6, 0x1

    move-object/from16 v0, p0

    invoke-virtual {v0, v7, v11}, Log/patch/HGTTile;->getAltAtIndexes(II)F

    move-result v11

    .line 86
    float-to-double v12, v11

    .line 87
    float-to-double v14, v10

    float-to-double v0, v11

    move-wide/from16 v16, v0

    sub-double v14, v14, v16

    .line 88
    float-to-double v0, v8

    move-wide/from16 v16, v0

    float-to-double v0, v11

    move-wide/from16 v18, v0

    sub-double v16, v16, v18

    .line 89
    float-to-double v0, v11

    move-wide/from16 v18, v0

    float-to-double v10, v10

    sub-double v10, v18, v10

    float-to-double v0, v8

    move-wide/from16 v18, v0

    sub-double v10, v10, v18

    float-to-double v8, v9

    add-double/2addr v8, v10

    .line 91
    const-wide/high16 v10, 0x3ff0000000000000L    # 1.0

    const-wide v18, 0x40ac200000000000L    # 3600.0

    mul-double v2, v2, v18

    int-to-double v0, v6

    move-wide/from16 v18, v0

    sub-double v2, v2, v18

    sub-double v2, v10, v2

    .line 92
    const-wide v10, 0x40ac200000000000L    # 3600.0

    mul-double/2addr v4, v10

    int-to-double v6, v7

    sub-double/2addr v4, v6

    .line 94
    mul-double v6, v14, v4

    add-double/2addr v6, v12

    mul-double v10, v16, v2

    add-double/2addr v6, v10

    mul-double/2addr v4, v8

    mul-double/2addr v2, v4

    add-double/2addr v2, v6

    double-to-float v2, v2

    return v2
.end method

.method public isPointInTile(DD)Z
    .registers 16

    .prologue
    const-wide/high16 v8, 0x3ff0000000000000L    # 1.0

    const-wide/16 v6, 0x0

    .line 67
    iget-wide v0, p0, Log/patch/HGTTile;->ref_lat:D

    sub-double v0, p1, v0

    .line 68
    iget-wide v2, p0, Log/patch/HGTTile;->ref_lng:D

    sub-double v2, p3, v2

    .line 69
    iget-object v4, p0, Log/patch/HGTTile;->m_TileData:[S

    if-eqz v4, :cond_2a

    iget-object v4, p0, Log/patch/HGTTile;->m_TileData:[S

    array-length v4, v4

    const v5, 0xc5dd21

    if-ne v4, v5, :cond_2a

    cmpg-double v4, v6, v0

    if-gez v4, :cond_2a

    cmpg-double v0, v0, v8

    if-gtz v0, :cond_2a

    cmpg-double v0, v6, v2

    if-gtz v0, :cond_2a

    cmpg-double v0, v2, v8

    if-gez v0, :cond_2a

    const/4 v0, 0x1

    :goto_29
    return v0

    :cond_2a
    const/4 v0, 0x0

    goto :goto_29
.end method

.method public load(Ljava/lang/String;)V
    .registers 12
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    const/4 v6, 0x0

    const-wide/high16 v4, 0x3ff0000000000000L    # 1.0

    const-wide/high16 v2, -0x4010000000000000L    # -1.0

    .line 29
    const-string v0, "((?<=%1$s)|(?=%1$s))"

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const-string v7, "[/.EWNS]"

    aput-object v7, v1, v6

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 30
    invoke-virtual {p1, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v7

    .line 32
    array-length v0, v7

    add-int/lit8 v0, v0, -0x9

    aget-object v0, v7, v0

    const-string v1, "W"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_aa

    move-wide v0, v2

    :goto_24
    iput-wide v0, p0, Log/patch/HGTTile;->ref_lng:D

    .line 33
    iget-wide v0, p0, Log/patch/HGTTile;->ref_lng:D

    array-length v8, v7

    add-int/lit8 v8, v8, -0x8

    aget-object v8, v7, v8

    invoke-static {v8}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v8

    mul-double/2addr v0, v8

    iput-wide v0, p0, Log/patch/HGTTile;->ref_lng:D

    .line 34
    array-length v0, v7

    add-int/lit8 v0, v0, -0xb

    aget-object v0, v7, v0

    const-string v1, "S"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_ad

    :goto_41
    iput-wide v2, p0, Log/patch/HGTTile;->ref_lat:D

    .line 35
    iget-wide v0, p0, Log/patch/HGTTile;->ref_lat:D

    array-length v2, v7

    add-int/lit8 v2, v2, -0xa

    aget-object v2, v7, v2

    invoke-static {v2}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v2

    mul-double/2addr v0, v2

    iput-wide v0, p0, Log/patch/HGTTile;->ref_lat:D

    .line 41
    new-instance v0, Ljava/util/zip/ZipFile;

    invoke-direct {v0, p1}, Ljava/util/zip/ZipFile;-><init>(Ljava/lang/String;)V

    .line 42
    new-instance v1, Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    array-length v3, v7

    add-int/lit8 v3, v3, -0xb

    aget-object v3, v7, v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    array-length v3, v7

    add-int/lit8 v3, v3, -0xa

    aget-object v3, v7, v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    array-length v3, v7

    add-int/lit8 v3, v3, -0x9

    aget-object v3, v7, v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    array-length v3, v7

    add-int/lit8 v3, v3, -0x8

    aget-object v3, v7, v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ".hgt"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/String;-><init>(Ljava/lang/String;)V

    .line 43
    invoke-virtual {v0, v1}, Ljava/util/zip/ZipFile;->getEntry(Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object v1

    .line 44
    invoke-virtual {v0, v1}, Ljava/util/zip/ZipFile;->getInputStream(Ljava/util/zip/ZipEntry;)Ljava/io/InputStream;

    move-result-object v2

    .line 45
    invoke-virtual {v1}, Ljava/util/zip/ZipEntry;->getSize()J

    move-result-wide v0

    long-to-int v0, v0

    .line 46
    new-array v1, v0, [B

    move v0, v6

    .line 49
    :goto_9e
    invoke-virtual {v2}, Ljava/io/InputStream;->available()I

    move-result v3

    if-lez v3, :cond_af

    .line 50
    invoke-virtual {v2, v1, v0, v3}, Ljava/io/InputStream;->read([BII)I

    move-result v3

    add-int/2addr v0, v3

    goto :goto_9e

    :cond_aa
    move-wide v0, v4

    .line 32
    goto/16 :goto_24

    :cond_ad
    move-wide v2, v4

    .line 34
    goto :goto_41

    .line 53
    :cond_af
    array-length v0, v1

    div-int/lit8 v0, v0, 0x2

    new-array v0, v0, [S

    iput-object v0, p0, Log/patch/HGTTile;->m_TileData:[S

    .line 54
    invoke-static {v1}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    sget-object v1, Ljava/nio/ByteOrder;->BIG_ENDIAN:Ljava/nio/ByteOrder;

    invoke-virtual {v0, v1}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->asShortBuffer()Ljava/nio/ShortBuffer;

    move-result-object v0

    iget-object v1, p0, Log/patch/HGTTile;->m_TileData:[S

    invoke-virtual {v0, v1}, Ljava/nio/ShortBuffer;->get([S)Ljava/nio/ShortBuffer;

    .line 55
    return-void
.end method
