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
CMAKE_SOURCE_DIR = /home/nvidia/osqp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/nvidia/osqp/build

# Include any dependencies generated for this target.
include CMakeFiles/osqp_demo.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/osqp_demo.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/osqp_demo.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/osqp_demo.dir/flags.make

CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o: CMakeFiles/osqp_demo.dir/flags.make
CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o: ../examples/osqp_demo.c
CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o: CMakeFiles/osqp_demo.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/osqp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o -MF CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o.d -o CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o -c /home/nvidia/osqp/examples/osqp_demo.c

CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/osqp/examples/osqp_demo.c > CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.i

CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/osqp/examples/osqp_demo.c -o CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.s

# Object files for target osqp_demo
osqp_demo_OBJECTS = \
"CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o"

# External object files for target osqp_demo
osqp_demo_EXTERNAL_OBJECTS =

out/osqp_demo: CMakeFiles/osqp_demo.dir/examples/osqp_demo.c.o
out/osqp_demo: CMakeFiles/osqp_demo.dir/build.make
out/osqp_demo: out/libosqp.a
out/osqp_demo: CMakeFiles/osqp_demo.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/nvidia/osqp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable out/osqp_demo"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/osqp_demo.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/osqp_demo.dir/build: out/osqp_demo
.PHONY : CMakeFiles/osqp_demo.dir/build

CMakeFiles/osqp_demo.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/osqp_demo.dir/cmake_clean.cmake
.PHONY : CMakeFiles/osqp_demo.dir/clean

CMakeFiles/osqp_demo.dir/depend:
	cd /home/nvidia/osqp/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/nvidia/osqp /home/nvidia/osqp /home/nvidia/osqp/build /home/nvidia/osqp/build /home/nvidia/osqp/build/CMakeFiles/osqp_demo.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/osqp_demo.dir/depend

