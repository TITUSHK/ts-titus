# ts-titus
README 

ts-titus is a management package in the TITUSHK organization. It contains the scripts to run to download and compile the code.

To check the status of the HEAD for any build problems before downloaded and installing the nightly build and runtime testing results can be found at:

http://pprc.qmul.ac.uk/~richards/TITUS/index.html

*************************************** Description of scripts  ****************************************

Scripts:

get_release.sh                  : to get the other repositories of the release
build.sh [option] build         : to build the release. 
build.sh [option] clean         : to clean
Source_At_Start.sh              : environment variables if one runs the executables in WCSim and fiTQun. 
ts_release.cfg                  : tag of each package of the release
[option] = ALL for building all the packages, otherwise use 

CLHEP Geant4 NEUT root ts-WChSandBox ts-WChRecoSandBox
*******************************************************************************************************

************************************ To get packages and install software *******************************

git clone https://github.com/TITUSHK/ts-titus.git
cd ts-titus
./get_release.sh  #check out the master version when prompted
source ./Source_At_Start.sh
./build.sh ALL build

********************************************************************************************************
