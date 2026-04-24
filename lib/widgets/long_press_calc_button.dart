import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../providers/settings_provider.dart';

class LongPressCalcButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final Color? textColor;
  final int flex;

  const LongPressCalcButton({
    super.key,
    required this.text,
    required this.onTap,
    this.onLongPress,
    this.color,
    this.textColor,
    this.flex = 1,
  });

  @override
  State<LongPressCalcButton> createState() => _LongPressCalcButtonState();
}

class _LongPressCalcButtonState extends State<LongPressCalcButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.9;
    });
  }

  void _onTapUp(TapUpDetails details) async {
    setState(() {
      _scale = 1.0;
    });
    
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    // Phát âm thanh
    if (settingsProvider.soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    
    // Rung
    if (settingsProvider.vibrationEnabled) {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        Vibration.vibrate(duration: 50);
      }
    }
    
    widget.onTap();
  }

  void _onLongPress() async {
    if (widget.onLongPress != null) {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      
      // Rung dài hơn khi long press
      if (settingsProvider.vibrationEnabled) {
        final hasVibrator = await Vibration.hasVibrator() ?? false;
        if (hasVibrator) {
          Vibration.vibrate(duration: 200);
        }
      }
      
      widget.onLongPress!();
    }
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = widget.color ?? (isDark ? const Color(0xFF2A2A2A) : theme.primaryColor);
    final fgColor = widget.textColor ?? Colors.white;

    return Expanded(
      flex: widget.flex,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onLongPress: _onLongPress,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: fgColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
