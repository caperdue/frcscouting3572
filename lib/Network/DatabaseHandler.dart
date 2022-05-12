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
            //"""CREATE TABLE ExtraUserInformation(uuid INTEGER PRIMARY KEY AUTOINCREMENT, eventName TEXT, startDate TEXT, endDate TEXT, seasonDesc TEXT)
            "CREATE TABLE User(uuid TEXT PRIMARY KEY, team INTEGER NOT NULL, name TEXT NOT NULL, season INTEGER NOT NULL, eventCode TEXT, district TEXT)");
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
  }

  Future<User> updateUser(User user) async {
    final Database db = await initializeDB();
    await db.update("User", user.toJson(),
        where: "uuid = ?", whereArgs: [user.uuid]);

    return user;
  }
}
