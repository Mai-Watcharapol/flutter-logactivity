import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'item.dart';

class ItemService {
  late Isar _isar;

  ItemService._privateConstructor();

  static final ItemService _instance = ItemService._privateConstructor();

  static ItemService get instance => _instance;

  Future<void> startIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ItemSchema],
      directory: dir.path,
    );
  }

  Future<List<Item>> getItems() async {
    return await _isar.items.where().findAll();
  }

  Future<bool> addItem(Item item) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.items.put(item);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeItem(Id itemId) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.items.delete(itemId);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateItem(Item item) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.items.put(item);
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
