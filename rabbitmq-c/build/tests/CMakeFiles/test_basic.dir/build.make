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
CMAKE_SOURCE_DIR = /home/nvidia/rabbitmq-c

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/nvidia/rabbitmq-c/build

# Include any dependencies generated for this target.
include tests/CMakeFiles/test_basic.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tests/CMakeFiles/test_basic.dir/compiler_depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/test_basic.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/test_basic.dir/flags.make

tests/CMakeFiles/test_basic.dir/test_basic.c.o: tests/CMakeFiles/test_basic.dir/flags.make
tests/CMakeFiles/test_basic.dir/test_basic.c.o: ../tests/test_basic.c
tests/CMakeFiles/test_basic.dir/test_basic.c.o: tests/CMakeFiles/test_basic.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object tests/CMakeFiles/test_basic.dir/test_basic.c.o"
	cd /home/nvidia/rabbitmq-c/build/tests && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT tests/CMakeFiles/test_basic.dir/test_basic.c.o -MF CMakeFiles/test_basic.dir/test_basic.c.o.d -o CMakeFiles/test_basic.dir/test_basic.c.o -c /home/nvidia/rabbitmq-c/tests/test_basic.c

tests/CMakeFiles/test_basic.dir/test_basic.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/test_basic.dir/test_basic.c.i"
	cd /home/nvidia/rabbitmq-c/build/tests && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/tests/test_basic.c > CMakeFiles/test_basic.dir/test_basic.c.i

tests/CMakeFiles/test_basic.dir/test_basic.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/test_basic.dir/test_basic.c.s"
	cd /home/nvidia/rabbitmq-c/build/tests && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/tests/test_basic.c -o CMakeFiles/test_basic.dir/test_basic.c.s

# Object files for target test_basic
test_basic_OBJECTS = \
"CMakeFiles/test_basic.dir/test_basic.c.o"

# External object files for target test_basic
test_basic_EXTERNAL_OBJECTS =

tests/test_basic: tests/CMakeFiles/test_basic.dir/test_basic.c.o
tests/test_basic: tests/CMakeFiles/test_basic.dir/build.make
tests/test_basic: librabbitmq/librabbitmq.a
tests/test_basic: /usr/lib/aarch64-linux-gnu/libssl.so
tests/test_basic: /usr/lib/aarch64-linux-gnu/libcrypto.so
tests/test_basic: tests/CMakeFiles/test_basic.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable test_basic"
	cd /home/nvidia/rabbitmq-c/build/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/test_basic.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/test_basic.dir/build: tests/test_basic
.PHONY : tests/CMakeFiles/test_basic.dir/build

tests/CMakeFiles/test_basic.dir/clean:
	cd /home/nvidia/rabbitmq-c/build/tests && $(CMAKE_COMMAND) -P CMakeFiles/test_basic.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/test_basic.dir/clean

tests/CMakeFiles/test_basic.dir/depend:
	cd /home/nvidia/rabbitmq-c/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/nvidia/rabbitmq-c /home/nvidia/rabbitmq-c/tests /home/nvidia/rabbitmq-c/build /home/nvidia/rabbitmq-c/build/tests /home/nvidia/rabbitmq-c/build/tests/CMakeFiles/test_basic.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/test_basic.dir/depend

