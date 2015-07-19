#!/bin/bash
# Module for building CLHEP. The first argument should be the package path
# the second argument should be the action (build, clean).
tcurdir=${PWD}
pkgdir=""
version=$3
if [[ -d $1 ]]; then
    pkgdir=$1
else
    echo "Error: package directory $1 missing"
    exit 101
fi

cd ${pkgdir}

if [[ $2 == "build" ]]; then
    echo "starting CLHEP build (can take some time)"

    if [[ ! -d "build" ]]; then
       mkdir "build"
    fi
    cd ./build
    cmake -DCMAKE_INSTALL_PREFIX=${CLHEP_BASE_DIR} ../source/${version}/CLHEP > ${tsbuilddir}/log/clhep-build.log 2>&1
    make >> "${tsbuilddir}/log/clhep-build.log" 2>&1
    make install >> "${tsbuilddir}/log/clhep-build.log" 2>&1
    echo "Finished CLHEP build (check the clhep-build.log to see if build was successful)"
elif [[ $2 == "clean"  ]]; then
    echo "Cleaning CLHEP..."
    if [[ -d "${pkgdir}/build" ]]; then
        cd ${pkgdir}/build
        make clean > "${tsbuilddir}/log/clhep-clean.log" 2>&1
        cd ../
        /bin/rm -r install
        cd ${tsbuilddir}
    fi
    echo "Done cleaning CLHEP"
fi

cd ${tcurdir}
