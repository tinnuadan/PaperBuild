#/bin/bash

rootdir=$(pwd)

if $(test -d "Paper"); then
  cd Paper
  git reset --hard HEAD
else
  git clone https://github.com/PaperMC/Paper.git
  cd Paper
fi

# apply init fix first
git apply "$rootdir/init_sh.patch"

# apply all other fixes
for patch in $rootdir/patches/*.patch; do 
  echo "Applying $patch"
  git apply $patch
done


echo "Starting build"
./paper jar

date=$(date +"%Y_%m_%d")
cp "paperclip.jar" "$rootdir/paper_$date.jar"