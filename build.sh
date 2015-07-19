#!/bin/bash
parentdir="$(dirname "${PWD}")"
tsbuilddir=${PWD}
cfgpkg="ts-config"
config="ts-prod.cfg"
rootdir=${parentdir}/root
moddir="modules"
pkgsdir="packages"

i=0
pkgType=0

# Get the packages from the config file and print the options
while read aline; do
    if [[ $aline == "TYPE" ]]; then
        pkgType=1
        continue
    elif [[ $aline == "PACKAGES" ]]; then
        break
    fi
    if [[ pkgType -eq 1 ]]; then
        if [[ $aline =~ "ALL" ]]; then
            packages[$i]=$(echo $aline | awk -F':' '{print $2}')
            ((i=i+1))
        else
            packages[$i]=$(echo $aline | awk -F':' '{print $1}')
            ((i=i+1))
        fi
    fi
done < ${parentdir}/${cfgpkg}/${config}

if [[ -z "$1"  || -z "$2" ]]; then
    echo "Script to build ALL packages."
    echo "Usage: ./build.sh <package> <action>"
    echo "Available values for <package> are: ${packages[@]}"
    echo "Valid <action> are: build, clean."
    echo "Valid <detector> are: ALL (default)"
    exit
fi

# Make sure the log directory exists
cd ${tsbuilddir}
if [[ ! -d "log" ]]; then
    mkdir "log"
fi

# Now get the packages for the selected type
ptype=0
while read apkgline; do
    if [[ $apkgline == "TYPE" ]]; then
        ptype=1
    fi
    if [[ $apkgline == "PACKAGES" ]]; then
        ptype=0
    fi
    if [[ $apkgline =~ $1 ]]; then
        if [[ $ptype == 1 ]]; then
            packs[0]=$(echo $apkgline | awk -F':' '{print $2}')
        else
            packs[0]=$(echo $apkgline | awk '{print $1}')
        fi
    fi
done < ${parentdir}/${cfgpkg}/${config}

echo ${packs[@]}

cd ${tsbuilddir}
for pkg in ${packs[@]}; do
    source ${tsbuilddir}/Source_At_Start.sh
    buildpkg="./${moddir}/${pkgsdir}/build_${pkg}.sh"
    . ${buildpkg} ${parentdir}/${pkg} $2
    cd ${tsbuilddir}
done
echo " "
echo "The build script has finished. You should check the log files for errors."
echo "To run the executables you need to source the script Source_At_Start.sh"
echo " "

