#!/bin/bash
# Source ROS 2 and your workspace
source /opt/ros/jazzy/setup.bash
source ~/husarion_ws/install/setup.bash

# Launch the Panther simulator in the background
ros2 launch husarion_ugv_gazebo simulation.launch.py &
SIM_PID=$!

# Give the simulator a few seconds to fully start
sleep 8

# Launch the Foxglove bridge in the background
ros2 launch foxglove_bridge foxglove_bridge_launch.xml 'address:="::"'&
BRIDGE_PID=$!

echo "Simulator PID: $SIM_PID"
echo "Foxglove Bridge PID: $BRIDGE_PID"
echo "Now open https://studio.foxglove.dev/ and connect to ws://localhost:8765"

wait
