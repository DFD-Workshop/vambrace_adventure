#pragma once

// Topics
#define TOPIC_CMD_VEL "/mobile_base_controller/cmd_vel"
#define TOPIC_LEFT_ARM "/simple_left_arm_controller/cmd"
#define TOPIC_RIGHT_ARM "/simple_right_arm_controller/cmd"
#define TOPIC_EMOTION "/emotion/int"
#define TOPIC_TTS "/orion_response"

// Status LED
#define LED_STATUS_PIN  23

// Joystick pins (ADC1 only — ADC2 conflicts with WiFi)
#define JOY_X_PIN       34    // VRx — ADC1_CH6, input-only
#define JOY_Y_PIN       35    // VRy — ADC1_CH7, input-only
#define JOY_BTN_PIN     32    // SW  — digital, INPUT_PULLUP

// Joystick parameters
#define JOY_DEADZONE    200           // raw ADC units around center
#define JOY_CENTER      2048          // center value for 12-bit ADC
#define JOY_MAX         2048          // max deviation from center (4095 - 2048 ≈ 2048 - 0)
#define MAX_LINEAR_VEL  2.0f          // m/s
#define MAX_ANGULAR_VEL 4.0f          // rad/s

// Update intervals (ms)
#define JOY_INTERVAL_MS 50            // 20 Hz