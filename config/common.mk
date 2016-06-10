PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/citrus/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/citrus/prebuilt/common/bin/50-citrus.sh:system/addon.d/50-citrus.sh

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# CITRUS-specific init file
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/init.local.rc:root/init.citrus.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/citrus/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/citrus/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/citrus/prebuilt/common/bin/sysinit:system/bin/sysinit

# DU Utils Library
PRODUCT_PACKAGES += \
    org.dirtyunicorns.utils

PRODUCT_BOOT_JARS += \
    org.dirtyunicorns.utils

# Theme engine
include vendor/citrus/config/themes_common.mk

# Required packages
PRODUCT_PACKAGES += \
    Development \
    SpareParts \
    su

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra Optional packages
PRODUCT_PACKAGES += \
    Launcher3 \+# DU Utils Library
 +PRODUCT_PACKAGES += \
 +    org.dirtyunicorns.utils
 +
 +PRODUCT_BOOT_JARS += \
 +    org.dirtyunicorns.utils
 +
 +

    LatinIME \
    BluetoothExt

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/citrus/overlay/common

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/citrus/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif
endif

# Versioning System
# CitrusCAF first version.
PRODUCT_VERSION_MAJOR = 6.0.1
PRODUCT_VERSION_MINOR = staging
PRODUCT_VERSION_MAINTENANCE = 0.1
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
    CITRUS_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

PLATFORM_VERSION_CODENAME := $(CITRUS_BUILD_TYPE)

# Set all versions
CITRUS_VERSION := CitrusCAF-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(CITRUS_BUILD_TYPE)$(CITRUS_POSTFIX)
CITRUS_MOD_VERSION := CitrusCAF-$(CITRUS_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(CITRUS_BUILD_TYPE)$(CITRUS_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    citrus.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.citrus.version=$(CITRUS_VERSION) \
    ro.modversion=$(CITRUS_MOD_VERSION) \
    ro.citrus.buildtype=$(CITRUS_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/citrus/tools/citrus_process_props.py

