import 'dart:async';
import 'dart:developer';

import 'package:digital_three/Screens/home.dart';
import 'package:digital_three/models/user_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../local_db/db.dart';
import '../main.dart';

final loginProvider =
    ChangeNotifierProvider.autoDispose((ref) => LoginProvider());

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _doesUserExists = false;
  StreamSubscription? _dbChangesSub;
  List<UserDetailsItem> _allUsers = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool get doesUserExists => _doesUserExists;

  List<UserDetailsItem>? get allUsers => _allUsers;

  bool get isLoading => _isLoading;

  Future<void> _init() async {
    await _initializeUsers();
    final userCollection =
        await TestLocalDb.instance.getCollection<UserDetailsItem>();
    _dbChangesSub = userCollection.watchLazy().listen(_onUserDbChange);
    notifyListeners();
  }

  Future<void> _initializeUsers() {
    return TestLocalDb.instance.readTxn((isar) async {
      _allUsers =
          await isar.userDetailsItems.where().distinctByEmail().findAll();
    });
  }

  LoginProvider() {
    _init();
  }

  Future<void> _onUserDbChange(_) async {
    await _initializeUsers();
    notifyListeners();
  }

  Future<void> login() async {
    try {
      _isLoading = true;
      notifyListeners();
      return await TestLocalDb.instance.readTxn((isar) async {
        _allUsers = await isar.userDetailsItems
            .filter()
            .emailEqualTo(emailController.text)
            .passwordEqualTo(passwordController.text)
            .findAll();
        notifyListeners();
        if (_allUsers.isNotEmpty) {
          navigatorKey.currentState?.pushNamed(Home.ROUTE_NAME);
        } else {
          const SnackBar snackBar = SnackBar(
            content: Text(
              "Please check your user id and password",
            ),
          );
          snackbarKey.currentState?.showSnackBar(snackBar);
        }
      });
    } catch (err, st) {
      log("$err $st");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _dbChangesSub?.cancel();
    super.dispose();
  }
}
