part of cryptography;

const String _randomKey16 = "kLxJ2yjFzs6jay9V";
const String _randomKey24 = "jsRkAz3uXzEHWBpEiU4Os1MD";
const String _randomKey32 = "5KJvVsMDuXNZgfZ4PDAcRg22OrqA20Yr";

class DataEncryption {
  late String _secretKey;
  late String _iv;
  late final AESMode _mode;
  late final DataCryptology _dataCryptology;

  DataEncryption.initial({required String secretKey, String? iv, AESMode? mode})
      : _secretKey = secretKey,
        _iv = iv ?? secretKey.split('').reversed.join(),
        _mode = mode ?? AESMode.cbc {
    if (_secretKey.length < 8) {
      throw "Please provide more than 8 characters of the secret key.";
    } else if (_secretKey.length >= 8 && _secretKey.length < 16) {
      _secretKey = _secretKey + _randomKey16.substring(_secretKey.length);
    } else if (_secretKey.length >= 16 && _secretKey.length < 24) {
      _secretKey = _secretKey + _randomKey24.substring(_secretKey.length);
    } else if (_secretKey.length >= 24 && _secretKey.length < 32) {
      _secretKey = _secretKey + _randomKey32.substring(_secretKey.length);
    } else if (_secretKey.length > 32) {
      _secretKey = _secretKey.substring(_secretKey.length - 32);
    }

    if (_iv.length < 8) {
      throw "Please provide more than 8 characters of the iv.";
    } else if (_iv.length >= 8 && _iv.length <= 16) {
      _iv = _iv + _randomKey16.substring(_iv.length);
    } else if (_iv.length > 16) {
      _iv = _iv.substring(_iv.length - 16);
    }

    _dataCryptology = DataCryptology(
      algorithm: AES(
          secretKey: Uint8List.fromList(_secretKey.mixBytes()),
          iv: Uint8List.fromList(_iv.mixBytes()),
          mode: _mode),
    );
  }

  Future<Uint8List> encrypt(Uint8List data) => _dataCryptology.encrypt(data);

  Future<String> encryptB64(Uint8List data) async =>
      CryptoHelpers.toB64(await encrypt(data));

  Future<Uint8List> decrypt(Uint8List cipherData) =>
      _dataCryptology.decrypt(cipherData);

  Future<Uint8List> decryptB64(String b64Data) =>
      decrypt(CryptoHelpers.toBytesBase64(b64Data));
}
