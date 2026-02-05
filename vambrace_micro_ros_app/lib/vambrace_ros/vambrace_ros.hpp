#pragma once
#include <stdint.h>
#include "vambrace_app.hpp"

void orion_micro_ros_connect_wifi();
void orion_micro_ros_init();
void orion_micro_ros_publish(const TeleoperationCmd& commands);
void orion_micro_ros_spin(uint32_t timeout_ms);