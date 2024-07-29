# Copyright 2016-2018 Proyectos y Sistemas de Mantenimiento SL (eProsima).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################
#
# CMake module for finding eProsima FastDDS.
#
# Output variables:
#
# - FastDDS_FOUND: flag indicating if the package was found
# - FastDDS_INCLUDE_DIR: Paths to the header files
#
# Example usage:
#
#   find_package(fastdds_cmake_module REQUIRED)
#   find_package(FastDDS MODULE)
#   # use FastDDS_* variables
#
###############################################################################

# lint_cmake: -convention/filename, -package/stdargs

set(FastDDS_FOUND FALSE)

find_package(fastcdr REQUIRED CONFIG)
find_package(fastdds REQUIRED CONFIG)

string(REGEX MATCH "^[0-9]+\\.[0-9]+" fastcdr_MAJOR_MINOR_VERSION "${fastcdr_VERSION}")
string(REGEX MATCH "^[0-9]+\\.[0-9]+" fastdds_MAJOR_MINOR_VERSION "${fastdds_VERSION}")

find_path(FastDDS_INCLUDE_DIR
  NAMES fastdds/
  HINTS "${fastdds_DIR}/../../../include")

find_library(FastCDR_LIBRARY_RELEASE
  NAMES fastcdr-${fastcdr_MAJOR_MINOR_VERSION} fastcdr
  HINTS "${fastcdr_DIR}/../..")

find_library(FastCDR_LIBRARY_DEBUG
  NAMES fastcdrd-${fastcdr_MAJOR_MINOR_VERSION}
  HINTS "${fastcdr_DIR}/../..")

if(FastCDR_LIBRARY_RELEASE AND FastCDR_LIBRARY_DEBUG)
  set(FastCDR_LIBRARIES
    optimized ${FastCDR_LIBRARY_RELEASE}
    debug ${FastCDR_LIBRARY_DEBUG}
  )
elseif(FastCDR_LIBRARY_RELEASE)
  set(FastCDR_LIBRARIES
    ${FastCDR_LIBRARY_RELEASE}
  )
elseif(FastCDR_LIBRARY_DEBUG)
  set(FastCDR_LIBRARIES
    ${FastCDR_LIBRARY_DEBUG}
  )
else()
  set(FastCDR_LIBRARIES "")
endif()

find_library(FastDDS_LIBRARY_RELEASE
  NAMES fastdds-${fastdds_MAJOR_MINOR_VERSION} fastdds
  HINTS "${fastdds_DIR}/../../../lib")

find_library(FastDDS_LIBRARY_DEBUG
  NAMES fastddsd-${fastdds_MAJOR_MINOR_VERSION}
  HINTS "${fastdds_DIR}/../../../lib")

if(FastDDS_LIBRARY_RELEASE AND FastDDS_LIBRARY_DEBUG)
  set(FastDDS_LIBRARIES
    optimized ${FastDDS_LIBRARY_RELEASE}
    debug ${FastDDS_LIBRARY_DEBUG}
    ${FastCDR_LIBRARIES}
  )
elseif(FastDDS_LIBRARY_RELEASE)
  set(FastDDS_LIBRARIES
    ${FastDDS_LIBRARY_RELEASE}
    ${FastCDR_LIBRARIES}
  )
elseif(FastDDS_LIBRARY_DEBUG)
  set(FastDDS_LIBRARIES
    ${FastDDS_LIBRARY_DEBUG}
    ${FastCDR_LIBRARIES}
  )
else()
  set(FastDDS_LIBRARIES "")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FastDDS
  FOUND_VAR FastDDS_FOUND
  REQUIRED_VARS
    FastDDS_INCLUDE_DIR
    FastDDS_LIBRARIES
)
