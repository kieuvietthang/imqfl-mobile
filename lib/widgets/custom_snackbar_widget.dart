import 'package:flutter/material.dart';

enum AppSnackType { success, error, warning, info }
enum AppSnackPosition { top, bottom }

class AppSnackbar {
  AppSnackbar._();

  /// Gọi chung
  static void show(
      BuildContext context, {
        required String message,
        String? title,
        AppSnackType type = AppSnackType.info,
        AppSnackPosition position = AppSnackPosition.bottom,
        Duration duration = const Duration(seconds: 3),
        String? actionLabel,
        VoidCallback? onAction,
        IconData? icon,
        Color? background,
        Color? foreground,
        bool dismissPrevious = true,
      }) {
    final resolved = _resolveStyle(
      context,
      type: type,
      icon: icon,
      background: background,
      foreground: foreground,
      title: title,
    );

    if (dismissPrevious) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).clearMaterialBanners();
    }

    if (position == AppSnackPosition.top) {
      // Hiển thị trên cùng bằng MaterialBanner
      final banner = MaterialBanner(
        backgroundColor: resolved.bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(resolved.icon, color: resolved.fgColor),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resolved.title != null)
              Text(
                resolved.title!,
                style: TextStyle(
                  color: resolved.fgColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            Text(
              message,
              style: TextStyle(color: resolved.fgColor),
            ),
          ],
        ),
        actions: [
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: () {
                onAction();
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: Text(actionLabel),
            ),
          IconButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            icon: Icon(Icons.close, color: resolved.fgColor),
            tooltip: 'Đóng',
          ),
        ],
      );

      ScaffoldMessenger.of(context).showMaterialBanner(banner);

      // Tự ẩn sau [duration]
      Future.delayed(duration, () {
        // Kiểm tra còn banner hiện tại không rồi mới ẩn
        if (ScaffoldMessenger.of(context).mounted &&
            ScaffoldMessenger.of(context).mounted) {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        }
      });
    } else {
      // Hiển thị dưới cùng bằng SnackBar
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: resolved.bgColor,
        duration: duration,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(resolved.icon, color: resolved.fgColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (resolved.title != null)
                    Text(
                      resolved.title!,
                      style: TextStyle(
                        color: resolved.fgColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  Text(
                    message,
                    style: TextStyle(color: resolved.fgColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        action: (actionLabel != null && onAction != null)
            ? SnackBarAction(
          label: actionLabel,
          onPressed: onAction,
          textColor: resolved.fgColor,
        )
            : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Helper nhanh cho API thành công
  static void success(BuildContext context, String message,
      {String? title, AppSnackPosition position = AppSnackPosition.bottom}) =>
      show(context,
          message: message,
          title: title ?? 'Thành công',
          type: AppSnackType.success,
          position: position);

  /// Helper nhanh cho API lỗi
  static void error(BuildContext context, String message,
      {String? title, AppSnackPosition position = AppSnackPosition.bottom}) =>
      show(context,
          message: message,
          title: title ?? 'Lỗi',
          type: AppSnackType.error,
          position: position);

  // --- style resolver ---
  static _Resolved _resolveStyle(
      BuildContext context, {
        required AppSnackType type,
        String? title,
        IconData? icon,
        Color? background,
        Color? foreground,
      }) {
    // Màu mặc định theo type
    Color bg;
    IconData ic;
    String? ttl = title;

    switch (type) {
      case AppSnackType.success:
        bg = const Color(0xFF16A34A); // green-600
        ic = Icons.check_circle;
        ttl ??= 'Thành công';
        break;
      case AppSnackType.error:
        bg = const Color(0xFFDC2626); // red-600
        ic = Icons.error_rounded;
        ttl ??= 'Lỗi';
        break;
      case AppSnackType.warning:
        bg = const Color(0xFFF59E0B); // amber-500
        ic = Icons.warning_amber_rounded;
        ttl ??= 'Cảnh báo';
        break;
      case AppSnackType.info:
      default:
        bg = const Color(0xFF2563EB); // blue-600
        ic = Icons.info_rounded;
        ttl ??= 'Thông báo';
        break;
    }

    final Color fg = foreground ?? Colors.white;
    return _Resolved(
      bgColor: background ?? bg,
      fgColor: fg,
      icon: icon ?? ic,
      title: ttl,
    );
  }
}

class _Resolved {
  final Color bgColor;
  final Color fgColor;
  final IconData icon;
  final String? title;

  _Resolved({
    required this.bgColor,
    required this.fgColor,
    required this.icon,
    required this.title,
  });
}
