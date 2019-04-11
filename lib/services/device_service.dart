import 'dart:async';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class DeviceService {
  Completer standbyDeviceInfo = new Completer();

  String deviceId = '';
  String deviceName = '';

  DeviceService._() {
    setDeviceInfo();
  }

  static final _instance = new DeviceService._();

  factory DeviceService() {
    return _instance;
  }

  void setDeviceInfo() async {
    dynamic deviceInfo = await _deviceDeteter();
    String _deviceId = '';
    String _deviceName = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo _android = (deviceInfo as AndroidDeviceInfo);
      _deviceId = _android.androidId;
      _deviceName = '${_android.manufacturer}(${_android.model})';
    } else {
      IosDeviceInfo _ios = (deviceInfo as IosDeviceInfo);
      _deviceId = _ios.identifierForVendor;
      _deviceName = 'Apple(${_ios.utsname.machine} ${_ios.utsname.nodename})';
    }

    this.deviceId = _generate(_deviceId);
    this.deviceName = _deviceName;
    standbyDeviceInfo.complete();
  }

  Future<dynamic> _deviceDeteter() {
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
    return Platform.isAndroid ? _deviceInfo.androidInfo : _deviceInfo.iosInfo;
  }

  String _generate(String text) {
    return crypto.sha1.convert(utf8.encode(text)).toString();
  }
}
