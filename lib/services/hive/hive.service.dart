// class HiveService {
//   Future<void> openBlueDeviceBox() async {
// // Create a box collection
//     final collection = await BoxCollection.open(
//       'MyFirstFluffyBox', // Name of your database
//       {'cats', 'dogs'}, // Names of your boxes
//       path:
//           './', // Path where to store your boxes (Only used in Flutter / Dart IO)
//       key:
//           HiveCipher(), // Key to encrypt your boxes (Only used in Flutter / Dart IO)
//     );

//     // Open your boxes. Optional: Give it a type.
//     final catsBox = collection.openBox<Map>('cats');
//   }
// }
