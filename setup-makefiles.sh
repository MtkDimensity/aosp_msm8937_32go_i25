#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# 设备代号和厂商
DEVICE=msm8937_32go_i25
VENDOR=xtc

# 加载 extract_utils 并检查路径
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# 初始化 helper 脚本
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# 生成警告头和保护
write_headers

# 生成 makefile 规则
write_makefiles "${MY_DIR}/proprietary-files.txt" true

# 生成结束标记
write_footers