# PaperBuild
Build chain for paper with custom patches.


## Setup
* Copy config.ini.example to config.ini and adapt if necessary
* Adapt build.sh if necessary, by default the last 5 builds will be kept.

### With docker
* Build an image `docker build -t paperbuild`
### Without docker
* Copy config.ini to ./app

## Compiling custom paper
### With docker
* Just run the container everytime you want to build a new jar
### Without docker
* Run `./app/build.sh`

## Getting the files
The files will be in `app/build`.
The build directory will have the structure `build/paper-<version>-<compiledate>.jar`. You can always find a `paper-<version>-latest.jar` which links to the last compiled jar.

### With docker
`cp docker cp <containerId>:/app/build/ /host/target/path/`
(also works if container is not running)

