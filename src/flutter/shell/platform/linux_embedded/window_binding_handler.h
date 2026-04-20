// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_SHELL_PLATFORM_LINUX_EMBEDDED_WINDOW_BINDING_HANDLER_H_
#define FLUTTER_SHELL_PLATFORM_LINUX_EMBEDDED_WINDOW_BINDING_HANDLER_H_

#include <string>
#include <variant>

#include "flutter/shell/platform/linux_embedded/public/flutter_elinux.h"
#include "flutter/shell/platform/linux_embedded/surface/surface_gl.h"
#include "flutter/shell/platform/linux_embedded/window_binding_handler_delegate.h"

namespace flutter {

class FlutterWindowsView;

// Structure containing physical bounds of a Window
struct PhysicalWindowBounds {
  size_t width;
  size_t height;
};

// Structure containing text input type information from Flutter.
struct TextInputTypeInfo {
  std::string input_type;           // e.g. "TextInputType.text"
  std::string input_action;         // e.g. "TextInputAction.done"
  bool obscure_text = false;
  bool autocorrect = true;
  bool enable_suggestions = true;
  std::string text_capitalization;  // e.g. "TextCapitalization.sentences"
  std::string preferred_language;   // BCP 47 tag, e.g. "de-DE"
};

using ELinuxRenderSurfaceTarget = SurfaceGl;

// Abstract class for binding Linux embedded platform windows to Flutter views.
class WindowBindingHandler {
 public:
  virtual ~WindowBindingHandler() = default;

  // Dispatches window events such as mouse and keyboard inputs. For Wayland,
  // you have to call this every time in the main loop.
  virtual bool DispatchEvent() = 0;

  // Create a surface.
  // @param[in] width_px         Physical width of the surface.
  // @param[in] height_px        Physical height of the surface.
  // @param[in] enable_impeller  Enable impeller.
  virtual bool CreateRenderSurface(int32_t width_px,
                                   int32_t height_px,
                                   bool enable_impeller) = 0;

  // Destroy a surface which is currently used.
  virtual void DestroyRenderSurface() = 0;

  // Returns a valid ELinuxRenderSurfaceTarget representing the backing
  // window.
  virtual ELinuxRenderSurfaceTarget* GetRenderSurfaceTarget() const = 0;

  // Sets the delegate used to communicate state changes from window to view
  // such as key presses, mouse position updates etc.
  virtual void SetView(WindowBindingHandlerDelegate* view) = 0;

  // Returns the rotation(degree) for the backing window.
  virtual uint16_t GetRotationDegree() const = 0;

  // Returns the scale factor for the backing window.
  virtual double GetDpiScale() = 0;

  // Returns the bounds of the backing window in physical pixels.
  virtual PhysicalWindowBounds GetPhysicalWindowBounds() = 0;

  // Returns the frame rate of the display.
  virtual int32_t GetFrameRate() = 0;

  // Sets the cursor that should be used when the mouse is over the Flutter
  // content. See mouse_cursor.dart for the values and meanings of cursor_name.
  virtual void UpdateFlutterCursor(const std::string& cursor_name) = 0;

  // Sets the virtual keyboard status when the virtual keyboard needs to be
  // shown by Flutter events.
  virtual void UpdateVirtualKeyboardStatus(
      const bool show,
      const TextInputTypeInfo& input_type_info = TextInputTypeInfo()) = 0;

  // Sets the height (in physical pixels) that the on-screen keyboard
  // occupies at the bottom of the window when visible.
  virtual void SetVirtualKeyboardBottomInset(int32_t height_physical_px) {}

  // Called whenever the active text field's contents or selection change,
  // so the backend can forward them to the platform IME.
  //
  // |text_utf8|          - Full UTF-8 text of the field. Empty when there is
  //                        no active client.
  // |cursor_byte_offset| - Cursor position as a byte offset into |text_utf8|.
  // |anchor_byte_offset| - Selection anchor as a byte offset into |text_utf8|
  //                        (equal to cursor offset for collapsed selections).
  virtual void UpdateTextInputState(const std::string& text_utf8,
                                    int32_t cursor_byte_offset,
                                    int32_t anchor_byte_offset) {}

  // Returns the clipboard data.
  virtual std::string GetClipboardData() = 0;

  // Sets the clipboard data.
  virtual void SetClipboardData(const std::string& data) = 0;
};

}  // namespace flutter

#endif  // FLUTTER_SHELL_PLATFORM_LINUX_EMBEDDED_WINDOW_BINDING_HANDLER_H_
