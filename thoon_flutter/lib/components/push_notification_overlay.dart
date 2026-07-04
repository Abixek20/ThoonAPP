import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class PushNotificationOverlay extends StatefulWidget {
  final Widget child;
  const PushNotificationOverlay({super.key, required this.child});

  static void show(BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final state = context.findAncestorStateOfType<_PushNotificationOverlayState>();
    if (state != null) {
      state.triggerNotification(title: title, message: message, icon: icon, onTap: onTap);
    }
  }

  @override
  State<PushNotificationOverlay> createState() => _PushNotificationOverlayState();
}

class _PushNotificationOverlayState extends State<PushNotificationOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  Timer? _dismissTimer;

  String _title = "";
  String _message = "";
  IconData _icon = Icons.notifications_active_rounded;
  VoidCallback? _onTap;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _dismissTimer?.cancel();
    super.dispose();
  }

  void triggerNotification({
    required String title,
    required String message,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    _dismissTimer?.cancel();
    setState(() {
      _title = title;
      _message = message;
      _icon = icon;
      _onTap = onTap;
      _isVisible = true;
    });

    _controller.forward();

    _dismissTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            setState(() {
              _isVisible = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isVisible)
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _offsetAnimation,
              child: GestureDetector(
                onTap: () {
                  _controller.reverse().then((_) {
                    if (mounted) {
                      setState(() {
                        _isVisible = false;
                      });
                    }
                  });
                  if (_onTap != null) _onTap!();
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThoonTheme.cardBg.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ThoonTheme.goldPrimary.withOpacity(0.5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: ThoonTheme.goldPrimary.withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ThoonTheme.goldPrimary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_icon, color: ThoonTheme.goldPrimary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _title,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _message,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: ThoonTheme.textMuted,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right_rounded, color: ThoonTheme.textMuted.withOpacity(0.6)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
