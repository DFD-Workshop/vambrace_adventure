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
// Row pins (OUTPUT) — module pins 1–4
#define KEYPAD_ROW0_PIN    21     // module pin 1 → membrane row 0 (1 2 3 A)
#define KEYPAD_ROW1_PIN    19     // module pin 2 → membrane row 1 (4 5 6 B)
#define KEYPAD_ROW2_PIN    18     // module pin 3 → membrane row 2 (7 8 9 C)
#define KEYPAD_ROW3_PIN     5     // module pin 4 → membrane row 3 (* 0 # D)
// Column pins (INPUT_PULLUP) — module pins 5–8
#define KEYPAD_COL0_PIN    13     // module pin 5 → membrane col 0 (1 4 7 *)
#define KEYPAD_COL1_PIN    14     // module pin 6 → membrane col 1 (2 5 8 0)
#define KEYPAD_COL2_PIN    25     // module pin 7 → membrane col 2 (3 6 9 #)
#define KEYPAD_COL3_PIN    26     // module pin 8 → membrane col 3 (A B C D)

// Keypad parameters
#define KEYPAD_DEBOUNCE_MS  50    // minimum ms between valid keypresses
#define KEYPAD_INTERVAL_MS 100    // 10 Hz scan rate

// Toggle buttons (INPUT_PULLUP)
#define BTN_CMD_VEL_PIN     16    // Toggle cmd_vel publishing
#define BTN_LEFT_ARM_PIN    17    // Toggle left arm publishing
#define BTN_RIGHT_ARM_PIN   22    // Toggle right arm publishing
#define BTN_KEYPAD_PIN      23    // Toggle keypad publishing

// LEDs (OUTPUT)
#define LED_CMD_VEL_PIN      0    // ON = cmd_vel active  (brief flicker at boot)
#define LED_LEFT_ARM_PIN    12    // ON = left arm active
#define LED_RIGHT_ARM_PIN   27    // ON = right arm active
#define LED_KEYPAD_PIN      15    // ON = keypad active

// Update intervals (ms)
#define JOY_INTERVAL_MS 50
#define POT_INTERVAL_MS 50
