#/bin/bash

#rootdir=$(pwd)
rootdir=$(pwd)
source <(grep = config.ini)


if $(test -d "Paper"); then
  cd Paper
  git reset --hard HEAD
  git checkout "$branch"
  git reset --hard HEAD
  git pull --rebase
else
  git clone https://github.com/PaperMC/Paper.git
  cd Paper
  git checkout "$branch"
fi

# set java options
export _JAVA_OPTIONS="$java_options"

# apply fixes first
git apply "$rootdir/patches/init_sh.patch"
git apply "$rootdir/patches/build_sh.patch"

echo "Starting build"
./paper jar

output="$rootdir/build/$branch"
if $(test ! -d $output);
then
  mkdir -p "$output";
fi
date=$(date +"%Y_%m_%d")
cp "paperclip.jar" "$output/paper_$date.jar"