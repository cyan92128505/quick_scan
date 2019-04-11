import 'package:cipher2/cipher2.dart';

class CryptoService {
  String _key = '0000000000000000';
  String _iv = '0000000000000000';

  CryptoService();

  void setupKeyAndIv(String key, String iv) {
    _key = key;
    _iv = iv;
  }

  Future<String> decrypt(String plainText) async {
    return await Cipher2.decryptAesCbc128Padding7(plainText, _key, _iv);
  }
}
