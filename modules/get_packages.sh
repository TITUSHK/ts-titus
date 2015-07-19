#!/bin/bash -x
# Script to download the packages given in the config files.
parent=".."
cfgpkg="ts-config"
pkgtype="ALL"
pkgscfg="ts-packages.cfg"

# If the config isn't set then we set it to the production config file
if [[ ! -z "$1" ]]; then
    cfgpkg=$1
fi

config="${parent}/${cfgpkg}/ts-prod.cfg"

# Check which dir we are in
curdir=${PWD}
basedir=$(basename $curdir)
if [[ $basedir == "modules" ]]; then
    parent="../.."
fi

# Read in the types and get the package versions for that type
packages=""
inPackages=0
i=0
while read atype; do
    if [[ $atype =~ $pkgtype ]]; then
        packages=$atype
    fi
    if [[ $atype == "PACKAGES" ]]; then
        inPackages=1
    fi
    if [[ $inPackages -eq 1 ]]; then
        package=$(echo $atype | awk '{print $1}')
        version=$(echo $atype | awk '{print $2}')
        if [[ $packages =~ $package ]]; then
            pkgvers[$i]="$package,$version"
            ((i=i+1))
        fi
    fi
done < ${config}

echo "packages ${pkgvers[@]}"

# Read in the packages
for pkgver in ${pkgvers[@]}; do
    pkg=$(echo $pkgver | awk -F',' '{print $1}')
    version=$(echo $pkgver | awk -F',' '{print $2}')
    # Loop over the packages and pick the correct one to checkout
    while read apkg; do
        [[ -z $pkg ]] && continue
        if [[ $apkg =~ $pkg ]]; then
            if [[ -d ${parent}/$pkg ]]; then
                echo "Package ${parent}/${pkg} already exists. Skipping clone and checkout"
            else
                echo "CLONING package: ${pkg}"
                path=$(echo $apkg | awk '{print $1}')
                if [[ $version == "HEAD" ]]; then
                    git clone ${path} ${parent}/${pkg}; cd ${parent}/${pkg}
                else
                    git clone ${path} ${parent}/${pkg}; cd ${parent}/${pkg}; git checkout tags/${version}
                fi
            fi
        fi
    done < ${parent}/${cfgpkg}/${pkgscfg}
done
