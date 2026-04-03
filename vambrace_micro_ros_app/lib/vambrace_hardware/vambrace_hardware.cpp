#include "vambrace_hardware.hpp"

#include <Arduino.h>
#include "vambrace_config.hpp"

// NOTE: Mutable file-scope state assumes single-threaded Arduino loop.
// If migrating to FreeRTOS tasks, protect with a mutex.
namespace
{
    uint32_t last_joy_ms = 0;
    uint32_t last_pot_ms = 0;
    int joy_center_x = JOY_CENTER;
    int joy_center_y = JOY_CENTER;

    constexpr int CALIBRATION_SAMPLES = 32;

    float normalize(int raw, int center)
    {
        int centered = raw - center;
        if (abs(centered) < JOY_DEADZONE) return 0.0f;

        int sign         = (centered > 0) ? 1 : -1;
        int adjusted     = abs(centered) - JOY_DEADZONE;
        int usable_range = JOY_MAX_DEVIATION - JOY_DEADZONE;
        return (float)sign * (float)adjusted / (float)usable_range;
    }

    int read_pot_avg(int pin)
    {
        long sum = 0;
        sum += analogRead(pin);
        sum += analogRead(pin);
        sum += analogRead(pin);
        sum += analogRead(pin);
        return (int)(sum >> 2);
    }

    float map_pot_to_arm(int raw)
    {
        return ARM_LOWER_LIMIT + ((float)raw / (float)POT_ADC_MAX) * (ARM_UPPER_LIMIT - ARM_LOWER_LIMIT);
    }

    MobileBaseVelocity read_joystick()
    {
        int raw_x = analogRead(JOY_X_PIN);
        int raw_y = analogRead(JOY_Y_PIN);

        bool sprinting = (digitalRead(JOY_BTN_PIN) == LOW);
        float max_lin = sprinting ? MAX_LINEAR_VEL_SPRINT : MAX_LINEAR_VEL;
        float max_ang = sprinting ? MAX_ANGULAR_VEL_SPRINT : MAX_ANGULAR_VEL;

        float linear_x  = -normalize(raw_y, joy_center_y) * max_lin;
        float angular_z = -normalize(raw_x, joy_center_x) * max_ang;

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

    if (abs(joy_center_x - 2048) > 500 || abs(joy_center_y - 2048) > 500)
    {
        Serial.println("WARNING: Joystick center far from expected. Was the stick touched during boot?");
        joy_center_x = JOY_CENTER;
        joy_center_y = JOY_CENTER;
    }

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

    if (now - last_pot_ms >= POT_INTERVAL_MS)
    {
        last_pot_ms = now;
        cmd.setLeftArm({-map_pot_to_arm(read_pot_avg(POT_LEFT_ARM_PIN))});
        cmd.setRightArm({map_pot_to_arm(read_pot_avg(POT_RIGHT_ARM_PIN))});
    }
}
