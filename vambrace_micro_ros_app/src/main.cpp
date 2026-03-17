#include <Arduino.h>
#include "vambrace_ros.hpp"
#include "vambrace_app.hpp"

TeleoperationCmd vambrace_cmds;

void setup()
{
    vambrace_micro_ros_init();
    Serial.print("Free heap before executor: ");
    Serial.println(esp_get_free_heap_size());
}

void loop()
{
    vambrace_micro_ros_publish(vambrace_cmds);
    vambrace_micro_ros_spin(10);
    delay(20);
}
