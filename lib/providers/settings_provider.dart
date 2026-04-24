import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider with ChangeNotifier {
  final StorageService _storageService;
  bool _soundEnabled;
  bool _vibrationEnabled;
  bool _animationEnabled;

  SettingsProvider(this._storageService)
      : _soundEnabled = _storageService.getSoundEnabled(),
        _vibrationEnabled = _storageService.getVibrationEnabled(),
        _animationEnabled = _storageService.getAnimationEnabled();

  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get animationEnabled => _animationEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    _storageService.saveSoundEnabled(enabled);
    notifyListeners();
  }

  void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
    _storageService.saveVibrationEnabled(enabled);
    notifyListeners();
  }

  void setAnimationEnabled(bool enabled) {
    _animationEnabled = enabled;
    _storageService.saveAnimationEnabled(enabled);
    notifyListeners();
  }
}
