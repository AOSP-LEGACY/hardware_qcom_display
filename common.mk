#Common headers
display_top := $(call my-dir)

#Common headers
common_includes := $(display_top)/libgralloc
common_includes += $(display_top)/liboverlay
common_includes += $(display_top)/libcopybit
common_includes += $(display_top)/libqdutils
common_includes += $(display_top)/libhwcomposer
common_includes += $(display_top)/libhdmi
common_includes += $(display_top)/libqservice
common_includes += $(display_top)/include

ifeq ($(TARGET_USES_POST_PROCESSING),true)
    common_flags     += -DUSES_POST_PROCESSING
    common_includes  += $(TARGET_OUT_HEADERS)/pp/inc
endif

common_header_export_path := qcom/display

#Common libraries external to display HAL
common_libs := liblog libutils libcutils libhardware

#Common C flags
common_flags := -DDEBUG_CALC_FPS -Wno-missing-field-initializers
common_flags += -Wconversion -Wall -Werror -Wno-sign-conversion -Wno-implicit-fallthrough

ifeq ($(ARCH_ARM_HAVE_NEON),true)
    common_flags += -D__ARM_HAVE_NEON
endif

ifeq ($(call is-board-platform-in-list, $(MSM_VIDC_TARGET_LIST)), true)
ifneq ($(TARGET_SUPPORTS_WEARABLES), true)
    common_flags += -DVENUS_COLOR_FORMAT
endif
endif

ifeq ($(call is-board-platform-in-list, msm8974 msm8226 msm8610 apq8084 \
        mpq8092 msm_bronze msm8916 msm8994), true)
    common_flags += -DMDSS_TARGET
endif
ifeq ($(call is-board-platform-in-list, msm8909 msm8916), true)
ifneq ($(TARGET_SUPPORTS_WEARABLES), true)
    common_flags += -DVENUS_COLOR_FORMAT
endif
    common_flags += -DMDSS_TARGET
endif

ifeq ($(DISPLAY_DEBUG_SWAPINTERVAL),true)
    common_flags += -DDEBUG_SWAPINTERVAL
endif

common_deps  :=
kernel_includes :=

# Executed only on QCOM BSPs
ifeq ($(TARGET_USES_QCOM_BSP),true)
# Enable QCOM Display features
    common_flags += -DQTI_BSP
endif

common_flags += -isystem $(TARGET_OUT_HEADERS)/qcom/display

ifneq ($(call is-platform-sdk-version-at-least,18),true)
    common_flags += -DANDROID_JELLYBEAN_MR1=1
endif

common_deps += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
kernel_includes += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
