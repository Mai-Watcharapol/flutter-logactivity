import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'user.dart';


class UserService {
  late Isar _isar;

  UserService._privateConstructor();

  static final UserService _instance = UserService._privateConstructor();

  static UserService get instance => _instance;

  Future<void> startIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [UserSchema],
      directory: dir.path,
    );
  }

  Future<List<User>> getUsers() async {
    return await _isar.users.where().findAll();
  }

  Future<void> addUser(User user) async {
    await _isar.writeTxn(() async {
      await _isar.users.put(user);
    });
  }

  Future<void> removeUser(Id userId) async {
    await _isar.writeTxn(() async {
      await _isar.users.delete(userId);
    });
  }

  Future<void> updateUser(User user) async {
    await _isar.writeTxn(() async {
      await _isar.users.put(user);
    });
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService.instance;
});
