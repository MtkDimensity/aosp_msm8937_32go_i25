#!/bin/bash

#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=msm8937_32go_i25
VENDOR=xtc

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Function to determine the module class based on file path
function get_module_class() {
    local file="$1"
    case "$file" in
        *.so)
            echo "SHARED_LIBRARIES"
            ;;
        */bin/*)
            echo "EXECUTABLES"
            ;;
        */etc/* | */firmware/* | */usr/*)
            echo "ETC"
            ;;
        *)
            echo "ETC"  # Default to ETC if no match
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

# Override write_makefiles to generate Android.mk instead of Android.bp
function write_makefiles() {
    local proprietary_files="$1"
    local is_vendor="$2"

    # Ensure Android.mk is generated
    local android_mk="${ANDROIDMK}"
    if [[ ! -f "${android_mk}" ]]; then
        echo "LOCAL_PATH := \$(call my-dir)" > "${android_mk}"
        echo "" >> "${android_mk}"
    fi

    while read -r line; do
        if [[ "$line" =~ ^# || -z "$line" ]]; then
            continue
        fi

        # Extract file path and module name
        local src_file=$(echo "$line" | awk '{print $1}')
        local module_name=$(basename "$src_file" | sed 's/\..*//')

        # Write Android.mk rules
        echo "include \$(CLEAR_VARS)" >> "${android_mk}"
        echo "LOCAL_MODULE := ${module_name}" >> "${android_mk}"
        echo "LOCAL_SRC_FILES := ${src_file}" >> "${android_mk}"
        echo "LOCAL_MODULE_CLASS := $(get_module_class "$src_file")" >> "${android_mk}"
        echo "LOCAL_MODULE_TAGS := optional" >> "${android_mk}"
        echo "LOCAL_MODULE_PATH := \$(TARGET_OUT_VENDOR)/$(dirname "$src_file")" >> "${android_mk}"
        echo "include \$(BUILD_PREBUILT)" >> "${android_mk}"
        echo "" >> "${android_mk}"
    done < "$proprietary_files"
}

# Generate Android.mk files
write_makefiles "${MY_DIR}/proprietary-files.txt" true

# Generate msm8937_32go_i25-vendor.mk
cat << EOF > "${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}/${DEVICE}-vendor.mk"
# Copyright (C) 2023 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Device-specific vendor makefile
# Include device-specific modules and configurations

# Include generated Android.mk
include \$(LOCAL_PATH)/Android.mk

# Device-specific variables
PRODUCT_PACKAGES += \\
    libfoo \\
    bar
EOF

# Generate BoardConfigVendor.mk
cat << EOF > "${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}/BoardConfigVendor.mk"
# Copyright (C) 2023 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Device-specific board configuration
# Define hardware-specific variables and options

# Kernel configuration
TARGET_KERNEL_SOURCE := kernel/${VENDOR}/${DEVICE}
TARGET_KERNEL_CONFIG := ${DEVICE}_defconfig

# Partition sizes
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10737418240
EOF

# Finish
write_footers
