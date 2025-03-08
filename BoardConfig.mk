# 设备路径
DEVICE_PATH := device/xtc/msm8937_32go_i25

# 架构
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := generic

# 64位 Binder（AOSP 8.1 支持）
TARGET_USES_64_BIT_BINDER := true

# APEX（AOSP 8.1 不支持 APEX，禁用）
OVERRIDE_TARGET_FLATTEN_APEX := true

# 引导加载程序
TARGET_BOOTLOADER_BOARD_NAME := QC_Reference_Phone
TARGET_NO_BOOTLOADER := true

# 显示
TARGET_SCREEN_DENSITY := 320

# 内核
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0 androidboot.hardware=qcom user_debug=30 vmalloc=300M msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78B0000 buildvariant=user appjenkins=1827 modemjenkins=138 buildsoftversion=1.7.6 builduser=root
BOARD_KERNEL_PAGESIZE := 2048
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_KERNEL_CONFIG := msm8937_32go_i25_defconfig
TARGET_KERNEL_SOURCE := kernel/xtc/msm8937_32go_i25

# 预编译内核
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilts/kernel
endif

# 分区
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432

# 平台
TARGET_BOARD_PLATFORM := msm8937

# 属性文件
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# 恢复模式
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# 安全补丁级别
VENDOR_SECURITY_PATCH := 2021-08-01

# Verified Boot（AOSP 8.1 不支持 AVB 2.0，禁用）
BOARD_AVB_ENABLE := false

# VINTF（AOSP 8.1 不支持 VINTF，移除）
# DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# 继承专有文件
include vendor/xtc/msm8937_32go_i25/BoardConfigVendor.mk