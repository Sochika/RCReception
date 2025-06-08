import 'dart:async';
import 'package:attendance/models/attendances.dart';
import 'package:attendance/models/event_types.dart';
import 'package:attendance/models/events.dart';
import 'package:attendance/models/settings.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/MemberAttendance.dart';
import '../models/membersRecords.dart';

class DatabaseHelper {
  static const int _version = 3;
  static const String _dbName = 'membersAttendance.db';
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbPath = await getDatabasesPath();
    print('Database path: $dbPath');

    try {
      return await openDatabase(
        join(dbPath, _dbName),
        onCreate: _createDatabase,
        version: _version,
        onUpgrade: _upgradeDatabase,
      );
    } catch (e) {
      print('Error opening database: $e');
      await deleteDatabase(join(dbPath, _dbName));
      return _initDatabase(); // Retry
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.transaction((txn) async {
      await _createTables(db);
      await _insertInitialData(db);
    });
  }

  Future<void> _createTables(Database db) async {
    // Use db parameter directly (it can be either Database or Transaction)
    await db.execute('''
    CREATE TABLE gca(
      id INTEGER NOT NULL,
      name TEXT NOT NULL,
      PRIMARY KEY(id)
    )''');

    await db.execute('''
      CREATE TABLE ab(
        id INTEGER NOT NULL,
        gca_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        PRIMARY KEY(id),
        FOREIGN KEY (gca_id) REFERENCES gca (id)
      )''');

    await db.execute('''
      CREATE TABLE members(
        id INTEGER NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        middleName TEXT NOT NULL,
        keyNum TEXT NOT NULL,
        gender TEXT NOT NULL,
        phoneNumber TEXT,
        email TEXT,
        gca_id INTEGER,
        ab_id INTEGER,
        office TEXT,
        degree TEXT,
        affiliatedNum INTEGER,
        natalDay TEXT,
        tmo INTEGER DEFAULT 0,
        colombe INTEGER DEFAULT 0,
        late INTEGER DEFAULT 0,
        dob TEXT,
        PRIMARY KEY(id),
        UNIQUE(keyNum, gender),
        FOREIGN KEY (gca_id) REFERENCES gca (id),
        FOREIGN KEY (ab_id) REFERENCES ab (id)
      )''');

    await db.execute('''
      CREATE TABLE event_types(
        id INTEGER NOT NULL,
        event_type TEXT NOT NULL,
        PRIMARY KEY(id)
      )''');

    await db.execute('''
      CREATE TABLE events(
        id INTEGER NOT NULL,
        event_types_id INTEGER NOT NULL,
        speaker TEXT NOT NULL,
        time TEXT NOT NULL,
        date TEXT NOT NULL,
        PRIMARY KEY(id),
        FOREIGN KEY (event_types_id) REFERENCES event_types (id)
      )''');

    await db.execute('''
      CREATE TABLE attendances(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        keyNum TEXT NOT NULL,
        gender TEXT NOT NULL,
        attendance_office INTEGER NULL,
        events_id INTEGER NOT NULL,
        entry_time TEXT,
        FOREIGN KEY (events_id) REFERENCES events (id),
        FOREIGN KEY (keyNum, gender) REFERENCES members (keyNum, gender),
        UNIQUE (keyNum, gender, events_id)
      )''');

    await db.execute('''
      CREATE TABLE settings(
        id INTEGER NOT NULL,
        gca_id INTEGER NOT NULL,
        ab_id INTEGER NOT NULL,
        userName TEXT NOT NULL,
        max_desktop INTEGER,
        tts INTEGER,
        PRIMARY KEY(id),
        FOREIGN KEY (gca_id) REFERENCES gca (id),
        FOREIGN KEY (ab_id) REFERENCES ab (id)
      )''');

    await db.execute('''
       CREATE TABLE dues(
        id INTEGER NOT NULL,
        "keyNum" TEXT NOT NULL,
        gender TEXT NOT NULL,
        "affiliatedNum" INTEGER,
        "affiliatedDate" DATE,
        "localDues" INTEGER NULL,
        "glDues" DATE NULL,
        PRIMARY KEY(id),
    CONSTRAINT "keyNum_keyNum" FOREIGN KEY ("keyNum") REFERENCES members ("keyNum"),
    CONSTRAINT members_ak_2 UNIQUE("keyNum", gender),
    CONSTRAINT "affiliatedNum_affiliatedNum" FOREIGN KEY ("affiliatedNum") REFERENCES members ("affiliatedNum")
    )''');


  }

