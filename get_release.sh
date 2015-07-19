#!/bin/bash
# Script to get the git packages corresponding to the HK release.
# The script reads in the config file and pulls in the package containing
# the list of packages. The user is then presented with a list of releases
# and can pick the one of interest (by default the most recent release is
# used. This then causes the packages within that release to be checked out.

curdir=${PWD}
tsconfig="ts-config.cfg"
config=""

if [[ $2 == "dev" ]]; then
    if [[ -z "$3" ]]; then
        echo "Error: A config file of packages must be supplied in dev mode"
        echo "Exiting..."
        exit 130
    fi
    if [[ -e $3 ]]; then
        config=$3
    fi
fi

while read line; do
    path=$(echo ${line} | awk '{print $2}')
    package=$(echo ${line} | awk '{print $3}')
    if [[ -d "../${package}" ]]; then
       echo "Package ${package} already exists. Skipping clone"
    else
       git clone $path ../$package
    fi
done < ${tsconfig}

# Get the list of releases in reverse order
cd ../$package
releases=$(git tag)
if [[ $? -ne 0 ]]; then
    echo "Error: cannot get tag from git. Exiting"
    exit $?
fi

cd $curdir
i=0
for ver in $releases; do
    versions[$i]="${ver} "
    ((i=i+1))
done
# Some people seem to be having problems with this section of code
# sortedVersions=($(echo "${versions[@]}" | sed 's/ /\n/g' | sort))

sortedVersions=( $(for aver in "${versions[@]}"; do
    echo "${aver}"
done | sort -u) )

echo "0 version: master"
revers[0]="master"
k=1
for ((j=${#sortedVersions[@]}-1; j>=0; j--)); do
    rever=${sortedVersions[$j]}
    echo "$k version: $rever"
    revers[$k]=$rever
    ((k=k+1))
done

((lastver=k-1))
echo "Please choose a version number [0-$lastver] or q to quit"
read vernum

if [[ $vernum == "q" ]]; then
    echo "Quitting the script"
    exit
fi

re='^[0-9]+$'
if [[ $vernum =~ $re && $vernum -le $lastver ]]; then
    if [[ -d "../${package}" ]]; then
       echo "Package ${package} exists. Skipping checkout"
    else
       cd ../$package
       git checkout master
       git checkout tags/${revers[$vernum]}
       cd $curdir
    fi
else
    echo "Unrecognised version number. Exiting"
    exit
fi

# Now get the packages
. ./modules/get_packages.sh ${package}
