#/bin/bash

#rootdir=$(pwd)
rootdir=$(pwd)
# read config but get rid of windows-style line feeds first
source <(grep = config.ini | sed 's/\r//g')


if $(test -d "Paper"); then
  cd Paper
  git clean -dfx
  git submodule foreach --recursive git clean -dfx
  git reset --hard HEAD
  git checkout "$branch"
  git reset --hard HEAD
  git submodule foreach --recursive git reset --hard HEAD
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
workdir="work"
minecraftversion=$(cat "$workdir/BuildData/info.json"  | grep minecraftVersion | cut -d '"' -f 4)
date=$(date +"%Y-%m-%d")
echo "Copying to \"$output/paper-${minecraftversion}_${date}.jar\""
cp "paperclip.jar" "$output/paper-${minecraftversion}_${date}.jar"