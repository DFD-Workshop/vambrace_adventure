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
#define MAX_LINEAR_VEL          0.75f
#define MAX_ANGULAR_VEL         0.75f
#define MAX_LINEAR_VEL_SPRINT   1.5f
#define MAX_ANGULAR_VEL_SPRINT  1.5f
#define JOY_SPRINT_GAIN         2.0f

// Potentiometer pins (ADC1 only — ADC2 conflicts with WiFi)
#define POT_LEFT_ARM_PIN    33
#define POT_RIGHT_ARM_PIN   36

// Arm position limits (radians)
#define ARM_LOWER_LIMIT    -1.0472f
#define ARM_UPPER_LIMIT     1.0472f
#define POT_ADC_MAX         4095

// 4x4 Membrane keypad pins
// Row pins (OUTPUT)
#define KEYPAD_ROW0_PIN     5
#define KEYPAD_ROW1_PIN    18
#define KEYPAD_ROW2_PIN    19
#define KEYPAD_ROW3_PIN    21
// Column pins (INPUT_PULLUP)
#define KEYPAD_COL0_PIN    17
#define KEYPAD_COL1_PIN    16
#define KEYPAD_COL2_PIN     4
#define KEYPAD_COL3_PIN     2

// Keypad parameters
#define KEYPAD_DEBOUNCE_MS  50    // minimum ms between valid keypresses
#define KEYPAD_INTERVAL_MS 100    // 10 Hz scan rate

// Update intervals (ms)
#define JOY_INTERVAL_MS 50
#define POT_INTERVAL_MS 50
