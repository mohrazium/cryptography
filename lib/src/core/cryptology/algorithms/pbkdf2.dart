part of cryptography.core;

class PBKDF2 extends Algorithm {
  final Uint8List secretKey;
  final int blockLength;
  final int iterationCount;
  final int desiredKeyLength;
  final Uint8List? salt;
  late PBKDF2KeyDerivator _derivator;
  late Uint8List _salt;

  PBKDF2({
    required this.secretKey,
    this.blockLength = 64,
    this.iterationCount = 10000,
    this.desiredKeyLength = 64,
    this.salt,
  }) : super(secretKey) {
    final rnd = FortunaRandom()..seed(KeyParameter(Uint8List(32)));

    _salt = salt ?? rnd.nextBytes(32);

    _derivator = PBKDF2KeyDerivator(HMac(SHA512Digest(), blockLength))
      ..init(Pbkdf2Parameters(_salt, iterationCount, desiredKeyLength));
  }

  Uint8List hash(dynamic data) {
    Uint8List inputData;
    if (data is Uint8List) {
      inputData = data;
    } else if (data is String) {
      inputData = data.toUint8List();
    } else {
      throw "Please provide a valid data type of Uint8List or String";
    }
    final bytes = _derivator.process(inputData);
    return [
      '',
      secureKey,
      [blockLength, iterationCount, desiredKeyLength],
      CryptoHelpers.toHexString(_salt),
      CryptoHelpers.toHexString(bytes),
    ].join('\$').toUint8List();
  }
}
