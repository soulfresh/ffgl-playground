# Simple make file so you don't have to remember the
# commands to run in order to generate and build the
# playground.

gen-xcode:
	@echo "Generating make based project..."
	cmake -B ./build/xcode -S . -G Xcode
	@echo "🏗"

gen-ninja-debug:
	@echo "Generating Ninja based Debug project..."
	cmake -B ./build/make/debug -S . \
		-G Ninja \
		-DCMAKE_BUILD_TYPE=Debug \
		-DLINK_COMPILE_COMMANDS:string=true
	@echo "🏗"

gen-ninja-release:
	@echo "Generating Ninja based Debug project..."
	cmake -B ./build/make/release -S . \
		-G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DPUBLISH_TO_JUICEBAR=ON \
		-DLINK_COMPILE_COMMANDS:string=true
	@echo "🏗"

gen-make-debug:
	@echo "Generating make based Debug project..."
	cmake -B ./build/make/debug -S . \
		-DCMAKE_BUILD_TYPE=Debug \
		-DLINK_COMPILE_COMMANDS:string=true
	@echo "🏗"

gen-make-release:
	@echo "Generating make based Release project..."
	cmake -B ./build/make/release -S . \
		-DCMAKE_BUILD_TYPE=Release \
		-DPUBLISH_TO_JUICEBAR=ON \
		-DLINK_COMPILE_COMMANDS:string=true
	@echo "🏗"

# Shorthand for my favorite build. Customize to yours.
gen: gen-ninja-debug

clean:
	@echo "Cleaning build files..."
	cmake --build ./build/make/debug --target clean
	@echo "🧹"

clean-release:
	@echo "Cleaning build files..."
	cmake --build ./build/make/release --target clean
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
	@echo "Not Implemented"
	# @echo "🙌"

playground:
	@echo "Starting FFGL Playground ⛹️"
	cmake --build ./build/make/debug --target SpiderPointsPlayground
	./build/make/debug/src/SpiderPointsPlayground
	@echo "👋"

gradients:
	@echo "Building Gradients example plugin..."
	cmake --build ./build/make/debug --target Gradients
	@echo "🌈"

addsubtract:
	@echo "Building AddSubtract example plugin..."
	cmake --build ./build/make/debug --target AddSubtract
	@echo "+-"

sp:
	@echo "Building SpiderPoints plugin..."
	cmake --build ./build/make/debug --target SpiderPoints
	@echo "🕷"

sp-release:
	@echo "Building SpiderPoints RELEASE plugin..."
	cmake --build ./build/make/release --target SpiderPoints
	@echo "🕷"

sp-play:
	@echo "Starting FFGL Playground ⛹️"
	cmake --build ./build/make/debug --target SpiderPointsPlayground
	./build/make/debug/src/SpiderPointsPlayground
	@echo "👋"

spm:
	@echo "Building SpiderPointsMask plugin..."
	cmake --build ./build/make/debug --target SpiderPointsMask
	# rsync -av ./build/make/debug/src/SpiderPointsMask.bundle ./plugins
	@echo "🕷"

spm-release:
	@echo "Building SpiderPointsMask RELEASE plugin..."
	cmake --build ./build/make/release --target SpiderPointsMask
	@echo "🕷"

spm-play:
	@echo "Building SpiderPointsMask plugin..."
	cmake --build ./build/make/debug --target SpiderPointsMaskPlayground
	./build/make/debug/src/SpiderPointsMaskPlayground
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
		../ffgl-playground

