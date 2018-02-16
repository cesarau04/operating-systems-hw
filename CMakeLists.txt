cmake_minimum_required(VERSION 3.9)
project(operating_systems_hw)

set(CMAKE_CXX_STANDARD 11)

add_executable(operating_systems_hw
        01/hello.c
        02/echo_file.c
        02/echo_file_sys_call.c
        03/homework3.sh
        03/instructions.txt
        04/instructions.txt
        LICENSE
        README.md)
