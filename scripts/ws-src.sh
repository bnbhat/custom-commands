#!/bin/bash

usage() {
    echo "Usage: src-ws [1|2|3]"
    echo "  1 : source moveit_tutorial_ws"
    echo "  2 : source thesis_ws"
    echo "  3 : source moveit_ws"
}

if [ "$#" -ne 1 ]; then
    echo "Error: You must provide exactly one argument."
    usage
    exit 1
fi

case "$1" in
    1)
        echo "sourcing moveit_tutorial_ws ..."
        source ~/moveit_tutorial_ws/install/setup.bash
        echo "done!"
        ;;
    2)
        echo "sourcing thesis_ws ..."
        source ~/thesis_ws/install/setup.bash
        echo "done!"
        ;;
    3)
        echo "sourcing moveit_ws ..."
        source ~/moveit_ws/install/setup.bash
        echo "done!"
        ;;
    *)
        echo "Error: Invalid argument provided."
        usage
        exit 1
        ;;
esac
