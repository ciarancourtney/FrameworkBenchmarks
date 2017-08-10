cmake_minimum_required(VERSION 2.8.9)

# IncludeOS install location
if (NOT DEFINED ENV{INCLUDEOS_PREFIX})
  set(ENV{INCLUDEOS_PREFIX} /usr/local)
endif()
include($ENV{INCLUDEOS_PREFIX}/includeos/pre.service.cmake)

# Name of your project
project (mana_simple)

# Human-readable name of your service
set(SERVICE_NAME "Mana Simple Example")

# Name of your service binary
set(BINARY       "mana_simple")

# Maximum memory can be hard-coded into the binary
set(MAX_MEM 128)

# Source files to be linked with OS library parts to form bootable image
set(SOURCES
  service.cpp
  )


# DRIVERS / PLUGINS:

if ("$ENV{PLATFORM}" STREQUAL "x86_solo5")
  set(DRIVERS
      silent_start  # Less output during boot
      solo5net     # Virtio networking
    )
else()
  set(DRIVERS
      silent_start  # Less output during boot
      virtionet     # Virtio networking
    )
endif()


# THIRD PARTY LIBRARIES:

set(LIBRARIES
  "libmana.a"
  )


# include service build script
include($ENV{INCLUDEOS_PREFIX}/includeos/post.service.cmake)
