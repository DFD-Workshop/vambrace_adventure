#include "vambrace_app.hpp"

void TeleoperationCmd::setMobileBaseVelocity(const MobileBaseVelocity& cmd)
{
    mobile_base_ = cmd;
}

void TeleoperationCmd::setLeftArm(const ArmPosition& cmd)
{
    left_arm_ = cmd;
}

void TeleoperationCmd::setRightArm(const ArmPosition& cmd)
{
    right_arm_ = cmd;
}

void TeleoperationCmd::setEmotion(int32_t emotion_num)
{
    emotion_ = emotion_num;
}

void TeleoperationCmd::sendSpeech(const char* txt)
{
    speech_= txt;
}

const MobileBaseVelocity& TeleoperationCmd::mobileBaseVelocity() const { return mobile_base_; }

const ArmPosition& TeleoperationCmd::leftArm() const { return left_arm_; }

const ArmPosition& TeleoperationCmd::rightArm() const { return right_arm_; }

int32_t TeleoperationCmd::emotion() const { return emotion_; }

const char* TeleoperationCmd::speech() const { return speech_; }
