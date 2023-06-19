import 'dart:async';

import 'package:digital_three/local_db/db_provider.dart';
import 'package:digital_three/models/user_details_model.dart';
import 'package:isar/isar.dart';

class TestLocalDb {
  Isar? _isar;
  static TestLocalDb instance = TestLocalDb._();

  TestLocalDb._();

  Future<IsarCollection<UserDetailsItem>> userDetails() =>
      getCollection<UserDetailsItem>();

  Future<Isar> _init() async {
    _isar ??= await Isar.open(
      [
        UserDetailsItemSchema,
      ],
      directory: await LocalDbFiles.instance.getDbPath(),
    );
    return _isar!;
  }

  ///Call this in the main
  Future<IsarCollection<T>> getCollection<T>() async {
    final isar = await _init();
    return isar.collection<T>();
  }

  Future<T> readTxn<T>(Future<T> Function(Isar isar) callback) async {
    final isar = await _init();
    return isar.txn(() => callback(isar));
  }

  Future<T> writeTxn<T>(Future<T> Function(Isar isar) callback) async {
    final isar = await _init();
    return isar.writeTxn(() => callback(isar));
  }
}
