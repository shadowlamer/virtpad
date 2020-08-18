cmake_minimum_required(VERSION 3.16)
set(CMAKE_CXX_STANDARD 11)

set(TARGET uinputd)
set(TARGET_VERSION "0.0.3")

project(${TARGET})

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake_modules")

set(CMAKE_CXX_STANDARD_REQUIRED on)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror -std=gnu++11")

file(GLOB_RECURSE SOURCES RELATIVE ${CMAKE_SOURCE_DIR} "src/*.cpp")
add_executable( ${TARGET} ${SOURCES})

find_package (Threads REQUIRED)
find_package (Poco REQUIRED Net Util)

include_directories(src ${Poco_INCLUDE_DIRS})
target_link_libraries (${TARGET} ${CMAKE_THREAD_LIBS_INIT} ${Poco_LIBRARIES})

install(TARGETS ${TARGET} DESTINATION bin)
install(FILES ${CMAKE_SOURCE_DIR}/deb/${TARGET}.service DESTINATION /lib/systemd/system)
install(FILES ${CMAKE_SOURCE_DIR}/deb/90-${TARGET}-restart
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
        DESTINATION /etc/NetworkManager/dispatcher.d)

if (NOT DEFINED PACKAGE_ARCHITECTURE)
    execute_process (
            COMMAND dpkg --print-architecture
            OUTPUT_VARIABLE PACKAGE_ARCHITECTURE
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

set(CPACK_GENERATOR "DEB")
set(CPACK_PACKAGE_NAME "${TARGET}")
set(CPACK_PACKAGE_VERSION "${TARGET_VERSION}")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_${CPACK_PACKAGE_VERSION}_${PACKAGE_ARCHITECTURE}")
set(CPACK_DEBIAN_PACKAGE_SECTION "non-free")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Vadim Cherenev <sl@anhot.ru>")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION "Translates uinput messages via UDP broadcast")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libpocoutil62:${PACKAGE_ARCHITECTURE}, libpoconet62:${PACKAGE_ARCHITECTURE}")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "${PACKAGE_ARCHITECTURE}")
set(CPACK_PACKAGING_INSTALL_PREFIX "usr")

set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
        ${CMAKE_SOURCE_DIR}/deb/postinst
        ${CMAKE_SOURCE_DIR}/deb/prerm
        ${CMAKE_SOURCE_DIR}/deb/postrm)

include(CPack)