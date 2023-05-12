# ffgl-playground
A development area for building FFGL plugins.

Includes:
- Ready to use Cmake based build system
- Dependency management with git submodules
- Language server support
- A playground for developing plugins outside of Resolume

Coming soon...
- Plugin generator
- Plugin preview host with
  - `imGui` integration
  - Plugin hot reload
  - Debug support

## The Playground
MennoVink has a nice FFGL testbed at https://github.com/MennoVink/FFGL_Testbed

Unfortunately, the testbed stopped working for me and I'm unable
to get it working again so I've created a "playground" in this
project where you can run your code outside of Resolume.

Ideally the playground would be an FFGL
host but I don't have that working yet. For the moment, you need to
manually call functions in your plugin from a `Playground.cpp` file
next to your plugin. You can copy the `src/playground/playground.cpp`
as a starting point.

I use IMGUI to provide a components you can manually attach to your
plugin parameters. There are a couple examples in the
`src/playground/playground.cpp` file.

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
is a namespace for your plugins (ex. `source-plugins` or `my-project-a`).
Inside of that should be a folder for each plugin you create.
See the `src/example` folders as for reference.

    touch src/myplugins/firstplugin/FirstPlugin.h
    touch src/myplugins/firstplugin/FirstPlugin.cpp

Now you can use cmake to generate your project. The `Makefile` in the
root of the project shows how to generate and build the project. I use it
as a list of shortcut commands so I don't have to remember the CMake
commands and for brevity (ex. `make sp` builds one of my plugins).
Feel free to customize the makefile with any build rules you use frequently.

### Development Flow
You'll see from the makefile that I generally use Ninja to build my plugins
from the commandline. On Windows, I use Visual Studio which will detect
and configure itself based on the CMake files.

Here's a description of my flow on the commandline:

On a new checkout, start by initializing the builds. If you want you can
`make all` to verify the build is working.

    make gen
    make all

There are also make tasks for generating other build types (ex. XCode) in the make file.

During development, I'll use the playground to build and test the plugin I'm
working on. I create specific build targets for each of my targets for running in the
playground and for generating debug/release builds. I'll usually have make
tasks like the following:

    make my-plug # create a debug build of a plugin 
    make my-plug-play # start the playground for a plugin
    make my-plug-release # create a release build

There are a couple example plugins in the `src/examples` folder.
For more example plugins, copy one of the FFGL SDK plugins from
`deps/ffgl/srouce/plugins` into the `src/examples` folder.

## Using with your VJ software
All plugins are built into the `/plugins` directory. This means you can
add the `/plugins` folder to your plugin host and it should pick up the
plugins as they are built.

### Resolume
See: https://github.com/resolume/ffgl/wiki/4.-Convenience-tips

## Dependency Management
Dependencies (ex. the FFGL SDK) are installed in the project as submodules.
You can add additional dependencies however you want but here are some
directions on how I use submodules to manage the dependencies.

### Adding New Libraries

    cd ./deps
    git submodule add ${REPO_URL}
    cd ./${REPO_NAME}
    git checkout tags/${VERSION_NUMBER}

Once you've checkouted the library, you can use CMake to build and include it.
See the CMakelists and find* files in the `/deps` folder for examples.

### Removing Libraries

    git rm ./deps/${REPO_NAME}

## Precompiled Headers
Any `.pch` files found a `/lib` or `/src` subdirectory will be treated as a
precompiled header. If none are found, the FFGL SDK headers will be automatically
precompiled and included in your plugins.

## compile_commands.json
If you need a compile database generated for your IDE, you can pass
`-DLINK_COMPILE_COMMANDS` when generating the project and the `compile_commands.json`
file will be linked in the root of the project.

## Troubleshooting

### Plugin fails to load on OSX

try

    sudo xattr -rd com.apple.quarantine /Users/{YOUR_USERNAME}/Library/Graphics/FreeFramePlug-Ins/

