#pragma once

// Topics
#define TOPIC_CMD_VEL "/mobile_base_controller/cmd_vel"
#define TOPIC_LEFT_ARM "/simple_left_arm_controller/commands"
#define TOPIC_RIGHT_ARM "/simple_right_arm_controller/commands"
#define TOPIC_EMOTION "/emotion/int"
#define TOPIC_TTS "/orion_response"

// Status LED
#define LED_STATUS_PIN  23

// Joystick pins
#define JOY_X_PIN       34
#define JOY_Y_PIN       35
#define JOY_BTN_PIN     32

// Joystick parameters
#define JOY_DEADZONE    200
#define JOY_CENTER      2048
#define JOY_MAX_DEVIATION         2048
#define MAX_LINEAR_VEL          0.75f          // m/s — normal mode
#define MAX_ANGULAR_VEL         0.75f          // rad/s — normal mode
#define MAX_LINEAR_VEL_SPRINT   1.5f           // m/s — sprint cap
#define MAX_ANGULAR_VEL_SPRINT  1.5f           // rad/s — sprint cap
#define JOY_SPRINT_GAIN         2.0f           // speed multiplier when button pressed

// Potentiometer pins (ADC1 only — ADC2 conflicts with WiFi)
#define POT_LEFT_ARM_PIN    33    // ADC1_CH5
#define POT_RIGHT_ARM_PIN   36    // ADC1_CH0, input-only

// Arm position limits (radians)
#define ARM_LOWER_LIMIT    -1.0472f          // -pi/3
#define ARM_UPPER_LIMIT     1.0472f          //  pi/3
#define POT_ADC_MAX         4095             // 12-bit ADC

// Update intervals (ms)
#define JOY_INTERVAL_MS 50
#define POT_INTERVAL_MS 50
