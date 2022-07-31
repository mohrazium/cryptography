part of cryptology.core;

class PasswordCryptology implements Cryptology<PBKDF2, Uint8List> {
  @override
  late final PBKDF2 algorithm;
  PasswordCryptology({
    required this.algorithm,
  });

  @override
  Future<Uint8List> hash(Uint8List data) async => compute(algorithm.hash, data);

  @override
  Future<bool> verify(Uint8List data, Uint8List oldHash) async {
    // Hashing current password.
    final hashedNew = await hash(data);
    // Compare latest hashed password to current password.
    return CryptoHelpers.compare(hashedNew, oldHash);
  }

  @protected
  @override
  decrypt(cipherData, [String? key]) {
    throw "$this.decrypt() is not supported.";
  }

  @protected
  @override
  encrypt(Uint8List data) {
    throw "$this.encrypt() is not supported.";
  }
}
