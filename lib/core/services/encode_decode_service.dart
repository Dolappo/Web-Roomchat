// import 'dart:convert';
//
// class EncodingDecodingService {
//   static String encodeAndEncrypt(
//       Map<String, dynamic> data, String ivPassword, String password) {
//     String encodedString = jsonEncode(data);
//
//     return EncryptionService.encrypt(ivPassword, password, encodedString);
//   }
//
//   static Map<String, dynamic> decryptAndDecode(
//       String data, String ivPassword, String password) {
//     String decryptedString =
//         EncryptionService.decrypt(ivPassword, password, data);
//
//     return jsonDecode(decryptedString);
//   }
// }

import 'package:webcrypto/webcrypto.dart';

Future<void> _generateKeys() async {
  //1. Generate keys
  KeyPair<EcdhPrivateKey, EcdhPublicKey> keyPair =
      await EcdhPrivateKey.generateKey((EllipticCurve.p256));
  Map<String, dynamic> publicKeyJwk =
      await keyPair.publicKey.exportJsonWebKey();
  Map<String, dynamic> privateKeyJwk =
      await keyPair.privateKey.exportJsonWebKey();
}
