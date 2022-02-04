set(include "")
set(headers "")
set(sources main.cpp)

set(LOLPXL_INCLUDE_DIR ${include} PARENT_SCOPE)
set(LOLPXL_HEADERS ${headers} PARENT_SCOPE)
set(LOLPXL_SOURCES ${sources} PARENT_SCOPE)

add_executable(lolpxl ${headers} ${sources})
