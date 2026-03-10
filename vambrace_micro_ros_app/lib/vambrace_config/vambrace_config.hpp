#pragma once

#define TOPIC_CMD_VEL "/mobile_base_controller/cmd_vel"
#define TOPIC_LEFT_ARM "/simple_left_arm_controller/cmd"
#define TOPIC_RIGHT_ARM "/simple_right_arm_controller/cmd"
#define TOPIC_EMOTION "/emotion/int"
#define TOPIC_TTS "/orion_response"

// Status LED — used for error indication (move to pins.h when created)
#define LED_STATUS_PIN  23