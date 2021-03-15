LOCAL_PATH := $(call my-dir)
ifeq ($(TARGET_DEVICE),I005_1)
include $(call all-makefiles-under,$(LOCAL_PATH))
include $(CLEAR_VARS)
endif