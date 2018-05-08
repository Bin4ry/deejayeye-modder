.class public Log/patch/URLHook;
.super Ljava/lang/Object;
.source "URLHook.java"


# static fields
.field public static m_Instance:Log/patch/URLHook;

.field public static ms_settings_path:Ljava/lang/String;


# instance fields
.field private m_AllowedURLs:[Ljava/lang/String;

.field private m_AllowedURLsPatterns:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Ljava/util/regex/Pattern;",
            ">;"
        }
    .end annotation
.end field

.field private m_DoLogging:Z

.field private m_ForbiddenURLs:[Ljava/lang/String;

.field private m_ForbiddenURLsPatterns:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Ljava/util/regex/Pattern;",
            ">;"
        }
    .end annotation
.end field

.field private m_HardcodedAllowed:[Ljava/lang/String;

.field private m_HardcodedAllowedURlsList:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private m_UrlFilteringType:I

.field private m_logger:Ljava/util/logging/Logger;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .prologue
    .line 31
    const/4 v0, 0x0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 32
    const-string v0, "/mnt/sdcard/DJI/urlhook.settings.json"

    sput-object v0, Log/patch/URLHook;->ms_settings_path:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 5

    .prologue
    const/4 v2, 0x0

    const/4 v3, 0x0

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 34
    iput-boolean v2, p0, Log/patch/URLHook;->m_DoLogging:Z

    .line 35
    iput-object v3, p0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    .line 36
    iput v2, p0, Log/patch/URLHook;->m_UrlFilteringType:I

    .line 37
    iput-object v3, p0, Log/patch/URLHook;->m_AllowedURLs:[Ljava/lang/String;

    .line 38
    iput-object v3, p0, Log/patch/URLHook;->m_ForbiddenURLs:[Ljava/lang/String;

    .line 39
    const/4 v0, 0x4

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "192.168.42.1"

    aput-object v1, v0, v2

    const/4 v1, 0x1

    const-string v2, "192.168.42.2"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "192.168.42.3"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "localhost"

    aput-object v2, v0, v1

    iput-object v0, p0, Log/patch/URLHook;->m_HardcodedAllowed:[Ljava/lang/String;

    .line 41
    iput-object v3, p0, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    .line 42
    iput-object v3, p0, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    .line 43
    iput-object v3, p0, Log/patch/URLHook;->m_HardcodedAllowedURlsList:Ljava/util/ArrayList;

    return-void
.end method

.method private static checkHost(Ljava/lang/String;I)Ljava/lang/String;
    .registers 8

    .prologue
    const/4 v1, 0x1

    const/4 v2, 0x0

    .line 150
    const-string v0, "((?<=%1$s)|(?=%1$s))"

    new-array v3, v1, [Ljava/lang/Object;

    const-string v4, "[/:]"

    aput-object v4, v3, v2

    invoke-static {v0, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 151
    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    .line 153
    array-length v0, v3

    if-lt v0, p1, :cond_28

    .line 154
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_HardcodedAllowedURlsList:Ljava/util/ArrayList;

    aget-object v4, v3, p1

    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v0

    .line 155
    sget-object v4, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v4, v4, Log/patch/URLHook;->m_UrlFilteringType:I

    packed-switch v4, :pswitch_data_7c

    .line 174
    :goto_26
    if-eqz v0, :cond_62

    .line 187
    :cond_28
    :goto_28
    return-object p0

    .line 158
    :pswitch_29
    aget-object v1, v3, p1

    sget-object v4, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v4, v4, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v1, v4}, Log/patch/URLHook;->stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z

    move-result v1

    or-int/2addr v0, v1

    .line 159
    goto :goto_26

    .line 164
    :pswitch_35
    aget-object v0, v3, p1

    sget-object v4, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v4, v4, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v0, v4}, Log/patch/URLHook;->stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z

    move-result v0

    if-nez v0, :cond_44

    move v0, v1

    :goto_42
    and-int/2addr v0, v1

    .line 165
    goto :goto_26

    :cond_44
    move v0, v2

    .line 164
    goto :goto_42

    .line 169
    :pswitch_46
    aget-object v4, v3, p1

    sget-object v5, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v5, v5, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v4, v5}, Log/patch/URLHook;->stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z

    move-result v4

    if-eqz v4, :cond_60

    aget-object v4, v3, p1

    sget-object v5, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v5, v5, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v4, v5}, Log/patch/URLHook;->stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z

    move-result v4

    if-nez v4, :cond_60

    :goto_5e
    or-int/2addr v0, v1

    goto :goto_26

    :cond_60
    move v1, v2

    goto :goto_5e

    .line 177
    :cond_62
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 178
    :goto_67
    array-length v0, v3

    if-ge v2, v0, :cond_77

    .line 179
    if-ne v2, p1, :cond_74

    const-string v0, "127.0.0.1"

    :goto_6e
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 178
    add-int/lit8 v2, v2, 0x1

    goto :goto_67

    .line 179
    :cond_74
    aget-object v0, v3, v2

    goto :goto_6e

    .line 181
    :cond_77
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_28

    .line 155
    :pswitch_data_7c
    .packed-switch 0x1
        :pswitch_29
        :pswitch_35
        :pswitch_46
    .end packed-switch
.end method

.method public static checkURL_S(Ljava/lang/String;)Ljava/lang/String;
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 191
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_a

    .line 192
    invoke-static {}, Log/patch/URLHook;->getInstance()Log/patch/URLHook;

    move-result-object v0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 197
    :cond_a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v0, v0, Log/patch/URLHook;->m_UrlFilteringType:I

    if-nez v0, :cond_38

    move-object v0, p0

    .line 204
    :goto_11
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v1, v1, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v1, :cond_37

    .line 205
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 206
    const-string v2, "orig_url = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 207
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 208
    const-string v2, ", subst_url = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 209
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 210
    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 212
    :cond_37
    return-object v0

    .line 201
    :cond_38
    const/4 v0, 0x4

    invoke-static {p0, v0}, Log/patch/URLHook;->checkHost(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    goto :goto_11
.end method

.method public static checkURL_SS(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 216
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_a

    .line 217
    invoke-static {}, Log/patch/URLHook;->getInstance()Log/patch/URLHook;

    move-result-object v0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 222
    :cond_a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v0, v0, Log/patch/URLHook;->m_UrlFilteringType:I

    if-nez v0, :cond_40

    move-object v0, p1

    .line 229
    :goto_11
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v1, v1, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v1, :cond_3f

    .line 230
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 231
    const-string v2, "protocol = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 232
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 233
    const-string v2, ", orig host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 234
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 235
    const-string v2, ", subst host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 236
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 237
    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 239
    :cond_3f
    return-object v0

    .line 226
    :cond_40
    const/4 v0, 0x0

    invoke-static {p1, v0}, Log/patch/URLHook;->checkHost(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    goto :goto_11
.end method

.method public static checkURL_SSIS(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;
    .registers 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 272
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_a

    .line 273
    invoke-static {}, Log/patch/URLHook;->getInstance()Log/patch/URLHook;

    move-result-object v0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 278
    :cond_a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v0, v0, Log/patch/URLHook;->m_UrlFilteringType:I

    if-nez v0, :cond_50

    move-object v0, p1

    .line 285
    :goto_11
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v1, v1, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v1, :cond_4f

    .line 286
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 287
    const-string v2, "protocol = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 288
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 289
    const-string v2, ", orig host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 290
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 291
    const-string v2, ", subst host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 292
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 293
    const-string v2, ", port = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 294
    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 295
    const-string v2, ", file = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 296
    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 297
    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 299
    :cond_4f
    return-object v0

    .line 282
    :cond_50
    const/4 v0, 0x0

    invoke-static {p1, v0}, Log/patch/URLHook;->checkHost(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    goto :goto_11
.end method

.method public static checkURL_SSS(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 243
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_a

    .line 244
    invoke-static {}, Log/patch/URLHook;->getInstance()Log/patch/URLHook;

    move-result-object v0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 249
    :cond_a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v0, v0, Log/patch/URLHook;->m_UrlFilteringType:I

    if-nez v0, :cond_48

    move-object v0, p1

    .line 256
    :goto_11
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v1, v1, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v1, :cond_47

    .line 257
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 258
    const-string v2, "protocol = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 259
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 260
    const-string v2, ", orig host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 261
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 262
    const-string v2, ", subst host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 263
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 264
    const-string v2, ", file = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 265
    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 266
    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 268
    :cond_47
    return-object v0

    .line 253
    :cond_48
    const/4 v0, 0x0

    invoke-static {p1, v0}, Log/patch/URLHook;->checkHost(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    goto :goto_11
.end method

.method public static close()V
    .registers 4

    .prologue
    .line 96
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-eqz v0, :cond_2a

    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    if-eqz v0, :cond_2a

    .line 97
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    const-string v1, "closing"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 99
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0}, Ljava/util/logging/Logger;->getHandlers()[Ljava/util/logging/Handler;

    move-result-object v1

    array-length v2, v1

    const/4 v0, 0x0

    :goto_1d
    if-ge v0, v2, :cond_2a

    aget-object v3, v1, v0

    .line 100
    invoke-virtual {v3}, Ljava/util/logging/Handler;->flush()V

    .line 101
    invoke-virtual {v3}, Ljava/util/logging/Handler;->close()V

    .line 99
    add-int/lit8 v0, v0, 0x1

    goto :goto_1d

    .line 104
    :cond_2a
    return-void
.end method

.method public static getInstance()Log/patch/URLHook;
    .registers 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    const/4 v1, 0x0

    .line 48
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_ea

    .line 50
    new-instance v0, Lcom/google/gson/GsonBuilder;

    invoke-direct {v0}, Lcom/google/gson/GsonBuilder;-><init>()V

    .line 51
    invoke-virtual {v0}, Lcom/google/gson/GsonBuilder;->create()Lcom/google/gson/Gson;

    move-result-object v0

    .line 53
    new-instance v2, Ljava/io/File;

    sget-object v3, Log/patch/URLHook;->ms_settings_path:Ljava/lang/String;

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v2

    .line 55
    new-instance v4, Ljava/io/FileInputStream;

    sget-object v5, Log/patch/URLHook;->ms_settings_path:Ljava/lang/String;

    invoke-direct {v4, v5}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    .line 56
    long-to-int v2, v2

    new-array v2, v2, [B

    .line 57
    invoke-virtual {v4, v2}, Ljava/io/FileInputStream;->read([B)I

    .line 59
    new-instance v3, Ljava/lang/String;

    const-string v4, "ISO-8859-1"

    invoke-direct {v3, v2, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 61
    const-class v2, Log/patch/URLHook;

    invoke-virtual {v0, v3, v2}, Lcom/google/gson/Gson;->fromJson(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Log/patch/URLHook;

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 63
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v0, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    .line 64
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v0, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    .line 65
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v0, Log/patch/URLHook;->m_HardcodedAllowedURlsList:Ljava/util/ArrayList;

    .line 67
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v0, Log/patch/URLHook;->m_HardcodedAllowed:[Ljava/lang/String;

    array-length v3, v2

    move v0, v1

    :goto_58
    if-ge v0, v3, :cond_66

    aget-object v4, v2, v0

    .line 68
    sget-object v5, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v5, v5, Log/patch/URLHook;->m_HardcodedAllowedURlsList:Ljava/util/ArrayList;

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 67
    add-int/lit8 v0, v0, 0x1

    goto :goto_58

    .line 71
    :cond_66
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v0, Log/patch/URLHook;->m_AllowedURLs:[Ljava/lang/String;

    array-length v3, v2

    move v0, v1

    :goto_6c
    if-ge v0, v3, :cond_7e

    aget-object v4, v2, v0

    .line 72
    sget-object v5, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v5, v5, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v4}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 71
    add-int/lit8 v0, v0, 0x1

    goto :goto_6c

    .line 75
    :cond_7e
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v0, Log/patch/URLHook;->m_ForbiddenURLs:[Ljava/lang/String;

    array-length v3, v2

    move v0, v1

    :goto_84
    if-ge v0, v3, :cond_96

    aget-object v4, v2, v0

    .line 76
    sget-object v5, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v5, v5, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v4}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 75
    add-int/lit8 v0, v0, 0x1

    goto :goto_84

    .line 80
    :cond_96
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v0, v0, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v0, :cond_ea

    .line 82
    new-instance v0, Ljava/util/Date;

    invoke-direct {v0}, Ljava/util/Date;-><init>()V

    .line 83
    new-instance v2, Ljava/text/SimpleDateFormat;

    const-string v3, "yyyy-MM-dd_HH-mm-ss"

    invoke-direct {v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 85
    new-instance v3, Ljava/util/logging/FileHandler;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "/mnt/sdcard/DJI/og_logs/URLHook-"

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

    .line 87
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    const-class v2, Log/patch/URLHook;

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v2

    iput-object v2, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    .line 88
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0, v3}, Ljava/util/logging/Logger;->addHandler(Ljava/util/logging/Handler;)V

    .line 89
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->setUseParentHandlers(Z)V

    .line 92
    :cond_ea
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    return-object v0
.end method

.method private static stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/ArrayList",
            "<",
            "Ljava/util/regex/Pattern;",
            ">;)Z"
        }
    .end annotation

    .prologue
    .line 139
    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_4
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1c

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/regex/Pattern;

    .line 140
    invoke-virtual {v0, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    .line 141
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->matches()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 142
    const/4 v0, 0x1

    .line 145
    :goto_1b
    return v0

    :cond_1c
    const/4 v0, 0x0

    goto :goto_1b
.end method


# virtual methods
.method public getAllowedURLs()[Ljava/lang/String;
    .registers 2

    .prologue
    .line 115
    iget-object v0, p0, Log/patch/URLHook;->m_AllowedURLs:[Ljava/lang/String;

    return-object v0
.end method

.method public getDoLogging()Z
    .registers 2

    .prologue
    .line 107
    iget-boolean v0, p0, Log/patch/URLHook;->m_DoLogging:Z

    return v0
.end method

.method public getForbiddenURLs()[Ljava/lang/String;
    .registers 2

    .prologue
    .line 123
    iget-object v0, p0, Log/patch/URLHook;->m_ForbiddenURLs:[Ljava/lang/String;

    return-object v0
.end method

.method public getUrlFilteringType()I
    .registers 2

    .prologue
    .line 131
    iget v0, p0, Log/patch/URLHook;->m_UrlFilteringType:I

    return v0
.end method

.method public setAllowedURLs([Ljava/lang/String;)V
    .registers 2

    .prologue
    .line 119
    iput-object p1, p0, Log/patch/URLHook;->m_AllowedURLs:[Ljava/lang/String;

    .line 120
    return-void
.end method

.method public setDoLogging(Z)V
    .registers 2

    .prologue
    .line 111
    iput-boolean p1, p0, Log/patch/URLHook;->m_DoLogging:Z

    .line 112
    return-void
.end method

.method public setForbiddenURLs([Ljava/lang/String;)V
    .registers 2

    .prologue
    .line 127
    iput-object p1, p0, Log/patch/URLHook;->m_ForbiddenURLs:[Ljava/lang/String;

    .line 128
    return-void
.end method

.method public setUrlFilteringType(I)V
    .registers 2

    .prologue
    .line 135
    iput p1, p0, Log/patch/URLHook;->m_UrlFilteringType:I

    .line 136
    return-void
.end method
