#!/bin/bash
# Module to build WChRecoSandBox. The first argument should be the package path
# and the second argument should be the action (build, clean).

tcurdir=${PWD}
pkgdir=""

if [[ -d $1 ]]; then
    pkgdir=$1
else
    echo "Error: package directory $1 missing"
    exit 107
fi

cd ${pkgdir}

if [[ $2 == "build" ]]; then
        echo "Starting ts-WChRecoSandBox build (can take some time)"
	. ${tsbuilddir}/Source_At_Start.sh
        make > "${tsbuilddir}/log/ts-wchsandbox-build.log" 2>&1
	echo "Finished ts-WChRecoSandBox build (check the ts-wchsandbox-build.log to see if the build was successful)"
elif [[ $2 == "clean"  ]]; then
	echo "Cleaning ts-WChRecoSandBox..."
	make clean > "${tsbuilddir}/log/ts-wchsandbox-clean.log" 2>&1
	echo "Done cleaning ts-WCHSANDBOX"
fi

cd ${tcurdir}
