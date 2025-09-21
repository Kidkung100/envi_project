// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// เรียกเมื่อมีการเปลี่ยนแปลง Fullscreen (เข้า/ออก)
void initFullscreenListener(Function(bool) onChange) {
  html.document.onFullscreenChange.listen((event) {
    final isFullscreen = html.document.fullscreenElement != null;
    onChange(isFullscreen);
  });
}

/// สลับ fullscreen
void toggleFullscreen(bool isFullscreen) {
  if (isFullscreen) {
    html.document.exitFullscreen();
  } else {
    html.document.documentElement?.requestFullscreen();
  }
}
