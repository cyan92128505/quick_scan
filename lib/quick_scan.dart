import 'components/scan_button.dart';

class QuickScan {
  ScanButton getButton({
    Map<String, String> i18nData,
    String cryptoKey = '0000000000000000',
    String cryptoIV = '0000000000000000',
    int duration = 300,
    int count = 3,
  }) {
    return new ScanButton(
      i18nData: i18nData,
      cryptoKey: cryptoKey,
      cryptoIV: cryptoIV,
      duration: duration,
      count: count,
    );
  }
}
