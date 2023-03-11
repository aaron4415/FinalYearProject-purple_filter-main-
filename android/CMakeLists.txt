cmake_minimum_required(VERSION 3.4.1)
set(OpenCV_STATIC ON)
set(OpenCV_DIR "./third_sdk/OpenCV-android-sdk/sdk/native/jni")
find_package(OpenCV REQUIRED)
add_library(convertImage SHARED ../ios/Classes/converter.cpp)
find_library(
        log-lib
        log)
target_link_libraries( 
        purple_filter  # 你的專案名稱
        ${OpenCV_LIBS}
        ${log-lib})