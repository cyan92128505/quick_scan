import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'package:quick_scan/services/device_service.dart';
import 'package:quick_scan/services/scan_service.dart';
import 'package:quick_scan/config/event_set.dart';
import 'package:quick_scan/components/scan_icon.dart';

ScanService scanService = new ScanService();
DeviceService deviceService = new DeviceService();

class LangKey {
  static String titleText = 'title_text';
  static String scanText = 'scan_text';
  static String qrcodeText = 'qrcode_text';
  static String successText = 'success_text';
  static String errorText = 'error_text';
  static String startText = 'start_text';
}

Map<String, String> _i18nData = {
  LangKey.titleText: 'QuickScan - QR Code Scanner',
  LangKey.scanText: 'SCAN',
  LangKey.qrcodeText: 'QRCode',
  LangKey.successText: 'SUCCESS',
  LangKey.errorText: 'ERROR',
  LangKey.startText: 'START',
};

class ButtonOption {
  double elevation = 4;
  Color color = Colors.cyan;
  Color textColor = Colors.white;
  Color splashColor = Colors.cyanAccent;
}

ButtonOption _buttonOption = new ButtonOption();

class ScanButton extends StatefulWidget {
  ScanButton({
    Key key,
    Map<String, String> i18nData,
    String cryptoKey,
    String cryptoIV,
    int duration = 300,
    int count = 3,
    ButtonOption buttonOption,
  }) : super(key: key) {
    _i18nData = i18nData ?? _i18nData;
    _buttonOption = buttonOption ?? _buttonOption;
    scanService.setupKeyAndIv(cryptoKey, cryptoIV);
    scanService.setupHTTPDurationAndCount(duration, count);
  }

  @override
  _ScanButtonState createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  _ScanButtonState();

  @override
  void initState() {
    super.initState();
    ready(context);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.9;
    return RaisedButton(
      elevation: _buttonOption.elevation,
      color: _buttonOption.color,
      textColor: _buttonOption.textColor,
      splashColor: _buttonOption.splashColor,
      onPressed: () {
        scan(context);
      },
      shape: CircleBorder(
        side: BorderSide(
          style: BorderStyle.solid,
          color: _buttonOption.color,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: _width,
          height: _width,
          child: CustomPaint(
            painter: ScanIcon(),
          ),
        ),
      ),
    );
  }

  Future scan(BuildContext context) async {
    scanService.scan().then(
          (response) => showFinishMessage(context, response),
        );
  }

  void showFinishMessage(BuildContext context, dynamic response) {
    String message = '';
    switch (response) {
      case '200':
        message =
            '${_i18nData[LangKey.scanText]} ${_i18nData[LangKey.successText]}!';
        break;
      case '404':
      case '500':
        message =
            '${_i18nData[LangKey.scanText]} ${_i18nData[LangKey.errorText]}!';
        break;
      default:
        message = response;
    }

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    ));

    Vibration.vibrate(duration: 100);
  }

  void ready(BuildContext context) async {
    const channel = EventChannel(EventSet.EVENT_CHANNEL);
    try {
      channel.receiveBroadcastStream().listen((dynamic event) {
        String message = EventSet.decode(event)['MESSAGE'];
        print(EventSet.decode(event)['TYPE']);
        switch (EventSet.decode(event)['TYPE']) {
          case EventSet.DEEP_LINK:
            if (message != null && message.length > 0) {
              print(message);
              showBasicDialog(context, message);
            }
            break;
          default:
            print('not apply eventset $message');
        }
      }, onError: (dynamic error) {
        print('Received error: ${error.message}');
      });
    } catch (e) {
      print(e);
    }

    const PLATFORM_CHANNEL = const MethodChannel(EventSet.READY);
    try {
      final String result =
          await PLATFORM_CHANNEL.invokeMethod(EventSet.READY_INVOKE);
      print('EventSet.READY_INVOKE: $result');
    } catch (error) {
      print('Error: $error');
    }
  }

  void showBasicDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(_i18nData[LangKey.qrcodeText]),
            content: Text(_i18nData[LangKey.scanText]),
            actions: <Widget>[
              FlatButton(
                  child: Text(_i18nData[LangKey.startText]),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
    ).then<void>((value) {
      deviceService.standbyDeviceInfo.future.then((_) {
        return scanService.deepLink(message, true).then(
              (response) => showFinishMessage(context, response),
            );
      });
    });
  }
}
