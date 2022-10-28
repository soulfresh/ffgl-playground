# Simple make file so you don't have to remember the
# commands to run in order to generate and build the
# playground.

gen-xcode:
	@echo "Generating make based project..."
	cmake -B ./build/xcode -S . -G Xcode
	@echo "🏗"

gen-make-debug:
	@echo "Generating make based Debug project..."
	cmake -E env CXXFLAGS="--target=x86_64-apple-macos10.9" cmake -B ./build/make/debug/x86_64 -S . -DCMAKE_BUILD_TYPE=Debug -DLINK_COMPILE_COMMANDS:string=true
	@echo "🏗"

gen-make-release:
	@echo "Generating make based Release project..."
	cmake -E env CXXFLAGS="--target=x86_64-apple-macos10.9" cmake -B ./build/make/release/x86_64 -S . -DCMAKE_BUILD_TYPE=Release -DLINK_COMPILE_COMMANDS=true
	@echo "🏗"

gen-make-mulitarch:
	@echo "Generating make based Release project for multiple architectures..."
	cmake -E env CXXFLAGS="--target=x86_64-apple-macos10.9" cmake -B ./build/make/release/x86_64 -S . -DCMAKE_BUILD_TYPE=Release -DLINK_COMPILE_COMMANDS=true
	cmake -E env CXXFLAGS="--target=arm64-apple-macos10.9" cmake -B ./build/make/release/arm64 -S . -DCMAKE_BUILD_TYPE=Release -DLINK_COMPILE_COMMANDS=true
	@echo "🏗"

# Shorthand for my favorite build. Customize to yours.
gen: gen-make-debug

clean:
	@echo "Cleaning build files..."
	cmake --build ./build/make/debug/x86_64 --target clean
	-cmake --build ./build/make/release/arm64 --target clean
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
	cmake --build ./build/make/debug/x86_64 --target clean

all: sp spm
	@echo "Donzo! 😅"

all-release: sp-release
	@echo "🙌"

playground:
	@echo "Starting FFGL Playground ⛹️"
	cmake --build ./build/make/debug/x86_64 --target SpiderPointsPlayground
	./build/make/debug/x86_64/src/SpiderPointsPlayground
	@echo "👋"

gradients:
	@echo "Building Gradients example plugin..."
	cmake --build ./build/make/debug/x86_64 --target Gradients
	rsync -av ./build/make/debug/x86_64/src/Gradients.bundle ./plugins
	@echo "🌈"

addsubtract:
	@echo "Building AddSubtract example plugin..."
	cmake --build ./build/make/debug/x86_64 --target AddSubtract
	rsync -av ./build/make/debug/x86_64/src/AddSubtract.bundle ./plugins
	@echo "+-"

sp:
	@echo "Building SpiderPoints plugin..."
	cmake --build ./build/make/debug/x86_64 --target SpiderPoints
	rsync -av ./build/make/debug/x86_64/src/SpiderPoints.bundle ./plugins
	@echo "🕷"

sp-release:
	@echo "Building SpiderPoints RELEASE plugin..."
	cmake --build ./build/make/release/x86_64 --target SpiderPoints
	rsync -av ./build/make/release/x86_64/src/SpiderPoints.bundle ./plugins
	@echo "🕷"

sp-play:
	@echo "Starting FFGL Playground ⛹️"
	cmake --build ./build/make/debug/x86_64 --target SpiderPointsPlayground
	./build/make/debug/x86_64/src/SpiderPointsPlayground
	@echo "👋"

spm:
	@echo "Building SpiderPointsMask plugin..."
	cmake --build ./build/make/debug/x86_64 --target SpiderPointsMask VERBOSE=1
	rsync -av ./build/make/debug/x86_64/src/SpiderPointsMask.bundle ./plugins
	@echo "🕷"

spm-multiarch:
	@echo "Building SpiderPointsMask plugin..."
	cmake --build ./build/make/debug/arm64 --target SpiderPointsMask
	cmake --build ./build/make/debug/x86_64 --target SpiderPointsMask
	# Copy one of the builds as the basis for our multiarch bundle
	cp -R ./build/make/debug/arm64/src/SpiderPointsMask.bundle ./build/make/debug/
	# Remove the executable from our multiarch bundle
	rm ./build/make/debug/SpiderPointsMask.bundle/Contents/MacOS/SpiderPointsMask
	# Combine the builds from both architectures into a single executable
	lipo -create ./build/make/debug/arm64/src/SpiderPointsMask.bundle/Contents/MacOS/SpiderPointsMask ./build/make/debug/x86_64/src/SpiderPointsMask.bundle/Contents/MacOS/SpiderPointsMask -output ./build/make/debug/SpiderPointsMask.bundle/Contents/MacOS/SpiderPointsMask
	# Copy the multiarch executable into our multiarch bundle folder
	rsync -av ./build/make/debug/SpiderPointsMask.bundle ./plugins
	@echo "🕷"

spm-release:
	@echo "Building SpiderPointsMask RELEASE plugin..."
	cmake --build ./build/make/release/x86_64 --target SpiderPointsMask
	rsync -av ./build/make/release/x86_64/src/SpiderPointsMask.bundle ./plugins
	@echo "🕷"

spm-play:
	@echo "Building SpiderPointsMask plugin..."
	cmake --build ./build/make/debug/x86_64 --target SpiderPointsMaskPlayground
	./build/make/debug/x86_64/src/SpiderPointsMaskPlayground
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

