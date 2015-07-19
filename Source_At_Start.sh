#!/bin/bash
curdir=${PWD}
packagedir=$(dirname ${BASH_SOURCE})
parentdir=$(cd "${packagedir}/.."; pwd)
export parentdir

unset GEANT4_BASE_DIR
export GEANT4_BASE_DIR=${parentdir}/Geant4

if [[ -e "${GEANT4_BASE_DIR}/install/bin/Geant4.sh" ]]; then
    . ${GEANT4_BASE_DIR}/install/bin/Geant4.sh
    . ${GEANT4_BASE_DIR}/install/share/Geant4-9.6.4/geant4make/geant4make.sh
fi

if [[ ":${LD_LIBRARY_PATH}:" != "" ]]; then
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${G4LIB}/${G4SYSTEM}
fi

unset ROOTSYS
export ROOTSYS=${parentdir}/root

if [[ -e "${ROOTSYS}/bin/thisroot.sh" ]]; then
    . ${ROOTSYS}/bin/thisroot.sh
else
    echo "Cannot source bin/thisroot.sh"
fi

unset CLHEP_BASE_DIR
export CLHEP_BASE_DIR=${parentdir}/CLHEP/install

if [[ ":${LD_LIBRARY_PATH}:" != ":${CLHEP_BASE_DIR}/lib:" ]]; then
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CLHEP_BASE_DIR}/lib
fi


unset NEUTDIR
export NEUTDIR=${parentdir}/NEUT
