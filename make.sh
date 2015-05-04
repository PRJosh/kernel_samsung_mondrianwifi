#!/bin/bash

# Stupid shell script to compile kernel, nothing fancy
ID="`pwd`"

# Exports all the needed things Arch, SubArch and Cross Compile
export ARCH=arm
echo 'exporting Arch'
export SUBARCH=arm
echo 'exporting SubArch'

if [ "$2" = "cm" ] ; then
    kernel="cm"
elif [ "$2" = "slim" ] ; then
    kernel="slim"
else
    kernel=""
fi

# Export toolchain based on where I'm compiling
if [ "$kernerl" = "slim" ] ; then
    if echo "$ID" | grep josh ; then
        export CROSS_COMPILE=/home/josh/Android/android_prebuilt/linux-x86/toolchain/linaro-4.9-14.06/bin/arm-linux-gnueabihf-
        echo 'exporting Cross Compile for HOME'
    else
        export CROSS_COMPILE=/home/prbassplayer/lp5.1/prebuilt/linux-x86/toolchain/linaro-4.9-14.06/bin/arm-linux-gnueabihf-
        echo 'exporting Cross Compile server'
    fi
else
    export CROSS_COMPILE=/home/prbassplayer/lp5.1/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.8/bin/arm-linux-androideabi-
    echo 'exporting Cross Compile server'
fi

# Make sure build is clean!
echo 'Cleaning build'
make clean

# Generates a new .config and exists
if [ "$1" = "config" ] ; then
    if [ "$kernel" = "cm" ] ; then
        echo 'Making cm defconfig for mondrianwifi'
        make cyanogenmod_mondrian_defconfig
        exit
    elif [ "$kernel" = "slim" ] ; then
        echo 'Making slim defconfig for mondrianwifi'
        make slim_mondrian_defconfig
        exit
    elif [ -z "$kernel" ] ; then
        echo "You didn't specify what defconfig, exiting"
        exit
    fi
fi

if [ "$2" = "debug" ] ; then
    export CONFIG_DEBUG_SECTION_MISMATCH=y
    echo "Run debug mismatch"
    sleep 10
fi

# Exports kernel local version? Not sure yet.
#echo 'Exporting kernel version'
#export LOCALVERSION='SlimTest_1.0'

# Lets go!
echo 'Lets start!'
make -j$1
