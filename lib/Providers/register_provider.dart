import 'dart:async';
import 'dart:developer';

import 'package:digital_three/models/user_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../local_db/db.dart';

final registerProvider = ChangeNotifierProvider.autoDispose((ref) {
  return RegisterProvider();
});

class RegisterProvider with ChangeNotifier {
  bool _isLoading = false;
  dynamic _error;

  StreamSubscription? _dbChangesSub;
  List<UserDetailsItem> _allUsers = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  List<String> list = <String>[
    'Engineer',
    'Doctor',
    'CA',
    'Lawyer',
    'Designer'
  ];

  bool get hasError => _error != null;

  bool get isLoading => _isLoading;

  List<UserDetailsItem>? get allUsers => _allUsers;

  dynamic get error => _error;

  String _dropdownValue = "Engineer";

  String get dropdownValue => _dropdownValue;

  setDropdownValue(String value) {
    _dropdownValue = value;
    log(_dropdownValue);
    notifyListeners();
  }

  Future<void> saveUserDetails(UserDetailsItem userDetails) async {
    try {
      await TestLocalDb.instance.writeTxn((isar) async {
        await isar.userDetailsItems.put(userDetails);
      });
    } catch (err, st) {
      log("$err $st");
    } finally {
      notifyListeners();
    }
  }

  Future<void> _init() async {
    await _initializeUserDb();
    final userCollection =
        await TestLocalDb.instance.getCollection<UserDetailsItem>();
    _dbChangesSub = userCollection.watchLazy().listen(_onUserDbChange);
    notifyListeners();
  }

  Future<void> _initializeUserDb() {
    return TestLocalDb.instance.readTxn((isar) async {
      _allUsers =
          await isar.userDetailsItems.where().distinctByEmail().findAll();
    });
  }

  RegisterProvider() {
    _init();
  }

  Future<void> _onUserDbChange(_) async {
    await _initializeUserDb();
    notifyListeners();
  }

  @override
  void dispose() {
    _dbChangesSub?.cancel();
    super.dispose();
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
