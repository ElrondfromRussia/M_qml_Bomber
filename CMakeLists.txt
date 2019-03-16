cmake_minimum_required (VERSION 2.8.12)

project(My_Saper CXX)

#set(CMAKE_BUILD_WITH_INSTALL_RPATH  true)
#set(CMAKE_INSTALL_RPATH       ".")
set(CMAKE_INCLUDE_CURRENT_DIR     ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmakemodules")

include(GenerateExportHeader)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_GNUCC)
  message("GNUCXX or GNUCC compiler!")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -lgomp -g")
  # Предупреждения "return-type" & "deprecated-declarations" рассматриваются как ошибки.
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=return-type")

  CHECK_CXX_COMPILER_FLAG("-std=c++11" CXX11_SUPPORT)
  CHECK_CXX_COMPILER_FLAG("-std=c++0x" CXX0X_SUPPORT)

  if(CXX11_SUPPORT)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
  elseif(CXX0X_SUPPORT)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
  endif()
elseif (MSVC)
  message("MSVC compiler!")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W3 /MP /openmp /volatile:ms")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W3 /MP /openmp /volatile:ms")
else()
  message("Unknown compiler")
endif()

# <-- Отключение Q_ASSERT & qDebug() в Release
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_GNUCC)
  set(CMAKE_CXX_FLAGS_RELEASE "-DQT_NO_DEBUG -DQT_NO_DEBUG_OUTPUT ${CMAKE_CXX_FLAGS_RELEASE}")
elseif (MSVC)
  set(CMAKE_CXX_FLAGS_RELEASE "/DQT_NO_DEBUG /DQT_NO_DEBUG_OUTPUT ${CMAKE_CXX_FLAGS_RELEASE}")
endif()
# -->

option(${PROJECT_NAME}_BUILD_TEST "Enable testing" OFF)

add_subdirectory (src)

if(${PROJECT_NAME}_BUILD_TEST)
  enable_testing()
  add_subdirectory(tests)
endif()

