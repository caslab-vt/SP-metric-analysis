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
include examples/CMakeFiles/amqp_rpc_sendstring_client.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include examples/CMakeFiles/amqp_rpc_sendstring_client.dir/compiler_depend.make

# Include the progress variables for this target.
include examples/CMakeFiles/amqp_rpc_sendstring_client.dir/progress.make

# Include the compile flags for this target's objects.
include examples/CMakeFiles/amqp_rpc_sendstring_client.dir/flags.make

examples/CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o: examples/CMakeFiles/amqp_rpc_sendstring_client.dir/flags.make
examples/CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o: ../examples/amqp_rpc_sendstring_client.c
examples/CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o: examples/CMakeFiles/amqp_rpc_sendstring_client.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object examples/CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o"
	cd /home/nvidia/rabbitmq-c/build/examples && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT examples/CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o -MF CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o.d -o CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o -c /home/nvidia/rabbitmq-c/examples/amqp_rpc_sendstring_client.c

examples/CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.i"
	cd /home/nvidia/rabbitmq-c/build/examples && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/examples/amqp_rpc_sendstring_client.c > CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.i

examples/CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.s"
	cd /home/nvidia/rabbitmq-c/build/examples && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/examples/amqp_rpc_sendstring_client.c -o CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.s

# Object files for target amqp_rpc_sendstring_client
amqp_rpc_sendstring_client_OBJECTS = \
"CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o"

# External object files for target amqp_rpc_sendstring_client
amqp_rpc_sendstring_client_EXTERNAL_OBJECTS = \
"/home/nvidia/rabbitmq-c/build/examples/CMakeFiles/examples-common.dir/utils.c.o" \
"/home/nvidia/rabbitmq-c/build/examples/CMakeFiles/examples-common.dir/unix/platform_utils.c.o"

examples/amqp_rpc_sendstring_client: examples/CMakeFiles/amqp_rpc_sendstring_client.dir/amqp_rpc_sendstring_client.c.o
examples/amqp_rpc_sendstring_client: examples/CMakeFiles/examples-common.dir/utils.c.o
examples/amqp_rpc_sendstring_client: examples/CMakeFiles/examples-common.dir/unix/platform_utils.c.o
examples/amqp_rpc_sendstring_client: examples/CMakeFiles/amqp_rpc_sendstring_client.dir/build.make
examples/amqp_rpc_sendstring_client: librabbitmq/librabbitmq.so.0.12.0
examples/amqp_rpc_sendstring_client: examples/CMakeFiles/amqp_rpc_sendstring_client.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable amqp_rpc_sendstring_client"
	cd /home/nvidia/rabbitmq-c/build/examples && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/amqp_rpc_sendstring_client.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
examples/CMakeFiles/amqp_rpc_sendstring_client.dir/build: examples/amqp_rpc_sendstring_client
.PHONY : examples/CMakeFiles/amqp_rpc_sendstring_client.dir/build

examples/CMakeFiles/amqp_rpc_sendstring_client.dir/clean:
	cd /home/nvidia/rabbitmq-c/build/examples && $(CMAKE_COMMAND) -P CMakeFiles/amqp_rpc_sendstring_client.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/amqp_rpc_sendstring_client.dir/clean

examples/CMakeFiles/amqp_rpc_sendstring_client.dir/depend:
	cd /home/nvidia/rabbitmq-c/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/nvidia/rabbitmq-c /home/nvidia/rabbitmq-c/examples /home/nvidia/rabbitmq-c/build /home/nvidia/rabbitmq-c/build/examples /home/nvidia/rabbitmq-c/build/examples/CMakeFiles/amqp_rpc_sendstring_client.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : examples/CMakeFiles/amqp_rpc_sendstring_client.dir/depend

