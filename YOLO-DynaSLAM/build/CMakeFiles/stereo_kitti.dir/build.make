# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.23

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/nvidia/YOLO-DynaSLAM

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/nvidia/YOLO-DynaSLAM/build

# Include any dependencies generated for this target.
include CMakeFiles/stereo_kitti.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/stereo_kitti.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/stereo_kitti.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/stereo_kitti.dir/flags.make

CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o: CMakeFiles/stereo_kitti.dir/flags.make
CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o: ../Examples/Stereo/stereo_kitti.cc
CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o: CMakeFiles/stereo_kitti.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/YOLO-DynaSLAM/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o -MF CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o.d -o CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o -c /home/nvidia/YOLO-DynaSLAM/Examples/Stereo/stereo_kitti.cc

CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/nvidia/YOLO-DynaSLAM/Examples/Stereo/stereo_kitti.cc > CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.i

CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/nvidia/YOLO-DynaSLAM/Examples/Stereo/stereo_kitti.cc -o CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.s

# Object files for target stereo_kitti
stereo_kitti_OBJECTS = \
"CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o"

# External object files for target stereo_kitti
stereo_kitti_EXTERNAL_OBJECTS =

../Examples/Stereo/stereo_kitti: CMakeFiles/stereo_kitti.dir/Examples/Stereo/stereo_kitti.cc.o
../Examples/Stereo/stereo_kitti: CMakeFiles/stereo_kitti.dir/build.make
../Examples/Stereo/stereo_kitti: ../lib/libDynaSLAM.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_dnn.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_gapi.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_highgui.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_ml.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_objdetect.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_photo.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_stitching.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_video.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_calib3d.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_features2d.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_flann.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_videoio.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_imgcodecs.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_imgproc.so.4.1.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libopencv_core.so.4.1.1
../Examples/Stereo/stereo_kitti: /home/nvidia/Pangolin/build/src/libpangolin.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libGL.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libGLU.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libGLEW.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libSM.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libICE.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libX11.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libXext.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libpython2.7.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libavcodec.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libavformat.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libavutil.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libswscale.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libpng.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libz.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libjpeg.so
../Examples/Stereo/stereo_kitti: ../Thirdparty/DBoW2/lib/libDBoW2.so
../Examples/Stereo/stereo_kitti: ../Thirdparty/g2o/lib/libg2o.so
../Examples/Stereo/stereo_kitti: /usr/lib/x86_64-linux-gnu/libpython2.7.so
../Examples/Stereo/stereo_kitti: /usr/local/lib/libdarknet.so
../Examples/Stereo/stereo_kitti: /usr/local/lib/librabbitmq.so
../Examples/Stereo/stereo_kitti: /usr/local/lib/librabbitmq.so.4
../Examples/Stereo/stereo_kitti: /usr/local/lib/librabbitmq.so.0.12.0
../Examples/Stereo/stereo_kitti: /usr/local/lib/libSimpleAmqpClient.so.7
../Examples/Stereo/stereo_kitti: /usr/local/lib/libSimpleAmqpClient.so.7.0.1
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libboost_thread.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libboost_chrono.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libboost_system.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libboost_date_time.so
../Examples/Stereo/stereo_kitti: /usr/lib/aarch64-linux-gnu/libboost_atomic.so
../Examples/Stereo/stereo_kitti: CMakeFiles/stereo_kitti.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/nvidia/YOLO-DynaSLAM/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../Examples/Stereo/stereo_kitti"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/stereo_kitti.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/stereo_kitti.dir/build: ../Examples/Stereo/stereo_kitti
.PHONY : CMakeFiles/stereo_kitti.dir/build

CMakeFiles/stereo_kitti.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/stereo_kitti.dir/cmake_clean.cmake
.PHONY : CMakeFiles/stereo_kitti.dir/clean

CMakeFiles/stereo_kitti.dir/depend:
	cd /home/nvidia/YOLO-DynaSLAM/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/nvidia/YOLO-DynaSLAM /home/nvidia/YOLO-DynaSLAM /home/nvidia/YOLO-DynaSLAM/build /home/nvidia/YOLO-DynaSLAM/build /home/nvidia/YOLO-DynaSLAM/build/CMakeFiles/stereo_kitti.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/stereo_kitti.dir/depend

