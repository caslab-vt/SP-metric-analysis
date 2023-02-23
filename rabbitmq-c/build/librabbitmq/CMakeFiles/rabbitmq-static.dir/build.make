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
include librabbitmq/CMakeFiles/rabbitmq-static.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.make

# Include the progress variables for this target.
include librabbitmq/CMakeFiles/rabbitmq-static.dir/progress.make

# Include the compile flags for this target's objects.
include librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_api.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_api.c.o: ../librabbitmq/amqp_api.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_api.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_api.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_api.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_api.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_api.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_api.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_api.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_api.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_api.c > CMakeFiles/rabbitmq-static.dir/amqp_api.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_api.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_api.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_api.c -o CMakeFiles/rabbitmq-static.dir/amqp_api.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o: ../librabbitmq/amqp_connection.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_connection.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_connection.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_connection.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_connection.c > CMakeFiles/rabbitmq-static.dir/amqp_connection.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_connection.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_connection.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_connection.c -o CMakeFiles/rabbitmq-static.dir/amqp_connection.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o: ../librabbitmq/amqp_consumer.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_consumer.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_consumer.c > CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_consumer.c -o CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o: ../librabbitmq/amqp_framing.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_framing.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_framing.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_framing.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_framing.c > CMakeFiles/rabbitmq-static.dir/amqp_framing.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_framing.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_framing.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_framing.c -o CMakeFiles/rabbitmq-static.dir/amqp_framing.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o: ../librabbitmq/amqp_mem.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_mem.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_mem.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_mem.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_mem.c > CMakeFiles/rabbitmq-static.dir/amqp_mem.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_mem.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_mem.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_mem.c -o CMakeFiles/rabbitmq-static.dir/amqp_mem.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o: ../librabbitmq/amqp_openssl.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_openssl.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_openssl.c > CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_openssl.c -o CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o: ../librabbitmq/amqp_openssl_bio.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_openssl_bio.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_openssl_bio.c > CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_openssl_bio.c -o CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o: ../librabbitmq/amqp_socket.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_socket.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_socket.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_socket.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_socket.c > CMakeFiles/rabbitmq-static.dir/amqp_socket.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_socket.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_socket.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_socket.c -o CMakeFiles/rabbitmq-static.dir/amqp_socket.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_table.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_table.c.o: ../librabbitmq/amqp_table.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_table.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_table.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_table.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_table.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_table.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_table.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_table.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_table.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_table.c > CMakeFiles/rabbitmq-static.dir/amqp_table.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_table.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_table.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_table.c -o CMakeFiles/rabbitmq-static.dir/amqp_table.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o: ../librabbitmq/amqp_tcp_socket.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_tcp_socket.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_tcp_socket.c > CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_tcp_socket.c -o CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_time.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_time.c.o: ../librabbitmq/amqp_time.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_time.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_11) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_time.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_time.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_time.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_time.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_time.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_time.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_time.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_time.c > CMakeFiles/rabbitmq-static.dir/amqp_time.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_time.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_time.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_time.c -o CMakeFiles/rabbitmq-static.dir/amqp_time.c.s

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_url.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/flags.make
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_url.c.o: ../librabbitmq/amqp_url.c
librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_url.c.o: librabbitmq/CMakeFiles/rabbitmq-static.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_12) "Building C object librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_url.c.o"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_url.c.o -MF CMakeFiles/rabbitmq-static.dir/amqp_url.c.o.d -o CMakeFiles/rabbitmq-static.dir/amqp_url.c.o -c /home/nvidia/rabbitmq-c/librabbitmq/amqp_url.c

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_url.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/rabbitmq-static.dir/amqp_url.c.i"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/nvidia/rabbitmq-c/librabbitmq/amqp_url.c > CMakeFiles/rabbitmq-static.dir/amqp_url.c.i

librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_url.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/rabbitmq-static.dir/amqp_url.c.s"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/nvidia/rabbitmq-c/librabbitmq/amqp_url.c -o CMakeFiles/rabbitmq-static.dir/amqp_url.c.s

# Object files for target rabbitmq-static
rabbitmq__static_OBJECTS = \
"CMakeFiles/rabbitmq-static.dir/amqp_api.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_table.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_time.c.o" \
"CMakeFiles/rabbitmq-static.dir/amqp_url.c.o"

# External object files for target rabbitmq-static
rabbitmq__static_EXTERNAL_OBJECTS =

librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_api.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_connection.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_consumer.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_framing.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_mem.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_openssl_bio.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_socket.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_table.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_tcp_socket.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_time.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/amqp_url.c.o
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/build.make
librabbitmq/librabbitmq.a: librabbitmq/CMakeFiles/rabbitmq-static.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/nvidia/rabbitmq-c/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_13) "Linking C static library librabbitmq.a"
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && $(CMAKE_COMMAND) -P CMakeFiles/rabbitmq-static.dir/cmake_clean_target.cmake
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/rabbitmq-static.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
librabbitmq/CMakeFiles/rabbitmq-static.dir/build: librabbitmq/librabbitmq.a
.PHONY : librabbitmq/CMakeFiles/rabbitmq-static.dir/build

librabbitmq/CMakeFiles/rabbitmq-static.dir/clean:
	cd /home/nvidia/rabbitmq-c/build/librabbitmq && $(CMAKE_COMMAND) -P CMakeFiles/rabbitmq-static.dir/cmake_clean.cmake
.PHONY : librabbitmq/CMakeFiles/rabbitmq-static.dir/clean

librabbitmq/CMakeFiles/rabbitmq-static.dir/depend:
	cd /home/nvidia/rabbitmq-c/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/nvidia/rabbitmq-c /home/nvidia/rabbitmq-c/librabbitmq /home/nvidia/rabbitmq-c/build /home/nvidia/rabbitmq-c/build/librabbitmq /home/nvidia/rabbitmq-c/build/librabbitmq/CMakeFiles/rabbitmq-static.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : librabbitmq/CMakeFiles/rabbitmq-static.dir/depend

