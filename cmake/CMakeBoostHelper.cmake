# Original author: Ryan Pavlik <ryan@sensics.com> <ryan.pavlik@gmail.com
# Released with the same license as needed to integrate into CMake.
# Modified by Chadwick Boulay Jan 2018

# Help CMake find recent Boost MSVC binaries without manual configuration.
if(MSVC AND (NOT Boost_INCLUDE_DIR OR NOT Boost_LIBRARY_DIR))
    if(MSVC_VERSION EQUAL 1800)
        set(_vs_ver 12.0)
    elseif(MSVC_VERSION EQUAL 1900)
        set(_vs_ver 14.0)
    elseif(MSVC_VERSION GREATER 1910 AND MSVC_VERSION LESS 1919)
        set(_vs_ver 14.1)
    else()
        message(WARNING "You're using an untested Visual C++ compiler.")
    endif()
    if(CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 8)
        set(_libdir "lib64-msvc-${_vs_ver}")
    else()
        set(_libdir "lib32-msvc-${_vs_ver}")
    endif()

    set(_haslibs)
    if(EXISTS "c:/local")
        file(GLOB _possibilities "c:/local/boost*")
        list(REVERSE _possibilities)
        foreach(DIR ${_possibilities})
            if(EXISTS "${DIR}/${_libdir}")
                list(APPEND _haslibs "${DIR}")
            endif()
        endforeach()
        if(_haslibs)
            list(APPEND CMAKE_PREFIX_PATH ${_haslibs})
            find_package(Boost QUIET)
            if(Boost_FOUND AND NOT Boost_LIBRARY_DIR)
                set(BOOST_ROOT "${Boost_INCLUDE_DIR}" CACHE PATH "")
                set(BOOST_LIBRARYDIR "${Boost_INCLUDE_DIR}/${_libdir}" CACHE PATH "")
            endif()
        endif()
    endif()
endif()