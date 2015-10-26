#!/bin/bash
# Module for building ROOT. The first argument should be the package path
# the second should be the action (build, clean).

tcurdir=${PWD}
pkgdir=""
if [[ -d $1 ]]; then
    pkgdir=$1
else
    echo "Error: package directory $1 missing"
    exit 100
fi

cd ${pkgdir}

if [[ $2 == "build" ]]; then
    echo "Starting ROOT build (can take some time)"
     ./configure --disable-cxx11 --enable-python --enable-roofit --enable-minuit2 > "${tsbuilddir}/log/root-build.log" 2>&1
      make >> "${tsbuilddir}/log/root-build.log" 2>&1
      source ${ROOTSYS}/bin/thisroot.sh
      echo "Finished ROOT build (check the root-build.log to see if the build was successful)"
elif [[ $2 == "clean" ]]; then
    echo "Cleaning ROOT..."
    make distclean > "${tsbuilddir}/log/root-clean.log" 2>&1
    echo "Done cleaning ROOT"
fi

cd ${tcurdir}
