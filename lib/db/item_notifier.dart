import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'db_factory.dart';
import 'item.dart';



final isarServiceProvider = Provider<ItemService>((ref) {
  return ItemService.instance;
});


Future<void> addItem(Ref ref, Item item) async {
  final isarService = ref.read(isarServiceProvider);
  await isarService.addItem(item);
}


Future<void> removeItem(Ref ref, Id itemId) async {
  final isarService = ref.read(isarServiceProvider);
  isarService.removeItem(itemId);
}

Future<void> updateItem(Ref ref, Item item) async {
  final isarService = ref.read(isarServiceProvider);
  isarService.updateItem(item);
}
