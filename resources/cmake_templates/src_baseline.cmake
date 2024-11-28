add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp)

target_include_directories(${PROJECT_NAME}
                           PUBLIC ${${PROJECT_NAME}_PUBLIC_INCLUDE_DIR})
