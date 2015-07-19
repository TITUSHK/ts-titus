#!/bin/bash
# Module to build the neut package. The first argument should be the package
# path and the second argument should be the action (build, clean).

tcurdir=${PWD}
pkgdir=""
if [[ -d $1 ]]; then
    pkgdir=$1
else
    echo "Error: package directory $1 missing"
    exit 111
fi

cd ${pkgdir}

if [[ $2 == "build" ]]; then
    if [[ -z ${CERN} || -z ${CERN_LEVEL} || -z ${CERN_ROOT} || ! ":${PATH}:" == *":${CERN_ROOT}/bin:"*  ]]; then
        echo "WARNING: CERNLIB environmental variables not set."
	    echo "If you wish to run NEUT you need to make sure you have access to"
	    echo "CERNLIB and have set the CERN, CERN_LEVEL, CERN_ROOT environmental variables"
	    echo "Skipping NEUT build"
    elif [[ ! -e "${ROOTSYS}/bin/root" ]]; then
	    echo "Cannot find root. Build ROOT first."
	    exit
    else
	    source ${ROOTSYS}/bin/thisroot.sh
	    cd ${pkgdir}/src/neutsmpl
        
        echo "Starting NEUT build"
	    if [[ -e "Makefile" ]]; then
            make clean
	    fi
	    csh -c ./Makeneutsmpl.csh > "${tsbuilddir}/log/neut-build.log" 2>&1
	    echo "Finished NEUT build (check the neut-build.log to see if the build was successful)"
    fi
elif [[ $2 == "clean"  ]]; then
	echo "Cleaning NEUT..."
	if [[ -e "Makefile" ]]; then
	    make  clean > "${tsbuilddir}/log/neut-clean.log" 2>&1
	fi
	echo "Done cleaning NEUT"
fi

cd ${tcurdir}
