import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../providers/calculator_provider.dart';
import '../providers/settings_provider.dart';

class DisplaySection extends StatefulWidget {
  const DisplaySection({super.key});

  @override
  State<DisplaySection> createState() => _DisplaySectionState();
}

class _DisplaySectionState extends State<DisplaySection> with SingleTickerProviderStateMixin {
  double _fontSize = 48.0;
  bool _showHistory = false;
  late AnimationController _resultAnimationController;
  late Animation<double> _resultFadeAnimation;

  @override
  void initState() {
    super.initState();
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _resultFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultAnimationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _resultAnimationController.dispose();
    super.dispose();
  }

  void _triggerResultAnimation() {
    _resultAnimationController.forward(from: 0.0);
  }

  void _vibrateOnError() async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    if (settingsProvider.vibrationEnabled) {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        // Rung 3 lần ngắn khi có lỗi
        Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 150));
        Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 150));
        Vibration.vibrate(duration: 100);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context);
    final theme = Theme.of(context);

    // Trigger animation khi có kết quả mới
    if (provider.result.isNotEmpty) {
      _triggerResultAnimation();
      
      // Rung khi có lỗi
      if (provider.result == 'Error') {
        _vibrateOnError();
      }
    }

    return GestureDetector(
      // Vuốt phải để xóa ký tự cuối (toàn bộ display area)
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 300) { // Giảm threshold để dễ trigger hơn
          provider.delete();
        }
      },
      // Vuốt lên để mở/đóng lịch sử (toàn bộ display area)
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < -300) { // Vuốt lên nhanh
          setState(() {
            _showHistory = !_showHistory;
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        color: Colors.transparent, // Đảm bảo toàn bộ area có thể nhận gesture
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header với mode indicator và nút history
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút History (dễ bấm hơn vuốt)
                if (provider.history.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      _showHistory ? Icons.close : Icons.history,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _showHistory = !_showHistory;
                      });
                    },
                    tooltip: _showHistory ? 'Đóng lịch sử' : 'Xem lịch sử',
                  )
                else
                  const SizedBox(width: 48),
                
                // Mode indicator (RAD/DEG) for scientific mode
                if (provider.mode.toString().contains('scientific'))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      provider.isRadian ? 'RAD' : 'DEG',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
            
            // Lịch sử (hiện khi bấm nút hoặc vuốt lên)
            if (_showHistory)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Lịch sử tính toán',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: provider.history.isEmpty
                          ? Center(
                              child: Text(
                                'Chưa có lịch sử',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            )
                          : ListView.builder(
                              reverse: false,
                              itemCount: provider.history.length,
                              itemBuilder: (context, index) {
                                final item = provider.history[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: InkWell(
                                    onTap: () {
                                      // Tap vào lịch sử để dùng lại
                                      provider.clear();
                                      for (var char in item.expression.split('')) {
                                        provider.append(char);
                                      }
                                      setState(() {
                                        _showHistory = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            item.expression,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '= ${item.result}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              )
            else
              // Spacer để expression và result nằm ở dưới
              const Spacer(),
            
            const SizedBox(height: 8),
            
            // Biểu thức đang nhập (hỗ trợ pinch to zoom)
            GestureDetector(
              onScaleUpdate: (details) {
                if (details.scale != 1.0) {
                  setState(() {
                    _fontSize = (_fontSize * details.scale).clamp(24.0, 72.0);
                  });
                }
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  provider.expression.isEmpty ? '0' : provider.expression,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Kết quả với hiệu ứng fade in
            if (provider.result.isNotEmpty)
              FadeTransition(
                opacity: _resultFadeAnimation,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    '=${provider.result}',
                    style: TextStyle(
                      fontSize: _fontSize * 0.67,
                      fontWeight: FontWeight.w600,
                      color: provider.result == 'Error' 
                          ? Colors.red 
                          : theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
