import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart';

import 'package:quick_scan/models/api_option.dart';
import 'package:quick_scan/services/device_service.dart';
import 'package:quick_scan/services/crypto_service.dart';
import 'package:quick_scan/services/http_service.dart';

DeviceService deviceService = new DeviceService();
CryptoService cryptoService = new CryptoService();

class ScanService {
  static final _instance = new ScanService._();
  String _deviceId = '';
  String _deviceName = '';

  int _duration = 300;
  int _count = 3;

  factory ScanService({String key, String iv}) {
    return _instance;
  }

  void setupKeyAndIv(String key, String iv) {
    cryptoService.setupKeyAndIv(key, iv);
  }

  void setupHTTPDurationAndCount(int duration, int count) {
    _duration = duration;
    _count = count;
  }

  ScanService._() {
    deviceService.standbyDeviceInfo.future.then((_) {
      this._deviceId = deviceService.deviceId;
      this._deviceName = deviceService.deviceName;
    });
  }

  Future scan() async {
    Completer apiCaller = new Completer();

    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
      deepLink(barcode, false).then(
        (response) => apiCaller.complete(response),
      );
    } catch (e) {
      print('Scan Method Unknown error: $e');
    }

    return apiCaller.future;
  }

  Future<ApiOption> _parseUri(String link) async {
    Uri uri = Uri.parse(link);
    String fragment = '';
    Map<String, dynamic> json = {};
    try {
      fragment = await cryptoService.decrypt(uri.fragment);
      json = jsonDecode(fragment);
    } catch (e) {
      return null;
    }

    ApiOption _apiOption = new ApiOption.generate(
      url: json['url'],
      key: json['key'],
      type: json['type'],
    );

    if (json['type'] == '2') {
      _apiOption.token = json['token'];
    }

    return _apiOption;
  }

  Future deepLink(String link, bool needReturnBrowser) async {
    Completer apiCaller = new Completer();
    try {
      ApiOption apiOption = await _parseUri(link);

      Response response =
          await _execApi(this._deviceId, apiOption, this._deviceName);

      if (needReturnBrowser &&
          Platform.isAndroid &&
          await canLaunch('${apiOption.url}')) {
        await launch('${apiOption.url}');
      }

      apiCaller.complete(Future(() => response.statusCode.toString()));
    } catch (e) {
      apiCaller.complete(Future(() => link));
      if (await canLaunch('$link')) {
        await launch('$link');
      }
    }

    return apiCaller.future;
  }

  Future _execApi(
    String deviceId,
    ApiOption apiOption,
    String deviceName,
  ) {
    Map<String, dynamic> _option = apiOption.type == 1
        ? {
            'deviceName': deviceName,
            'deviceId': deviceId,
            'key': apiOption.key,
          }
        : {
            'deviceId': deviceId,
            'key': apiOption.key,
            'token': apiOption.token,
          };

    var response = new HttpService().exec(
      apiOption.url,
      _option,
      _duration,
      _count,
    );

    return response;
  }
}
