part of cryptology.core;

extension CryptoHelpersUtf8 on Uint8List {
  toUtf8() => utf8.decode(this);
}

/// Extension on String for convert them to Uint8List.
extension CryptoHelpersString on String {
  toBytes() => CryptoHelpers.toBytes(this);
}

/// Extension on Uint8List for convert them to String.
extension CryptoHelpersBytes on Uint8List {
  toHex() => CryptoHelpers.toHex(this);
}

/// Extension on String for convert them to Uint8List.
extension CryptoHelpersMixBytes on String {
  mixBytes() => CryptoHelpers.mixBytes(this);
}

class CryptoHelpers {
  /// Creates a hexadecimal representation of the given [bytes].
  static String toHex(Uint8List bytes) {
    var result = StringBuffer();
    for (var i = 0; i < bytes.lengthInBytes; i++) {
      var part = bytes[i];
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }

  static List<int> mixBytes(String asciiStr) {
    List<int> chars = asciiStr.codeUnits;
    List<int> mixedBytes = List.empty(growable: true);
    for (int ch in chars) {
      var shifted = ((ch) ^ 0xFFFFF) & 0x0F;
      var hexCh =
          shifted.toRadixString(16).padLeft(shifted.toString().length, '0x');
      mixedBytes.add(int.tryParse(hexCh) ?? 0);
    }
    return mixedBytes;
  }

  /// Creates binary data from the given [plainText] String.
  static Uint8List toBytes(String plainText) {
    return Uint8List.fromList(utf8.encode(plainText));
  }

  /// Simply convert a [bytes] to string.
  static String toStringFromBytes(Uint8List bytes) =>
      String.fromCharCodes(bytes);

  /// Encode a [bytes] to base64 encoded string.
  static String toB64(Uint8List bytes) => base64.encode(bytes);

  /// Decode a [base64Coded] string to corresponding string.
  static Uint8List toBytesBase64(String base64Coded) =>
      base64.decode(base64Coded);

  /// Decode a [base64Coded] string to corresponding string.
  static String toNormalString(String base64Coded) =>
      utf8.decode(base64.decode(base64Coded));

  /// Padded [src] bytes with value of [blockSize]
  static Uint8List pad(Uint8List src, int blockSize) {
    var pad = PKCS7Padding();
    pad.init(null);
    int padLength = blockSize - (src.length % blockSize);
    var out = Uint8List(src.length + padLength)..setAll(0, src);
    pad.addPadding(out, src.length);
    return out;
  }

  /// un pad padded [src] to normal bytes.
  static Uint8List unPad(Uint8List src) {
    Uint8List out = Uint8List(src.length);
    try {
      var pad = PKCS7Padding();
      pad.init(null);
      int padLength = pad.padCount(src);
      int len = src.length - padLength;
      out = Uint8List(len)..setRange(0, len, src);
    } catch (e) {
      //ignore
    }
    return out;
  }

  /// Compare two bytes.
  static bool compare(Uint8List leftBytes, Uint8List rightBytes) {
    if (identical(leftBytes, rightBytes)) {
      return true;
    }

    if (leftBytes.lengthInBytes != rightBytes.lengthInBytes) {
      return false;
    }

    // Treat the original byte lists as lists of 8-byte words.
    var numWords = leftBytes.lengthInBytes ~/ 8;
    var leftWords = leftBytes.buffer.asUint64List(0, numWords);
    var rightWords = rightBytes.buffer.asUint64List(0, numWords);

    for (var i = 0; i < leftWords.length; i += 1) {
      if (leftWords[i] != rightWords[i]) {
        return false;
      }
    }

    // Compare any remaining bytes.
    for (var i = leftWords.lengthInBytes; i < leftBytes.lengthInBytes; i += 1) {
      if (leftBytes[i] != rightBytes[i]) {
        return false;
      }
    }

    return true;
  }
}
