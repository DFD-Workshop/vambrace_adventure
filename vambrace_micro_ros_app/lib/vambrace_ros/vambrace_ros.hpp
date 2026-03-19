#pragma once
#include <stdint.h>
#include "vambrace_app.hpp"

void vambrace_micro_ros_connect_wifi();
void vambrace_micro_ros_init();
void vambrace_micro_ros_publish(TeleoperationCmd& commands);
void vambrace_micro_ros_spin(uint32_t timeout_ms);