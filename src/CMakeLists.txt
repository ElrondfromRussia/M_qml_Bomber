cmake_minimum_required(VERSION 2.8.12)
project(My_Saper)

find_package(Qt5Widgets REQUIRED)
find_package(Qt5Core REQUIRED)
find_package(Qt5Qml REQUIRED)


file(GLOB_RECURSE UI_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.ui*")
file(GLOB_RECURSE HEADER_FILES  "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
file(GLOB_RECURSE SOURCE_FILES  "${CMAKE_CURRENT_SOURCE_DIR}/*.c*")
file(GLOB QRC_FILE "${CMAKE_CURRENT_SOURCE_DIR}/*.qrc")
file(GLOB QML_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.qml")

qt5_add_resources(RESOURCE_FILES ${QRC_FILE})
qt5_wrap_ui(GUI_FILES ${UI_FILES})

add_executable(${PROJECT_NAME} WIN32 ${UI_FILES} ${HEADER_FILES} ${SOURCE_FILES} ${RESOURCE_FILES} ${QML_FILES} ${SRCS} myapp.rc)


target_link_libraries(${PROJECT_NAME}
PUBLIC
  Qt5::Widgets
  Qt5::Core
  Qt5::Qml
)

set_target_properties (${PROJECT_NAME} PROPERTIES
  AUTOMOC ON
  AUTOUIC ON
  AUTORCC ON
  FOLDER  "exe"
)


###################

