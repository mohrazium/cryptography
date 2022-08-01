
# Cryptology

A cryptography library for use pointycastle in dart and flutter.
this package provides password encryption and data encryption.

## Getting started

For using Cryptology adding this package to your pubspec.yaml file

```bash
flutter pub add cryptology
```

### Password encryption and verify

 PasswordEncryption use PBKDF2 algorithm to hash passwords.

#### How PBKDF2 works?

 PBKDF2 takes as input a password, a salt, an integer defining how many “iterations” of the hash function to undergo, and an integer describing the desired key length for the output.

### Password Encryption Usage

#### Initial PasswordEncryption

to Initial PasswordEncryption

```dart
final passwordEncryption = PasswordEncryption.initial(difficulty: HashDifficulty.strong); 
```

#### Hashing

then hash a password:

```dart
  final hashedPwd = passwordEncryption.hash("pa$$w0rd");
  // if you want base64 encoded password use hashB64() instead.
  final b64StringHashedPwd = passwordEncryption.hashB64("pa$$w0rd");
```

#### Verify

to verify hashed password:

```dart
  final hashedPwd = passwordEncryption.verify("pa$$w0rd");
  // if you have base64 encoded password use hashB64() instead.
  final b64StringHashedPwd = passwordEncryption.verifyB64("pa$$w0rd");
```

### Data encryption

DataEncryption use AES encryption methods to encrypt data.

How AES works?

The Advanced Encryption Standard (AES) works by taking plain text or binary data and converting it into cipher text, which is made up of seemingly random characters. Only those who have the special key can decrypt it. AES uses symmetric key encryption, which involves the use of only one secret key to cipher and decipher information.

#### Initial DataEncryption

Data Encryption work with plaint text or files. make sure to read theme as bytes.
Initial Data Encryption :

```dart
final DataEncryption dataEncryption = DataEncryption.initial(
      secretKey: '1a2b3c4d', mode: AESMode.cbc, iv: 'q1w2e3r4');
```

* Provide secret key at last 8 characters or up to 32 characters.
* Provide mode it's (**cbc, cfb, ofb, gcm**).
* Provide iv key at last 8 characters or up to 16 characters.(isn't required, provides iv from reversed of secret key).

#### Encrypt data

to encrypt data you **should convert data to byte array**.

**For plaint text data you can use the following methods:**

```dart
final plainText = "plain text data";
final Uint8List dataAsBytes = CryptoHelpers.toBytes(plainText);
// Or using extension like :
final Uint8List dataAsBytes = plainText.toBytes();
```

**For files you can use the following methods:**

```dart
final fileData =
      await File("~/Pictures/my_profile.png").readAsBytes();
```

##### Encrypt bytes

```dart
final encryptedData = await dataEncryption.encrypt(fileData);
// for base64 string encoding:
final encryptedData = await dataEncryption.encryptB64(fileData);
```

#### Decrypt data

to decrypt encryptedData use the following methods:

```dart
final decryptedData = await dataEncryption.decrypt(encryptedData);
// if your encrypt data was base64 using decryptB64 methods:
final decryptedData = await dataEncryption.decryptB64(encryptedData);
```
