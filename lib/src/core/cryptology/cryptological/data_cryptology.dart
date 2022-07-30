part of cryptography.core;

class DataCryptology implements Cryptology<AES, Uint8List> {
  @override
  late final AES algorithm;
  DataCryptology({
    required this.algorithm,
  });

  @override
  Future<Uint8List> decrypt(Uint8List cipherData) async =>     
      compute(algorithm.decrypt, cipherData);

  @override
  Future<Uint8List> encrypt(Uint8List data) async =>
      compute(algorithm.encrypt, data);

  @protected
  @override
  hash(Uint8List data) {
    throw "$this.hash not supported.";
  }

  @protected
  @override
  verify(Uint8List data, Uint8List hashedData) {
    throw "$this.verify not supported.";
  }
}
