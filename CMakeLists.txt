cmake_minimum_required(VERSION 3.14)

project(Ruler LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

set(PROJECT_SOURCES
        src/main.cpp
        res/qml.qrc
)

add_executable(Ruler ${PROJECT_SOURCES})

target_compile_definitions(Ruler
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(Ruler
  PRIVATE Qt5::Core Qt5::Quick)
