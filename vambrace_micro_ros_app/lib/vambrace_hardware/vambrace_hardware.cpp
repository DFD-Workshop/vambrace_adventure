#include "vambrace_hardware.hpp"

#include <Arduino.h>
#include "vambrace_config.hpp"

// NOTE: Mutable file-scope state assumes single-threaded Arduino loop.
// If migrating to FreeRTOS tasks, protect with a mutex.
namespace
{
    uint32_t last_joy_ms     = 0;
    uint32_t last_pot_ms     = 0;
    uint32_t last_keypad_ms  = 0;
    uint32_t last_keypress_ms = 0;
    char     last_scanned_key = '\0';
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

    constexpr int POT_AVG_SAMPLES = 4;

    int read_pot_avg(int pin)
    {
        long sum = 0;
        for (int i = 0; i < POT_AVG_SAMPLES; i++) sum += analogRead(pin);
        return (int)(sum / POT_AVG_SAMPLES);
    }

    float map_pot_to_arm(int raw)
    {
        int clamped = constrain(raw, 0, POT_ADC_MAX);
        return ARM_LOWER_LIMIT + ((float)clamped / (float)POT_ADC_MAX) * (ARM_UPPER_LIMIT - ARM_LOWER_LIMIT);
    }

    const uint8_t KEYPAD_ROWS[4] = {KEYPAD_ROW0_PIN, KEYPAD_ROW1_PIN, KEYPAD_ROW2_PIN, KEYPAD_ROW3_PIN};
    const uint8_t KEYPAD_COLS[4] = {KEYPAD_COL0_PIN, KEYPAD_COL1_PIN, KEYPAD_COL2_PIN, KEYPAD_COL3_PIN};

    char scan_keypad()
    {
        for (int row = 0; row < 4; row++)
        {
            digitalWrite(KEYPAD_ROWS[row], LOW);
            for (int col = 0; col < 4; col++)
            {
                if (digitalRead(KEYPAD_COLS[col]) == LOW)
                {
                    digitalWrite(KEYPAD_ROWS[row], HIGH);
                    return KEYPAD_MAP[row][col];
                }
            }
            digitalWrite(KEYPAD_ROWS[row], HIGH);
        }
        return '\0';
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

    for (int i = 0; i < 4; i++)
    {
        pinMode(KEYPAD_ROWS[i], OUTPUT);
        digitalWrite(KEYPAD_ROWS[i], HIGH);
        pinMode(KEYPAD_COLS[i], INPUT_PULLUP);
    }

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

        // Left arm negated: ORION's left/right servos have opposite Z-axis orientation.
        // Negating ensures clockwise rotation on both pots raises the corresponding arm.
        cmd.setLeftArm({-map_pot_to_arm(read_pot_avg(POT_LEFT_ARM_PIN))});
        cmd.setRightArm({map_pot_to_arm(read_pot_avg(POT_RIGHT_ARM_PIN))});
    }

    if (now - last_keypad_ms >= KEYPAD_INTERVAL_MS)
    {
        last_keypad_ms = now;
        char key = scan_keypad();

        if (key != last_scanned_key)
        {
            last_scanned_key = key;
            if (key != '\0' && (now - last_keypress_ms) >= KEYPAD_DEBOUNCE_MS)
            {
                // Anti-ghosting: confirm the same key reads stable after 5ms.
                delayMicroseconds(5000);
                if (scan_keypad() == key)
                {
                    last_keypress_ms = now;
                    cmd.setKeypress(key);
                }
            }
        }
    }
}
