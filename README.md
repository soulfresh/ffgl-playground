# lolpxl
FFGL plugins

# Setup

    git clone --recursive git@github.com:soulfresh/lolpxl.git

# Adding New Libraries

    cd ./deps
    git submodule add ${REPO_URL}
    cd ./${REPO_NAME}
    git checkout tags/${VERSION_NUMBER}
