file(GLOB QML_JS_FILES *.qml *.js *.qrc)

# Make the files visible on qtcreator
add_custom_target(antivirus_QMlFiles ALL SOURCES ${QML_JS_FILES})

# Substitute variables in the desktop file
configure_file(${DESKTOP_FILE_NAME}.in ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE_NAME}.in)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE_NAME} DESTINATION ${DESKTOP_DIR})
install(FILES ${QML_JS_FILES} DESTINATION ${ANTIVIRUS_DIR})
set(RESOURCES "pics.qrc")

# Make the autpilot files visible in qtcreator
file(GLOB_RECURSE AUTOPILOT_TEST_FILES *.py)
add_custom_target(antivirus_AutopilotFiles ALL SOURCES ${AUTOPILOT_TEST_FILES})

# Make the unit test files visible in qtcreator
file(GLOB_RECURSE UNIT_TEST_FILES tests/unit/*.qml)
add_custom_target(antivirus_UnitTestFiles ALL SOURCES ${UNIT_TEST_FILES})
