import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SettingProvider with ChangeNotifier {

  final _storage = const FlutterSecureStorage();

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void updateTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    notifyListeners();
  }

  Future<String?> getCurrentTheme() async {
    return await _storage.read(key: 'theme');
  }

  Future<void> saveTheme(bool isDarkMode) async {
    await _storage.write(key: 'theme', value: isDarkMode ? 'dark' : 'light');
    updateTheme(isDarkMode);
  }

  void initTheme() async {
    String? theme = await getCurrentTheme();
    if (theme != null) {
      _isDarkMode = theme == 'dark';
      notifyListeners();
    }
  }
}
