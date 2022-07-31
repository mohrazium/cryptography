part of cryptology.core;


enum AESMode {
  cbc('CBC', "CBCBlockCipher"),
  cfb('CFB', "CFBBlockCipher"),
  // ctr('CTR', "CTRBlockCipher"),
  // ecb('ECB', "ECBBlockCipher"),
  // gctr('GCTR', "GCTRBlockCipher"),
  ofb('OFB', "OFBBlockCipher"),
  gcm('GCM', "GCMBlockCipher"),
  // ccm('CCM', "CCMBlockCipher"),
  // sic('SIC', "SICBlockCipher"),
  // ige('IGE', "IGEBlockCipher");;
  ;

  final String name;
  final String algorithmName;
  const AESMode(
    this.name,
    this.algorithmName,
  );
}

class AES extends Algorithm {
  final Uint8List secretKey;
  final Uint8List iv;
  final AESMode mode;
  late final BlockCipher _cipher;
  late final ParametersWithIV _params;
  AES({
    required this.secretKey,
    required this.iv,
    required this.mode,
  }) : super(secretKey) {
    assert([128, 192, 256].contains(secureKey.length * 8));
    assert(128 == iv.length * 8);
    BlockCipher aes = AESEngine();
    switch (mode) {
      case AESMode.cbc:
        _cipher = CBCBlockCipher(aes);
        break;
      case AESMode.cfb:
        _cipher = CFBBlockCipher(aes, aes.blockSize);
        break;
      // case AESMode.ccm:
      //   _cipher = CCMBlockCipher(aes);
      //   break;
      // case AESMode.ctr:
      //   throw "CTR mode not supported yet";
      // _cipher = CTRBlockCipher(aes.);//stream
      // case AESMode.ecb:
      //   _cipher = ECBBlockCipher(aes);
      //   break;
      // case AESMode.gctr:
      //   _cipher = GCTRBlockCipher(aes);
      //   break;
      case AESMode.ofb:
        _cipher = OFBBlockCipher(aes, aes.blockSize);
        break;
      case AESMode.gcm:
        _cipher = GCMBlockCipher(aes);
        break;
      // case AESMode.sic:
      //   // _cipher = SICBlockCipher(aes);//stream
      //   throw "SIC mode not supported yet.";
      // case AESMode.ige:
      //   _cipher = IGEBlockCipher(aes);
      //   break;
    }
    _params = ParametersWithIV(KeyParameter(secureKey), iv);
  }

  Uint8List _processBlocks(Uint8List inp) {
    var out = Uint8List(inp.lengthInBytes);
    for (var offset = 0; offset < inp.lengthInBytes;) {
      var len = _cipher.processBlock(inp, offset, out, offset);
      offset += len;
    }
    return out;
  }

  Uint8List encrypt(Uint8List data) {
    _cipher.init(true, _params);
    Uint8List paddedData = CryptoHelpers.pad(data, _cipher.blockSize);
    Uint8List cipherBytes = _processBlocks(paddedData);
    return Uint8List(cipherBytes.length + iv.length)
      ..setAll(0, iv)
      ..setAll(iv.length, cipherBytes);
  }

  Uint8List decrypt(Uint8List cipherData) {
    _cipher.init(false, _params);
    int cipherLen = cipherData.length - _cipher.blockSize;
    Uint8List cipherBytes = Uint8List(cipherLen)
      ..setRange(0, cipherLen, cipherData, _cipher.blockSize);
    Uint8List paddedData = _processBlocks(cipherBytes);
    return CryptoHelpers.unPad(paddedData);
  }
}
