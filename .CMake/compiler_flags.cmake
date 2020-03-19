if(CMAKE_C_COMPILER_ID MATCHES "Clang")
    add_compile_options(-Werror)
    add_compile_options(-Wall)
    add_compile_options(-Wextra)
    add_compile_options(-Wpedantic)
    #add_compile_options(-Wbad-function-cast)
    add_compile_options(-fvisibility=hidden)
    add_compile_options(-fPIC)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        add_compile_options(-g3)
        add_compile_options(-fno-omit-frame-pointer)
        if(USE_SANITIZER STREQUAL "Address")
            add_compile_options(-fno-optimize-sibling-calls)
            add_compile_options(-fsanitize-address-use-after-scope)
            add_compile_options(-fsanitize=address)
        elseif(USE_SANITIZER STREQUAL "Memory")
            add_compile_options(-fsanitize=memory)
        elseif(USE_SANITIZER STREQUAL "MemoryWithOrigins")
            add_compile_options(-fsanitize=memory)
            add_compile_options(-fsanitize-memory-track-origins)
        elseif(USE_SANITIZER STREQUAL "Undefined")
            add_compile_options(-fsanitize=undefined)
            if(EXISTS "${BLACKLIST_FILE}")
                add_compile_options(-fsanitize-blacklist=${BLACKLIST_FILE})
            endif()
        elseif(USE_SANITIZER STREQUAL "Thread")
            add_compile_options(-fsanitize=thread)
        elseif(USE_SANITIZER STREQUAL "Leak")
            add_compile_options(-fsanitize=leak)
        endif()
    elseif(CMAKE_BUILD_TYPE STREQUAL "Optimized")
        add_compile_options(-O3)
        add_compile_options(-march=native)
        add_compile_options(-fomit-frame-pointer)
    else() #Build type = Generic/Dependency
        add_compile_options(-O3)
        add_compile_options(-fomit-frame-pointer)
    endif()

elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-Werror)
    add_compile_options(-Wall)
    add_compile_options(-Wextra)
    add_compile_options(-Wpedantic)
    add_compile_options(-Wstrict-prototypes)
    add_compile_options(-Wshadow)
    add_compile_options(-Wformat=2)
    add_compile_options(-Wfloat-equal)
    add_compile_options(-Wwrite-strings)
    add_compile_options(-fvisibility=hidden)
    add_compile_options(-fPIC)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        add_compile_options (-Wstrict-overflow=4)
        add_compile_options(-ggdb3)
    elseif(CMAKE_BUILD_TYPE STREQUAL "Optimized")
        add_compile_options(-O3)
        add_compile_options(-march=native)
        add_compile_options(-fomit-frame-pointer)
        add_compile_options(-fdata-sections)
        add_compile_options(-ffunction-sections)
        if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
            add_compile_options(-Wl,-dead_strip)
        else ()
            add_compile_options(-Wl,--gc-sections)
        endif ()
    else() #Build type = Generic/Dependency
        add_compile_options(-O3)
        add_compile_options(-fomit-frame-pointer)
        add_compile_options(-fdata-sections)
        add_compile_options(-ffunction-sections)
        if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
            add_compile_options(-Wl,-dead_strip)
        else ()
            add_compile_options(-Wl,--gc-sections)
        endif ()
    endif()

elseif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    # Warning C4146 is raised when a unary minus operator is applied to an
    # unsigned type; this has nonetheless been standard and portable for as
    # long as there has been a C standard, and we need it for constant-time
    # computations. Thus, we disable that spurious warning.
    add_compile_options(/wd4146)
    # Need a larger stack for Classic McEliece
    add_link_options(/STACK:8192000)
endif()

if(MINGW OR MSYS OR CYGWIN)
    add_compile_options(-Wno-maybe-uninitialized)
    add_link_options(-Wl,--stack,16777216)
endif()
