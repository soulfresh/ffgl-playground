# lolpxl
FFGL plugins

## Dependencies

You'll need `cmake` in order to work on the project:

- https://cmake.org/download/
- https://formulae.brew.sh/formula/cmake

## Setup

    git clone --recursive git@github.com:soulfresh/lolpxl.git
    make gen
    make all

## Adding New Libraries

    cd ./deps
    git submodule add ${REPO_URL}
    cd ./${REPO_NAME}
    git checkout tags/${VERSION_NUMBER}

## Removing Libraries

    git rm ./deps/${REPO_NAME}


## Premake 5

Keeping these notes should I try Premake again in the future...

You have a couple options for installing Premake 5.

### Brew
This requires installying from HEAD because only brew 4-alpha is available:

    brew install --HEAD premake

There's no easy way to grab a specific version of the library so this comes
with the caveat that there may be bugs in the HEAD version.

More info: https://github.com/premake/premake-core/issues/1002

### Download
Download the program old-school style: https://premake.github.io/download