  Future<void> _insertInitialData(Database db) async {
    await db.execute('''
    INSERT INTO gca (id, name) VALUES (1, 'Default GCA')''');
    await db.execute('''
      INSERT INTO ab (id, gca_id, name) VALUES (1, 1, 'Default AB')''');
    await db.execute('''
      INSERT INTO settings (id, gca_id, ab_id, userName, max_desktop, tts)
      VALUES (1, 1, 1, 'SuchTree', 20, 1)''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE members ADD COLUMN new_column TEXT');
    }
    // Add more upgrade steps as needed
  }

  // Database verification
  Future<bool> verifyDatabase() async {
    try {
      final db = await database;
      final tables = ['members', 'gca', 'ab', 'settings', 'attendances', 'events', 'event_types'];
      for (var table in tables) {
        await db.rawQuery('SELECT 1 FROM $table LIMIT 1');
      }
      return true;
    } catch (e) {
      print('Database verification failed: $e');
      return false;
    }
  }

  // Settings operations
  Future<int> setSettings(SettingsLoad setting) async {
    final db = await database;
    return await db.update(
      'settings',
      setting.toJson(),
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<SettingsLoad?> getSetting() async {
    final db = await database;
    final result = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    return result.isNotEmpty ? SettingsLoad.fromJson(result.first) : null;
  }

  // Member operations
  Future<int> insertMember(Members member) async {
    final db = await database;
    return await db.insert(
      'members',
      member.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateMember(Members member) async {
    final db = await database;
    return await db.update(
      'members',
      member.toJson(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  Future<int> deleteMember(int id) async {
    final db = await database;
    return await db.delete(
      'members',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Members>> colombe() async {
    // Get a reference to the database.
    final db = await database;
    // Query the table for all the dogs.
    final List<Map<String, Object?>> memberMaps = await db.query(
      'members',
      where: 'colombe = ?',
      whereArgs: [1],
    );

    List<Members> dataList =
    memberMaps.map((map) => Members.fromJson(map)).toList();
    await db.close();
    print(dataList);
    return dataList;
  }
  Future<dynamic> insertColombe(Members member) async {
    // Get a reference to the database.
    final db = await database;

    var numID = await db.insert(
      'members',
      member.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.close();
    return numID;
  }

  Future<bool> checkExistingAttendance(String keyNum, int eventId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendances',
      where: 'keyNum = ? AND events_id = ?',
      whereArgs: [keyNum, eventId],
    );
    return maps.isNotEmpty;
  }

  Future<List<Members>> members() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> memberMaps = await db.query(
      'members',
      where: 'colombe = ?',
      whereArgs: [0],
    );

    List<Members> dataList =
    memberMaps.map((map) => Members.fromJson(map)).toList();
    await db.close();
    print(dataList);
    return dataList;
  }

  Future<List<Members>> getMembers({bool colombe = false, String? keyNum}) async {
    final db = await database;
    final where = colombe ? 'colombe = ?' : 'colombe = ?';
    final whereArgs = colombe ? [1] : [0];

    if (keyNum != null && keyNum.isNotEmpty) {
      return (await db.query(
        'members',
        where: '$where AND keyNum LIKE ?',
        whereArgs: [...whereArgs, '$keyNum%'],
      )).map((map) => Members.fromJson(map)).toList();
    }

    return (await db.query(
      'members',
      where: where,
      whereArgs: whereArgs,
    )).map((map) => Members.fromJson(map)).toList();
  }

  // Event operations
  Future<int> insertEvent(EventsDetails event) async {
    final db = await database;
    return await db.insert(
      'events',
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> editEvent(int id, EventsDetails event) async {
    final db = await database;
    return await db.update(
      'events',
      event.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<EventsDetails>> getEvents() async {
    final db = await database;
    return (await db.rawQuery('SELECT * FROM events ORDER BY id DESC'))
        .map((map) => EventsDetails.fromJson(map))
        .toList();
  }

  Future<List<EventsDetails>> getEvent(int id) async {
    final db = await database;
    return (await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    )).map((map) => EventsDetails.fromJson(map)).toList();
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    await db.delete(
      'attendances',
      where: 'events_id = ?',
      whereArgs: [id],
    );
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Attendance operations
  // In your DatabaseHelper class
  Future<int> markAttendance(Attendances attendance) async {
    final db = await database;

    // First check if attendance already exists
    final existing = await db.query(
      'attendances',
      where: 'keyNum = ? AND events_id = ? AND gender = ?',
      whereArgs: [attendance.keyNum, attendance.eventID, attendance.gender],
    );

    if (existing.isNotEmpty) {
      return 0; // 0 means already exists
    }

    // If not exists, insert new record
    final id = await db.insert('attendances', attendance.toMap());
    return id > 0 ? 1 : -1; // 1 = success, -1 = failure
  }

  Future<int> deleteAttendee(Attendances attendee) async {
    final db = await database;
    return await db.delete(
      'attendances',
      where: 'events_id = ? AND keynum = ? AND gender = ?',
      whereArgs: [attendee.eventID, attendee.keyNum, attendee.gender],
    );
  }

  Future<List<Attendances>> checkAttendMember(Attendances attendee) async {
    final db = await database;
    return (await db.query(
      'attendances',
      where: 'events_id = ? AND keynum = ? AND gender = ?',
      whereArgs: [attendee.eventID, attendee.keyNum, attendee.gender],
    )).map((map) => Attendances.fromJson(map)).toList();
  }

  Future<List<MemberAttendance>> getEventMembers(int id, String sortOrder) async {
    final db = await database;
    return (await db.rawQuery('''
      SELECT DISTINCT members.*, attendances.*
      FROM attendances
      JOIN members ON attendances.keyNum = members.keyNum AND attendances.gender = members.gender
      WHERE attendances.events_id = ?
      ORDER BY 
        attendances.attendance_office IS NULL,
        attendances.attendance_office,
        attendances.id ${sortOrder.toUpperCase() == 'ASC' ? 'ASC' : 'DESC'}
    ''', [id])).map((map) => MemberAttendance.fromMap(map)).toList();
  }

  Future<List<MemberAttendance>> getEntryMembers(int id, String sortOrder) async {
    final db = await database;
    return (await db.rawQuery('''
      SELECT DISTINCT members.*, attendances.*
      FROM attendances
      JOIN members ON attendances.keyNum = members.keyNum AND attendances.gender = members.gender
      WHERE attendances.events_id = ?
      ORDER BY
        attendances.id ${sortOrder.toUpperCase() == 'ASC' ? 'ASC' : 'DESC'}
    ''', [id])).map((map) => MemberAttendance.fromMap(map)).toList();
  }

  // Event Types operations
  Future<int> insertEventTypes(EventTypes eventType) async {
    final db = await database;
    return await db.insert(
      'event_types',
      eventType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteEventType(int id) async {
    final db = await database;
    return await db.delete(
      'event_types',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Count operations
  Future<int> getAttendeeCount(int id, String gender) async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery(
      "SELECT COUNT(*) FROM attendances JOIN members ON attendances.keyNum = members.keyNum AND attendances.gender = members.gender WHERE attendances.events_id = ? AND members.gender = ?",
      [id, gender],
    )) ?? 0;
  }

  Future<int> getCandidateCount(int id, int candidate) async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery(
      "SELECT COUNT(*) FROM attendances JOIN members ON attendances.keyNum = members.keyNum AND attendances.gender = members.gender WHERE attendances.events_id = ? AND attendances.attendance_office = ?",
      [id, candidate],
    )) ?? 0;
  }

  Future<int> getColombeAttendeeCount(int id) async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery(
      "SELECT COUNT(*) FROM attendances JOIN members ON attendances.keyNum = members.keyNum AND attendances.gender = members.gender WHERE attendances.events_id = ? AND members.colombe = 1",
      [id],
    )) ?? 0;
  }

  Future<int> getMemberCount(String gender) async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery(
      "SELECT COUNT(*) FROM members WHERE gender = ?",
      [gender],
    )) ?? 0;
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}