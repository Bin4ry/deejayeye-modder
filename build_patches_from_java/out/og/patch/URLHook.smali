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

.field private m_HardcodedAllowedPatterns:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Ljava/util/regex/Pattern;",
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
    const/4 v0, 0x6

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, ".*gnss_assist.*"

    aput-object v1, v0, v2

    const/4 v1, 0x1

    const-string v2, ".*\\.ubx.*"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, ".*192.168.42.1.*"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, ".*192.168.42.2.*"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, ".*192.168.42.3.*"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, ".*localhost.*"

    aput-object v2, v0, v1

    iput-object v0, p0, Log/patch/URLHook;->m_HardcodedAllowed:[Ljava/lang/String;

    .line 41
    iput-object v3, p0, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    .line 42
    iput-object v3, p0, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    .line 43
    iput-object v3, p0, Log/patch/URLHook;->m_HardcodedAllowedPatterns:Ljava/util/ArrayList;

    return-void
.end method

.method private static checkHost(Ljava/lang/String;I)Ljava/lang/String;
    .registers 11

    .prologue
    const/4 v2, 0x1

    const/4 v3, 0x0

    .line 148
    const-string v0, "((?<=%1$s)|(?=%1$s))"

    new-array v1, v2, [Ljava/lang/Object;

    const-string v4, "[/:]"

    aput-object v4, v1, v3

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 149
    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    .line 151
    array-length v6, v5

    move v4, v3

    move v1, v3

    :goto_15
    if-ge v4, v6, :cond_a1

    aget-object v7, v5, v4

    .line 152
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_HardcodedAllowedPatterns:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v8

    :cond_21
    invoke-interface {v8}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_9f

    invoke-interface {v8}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/regex/Pattern;

    .line 153
    invoke-virtual {v0, v7}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    .line 154
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->matches()Z

    move-result v0

    if-eqz v0, :cond_21

    move v0, v2

    .line 159
    :goto_38
    if-eqz v0, :cond_47

    .line 164
    :goto_3a
    array-length v1, v5

    if-lt v1, p1, :cond_46

    .line 166
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v1, v1, Log/patch/URLHook;->m_UrlFilteringType:I

    packed-switch v1, :pswitch_data_a4

    .line 185
    :goto_44
    if-eqz v0, :cond_85

    .line 198
    :cond_46
    :goto_46
    return-object p0

    .line 151
    :cond_47
    add-int/lit8 v1, v4, 0x1

    move v4, v1

    move v1, v0

    goto :goto_15

    .line 169
    :pswitch_4c
    aget-object v1, v5, p1

    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v1, v2}, Log/patch/URLHook;->stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z

    move-result v1

    or-int/2addr v0, v1

    .line 170
    goto :goto_44

    .line 175
    :pswitch_58
    aget-object v0, v5, p1

    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v1, v1, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v0, v1}, Log/patch/URLHook;->stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z

    move-result v0

    if-nez v0, :cond_67

    move v0, v2

    :goto_65
    and-int/2addr v0, v2

    .line 176
    goto :goto_44

    :cond_67
    move v0, v3

    .line 175
    goto :goto_65

    .line 180
    :pswitch_69
    aget-object v1, v5, p1

    sget-object v4, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v4, v4, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v1, v4}, Log/patch/URLHook;->stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z

    move-result v1

    if-eqz v1, :cond_83

    aget-object v1, v5, p1

    sget-object v4, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v4, v4, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v1, v4}, Log/patch/URLHook;->stringMatchPatternList(Ljava/lang/String;Ljava/util/ArrayList;)Z

    move-result v1

    if-nez v1, :cond_83

    :goto_81
    or-int/2addr v0, v2

    goto :goto_44

    :cond_83
    move v2, v3

    goto :goto_81

    .line 188
    :cond_85
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 189
    :goto_8a
    array-length v0, v5

    if-ge v3, v0, :cond_9a

    .line 190
    if-ne v3, p1, :cond_97

    const-string v0, "127.0.0.1"

    :goto_91
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 189
    add-int/lit8 v3, v3, 0x1

    goto :goto_8a

    .line 190
    :cond_97
    aget-object v0, v5, v3

    goto :goto_91

    .line 192
    :cond_9a
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_46

    :cond_9f
    move v0, v1

    goto :goto_38

    :cond_a1
    move v0, v1

    goto :goto_3a

    .line 166
    nop

    :pswitch_data_a4
    .packed-switch 0x1
        :pswitch_4c
        :pswitch_58
        :pswitch_69
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
    .line 202
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_a

    .line 203
    invoke-static {}, Log/patch/URLHook;->getInstance()Log/patch/URLHook;

    move-result-object v0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 208
    :cond_a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v0, v0, Log/patch/URLHook;->m_UrlFilteringType:I

    if-nez v0, :cond_38

    move-object v0, p0

    .line 215
    :goto_11
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v1, v1, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v1, :cond_37

    .line 216
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 217
    const-string v2, "orig_url = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 218
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 219
    const-string v2, ", subst_url = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 220
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 221
    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 223
    :cond_37
    return-object v0

    .line 212
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
    .line 227
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_a

    .line 228
    invoke-static {}, Log/patch/URLHook;->getInstance()Log/patch/URLHook;

    move-result-object v0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 233
    :cond_a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v0, v0, Log/patch/URLHook;->m_UrlFilteringType:I

    if-nez v0, :cond_40

    move-object v0, p1

    .line 240
    :goto_11
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v1, v1, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v1, :cond_3f

    .line 241
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 242
    const-string v2, "protocol = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 243
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 244
    const-string v2, ", orig host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 245
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 246
    const-string v2, ", subst host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 247
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 248
    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 250
    :cond_3f
    return-object v0

    .line 237
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
    .line 283
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_a

    .line 284
    invoke-static {}, Log/patch/URLHook;->getInstance()Log/patch/URLHook;

    move-result-object v0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 289
    :cond_a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v0, v0, Log/patch/URLHook;->m_UrlFilteringType:I

    if-nez v0, :cond_50

    move-object v0, p1

    .line 296
    :goto_11
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v1, v1, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v1, :cond_4f

    .line 297
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 298
    const-string v2, "protocol = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 299
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 300
    const-string v2, ", orig host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 301
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 302
    const-string v2, ", subst host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 303
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 304
    const-string v2, ", port = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 305
    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 306
    const-string v2, ", file = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 307
    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 308
    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 310
    :cond_4f
    return-object v0

    .line 293
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
    .line 254
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_a

    .line 255
    invoke-static {}, Log/patch/URLHook;->getInstance()Log/patch/URLHook;

    move-result-object v0

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 260
    :cond_a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget v0, v0, Log/patch/URLHook;->m_UrlFilteringType:I

    if-nez v0, :cond_48

    move-object v0, p1

    .line 267
    :goto_11
    sget-object v1, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v1, v1, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v1, :cond_47

    .line 268
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 269
    const-string v2, "protocol = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 270
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 271
    const-string v2, ", orig host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 272
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 273
    const-string v2, ", subst host = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 274
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 275
    const-string v2, ", file = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 276
    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 277
    sget-object v2, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v2, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 279
    :cond_47
    return-object v0

    .line 264
    :cond_48
    const/4 v0, 0x0

    invoke-static {p1, v0}, Log/patch/URLHook;->checkHost(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    goto :goto_11
.end method

.method public static close()V
    .registers 4

    .prologue
    .line 94
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-eqz v0, :cond_2a

    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    if-eqz v0, :cond_2a

    .line 95
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    const-string v1, "closing"

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->info(Ljava/lang/String;)V

    .line 97
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0}, Ljava/util/logging/Logger;->getHandlers()[Ljava/util/logging/Handler;

    move-result-object v1

    array-length v2, v1

    const/4 v0, 0x0

    :goto_1d
    if-ge v0, v2, :cond_2a

    aget-object v3, v1, v0

    .line 98
    invoke-virtual {v3}, Ljava/util/logging/Handler;->flush()V

    .line 99
    invoke-virtual {v3}, Ljava/util/logging/Handler;->close()V

    .line 97
    add-int/lit8 v0, v0, 0x1

    goto :goto_1d

    .line 102
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

    .line 46
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    if-nez v0, :cond_ee

    .line 48
    new-instance v0, Lcom/google/gson/GsonBuilder;

    invoke-direct {v0}, Lcom/google/gson/GsonBuilder;-><init>()V

    .line 49
    invoke-virtual {v0}, Lcom/google/gson/GsonBuilder;->create()Lcom/google/gson/Gson;

    move-result-object v0

    .line 51
    new-instance v2, Ljava/io/File;

    sget-object v3, Log/patch/URLHook;->ms_settings_path:Ljava/lang/String;

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v2

    .line 53
    new-instance v4, Ljava/io/FileInputStream;

    sget-object v5, Log/patch/URLHook;->ms_settings_path:Ljava/lang/String;

    invoke-direct {v4, v5}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    .line 54
    long-to-int v2, v2

    new-array v2, v2, [B

    .line 55
    invoke-virtual {v4, v2}, Ljava/io/FileInputStream;->read([B)I

    .line 57
    new-instance v3, Ljava/lang/String;

    const-string v4, "ISO-8859-1"

    invoke-direct {v3, v2, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 59
    const-class v2, Log/patch/URLHook;

    invoke-virtual {v0, v3, v2}, Lcom/google/gson/Gson;->fromJson(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Log/patch/URLHook;

    sput-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    .line 61
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v0, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    .line 62
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v0, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    .line 63
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, v0, Log/patch/URLHook;->m_HardcodedAllowedPatterns:Ljava/util/ArrayList;

    .line 65
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v0, Log/patch/URLHook;->m_HardcodedAllowed:[Ljava/lang/String;

    array-length v3, v2

    move v0, v1

    :goto_58
    if-ge v0, v3, :cond_6a

    aget-object v4, v2, v0

    .line 66
    sget-object v5, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v5, v5, Log/patch/URLHook;->m_HardcodedAllowedPatterns:Ljava/util/ArrayList;

    invoke-static {v4}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 65
    add-int/lit8 v0, v0, 0x1

    goto :goto_58

    .line 69
    :cond_6a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v0, Log/patch/URLHook;->m_AllowedURLs:[Ljava/lang/String;

    array-length v3, v2

    move v0, v1

    :goto_70
    if-ge v0, v3, :cond_82

    aget-object v4, v2, v0

    .line 70
    sget-object v5, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v5, v5, Log/patch/URLHook;->m_AllowedURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v4}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 69
    add-int/lit8 v0, v0, 0x1

    goto :goto_70

    .line 73
    :cond_82
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v2, v0, Log/patch/URLHook;->m_ForbiddenURLs:[Ljava/lang/String;

    array-length v3, v2

    move v0, v1

    :goto_88
    if-ge v0, v3, :cond_9a

    aget-object v4, v2, v0

    .line 74
    sget-object v5, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v5, v5, Log/patch/URLHook;->m_ForbiddenURLsPatterns:Ljava/util/ArrayList;

    invoke-static {v4}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 73
    add-int/lit8 v0, v0, 0x1

    goto :goto_88

    .line 78
    :cond_9a
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-boolean v0, v0, Log/patch/URLHook;->m_DoLogging:Z

    if-eqz v0, :cond_ee

    .line 80
    new-instance v0, Ljava/util/Date;

    invoke-direct {v0}, Ljava/util/Date;-><init>()V

    .line 81
    new-instance v2, Ljava/text/SimpleDateFormat;

    const-string v3, "yyyy-MM-dd_HH-mm-ss"

    invoke-direct {v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 83
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

    .line 85
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    const-class v2, Log/patch/URLHook;

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/util/logging/Logger;->getLogger(Ljava/lang/String;)Ljava/util/logging/Logger;

    move-result-object v2

    iput-object v2, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    .line 86
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0, v3}, Ljava/util/logging/Logger;->addHandler(Ljava/util/logging/Handler;)V

    .line 87
    sget-object v0, Log/patch/URLHook;->m_Instance:Log/patch/URLHook;

    iget-object v0, v0, Log/patch/URLHook;->m_logger:Ljava/util/logging/Logger;

    invoke-virtual {v0, v1}, Ljava/util/logging/Logger;->setUseParentHandlers(Z)V

    .line 90
    :cond_ee
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
    .line 137
    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_4
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1c

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/regex/Pattern;

    .line 138
    invoke-virtual {v0, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    .line 139
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->matches()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 140
    const/4 v0, 0x1

    .line 143
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
    .line 113
    iget-object v0, p0, Log/patch/URLHook;->m_AllowedURLs:[Ljava/lang/String;

    return-object v0
.end method

.method public getDoLogging()Z
    .registers 2

    .prologue
    .line 105
    iget-boolean v0, p0, Log/patch/URLHook;->m_DoLogging:Z

    return v0
.end method

.method public getForbiddenURLs()[Ljava/lang/String;
    .registers 2

    .prologue
    .line 121
    iget-object v0, p0, Log/patch/URLHook;->m_ForbiddenURLs:[Ljava/lang/String;

    return-object v0
.end method

.method public getUrlFilteringType()I
    .registers 2

    .prologue
    .line 129
    iget v0, p0, Log/patch/URLHook;->m_UrlFilteringType:I

    return v0
.end method

.method public setAllowedURLs([Ljava/lang/String;)V
    .registers 2

    .prologue
    .line 117
    iput-object p1, p0, Log/patch/URLHook;->m_AllowedURLs:[Ljava/lang/String;

    .line 118
    return-void
.end method

.method public setDoLogging(Z)V
    .registers 2

    .prologue
    .line 109
    iput-boolean p1, p0, Log/patch/URLHook;->m_DoLogging:Z

    .line 110
    return-void
.end method

.method public setForbiddenURLs([Ljava/lang/String;)V
    .registers 2

    .prologue
    .line 125
    iput-object p1, p0, Log/patch/URLHook;->m_ForbiddenURLs:[Ljava/lang/String;

    .line 126
    return-void
.end method

.method public setUrlFilteringType(I)V
    .registers 2

    .prologue
    .line 133
    iput p1, p0, Log/patch/URLHook;->m_UrlFilteringType:I

    .line 134
    return-void
.end method
