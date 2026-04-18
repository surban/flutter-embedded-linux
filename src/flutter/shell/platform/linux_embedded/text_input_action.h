// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_SHELL_PLATFORM_LINUX_EMBEDDED_TEXT_INPUT_ACTION_H_
#define FLUTTER_SHELL_PLATFORM_LINUX_EMBEDDED_TEXT_INPUT_ACTION_H_

#include <cstdint>

namespace flutter {

// Flutter TextInputAction values encoded in bits 10-13 of the Wayland
// content_hint bitmask. These bits are unused by the standard
// zwp_text_input_v1/v3 protocols.
//
// To extract from a content_hint value:
//   uint32_t action = (hint & kTextInputActionMask) >> kTextInputActionShift;

constexpr uint32_t kTextInputActionShift = 10;
constexpr uint32_t kTextInputActionMask = 0xF << kTextInputActionShift;  // 0x3C00

constexpr uint32_t kTextInputActionNone           =  0 << kTextInputActionShift;
constexpr uint32_t kTextInputActionUnspecified     =  1 << kTextInputActionShift;
constexpr uint32_t kTextInputActionDone            =  2 << kTextInputActionShift;
constexpr uint32_t kTextInputActionGo              =  3 << kTextInputActionShift;
constexpr uint32_t kTextInputActionSearch          =  4 << kTextInputActionShift;
constexpr uint32_t kTextInputActionSend            =  5 << kTextInputActionShift;
constexpr uint32_t kTextInputActionNext            =  6 << kTextInputActionShift;
constexpr uint32_t kTextInputActionPrevious        =  7 << kTextInputActionShift;
constexpr uint32_t kTextInputActionContinue        =  8 << kTextInputActionShift;
constexpr uint32_t kTextInputActionJoin            =  9 << kTextInputActionShift;
constexpr uint32_t kTextInputActionRoute           = 10 << kTextInputActionShift;
constexpr uint32_t kTextInputActionEmergencyCall   = 11 << kTextInputActionShift;
constexpr uint32_t kTextInputActionNewline         = 12 << kTextInputActionShift;

}  // namespace flutter

#endif  // FLUTTER_SHELL_PLATFORM_LINUX_EMBEDDED_TEXT_INPUT_ACTION_H_
