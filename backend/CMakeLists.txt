include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(
    Antivirusbackend_SRCS
    modules/Antivirus/backend.cpp
    modules/Antivirus/mytype.cpp
)

# Make the unit test files visible on qtcreator
add_custom_target(Antivirusbackend_UNITTEST_QML_FILES ALL SOURCES "tests/unit/tst_mytype.qml")

add_library(Antivirusbackend MODULE
    ${Antivirusbackend_SRCS}
)

set_target_properties(Antivirusbackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY Antivirus)

qt5_use_modules(Antivirusbackend Gui Qml Quick)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(Antivirusbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/Antivirus/qmldir ${CMAKE_CURRENT_BINARY_DIR}/Antivirus
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS Antivirusbackend DESTINATION ${QT_IMPORTS_DIR}/Antivirus/)
install(FILES   modules/Antivirus/qmldir DESTINATION ${QT_IMPORTS_DIR}/Antivirus/)
