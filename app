#!/bin/bash

arg=$1

function prepare_gschema {
    mkdir ~/.cache/temp_gschemas 2> /dev/null
    cp data/com.github.calo001.fondo.gschema.xml ~/.cache/temp_gschemas/
    glib-compile-schemas ~/.cache/temp_gschemas/
    export GSETTINGS_SCHEMA_DIR=~/.cache/temp_gschemas/
}

function clear_gschema {
    rm ~/.cache/temp_gschemas/* 2> /dev/null
}


function initialize {
    meson build --prefix=/usr
    result=$?

    if [ $result -gt 0 ]; then
        echo "Unable to initialize, please review log"
        exit 1
    fi

    cd build

    ninja

    result=$?

    if [ $result -gt 0 ]; then
        echo "Unable to build project, please review log"
        exit 2
    fi
}

function test {
    initialize

    export DISPLAY=:0
    ./com.github.calo001.fondo --run-tests
    result=$?

    export DISPLAY=":0.0"

    echo ""
    if [ $result -gt 0 ]; then
        echo "Failed testing"
        exit 100
    fi

    echo "Tests passed!"
}

case $1 in
"clean")
    clear_gschema
    sudo rm -rf ./build
    ;;
"generate-i18n")
    initialize
    ninja com.github.calo001.fondo-pot
    ninja com.github.calo001.fondo-update-po
    ;;
"install")
    initialize
    sudo ninja install
    ;;
"install-deps")
    checkdeps=$(which dpkg-checkbuilddeps)
    output=$(($checkdeps ) 2>&1)
    [ "$?" -eq "0" ] && echo "All dependencies are installed" && exit 0 ;
    packages=$(echo "$output" | sed 's/dpkg-checkbuilddeps: erro: Unmet build dependencies: //g')
    packages=$(echo "$packages" | sed -r -e 's/(\([>=<0-9. ]+\))+//g')
    command="sudo apt install $packages"
    $command
    ;;
"run")
    prepare_gschema
    initialize
    GOBJECT_DEBUG=instance-count ./com.github.calo001.fondo "${@:2}"
    ;;
"uninstall")
    initialize
    sudo ninja uninstall
    ;;
*)
    echo "Usage:"
    echo "  ./app [OPTION]"
    echo ""
    echo "Options:"
    echo "  clean             Removes build directories (can require sudo)"
    echo "  generate-i18n     Generates .pot and .po files for i18n (multi-language support)"
    echo "  install           Builds and installs application to the system (requires sudo)"
    echo "  install-deps      Installs missing build dependencies"
    echo "  run               Builds and runs the application"
    echo "  uninstall         Removes the application from the system (requires sudo)"
    ;;
esac
