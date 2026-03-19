#include "vambrace_hardware.hpp"

#include <Arduino.h>
#include "vambrace_config.hpp"

namespace
{
    uint32_t last_joy_ms = 0;

    // Maps a raw ADC value to a normalized float in [-1.0, 1.0].
    // Values within the deadzone around center are clamped to 0.
    float normalize(int raw)
    {
        int centered = raw - JOY_CENTER;
        if (abs(centered) < JOY_DEADZONE) return 0.0f;
        return (float)centered / (float)JOY_MAX;
    }

    MobileBaseVelocity read_joystick()
    {
        // VRy controls forward/backward linear velocity
        // VRx controls left/right angular velocity (negated: stick right = turn right = negative z)
        float linear_x  =  normalize(analogRead(JOY_Y_PIN)) * MAX_LINEAR_VEL;
        float angular_z = -normalize(analogRead(JOY_X_PIN)) * MAX_ANGULAR_VEL;

        return {linear_x, angular_z};
    }

} // namespace

void vambrace_hardware_init()
{
    pinMode(JOY_BTN_PIN, INPUT_PULLUP);
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
