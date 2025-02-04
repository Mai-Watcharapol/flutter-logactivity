import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'db_factory.dart';
import 'item.dart';

final isarServiceProvider = Provider<ItemService>((ref) {
  return ItemService.instance;
});

final itemsProvider = FutureProvider<List<Item>>((ref) async {
  final isarService = ref.read(isarServiceProvider);
  return isarService.getItems();
});

final addItemProvider = FutureProvider.family<void, Item>((ref, item) async {
  final isarService = ref.read(isarServiceProvider);
  await isarService.addItem(item);
});

final removeItemProvider = FutureProvider.family<void, Id>((ref, itemId) async {
  final isarService = ref.read(isarServiceProvider);
  await isarService.removeItem(itemId);
});

final updateItemProvider = FutureProvider.family<void, Item>((ref, item) async {
  final isarService = ref.read(isarServiceProvider);
  await isarService.updateItem(item);
});


