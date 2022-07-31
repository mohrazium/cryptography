part of cryptology.core;

abstract class Algorithm {
  dynamic secureKey;
  Algorithm(
    this.secureKey,
  );

  @override
  String toString() => 'Algorithm(secretKey: $secureKey)';
}
