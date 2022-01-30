#/bin/bash

rootdir=$(readlink -f $0)
rootdir=$(dirname $rootdir)
cd $rootdir
# read config but get rid of windows-style line feeds first
source <(grep = config.ini | sed 's/\r//g')

# Get latest commit of paper
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

# blacklist patches
python3 $rootdir/blacklist_patches.py "${rootdir}/blacklist.txt"
if $(test $? -ne 0); then
  exit $?
fi

echo "Starting build"
./gradlew applyPatches && ./gradlew createReobfBundlerJar

if $(test $? -ne 0); then
  exit $?
fi
 
output="$rootdir/build/"
if $(test ! -d $output);
then
  mkdir -p "$output";
fi
workdir="work"
paper_out=$rootdir/Paper/build/libs/
build_file=$(ls $paper_out)
minecraftversion=$(cat "$workdir/BuildData/info.json"  | grep minecraftVersion | cut -d '"' -f 4)
spigotversion=$(cat "$workdir/BuildData/info.json"  | grep spigotVersion | cut -d '"' -f 4)
date=$(date +"%Y-%m-%d")
echo "Copying ${build_file} to \"$output/paper-${minecraftversion}_${date}.jar\""
cp "$paper_out/$build_file" "$output/paper-${minecraftversion}_${date}.jar"

# removing all but the n latest builds
echo "Removing old builds"
n=5
cd $output
ls -tp | grep -v '/$' | grep -v '^l' | tail -n +$(expr $n + 1) | xargs -I {} rm -- {}
echo "Creating symbolic link paper-${minecraftversion}_latest.jar"
ln -s "paper-${minecraftversion}_${date}.jar" "paper-${minecraftversion}_latest.jar"