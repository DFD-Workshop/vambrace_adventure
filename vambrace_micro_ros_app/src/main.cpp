#include <Arduino.h>
#include "vambrace_ros.hpp"
#include "vambrace_app.hpp"

TeleoperationCmd vambrace_cmds;

void setup()
{
    orion_micro_ros_init();
}

void loop()
{
    orion_micro_ros_publish(vambrace_cmds);
    orion_micro_ros_spin(10);
    delay(20);
}
