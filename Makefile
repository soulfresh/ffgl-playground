# Simple make file so you don't have to remember the
# commands to run in order to generate and build the
# playground.

gen-xcode:
	@echo "Generating make based project..."
	cmake -B ./build/xcode -S . -G Xcode
	@echo "🏗"

gen-make-debug:
	@echo "Generating make based Debug project..."
	cmake -B ./build/make/debug -S . -DCMAKE_BUILD_TYPE=Debug -DLINK_COMPILE_COMMANDS:string=true
	@echo "🏗"

gen-make-release:
	@echo "Generating make based Release project..."
	cmake -B ./build/make/release -S . -DCMAKE_BUILD_TYPE=Release -DLINK_COMPILE_COMMANDS=true
	@echo "🏗"

# Generate a release but maintain debug info
gen-make-release-debinfo:
	@echo "Generating make based Release project with debug info..."
	cmake -B ./build/make/releasedebinfo -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLINK_COMPILE_COMMANDS=true
	@echo "🏗"

# Shorthand for my favorite build. Customize to yours.
gen: gen-make-debug

clean:
	@echo "Cleaning build files..."
	cmake --build ./build/make/debug --target clean
	-cmake --build ./build/make/release --target clean
	-cmake --build ./build/make/releasedebinfo --target clean
	@echo "🧹"

clean-plugins:
	@echo "Cleaning plugins folder..."
	rm -rfv ./plugins/*
	@echo "👋"

clean-cmake:
	@echo "Cleaning workspaces..."
	rm -rf ./build
	@echo "✌️"

install:
	cmake --install ./build/make/debug/src

all: gradients sp
	@echo "Donzo! 😅"

all-release: sp-release
	@echo "🙌"

gradients:
	@echo "Building Gradients example plugin..."
	cmake --build ./build/make/debug --target Gradients
	rm -rf plugins/*
	cmake --install ./build/make/debug/src
	@echo "💪"

sp:
	@echo "Building SpiderPoints plugin..."
	cmake --build ./build/make/debug --target SpiderPoints
	rm -rf plugins/*
	cmake --install ./build/make/debug/src
	@echo "🕷"

sp-release:
	@echo "Building SpiderPoints RELEASE plugin..."
	cmake --build ./build/make/release --target SpiderPoints
	rm -rf plugins/*
	cmake --install ./build/make/release/src
	@echo "🕷"

logs:
	@echo "Tailing Resolume logs..."
	# You will need to customize this with the location of your log file
	tail -f -n 600 /Users/marc/Library/Logs/Resolume\ Avenue/Resolume\ Avenue\ log.txt

# You can ignore this task. I use it to sync my
# changes to this repo from my private plugin repo.
sync:
	@echo "Synching to ffgl-playground..."
	rsync -av --progress --delete --exclude /.git --include /.git/modules --exclude /deps/ --exclude /src/lolpxl/ --exclude /lib/lolpxl/ ./ ../ffgl-playground

