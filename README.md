修改自鱼丸大佬制作的z7的lineageOS15.1设备树
请把此设备树放置在 aosp编译工作目录/device/xtc/msm8937_32go_i25/下
请在编译之前将手表连接至电脑，执行sudo apt-get update ，随后执行sudo apt-get install android-tools-adb
然后确认当前的文件夹是在aosp编译工作目录/device/xtc/msm8937_32go_i25/，确认无误后执行 source extract_files.sh并等待执行完成
执行前请同步https://github.com/LineageOS/android_tools_extract-utils.git 到aosp编译工作目录/tools/extract_utils
执行完毕后回到aosp编译工作目录并继续编译即可
