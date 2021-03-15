# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from I005_1 device
$(call inherit-product, $(LOCAL_PATH)/device.mk)

PRODUCT_BRAND := asus
PRODUCT_DEVICE := I005_1
PRODUCT_MANUFACTURER := asus
PRODUCT_NAME := lineage_I005_1
PRODUCT_MODEL := ASUS_I005D

PRODUCT_GMS_CLIENTID_BASE := android-asus
TARGET_VENDOR := asus
TARGET_VENDOR_PRODUCT_NAME := I005_1
PRODUCT_BUILD_PROP_OVERRIDES += PRIVATE_BUILD_DESC=" 11 RKQ1.200903.002.WW_Phone-18.0600.2009.15-0 18.0600.2009.15-0 release-keys"

# Set BUILD_FINGERPRINT variable to be picked up by both system and vendor build.prop
BUILD_FINGERPRINT := asus/CN_I005D/ASUS_I005_1:11/RKQ1.201022.002/18.0830.2101.75-0:user/release-keys
