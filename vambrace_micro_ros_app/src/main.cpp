#include <Arduino.h>
#include "vambrace_ros.hpp"
#include "vambrace_app.hpp"
#include "vambrace_hardware.hpp"

TeleoperationCmd vambrace_cmds;

void setup()
{
    vambrace_micro_ros_init();
    vambrace_hardware_init();
}

void loop()
{
    vambrace_hardware_update(vambrace_cmds);
    vambrace_micro_ros_publish(vambrace_cmds);
    vambrace_micro_ros_spin(10);
    delay(20);
}
