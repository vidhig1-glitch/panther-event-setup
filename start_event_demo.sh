#!/bin/bash
source /opt/ros/jazzy/setup.bash
source ~/husarion_ws/install/setup.bash

# Launch the Panther simulator in the background
ros2 launch husarion_ugv_gazebo simulation.launch.py &
SIM_PID=$!

sleep 8

# Launch the Foxglove bridge in the background
ros2 launch foxglove_bridge foxglove_bridge_launch.xml &
BRIDGE_PID=$!

sleep 3

# Release E-stop automatically so the rover is drivable by default
ros2 service call /hardware/e_stop_reset std_srvs/srv/Trigger {}

# Launch twist_stamper to convert plain Twist -> TwistStamped for manual control
ros2 run twist_stamper twist_stamper --ros-args -r cmd_vel_in:=/teleop_cmd_vel -r cmd_vel_out:=/manual/cmd_vel -p use_sim_time:=true &
STAMPER_PID=$!

echo "Simulator PID: $SIM_PID"
echo "Foxglove Bridge PID: $BRIDGE_PID"
echo "Twist Stamper PID: $STAMPER_PID"
echo "E-stop released, ready for teleop"
echo "Connect Foxglove to ws://localhost:8765 (or your Tailscale IP)"
echo "In Teleop panel, set topic to /teleop_cmd_vel"

wait
