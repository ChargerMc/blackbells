abstract class BaseConfig {
  String get baseURL;
  String get socketURL;
}

class DevConfig implements BaseConfig {
  @override
  String get baseURL => "http://192.168.231.1:8000/api";

  @override
  String get socketURL => "http://192.168.231.1:8000/";
}

class ProdConfig implements BaseConfig {
  @override
  String get baseURL => "https://app.blackbells.com.ec/api";

  @override
  String get socketURL => "https://app.blackbells.com.ec/";
}

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'DEV';
  static const String prod = 'PROD';

  late BaseConfig config;

  void initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.prod:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}
