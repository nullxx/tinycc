#!/bin/bash
TARGET=$1
make clean

declare -a StringArray=("i386" "x86_64" "i386-win32" "x86_64-win32" "x86_64-osx" "arm" "arm64" "arm-wince" "c67" "riscv64" "arm64-osx")

check_target () {
    check_target_result=0
    for val in ${StringArray[@]}; do
        if [[ $val == $TARGET ]]; then
            check_target_result=1
            break;
        fi
    done
}


if [[ $TARGET == "help" ]]; then
    echo "Usage: $0 <target>"
    exit 1
fi

check_target

if [[ $$check_target_result == 0 ]]; then
    echo "Target $TARGET is not supported"
    exit 1
fi

rm -rf output || true
mkdir -p output

echo "Building for $TARGET"
echo "-- Running configure -- "
./configure --exec-prefix="." --prefix="."

echo "-- Running make -- "
make cross-$TARGET
make install

mv ./bin ./output/bin
mv ./lib ./output/lib
mv ./include ./output/include
mv ./share ./output/share

echo "-- Creating zip --"
cd output/ && zip ../tcc-$TARGET.zip * -r
