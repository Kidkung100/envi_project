import 'dart:html' as html;

void initFullscreenListener(Function(bool) onChange) {
  html.document.onFullscreenChange.listen((event) {
    final isFullscreen = html.document.fullscreenElement != null;
    onChange(isFullscreen);
  });
}

void toggleFullscreen(bool isFullscreen) {
  if (isFullscreen) {
    html.document.exitFullscreen();
  } else {
    html.document.documentElement?.requestFullscreen();
  }
}
