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
  late Database dbasql;
  static const int _version = 3;
  static const String _dbName = 'membersAttendance.db';

  // static Future<Database> _getDB() async{
  //   return openDatabase(join(await getDatabasesPath(), _dbName),
  //     onCreate: (db, version) async =>
  //   await db.execute("CREATE TABLE MEMBERS(id INTEGER PRIMARY KEY, firstName TEXT NOT NULL, lastName TEXT NOT NULL, middleName TEXT NULL, keyNum TEXT NOT NULL, gender TEXT NOT NULL, ab TEXT NOT NULL, gca TEXT NULL, office TEXT NOT NULL, degree TEXT NULL, tmo TEXT NOT NULL"),
  //   version: _version);
  //
  // }

   open() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    print('hello data link :${await getDatabasesPath()}');
    // Open the database and store the reference.
    dbasql = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), _dbName),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(''' CREATE TABLE members(
            id INTEGER NOT NULL,
            "firstName" TEXT NOT NULL,
            "lastName" TEXT NOT NULL,
            "middleName" TEXT NOT NULL,
            "keyNum" TEXT NOT NULL,
            gender TEXT NOT NULL,
             phoneNumber TEXT NULL,
            email TEXT NULL,
            gca_id INTEGER,
            ab_id INTEGER,
            office TEXT,
            degree TEXT,
             affiliatedNum INTEGER NULL,
             natalDay TEXT,
            tmo INTEGER DEFAULT 0,
            colombe INTEGER DEFAULT 0,
            late INTEGER DEFAULT 0,
            dob DATE NULL,
            PRIMARY KEY(id),
            CONSTRAINT members_ak_1 UNIQUE("keyNum", gender),
            CONSTRAINT gca_members FOREIGN KEY (gca_id) REFERENCES gca (id),
            CONSTRAINT ab_members FOREIGN KEY (ab_id) REFERENCES ab (id)
          );
          
             CREATE TABLE ab(
            id INTEGER NOT NULL,
            gca_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            PRIMARY KEY(id),
            CONSTRAINT gca_ab FOREIGN KEY (gca_id) REFERENCES gca (id)
          );
          
         CREATE TABLE attendances (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              keyNum TEXT NOT NULL,
              gender TEXT NOT NULL,
              attendance_office INTEGER NOT NULL,
              events_id INTEGER NOT NULL,
              entry_time TEXT, -- Change the type to TEXT
              CONSTRAINT events_attendances FOREIGN KEY (events_id) REFERENCES events (id),
              CONSTRAINT keyNum_keyNum FOREIGN KEY (keyNum) REFERENCES members (keyNum),
              CONSTRAINT keyNum_gender_events_id_unique UNIQUE (keyNum, gender, events_id)
          );
          
          -- Create trigger to set entry_time to current date time on insert
          CREATE TRIGGER set_entry_time_on_insert
          AFTER INSERT ON attendances
          BEGIN
              UPDATE attendances
              SET entry_time = DATETIME('now')
              WHERE id = NEW.id;
          END;


          
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
          );
          
          CREATE TABLE event_types(id INTEGER NOT NULL, event_type TEXT NOT NULL, PRIMARY KEY(id));
          
          CREATE TABLE events(
            id INTEGER NOT NULL,
            event_types_id INTEGER NOT NULL,
            speaker TEXT NOT NULL,
            time DATE NOT NULL,
            date DATE NOT NULL,
            PRIMARY KEY(id),
            CONSTRAINT event_types_events
              FOREIGN KEY (event_types_id) REFERENCES event_types (id)
          );
          
          CREATE TABLE gca(id INTEGER NOT NULL, name TEXT NOT NULL, PRIMARY KEY(id));
                   
          CREATE TABLE settings(
            id INTEGER NOT NULL,
            gca_id INTEGER NOT NULL,
            ab_id INTEGER NOT NULL,
            "userName" TEXT NOT NULL,
            max_desktop INTEGER NULL,
            PRIMARY KEY(id),
            CONSTRAINT gca_settings FOREIGN KEY (gca_id) REFERENCES gca (id),
            CONSTRAINT ab_settings FOREIGN KEY (ab_id) REFERENCES ab (id)
          );
          INSERT INTO settings (gca_id, ab_id, userName, max_desktop)
          VALUES (1, 1, 'SuchTree', 20); ''');
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: _version,
    );
  }

  Future<dynamic> setSettings(SettingsLoad setting) async {
    // Get a reference to the database.
    await open();

    var callBack = await dbasql.update(
      'settings',
      setting.toJson(),
      // Ensure that the Member has a matching id.
      where: 'id = ?',
      // Pass the Member's id as a whereArg to prevent SQL injection.
      whereArgs: [1],
    );
    // if (callBack != 0) {
    //   callBack = await dbasql.insert(
    //     'settings',
    //     setting.toJson(),
    //     conflictAlgorithm: ConflictAlgorithm.replace,
    //   );
    // }

    await dbasql.close();
    return callBack;
  }
  Future<SettingsLoad?> getSetting() async {
    try {
      // Open the database.
      await open();

      // Perform the query.
      final result = await dbasql.query(
        'settings',
        where: 'id = ?',
        whereArgs: [1],
      );

      // Close the database.
      await dbasql.close();

      // Check if the query returned any results.
      if (result.isNotEmpty) {
        // If the query returned results, convert the first row to a SettingsLoad object.
        return SettingsLoad.fromJson(result.first);
      } else {
        // If the query returned no results, return null.
        return null;
      }
    } catch (e) {
      // Handle any exceptions that occur during database operations.
      print('Error fetching setting: $e');
      return null;
    }
  }


  Future<dynamic> insertMember(Members member) async {
    // Get a reference to the database.
    await open();

    var numID = await dbasql.insert(
      'members',
      member.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await dbasql.close();
    return numID;
  }

  Future<dynamic> insertColombe(Members member) async {
    // Get a reference to the database.
    await open();

    var numID = await dbasql.insert(
      'members',
      member.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await dbasql.close();
    return numID;
  }

  // A method that retrieves all the dogs from the members table.
  Future<List<Members>> members() async {
    // Get a reference to the database.
    await open();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> memberMaps = await dbasql.query(
      'members',
      where: 'colombe = ?',
      whereArgs: [0],
    );

    List<Members> dataList =
        memberMaps.map((map) => Members.fromJson(map)).toList();
    await dbasql.close();
    print(dataList);
    return dataList;
  }

  Future<List<Members>> colombe() async {
    // Get a reference to the database.
    await open();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> memberMaps = await dbasql.query(
      'members',
      where: 'colombe = ?',
      whereArgs: [1],
    );

    List<Members> dataList =
    memberMaps.map((map) => Members.fromJson(map)).toList();
    await dbasql.close();
    print(dataList);
    return dataList;
  }

  Future<List<Members>> getMembers(String keyNum) async {
    // Get a reference to the database.
    await open();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> memberMaps =
    await dbasql.query(
      'members',
      where: 'keyNum LIKE ?',
      whereArgs: ['$keyNum%'], // Begins with `keyNum`
    );

    List<Members> dataList =
        memberMaps.map((map) => Members.fromJson(map)).toList();
    await dbasql.close();
    // print(dataList);
    return dataList;
  }

  Future<List<MemberAttendance>> getEventMembers(int id, String sortOrder) async {
    // Get a reference to the database.
    await open();

    // Define the order based on the sortOrder parameter
    String orderBy = sortOrder.toUpperCase() == 'ASC' ? 'ASC' : 'DESC';

    // Query the table for all the dogs.
    final List<Map<String, Object?>> memberMaps = await dbasql.rawQuery('''
  SELECT DISTINCT members.*, attendances.*
  FROM attendances
  JOIN members ON attendances.keyNum = members.keyNum AND attendances.gender = members.gender
  WHERE attendances.events_id = ?
  ORDER BY 
    attendances.attendance_office IS NULL,  -- FALSE (0) comes before TRUE (1)
    attendances.attendance_office,
    attendances.id $orderBy 
''', [id]);

    List<MemberAttendance> dataList =
        memberMaps.map((map) => MemberAttendance.fromMap(map)).toList();
    await dbasql.close();
    print(dataList);
    return dataList;
  }

  Future<List<Attendances>> checkAttendMember(Attendances attendee) async {
    // Get a reference to the database.
    await open();

    String gender = attendee.gender;
    String keyNum = attendee.keyNum;
    int id = attendee.eventID;

    final List<Map<String, Object?>> memberMaps = await dbasql.rawQuery(
      '''
    SELECT *
    FROM attendances
    WHERE attendances.events_id = ? and attendances.keynum = ? and attendances.gender = ?
    ''',
      [id, keyNum, gender],
    );

    List<Attendances> dataList =
        memberMaps.map((map) => Attendances.fromJson(map)).toList();
    await dbasql.close();
    return dataList;
  }

  // Future<List<Members>> checkEventMembers(int id, String keyNum) async {
  //   // Get a reference to the database.
  //   await open();
  //
  //   // Query the table for all the dogs.
  //   // final List<Map<String, Object?>> memberMaps = await db.query('attendances', where: 'events_id = ?', whereArgs: [id]);
  //   final List<Map<String, Object?>> memberMaps = await db.rawQuery('''
  //     SELECT members.*
  //     FROM attendances
  //     JOIN members ON attendances.keyNum = members.keyNum
  //     WHERE attendances.events_id = ?
  //   ''', [id]);
  //
  //
  //
  //   List<Members> dataList = memberMaps.map((map) => Members.fromJson(map)).toList();
  //   await db.close();
  //   print(dataList);
  //   return dataList;
  //
  //
  // }

  Future<int> updateMember(Members member) async {
    // Get a reference to the database.
    await open();

    // Update the given Member.
    await dbasql.update(
      'members',
      member.toJson(),
      // Ensure that the Member has a matching id.
      where: 'id = ?',
      // Pass the Member's id as a whereArg to prevent SQL injection.
      whereArgs: [member.id],
    );
    await dbasql.close();
    return 1;
  }

  Future<int> deleteMember(int id) async {
    // Get a reference to the database.
    await open();

    // Remove the Member from the database.
    await dbasql.delete(
      'members',
      where: 'id = ?',
      // Pass the Member's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    await dbasql.close();
    return 1;
  }

  Future<int> markAttendances(Attendances attendance) async {
    // Get a reference to the database.
    await open();

    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await dbasql.insert(
      'attendances',
      attendance.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await dbasql.close();
    return 1;
  }

  Future<int> deleteAttendee(Attendances attendee) async {
    // Get a reference to the database.
    await open();

    final int rowsAffected = await dbasql.delete(
      'attendances',
      where: 'events_id = ? AND keynum = ? AND gender = ?',
      whereArgs: [attendee.eventID, attendee.keyNum, attendee.gender],
    );

    await dbasql.close();
    print(rowsAffected);
    return rowsAffected;
  }

  Future<int> insertEvent(EventsDetails event) async {
    // Get a reference to the database.
    await open();

    var idNum = await dbasql.insert(
      'events',
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await dbasql.close();
    return idNum;
  }

  Future<int> editEvent(int id, EventsDetails event) async {
    // Get a reference to the database.
    await open();

    var idNum = await dbasql.update(
      'events',
      event.toJson(),
      where: 'id = ?',
      whereArgs: [id],
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await dbasql.close();
    return idNum;
  }

  // Future<List<Members>> getEvents() async {
  //   // Get a reference to the database.
  //   await open();
  //
  //   // Query the table for all the dogs.
  //   final List<Map<String, Object?>> memberMaps = await db.query('members', where: 'keyNum = ?', whereArgs: [keyNum]);
  //
  //   List<Members> dataList = memberMaps.map((map) => Members.fromJson(map)).toList();
  //   await db.close();
  //   print(dataList);
  //   return dataList;
  //
  //
  // }

  // Future<int> deleteEvent(int id) async {
  //   // Get a reference to the database.
  //   await open();
  //
  //
  //   final int success = await db.delete('events', where: 'id = ?', whereArgs: [id]);
  //
  //
  //   await db.close();
  //   print(success);
  //   return success;
  //
  //
  // }

  Future<List<EventsDetails>> getEvent(int id) async {
    // Get a reference to the database.
    await open();

    final List<Map<String, Object?>> eventMaps =
        await dbasql.query('events', where: 'id = ?', whereArgs: [id]);

    List<EventsDetails> dataList =
        eventMaps.map((map) => EventsDetails.fromJson(map)).toList();
    await dbasql.close();
    print(dataList);
    return dataList;
  }

  Future<List<EventsDetails>> getEvents() async {
    // Get a reference to the database.
    await open();

    // Query the table for all the events ordered by ID in descending order.
    final List<Map<String, Object?>> eventMaps = await dbasql.rawQuery('''
    SELECT *
    FROM events
    ORDER BY id DESC
  ''');

    List<EventsDetails> dataList =
        eventMaps.map((map) => EventsDetails.fromJson(map)).toList();
    await dbasql.close();
    print(dataList);
    return dataList;
  }

  Future<int> deleteEvent(int id) async {
    // Get a reference to the database.
    await open();

    int successEvent = await dbasql.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
    int successAttend = await dbasql.delete(
      'attendances',
      where: 'events_id = ?',
      whereArgs: [id],
    );
    await dbasql.close();
    int success = successEvent > 0 && successAttend > 0 ? 1 : 0;
    return success;
  }

  Future<int> insertEventTypes(EventTypes eventType) async {
    // Get a reference to the database.
    final db = await open();

    await db.insert(
      'event_types',
      eventType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.close();
    return 1;
  }

  Future<int> deleteEventType(int id) async {
    dbasql = await open();

    await dbasql.delete(
      'event_types',
      where: 'id = ?',
      whereArgs: [id],
    );
    await dbasql.close();
    return 1;
  }

  Future<int> getAttendeeCount(int id, String gender) async {
    // Open the database
    await open();
    // attendances.keyNum = members.keyNum
    // Query the number of attendees from the table
    int num = Sqflite.firstIntValue(await dbasql.rawQuery(
        "SELECT DISTINCT COUNT(*) FROM attendances JOIN members ON attendances.keyNum = members.keyNum and attendances.gender = members.gender WHERE attendances.events_id = '$id' AND members.gender = '$gender'"))!;

    // Close the database
    print('$gender $num');
    await dbasql.close();

    return num;
  }

  Future<int> getCandidateCount(int id, candidate) async {
    // Open the database
    await open();
    // attendances.keyNum = members.keyNum
    // Query the number of attendees from the table
    int num = Sqflite.firstIntValue(await dbasql.rawQuery(
        "SELECT DISTINCT COUNT(*) FROM attendances JOIN members ON attendances.keyNum = members.keyNum and attendances.gender = members.gender WHERE attendances.events_id = '$id' AND attendances.attendance_office = '$candidate'"))!;

    // Close the database
    // print('$gender $num');
    await dbasql.close();

    return num;
  }

  Future<int> getColombeAttendeeCount(int id) async {
    // Open the database
    await open();

    // Query the number of attendees from the table
    int num = Sqflite.firstIntValue(await dbasql.rawQuery(
        "SELECT DISTINCT COUNT(*) FROM attendances JOIN members ON attendances.keyNum = members.keyNum and attendances.gender = members.gender WHERE attendances.events_id = ? AND members.colombe = 1",
        [id]))!;
    // Close the database
    print('colombe $num');
    // await dbasql.close();

    return num;
  }
  // SELECT DISTINCT members.*
  // FROM attendances
  // JOIN members ON attendances.keyNum = members.keyNum
  // WHERE attendances.events_id = ?

  Future<int> getMemberCount(String gender) async {
    await open();

    // Query the number of males from the table

    int num = Sqflite.firstIntValue(await dbasql
        .rawQuery("SELECT COUNT(*) FROM members WHERE gender = ?", [gender]))!;
    await dbasql.close();
    return num;
  }
}
// }
