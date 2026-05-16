set(GrSdrBlocks_HDRS
    include/gnuradio-4.0/sdr/RTL2832Device.hpp
    include/gnuradio-4.0/sdr/RTL2832Source.hpp)

set(GrSdrBlocks_LIBS gnuradio4::gr-sdr)

add_library(gr-sdr INTERFACE ${GrSdrBlocks_HDRS})
add_library(gnuradio4::gr-sdr ALIAS gr-sdr)
target_include_directories(gr-sdr INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
                                            $<INSTALL_INTERFACE:include/>)
target_link_libraries(gr-sdr INTERFACE gnuradio4::gnuradio-core gnuradio4::gr-common gnuradio4::gnuradio-algorithm)
install(TARGETS gr-sdr EXPORT gnuradio4Targets)
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/gnuradio-4.0/sdr"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/gnuradio-4.0")

if(TARGET SoapySDR)
  list(
    APPEND
    GrSdrBlocks_HDRS
    include/gnuradio-4.0/sdr/SoapyRaiiWrapper.hpp
    include/gnuradio-4.0/sdr/SoapySource.hpp
    include/gnuradio-4.0/sdr/SoapySink.hpp)
  list(APPEND GrSdrBlocks_LIBS SoapySDR)

  target_link_libraries(gr-sdr INTERFACE SoapySDR)

  # loopback device: static library for tests + optional shared module for system-wide use
  add_library(gr-sdr-loopback-static STATIC src/SoapyLoopbackModule.cpp)
  target_link_libraries(gr-sdr-loopback-static PUBLIC gr-sdr SoapySDR)
  set_target_properties(gr-sdr-loopback-static PROPERTIES POSITION_INDEPENDENT_CODE ON)

  add_library(gr-sdr-loopback MODULE src/SoapyLoopbackModule.cpp)
  target_link_libraries(gr-sdr-loopback PRIVATE gr-sdr SoapySDR)
  set_target_properties(gr-sdr-loopback PROPERTIES PREFIX "") # SoapySDR expects no lib prefix
endif()

gr_add_block_library(
  GrSdrBlocks
  MAKE_SHARED_LIBRARY
  SPLIT_BLOCK_INSTANTIATIONS
  HEADERS
  ${GrSdrBlocks_HDRS}
  LINK_LIBRARIES
  ${GrSdrBlocks_LIBS})

if(TARGET gnuradio4::GrSdrBlocksShared AND ENABLE_TESTING)
  add_subdirectory(test)
endif()

if(ENABLE_EXAMPLES)
  add_subdirectory(src)
endif()
