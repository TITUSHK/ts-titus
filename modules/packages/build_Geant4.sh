#!/bin/bash
# Module to build Geant4. The first argument should be the path to the package.
# The second argument should be the action (build, clean).

tcurdir=${PWD}
pkgdir=""

if [[ -z "$3" ]]; then
   echo "Error: version environmental variable missing."
   exit 105
fi

if [[ -z "$CLHEP_VERSION" ]]; then
   echo "Error CLHEP_VERSION environmental variable missing."
   exit 106
fi

version=$3

if [[ -d $1 ]]; then
    pkgdir=$1
else
    echo "Error: package directory $1 missing"
    exit 102
fi

cd ${pkgdir}

if [[ -z $2 ]]; then
    echo "Error: action missing. Should be 'build' or 'clean'"
    exit 202
fi

if [[ $2 == "build" ]]; then
    echo "Starting GEANT4 build (can take some time)"
    if [[ ! -d "build" ]]; then
        mkdir "build"
    fi
    cd ./build
    cmake -DGEANT4_INSTALL_DATA=ON -DGEANT4_INSTALL_DATADIR=${pkgdir}/data -DCMAKE_INSTALL_PREFIX="${GEANT4_BASE_DIR}/install" -DCLHEP_VERSION_OK=${CLHEP_VERSION} -DCLHEP_LIBRARIES="${CLHEP_BASE_DIR}/lib" -DCLHEP_INCLUDE_DIRS="${CLHEP_BASE_DIR}/include" ${GEANT4_BASE_DIR}/source/${version} > "${tsbuilddir}/log/geant4-build.log" 2>&1
    make >> "${tsbuilddir}/log/geant4-build.log" 2>&1
    make install >> "${tsbuilddir}/log/geant4-build.log" 2>&1

    # Hack needed to compile the libmap and create the map file for the
    # libraries
    #if [[ -e ${GEANT4_BASE_DIR}/install/share/geant4-9.4.4/config/geant4-9.4.4.sh ]]; then
    #    source ${GEANT4_BASE_DIR}/install/share/geant4-9.4.4/config/geant4-9.4.4.sh
    #    # Set the G4INSTALL to point to the source location of the code
    #    export G4INSTALL=${GEANT4_BASE_DIR}/source
    #    cd ${GEANT4_BASE_DIR}/source/source
    #    make libmap >> "${tsbuilddir}/log/geant4-build.log" 2>&1
    #fi

    cd ${tsbuilddir}
    cd ${pkgdir}

    if [[ ! -d "data" ]]; then
        mkdir "data"
    fi 
      
    cd "data"
    if [ ! -e "G4NDL.3.14.tar.gz" ]; then
        wget http://geant4.cern.ch/support/source/G4NDL.3.14.tar.gz  >> "${tsbuilddir}/log/geant4-build.log" 2>&1
        tar -zxvf G4NDL.3.14.tar.gz >> "${tsbuilddir}/log/geant4-build.log" 2>&1
    else
        echo "Tar file G4NDL.3.14.tar.gz already downloaded"
    fi

    echo "Finished GEANT4 build (check the geant4-build.log to see if the build was successful)" 
   
elif [[ $2 == "clean"  ]]; then
    echo "Cleaning GEANT4..."
    if [[ -d "${pkgdir}/build" ]]; then
        cd ${pkgdir}/build
        make clean >> "${tsbuilddir}/log/geant4-clean.log" 2>&1
        cd ../
        /bin/rm -r install
        cd ${tsbuilddir}
    fi
    echo "Done cleaning GEANT4"
fi
cd ${tcurdir}
