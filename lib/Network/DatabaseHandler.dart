import 'package:frcscouting3572/Models/ExtraUserInfo.dart';
import 'package:frcscouting3572/Models/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

DatabaseHandler dbHandler = DatabaseHandler();

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'default.db'),
      onCreate: (database, version) async {
        await database.execute(
            """CREATE TABLE IF NOT EXISTS User(uuid MEDIUMTEXT PRIMARY KEY, team INTEGER NOT NULL, name MEDIUMTEXT NOT NULL, season INTEGER NOT NULL, eventCode MEDIUMTEXT, district MEDIUMTEXT)""");
        await database.execute(
            """CREATE TABLE IF NOT EXISTS ExtraUserInfo(uuid MEDIUMTEXT PRIMARY KEY, eventName MEDIUMTEXT, name MEDIUMTEXT, startDate MEDIUMTEXT, endDate MEDIUMTEXT, seasonDesc MEDIUMTEXT)""");
      },
      version: 1,
    );
  }

  Future<int> insertUser(User user) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('User', user.toJson());
    return result;
  }

  Future<User?> getUser() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query("User");
    if (maps.length == 1) {
      User user = User.fromJson(maps[0]);
      return user;
    }
    return null;
  }

  Future<User> updateUser(User user) async {
    final Database db = await initializeDB();
    await db.update("User", user.toJson(),
        where: "uuid = ?", whereArgs: [user.uuid]);

    return user;
  }

  Future<ExtraUserInfo?> getExtraUserInformation() async {
    final Database db = await initializeDB();
    print(await db.query("ExtraUserInfo"));
    final List<Map<String, dynamic>> maps = await db.query("ExtraUserInfo");
    if (maps.length == 1) {
      ExtraUserInfo extraUserInfo = ExtraUserInfo.fromJson(maps[0]);
      return extraUserInfo;
    }
    return null;
  }

  Future<ExtraUserInfo> updateExtraUserInformation(
      ExtraUserInfo extraUserInfo) async {
    final Database db = await initializeDB();
    await db.update("ExtraUserInfo", extraUserInfo.toJson(),
        where: "uuid = ?", whereArgs: [extraUserInfo.uuid]);

    return extraUserInfo;
  }

  Future<ExtraUserInfo> insertExtraUserInformation(
      ExtraUserInfo extraUserInfo) async {
    final Database db = await initializeDB();
    await db.insert("ExtraUserInfo", extraUserInfo.toJson());

    return extraUserInfo;
  }
}
