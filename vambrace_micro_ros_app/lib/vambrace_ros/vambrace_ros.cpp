#include "vambrace_ros.hpp"

#include <Arduino.h>
#include <micro_ros_platformio.h>
#include <WiFi.h>

#include <rcl/rcl.h>
#include <rclc/rclc.h>
#include <rclc/executor.h>

#include <geometry_msgs/msg/twist_stamped.h>
#include <std_msgs/msg/float64_multi_array.h>
#include <std_msgs/msg/int32.h>
#include <std_msgs/msg/string.h>

#include "vambrace_config.hpp"
#include "vambrace_secret.hpp"

namespace
{
    rcl_node_t node;
    rclc_support_t support;
    rcl_allocator_t allocator;
    rclc_executor_t executor;

    rcl_publisher_t pub_cmd_vel;
    rcl_publisher_t pub_left_arm;
    rcl_publisher_t pub_right_arm;
    rcl_publisher_t pub_emotion;
    rcl_publisher_t pub_tts;

    geometry_msgs__msg__TwistStamped msg_cmd_vel;
    std_msgs__msg__Float64MultiArray msg_left_arm;
    std_msgs__msg__Float64MultiArray msg_right_arm;
    std_msgs__msg__Int32 msg_emotion;
    std_msgs__msg__String msg_tts;

    double left_arm_buffer[1];
    double right_arm_buffer[1];

    // If planning to use WiFi transport
    IPAddress agent_ip AGENT_IP_ADDRESS;
    size_t agent_port = AGENT_PORT;

    void error_loop()
    {
        while(true)
        {
            delay(100);
        }
    }

    #define RCCHECK(fn) { rcl_ret_t temp_rc = fn; if((temp_rc != RCL_RET_OK)){error_loop();}}
    #define RCSOFTCHECK(fn) { rcl_ret_t temp_rc = fn; if((temp_rc != RCL_RET_OK)){}}

} // namespace

void orion_micro_ros_connect_wifi()
{
  WiFi.begin(WIFI_SSID, WIFI_PASS);

  uint32_t start = millis();
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    if (millis() - start > 10000) {
      Serial.println("WiFi connection timeout");
      return;
    }
  }

  Serial.print("Connected. IP: ");
  Serial.println(WiFi.localIP());
}

void orion_micro_ros_init()
{
    Serial.begin(115200);
    Serial.println("Vambrace ESP32 started!");
    
    // For WiFi transport
    orion_micro_ros_connect_wifi();
    set_microros_wifi_transports(WIFI_SSID, WIFI_PASS, agent_ip, agent_port);

    // For serial transport:
    // set_microros_serial_transports(Serial);
    
    delay(2000);

    allocator = rcl_get_default_allocator();
    RCCHECK(rclc_support_init(&support, 0, nullptr, &allocator));

    RCCHECK(rclc_node_init_default(&node, "orion_vambrace_node", "", &support));

    RCCHECK(rclc_publisher_init_default(
        &pub_cmd_vel,
        &node,
        ROSIDL_GET_MSG_TYPE_SUPPORT(geometry_msgs, msg, TwistStamped),
        TOPIC_CMD_VEL
    ));

    RCCHECK(rclc_publisher_init_default(
        &pub_left_arm,
        &node,
        ROSIDL_GET_MSG_TYPE_SUPPORT(std_msgs, msg, Float64MultiArray),
        TOPIC_LEFT_ARM
    ));

    RCCHECK(rclc_publisher_init_default(
        &pub_right_arm,
        &node,
        ROSIDL_GET_MSG_TYPE_SUPPORT(std_msgs, msg, Float64MultiArray),
        TOPIC_RIGHT_ARM
    ));

    RCCHECK(rclc_publisher_init_default(
        &pub_emotion,
        &node,
        ROSIDL_GET_MSG_TYPE_SUPPORT(std_msgs, msg, Int32),
        TOPIC_EMOTION
    ));

    RCCHECK(rclc_publisher_init_default(
        &pub_tts,
        &node,
        ROSIDL_GET_MSG_TYPE_SUPPORT(std_msgs, msg, String),
        TOPIC_TTS
    ));

    msg_left_arm.data.data = left_arm_buffer;
    msg_left_arm.data.size = 1;
    msg_left_arm.data.capacity = 1;

    msg_right_arm.data.data = right_arm_buffer;
    msg_right_arm.data.size = 1;
    msg_right_arm.data.capacity = 1;

    RCCHECK(rclc_executor_init(&executor, &support.context, 0, &allocator));

} // orion_micro_ros_init()

void orion_micro_ros_publish(const TeleoperationCmd& cmd)
{
    msg_cmd_vel.twist.linear.x = cmd.mobileBaseVelocity().linear_x;
    msg_cmd_vel.twist.angular.z = cmd.mobileBaseVelocity().angular_z;
    RCSOFTCHECK(rcl_publish(&pub_cmd_vel, &msg_cmd_vel, nullptr));

    left_arm_buffer[0] = cmd.leftArm().position;
    RCSOFTCHECK(rcl_publish(&pub_left_arm, &msg_left_arm, nullptr));

    right_arm_buffer[0] = cmd.rightArm().position;
    RCSOFTCHECK(rcl_publish(&pub_right_arm, &msg_right_arm, nullptr));

    if(cmd.speech() != nullptr)
    {
        msg_tts.data.data = const_cast<char*>(cmd.speech());
        msg_tts.data.size = strlen(cmd.speech());
        msg_tts.data.capacity = msg_tts.data.size + 1;
        RCSOFTCHECK(rcl_publish(&pub_tts, &msg_tts, nullptr));
    }
} // orion_micro_ros_publish()

void orion_micro_ros_spin(uint32_t timeout_ms)
{
    RCSOFTCHECK(rclc_executor_spin_some(&executor, RCL_MS_TO_NS(timeout_ms)));
}