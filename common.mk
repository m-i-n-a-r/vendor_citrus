PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/citrus/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/citrus/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/citrus/prebuilt/common/bin/whitelist:system/addon.d/whitelist \

# Bootanimation
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip

# init.d support
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/citrus/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/citrus/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Init file
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/init.local.rc:root/init.local.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/citrus/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/citrus/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Misc packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    Browser \
    MusicFX \
    libemoji \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    powertop \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    Terminal

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Telephony packages
PRODUCT_PACKAGES += \
    messaging \
    CellBroadcastReceiver \
    Stk

#RCS //Needed for Contacts and Mms Apps
PRODUCT_PACKAGES += \
    rcs_service_aidl \
    rcs_service_aidl.xml \
    rcs_service_aidl_static \
    rcs_service_api \
    rcs_service_api.xml

# Mms depends on SoundRecorder for recorded audio messages
PRODUCT_PACKAGES += \
    SoundRecorder

# World APN list
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Selective SPN list for operator number who has the problem.
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/selective-spn-conf.xml:system/etc/selective-spn-conf.xml

# Overlays & Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += \
	vendor/citrus/overlay/common \
	vendor/citrus/overlay/dictionaries

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so
else
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

$(call inherit-product-if-exists, vendor/extra/product.mk)

# Versioning System
# Citrus-CAF first version.
PRODUCT_VERSION_MAJOR = MM
PRODUCT_VERSION_MINOR = STAGING
PRODUCT_VERSION_MAINTENANCE = LemonDrop
ifdef CITRUS_BUILD_EXTRA
    CITRUS_POSTFIX := -$(CITRUS_BUILD_EXTRA)
endif
ifndef CITRUS_BUILD_TYPE
ifeq ($(CITRUS_RELEASE),true)
    CITRUS_BUILD_TYPE := OFFICIAL
    PLATFORM_VERSION_CODENAME := OFFICIAL
    CITRUS_POSTFIX := -$(shell date +"%Y%m%d")
else
    CITRUS_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
    CITRUS_POSTFIX := -$(shell date +"%Y%m%d")
endif
endif

ifeq ($(CITRUS_BUILD_TYPE),DM)
    CITRUS_POSTFIX := -$(shell date +"%Y%m%d")
endif

ifndef CITRUS_POSTFIX
    CITRUS_POSTFIX := -$(shell date +"%Y%m%d")
endif

PLATFORM_VERSION_CODENAME := $(CITRUS_BUILD_TYPE)

# Set all versions
CITRUS_VERSION := CitrusCAF-$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(PRODUCT_VERSION_MAJOR)-$(CITRUS_BUILD_TYPE)$(CITRUS_POSTFIX)
CITRUS_MOD_VERSION := CitrusCAF-$(CITRUS_BUILD)-$(PRODUCT_VERSION_MINOR)-$(CITRUS_BUILD_TYPE)$(CITRUS_POSTFIX)
PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    citrus.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.citrus.version=$(CITRUS_VERSION) \
    ro.modversion=$(CITRUS_MOD_VERSION) \
    ro.citrus.buildtype=$(CITRUS_BUILD_TYPE)