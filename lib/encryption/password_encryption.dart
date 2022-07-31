part of cryptography;

enum HashDifficulty {
  veryWeak(8, 8, 1250),
  weak(16, 16, 2500),
  medium(32, 32, 5000),
  strong(64, 64, 10000),
  veryStrong(128, 128, 20000),
  extra(256, 256, 40000);

  final int blockLength;
  final int desiredKeyLength;
  final int iterationCount;
  const HashDifficulty(
    this.blockLength,
    this.desiredKeyLength,
    this.iterationCount,
  );
}

class PasswordEncryption {
  late final PasswordCryptology _passwordCryptology;
  final String _secretKey;
  final HashDifficulty _difficulty;
  // Initialize PasswordCryptology with PBKDF2 algorithm to hashing input password.
  PasswordEncryption.initial({HashDifficulty? difficulty, String? secretKey})
      : _secretKey = secretKey ?? 'PBKDF2-ENC',
        _difficulty = difficulty ?? HashDifficulty.veryWeak {
    _passwordCryptology = PasswordCryptology(
        algorithm: PBKDF2(
      blockLength: _difficulty.blockLength,
      desiredKeyLength: _difficulty.desiredKeyLength,
      iterationCount: _difficulty.iterationCount,
      secretKey: _secretKey.toBytes(),
    ));
  }

  /// Hashed the given plain-text [password] using the given [_algorithm].
  Future<Uint8List> hash(Uint8List password) =>
      _passwordCryptology.hash(password);

  /// Hashed the given plain-text [password].
  Future<String> hashB64(String password) async =>
      CryptoHelpers.toB64(await hash(password.toBytes()));

  /// Checks if the given plain-text [password] matches the given encoded [hash].
  Future<bool> verify(String password, Uint8List hashedPassword) async =>
      _passwordCryptology.verify(password.toBytes(), hashedPassword);

  /// Checks if the given plain-text [password] matches the given encoded [hash].
  Future<bool> verifyB64(String password, String b64HashedPassword) async =>
      _passwordCryptology.verify(password.toBytes(),
          CryptoHelpers.toNormalString(b64HashedPassword).toBytes());
}
