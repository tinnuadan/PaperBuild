#/bin/bash

#rootdir=$(pwd)
rootdir=$(pwd)
source <(grep = config.ini)


if $(test -d "Paper"); then
  cd Paper
  git reset --hard HEAD
  git checkout "$branch"
  git fetch
  git rebase HEAD
else
  git clone https://github.com/PaperMC/Paper.git
  cd Paper
  git checkout "$branch"
fi

# apply fixes first
git apply "$rootdir/patches/init_sh.patch"
git apply "$rootdir/patches/build_sh.patch"

echo "Starting build"
./paper jar

if $(test ! -d build);
then
  mkdir "build";
fi
date=$(date +"%Y_%m_%d")
cp "paperclip.jar" "$rootdir/build/paper_$date.jar"