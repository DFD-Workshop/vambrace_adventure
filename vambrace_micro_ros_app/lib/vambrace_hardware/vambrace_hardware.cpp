#include "vambrace_hardware.hpp"

#include <Arduino.h>
#include "vambrace_config.hpp"

namespace
{
    uint32_t last_joy_ms = 0;
    int joy_center_x = JOY_CENTER;
    int joy_center_y = JOY_CENTER;

    constexpr int CALIBRATION_SAMPLES = 32;

    // Maps a raw ADC value to a normalized float in [-1.0, 1.0].
    // Values within the deadzone around center are clamped to 0.
    float normalize(int raw, int center)
    {
        int centered = raw - center;
        if (abs(centered) < JOY_DEADZONE) return 0.0f;

        int sign         = (centered > 0) ? 1 : -1;
        int adjusted     = abs(centered) - JOY_DEADZONE;
        int usable_range = JOY_MAX - JOY_DEADZONE;
        return sign * (float)adjusted / (float)usable_range;
    }

    MobileBaseVelocity read_joystick()
    {
        int raw_x = analogRead(JOY_X_PIN);
        int raw_y = analogRead(JOY_Y_PIN);

        // DEBUG: raw ADC values and calibrated centers
        Serial.print("RAW x=");
        Serial.print(raw_x);
        Serial.print(" y=");
        Serial.print(raw_y);
        Serial.print(" | CENTER x=");
        Serial.print(joy_center_x);
        Serial.print(" y=");
        Serial.println(joy_center_y);

        // Sprint: press joystick button to go faster
        float gain = (digitalRead(JOY_BTN_PIN) == LOW) ? JOY_SPRINT_GAIN : 1.0f;

        // VRy controls forward/backward linear velocity
        // VRx controls left/right angular velocity (negated: stick right = turn right = negative z)
        float linear_x  =  normalize(raw_y, joy_center_y) * MAX_LINEAR_VEL * gain;
        float angular_z = -normalize(raw_x, joy_center_x) * MAX_ANGULAR_VEL * gain;

        return {linear_x, angular_z};
    }

} // namespace

void vambrace_hardware_init()
{
    pinMode(JOY_BTN_PIN, INPUT_PULLUP);

    long sum_x = 0;
    long sum_y = 0;
    for (int i = 0; i < CALIBRATION_SAMPLES; i++)
    {
        sum_x += analogRead(JOY_X_PIN);
        sum_y += analogRead(JOY_Y_PIN);
        delay(5);
    }
    joy_center_x = sum_x / CALIBRATION_SAMPLES;
    joy_center_y = sum_y / CALIBRATION_SAMPLES;

    Serial.print("Joystick calibrated: center_x=");
    Serial.print(joy_center_x);
    Serial.print(", center_y=");
    Serial.println(joy_center_y);

    Serial.println("Hardware initialized.");
}

void vambrace_hardware_update(TeleoperationCmd& cmd)
{
    uint32_t now = millis();
    if (now - last_joy_ms >= JOY_INTERVAL_MS)
    {
        last_joy_ms = now;
        cmd.setMobileBaseVelocity(read_joystick());
    }
}
