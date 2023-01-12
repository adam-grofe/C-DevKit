

# Define function to handle running clang-format 
# over all files
function(format target directory )
    find_program(CLANG-FORMAT_PATH clang-format REQUIRED)

    set(EXPRESSION h hpp hh c cc cxx cpp)
    list(TRANSFORM EXPRESSION PREPEND "${directory}/*.")

    file(GLOB_RECURSE SOURCE_FILES FOLLOW_SYMLINKS LIST_DIRECTORIES false ${EXPRESSION})

    add_custom_command(TARGET ${target} PRE_BUILD 
        COMMAND ${CLANG-FORMAT_PATH} -i --style=file:${CLANG_STYLE_PATH} ${SOURCE_FILES}
    )
endfunction()

# Set up cppcheck static analysis
find_program(CPPCHECK_PATH cppcheck REQUIRED)
set(CMAKE_CXX_CPPCHECK ${CPPCHECK_PATH})

# Define function to handle running flawfinder (security analysis)
# over all files
function(flawfinder target directory )
    find_program(FLAWFINDER_PATH flawfinder REQUIRED)

    set(EXPRESSION h hpp hh c cc cxx cpp)
    list(TRANSFORM EXPRESSION PREPEND "${directory}/*.")

    file(GLOB_RECURSE SOURCE_FILES FOLLOW_SYMLINKS LIST_DIRECTORIES false ${EXPRESSION})

    add_custom_command(TARGET ${target} PRE_BUILD 
        COMMAND ${FLAWFINDER_PATH} ${SOURCE_FILES}
    )
endfunction()


# Run all of the code quality analyses
function(run_code_quality_analysis target directory)
    format(${target} ${directory})
    flawfinder(${target} ${directory})
endfunction()

# Change Default CXX Flags for Debug
add_compile_options(-fsanitize=address -Wall -Wextra -Wpedantic)
add_link_options(-fsanitize=address -Wall -Wextra -Wpedantic)
