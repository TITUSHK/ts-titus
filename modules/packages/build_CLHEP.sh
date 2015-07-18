#!/bin/bash
# Module for building CLHEP. The first argument should be the package path
# the second argument should be the action (build, clean).
tcurdir=${PWD}
pkgdir=""
if [[ -d $1 ]]; then
    pkgdir=$1
else
    echo "Error: package directory $1 missing"
    exit 101
fi

cd ${pkgdir}

if [[ $2 == "build" ]]; then
    echo "starting CLHEP build (can take some time)"
    ./configure --prefix=${CLHEP_BASE_DIR} > "${hkbuilddir}/log/clhep-build.log" 2>&1
    make >> "${hkbuilddir}/log/clhep-build.log" 2>&1
    make install >> "${hkbuilddir}/log/clhep-build.log" 2>&1
    echo "Finished CLHEP build (check the clhep-build.log to see if build was successful)"
elif [[ $2 == "clean"  ]]; then
    echo "Cleaning CLHEP..."
    make clean > "${hkbuilddir}/log/clhep-clean.log" 2>&1
    echo "Done cleaning CLHEP"
fi

cd ${tcurdir}
