#!/bin/bash

echo "Press enter to start MoveIt"
read

ros2 launch ur_moveit_config ur_moveit.launch.py ur_type:=ur5e launch_rviz:=true
