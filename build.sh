
CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)

if [ "a$BUILDTYPE" == "a" ]; then
	if [ `uname -s` == Linux ]; then
		BUILDTYPE="Unix Makefiles"
	elif [ `uname -s` == Darwin ]; then
		BUILDTYPE="Unix Makefiles"
	elif [ `uname -o` == Msys ]; then
		BUILDTYPE=VS
	fi
fi

if [ "$BUILDTYPE" == "Unix Makefiles" ]; then
	mkdir -p build
	cd build

	# Create 4 different makefiles (each in a separate directory)
	mkdir release;        cd release ;        cmake -G "$BUILDTYPE" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON  ../.. ; cd ..
	mkdir debug;          cd debug ;          cmake -G "$BUILDTYPE" -DCMAKE_BUILD_TYPE=Debug   -DBUILD_SHARED_LIBS=ON  ../.. ; cd ..
	mkdir release-static; cd release-static ; cmake -G "$BUILDTYPE" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF ../.. ; cd ..
	mkdir debug-static;   cd debug-static ;   cmake -G "$BUILDTYPE" -DCMAKE_BUILD_TYPE=Debug   -DBUILD_SHARED_LIBS=OFF ../.. ; cd ..

	cd release        ; make -j$CORES ; cd ..
	cd debug          ; make -j$CORES ; cd ..
	cd release-static ; make -j$CORES ; cd ..
	cd debug-static   ; make -j$CORES ; cd ..
elif [ "$BUILDTYPE" == "Xcode" ]; then
	cmake -G "$BUILDTYPE" -Bbuild -H.
elif [ "$BUILDTYPE" == "VS" ]; then
	cmake -G "Visual Studio 14 2015" -Bbuild -H.
fi
