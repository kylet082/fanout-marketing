# This only to be run on windows machines using 'linux on windows'
# IMPORTANT!! this script should only be run from the root directory
#         >   ie : ./scripts/common/dos2unix-convertions.sh
if [ ! dos2unix -v COMMAND &> /dev/null ] ; then echo "`dos2unix` command could not be found!!"; echo " On Ubuntu : sudo apt-get install dos2unix -y"; exit; fi; find . -type f -print0 | xargs -0 -n 1 -P 4 dos2unix