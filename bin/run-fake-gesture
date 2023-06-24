#!/bin/bash

# Check if roscore is already running
if ! pgrep -x "roscore" >/dev/null; then
  echo "roscore is not running. Starting roscore in the background..."
  roscore >/dev/null 2>&1 &
  sleep 2 # Wait for roscore to initialize (adjust sleep duration as needed)
  roscore_pid=$! # Store the PID of roscore
else
  echo "roscore is already running."
  roscore_pid="" # Clear the roscore_pid variable
fi

read -p "Press Enter to run the Fake Gesture..."

python3 ~/scheduler_ws/src/scheduler/scripts/fake_gesture.py

# Check if roscore was started by the script and if the PID is set
if [ -n "$roscore_pid" ]; then
  read -p "Press Enter to kill roscore..."

  echo "Killing roscore..."
  kill "$roscore_pid"
  echo "roscore killed."
fi
