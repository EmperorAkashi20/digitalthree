import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class LocalDbFiles {
  late Uuid uuid;
  static LocalDbFiles? _instance;

  static LocalDbFiles get instance {
    _instance ??= LocalDbFiles._();
    return _instance!;
  }

  LocalDbFiles._() {
    uuid = const Uuid();
  }

  ///Use this to generate unique fileName [file extension is not added]
  String uniqueId() => uuid.v1();

  Future<String> getDbPath() async {
    String dirPath = (await getApplicationDocumentsDirectory()).path;
    dirPath = [dirPath, "testing_db_v1"].join(Platform.pathSeparator);
    if (!await Directory(dirPath).exists()) {
      await Directory(dirPath).create(recursive: true);
    }
    return dirPath;
  }

  String randomFileName(String extension) {
    return "${uniqueId()}.$extension";
  }

  Future<void> deleteFile(String filePath) async {
    try {
      await File(filePath).delete(recursive: true);
    } catch (err, st) {
      log("$err $st");
    }
  }
}
