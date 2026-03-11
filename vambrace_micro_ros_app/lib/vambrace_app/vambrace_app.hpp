#pragma once
#include <stdint.h>

struct MobileBaseVelocity
{
    float linear_x;
    float angular_z;
};

struct ArmPosition
{
    float position;
};

class TeleoperationCmd
{
public:
    void setMobileBaseVelocity(const MobileBaseVelocity& cmd);
    void setLeftArm(const ArmPosition& cmd);
    void setRightArm(const ArmPosition& cmd);
    void setEmotion(int32_t emotion_num);
    void sendSpeech(const char* txt);

    const MobileBaseVelocity& mobileBaseVelocity() const;
    const ArmPosition& leftArm() const;
    const ArmPosition& rightArm() const;
    int32_t emotion() const;
    const char* speech() const;

private:
    MobileBaseVelocity mobile_base_{};
    ArmPosition left_arm_{};
    ArmPosition right_arm_{};
    int32_t emotion_{0};
    char speech_[128]{};
};