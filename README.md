# ffgl-playground
A development area for building FFGL plugins.

Includes:
- Ready to use Cmake based build system
- Dependency management with git submodules

Coming soon...
- Plugin preview host with
    - `imGui` integration
    - Plugin hot reload
    - Debug support

## Dependencies

You'll need `cmake` in order to work on the project:

- https://cmake.org/download/
- https://formulae.brew.sh/formula/cmake

## Setup
To use this project, simply clone or fork the repo and then add
subfolders inside of `src` and `lib` with your plugins and local
libs.

Start by cloning the repo with the `recursive` flag. The recursive
flag is necessary in order to get the FFGL SDK and other dependencies
which are linked as submodules.

    git clone --recursive git@github.com:soulfresh/lolpxl.git

Next create a folder inside of `src` that will contain your first plugin.
You will need to create your plugins two folders deep. The first level
is a namespace for your plugins. Inside of that will be a folder for
each plugin you create. You can copy one of the `src/example` folders as
quick way to get started.

    touch src/myplugins/firstplugin/FirstPlugin.h
    touch src/myplugins/firstplugin/FirstPlugin.cpp

Now you can use cmake to generate your project. The `Makefile` in the
root of the project shows how to generate and build the project. Feel
free to customize it with any build rules you use frequently.

    make gen-make
    make all

For more example plugins, copy one of the FFGL SDK plugins from
`deps/ffgl/srouce/plugins` into the `src/examples` folder.

## Using with your VJ software
All plugins are built into the `/plugins` directory. This means you can
add the `/plugins` folder to your plugin host and it should pick up the
plugins as they are built.

### Resolume
See: https://github.com/resolume/ffgl/wiki/4.-Convenience-tips

## Dependency Management
Dependencies (ie. the FFGL SDK) are installed in the project as submodules.
You can add additional dependencies however you want but here are some
directions on how I use submodules to manage the dependencies.

### Adding New Libraries

    cd ./deps
    git submodule add ${REPO_URL}
    cd ./${REPO_NAME}
    git checkout tags/${VERSION_NUMBER}

### Removing Libraries

    git rm ./deps/${REPO_NAME}

## compile_commands.json
If you need a compile database generated for your IDE, you can pass
`-DLINK_COMPILE_COMMANDS` when generating the project and the `compile_commands.json`
file will be linked in the root of the project.

