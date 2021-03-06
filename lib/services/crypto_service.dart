import 'package:cipher2/cipher2.dart';

class CryptoService {
  String _key = '0000000000000000';
  String _iv = '0000000000000000';

  CryptoService();

  void setupKeyAndIv(String key, String iv) {
    _key = key ?? _key;
    _iv = iv ?? _iv;
  }

  Future<String> decrypt(String plainText) async {
    try {
      var str = await Cipher2.decryptAesCbc128Padding7(plainText, _key, _iv);
      print(str);
      return str;
    } catch (e) {
      return Future(() => '');
    }
  }
}
