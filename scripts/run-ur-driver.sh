#!/bin/bash

echo "Press enter to start UR driver"
read

ros2 launch ur_robot_driver ur5e.launch.py robot_ip:=192.168.56.101 launch_rviz:=false
