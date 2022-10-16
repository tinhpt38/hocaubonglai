import 'package:blue_print_pos/models/blue_device.dart';
import 'package:hive/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  late BoxCollection? _collection;
  late CollectionBox _blueDeviceCollection;

  Future<void> initBoxCollection() async {
// Create a box collection
    _collection = await BoxCollection.open(
      'PrintTicketUniverse1910', // Name of your database
      {'BlueDevices', 'PrintPos'}, // Names of your boxes
    );
    // Open your boxes. Optional: Give it a type.BlueDevices
  }

  Future<CollectionBox> openBlueDeviceBox() async {
    if (_collection == null) {
      initBoxCollection();
    }

    _blueDeviceCollection = await _collection!.openBox<Map>('BlueDevices');
    return _blueDeviceCollection;
  }

  Future<void> addBlueDevice(Map<String, dynamic> device) async {
    await _blueDeviceCollection.put('selectedDevice', device);
  }

  Future<Map<String, dynamic>> getBlueDevice() async {
    Map<String, dynamic> device =
        await _blueDeviceCollection.get('selectedDevice');
    return device;
  }

  HiveService._internal();
}
