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

clean-output:
	@echo "Cleaning plugins folder..."
	rm -rfv ./plugins/*
	@echo "👋"

clean-cmake:
	@echo "Cleaning workspaces..."
	rm -rf ./build
	@echo "✌️"

clean-plugins:
	@echo "Cleaning Generated Plugin Files..."
	cmake --build ./build/make/debug --target clean

all: sp spm
	@echo "Donzo! 😅"

all-release: sp-release
	@echo "🙌"

playground:
	@echo "Starting FFGL Playground ⛹️"
	cmake --build ./build/make/debug --target Playground
	./build/make/debug/src/playground/Playground
	@echo "👋"

gradients:
	@echo "Building Gradients example plugin..."
	cmake --build ./build/make/debug --target Gradients
	rsync -av ./build/make/debug/src/Gradients.bundle ./plugins
	@echo "🌈"

addsubtract:
	@echo "Building AddSubtract example plugin..."
	cmake --build ./build/make/debug --target AddSubtract
	rsync -av ./build/make/debug/src/AddSubtract.bundle ./plugins
	@echo "+-"

sp:
	@echo "Building SpiderPoints plugin..."
	cmake --build ./build/make/debug --target SpiderPoints
	rsync -av ./build/make/debug/src/SpiderPoints.bundle ./plugins
	@echo "🕷"

sp-release:
	@echo "Building SpiderPoints RELEASE plugin..."
	cmake --build ./build/make/release --target SpiderPoints
	rsync -av ./build/make/release/src/SpiderPoints.bundle ./plugins
	@echo "🕷"

spm:
	@echo "Building SpiderPointsMask plugin..."
	cmake --build ./build/make/debug --target SpiderPointsMask
	rsync -av ./build/make/debug/src/SpiderPointsMask.bundle ./plugins
	@echo "🕷"

logs:
	@echo "Tailing Resolume logs..."
	# You will need to customize this with the location of your log file
	tail -f -n 600 /Users/marc/Library/Logs/Resolume\ Avenue/Resolume\ Avenue\ log.txt

# You can ignore this task. I use it to sync my
# changes to this repo from my private plugin repo.
sync:
	@echo "Synching to ffgl-playground..."
	rsync -av --progress --delete \
		--exclude /.git \
		--include /.git/modules \
		--exclude /deps/ \
		--exclude /src/lolpxl/ \
		--exclude /lib/lolpxl/ \
		--exclude /build \
		--exclude /plugins \
		./ \
		../playground

