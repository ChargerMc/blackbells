import 'dart:io';

abstract class BaseConfig {
  String get baseURL;
  String get socketURL;
}

class DevConfig implements BaseConfig {
  @override
  String get baseURL {
    if (Platform.isAndroid) return "http://10.0.2.2:8000/api";
    return "http://127.0.0.1:8000/api";
  }

  @override
  String get socketURL {
    if (Platform.isAndroid) return "http://10.0.2.2:8000/";
    return "http://127.0.0.1:8000/";
  }
}

class ProdConfig implements BaseConfig {
  @override
  String get baseURL => "https://app.blackbells.com.ec/api";

  @override
  String get socketURL => "https://app.blackbells.com.ec/";
}

class Environment {
  static const String dev = 'DEV';
  static const String prod = 'PROD';
  static late BaseConfig config;

  static void init(String mode) {
    config = _setConfig(mode);
  }

  static BaseConfig _setConfig(String mode) {
    switch (mode) {
      case 'PROD':
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}
