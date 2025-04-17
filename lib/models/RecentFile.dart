import 'package:attendance/models/membersRecords.dart';

import '../data/sqlite.dart';

class RecentFile {
  final String? icon, keyNum, name, ab, tmo, office, degree;

  RecentFile({this.icon, this.keyNum, this.name, this.ab, this.tmo, this.office, this.degree});
  // List? getMembersList;
  // Future<List> getMembers() async {
  //   var db =DatabaseHelper();
  //   return await db.members();
  // }
  // getMembersList = getMembers();

}
// late List<Members> demoRecentFiles;
Future<List<Members>> getMembers() async {
  DatabaseHelper dbHelper = DatabaseHelper();

  // Get all data from the SQLite database
    List<Members> membersList = await dbHelper.members();
  // demoRecentFiles = membersList;

    return membersList;
  }

// List<Members> demoRecentFiles = getMembers() as List<Members>;

// void memFunc() async {
//   List demoRecentFiles  = await getMembers();
// }

// mixin dataList {
// }
// [
//   // for (var data in dataList) {
//   //   print('Row: $data');
//   //   RecentFile(
//   //     icon: "assets/icons/male.svg",
//   //     keyNum: data['keyNum'],
//   //     name: "$data['keyNum'] $data['keyNum']",
//   //     ab: "Thales",
//   //     tmo: "assets/icons/accept.svg",
//   //     office: "member",
//   //     degree: "9+",
//   //   );
//   // }
//
//   RecentFile(
//     icon: "assets/icons/male.svg",
//     keyNum: "124121",
//     name: "John Doe",
//     ab: "Thales",
//     tmo: "assets/icons/accept.svg",
//     office: "member",
//     degree: "9+",
//   ),
//   RecentFile(
//     icon: "assets/icons/female.svg",
//     keyNum: "422424",
//     name: "Jane Doe",
//     ab: "Thales",
//     tmo: "assets/icons/cross.svg",
//     office: "GC",
//     degree: "9+"
//   ),
//   RecentFile(
//     icon: "assets/icons/male.svg",
//     keyNum: "522424",
//     name: "John Doe",
//     ab: "Thales",
//     tmo: "assets/icons/accept.svg",
//     office: "member",
//     degree: "9+",
//   ),
//   RecentFile(
//     icon: "assets/icons/female.svg",
//     keyNum: "532422",
//     name: "John Doe",
//     ab: "Thales",
//     tmo: "assets/icons/cross.svg",
//     office: "member",
//     degree: "9+",
//   ),
//   RecentFile(
//     icon: "assets/icons/male.svg",
//     keyNum: "753255",
//     name: "John Doe",
//     ab: "Thales",
//     tmo: "assets/icons/cross.svg",
//     office: "member",
//     degree: "9+",
//   ),
//   RecentFile(
//     icon: "assets/icons/male.svg",
//     keyNum: "533522",
//     name: "John Doe",
//     ab: "Thales",
//     tmo: "assets/icons/accept.svg",
//     office: "member",
//     degree: "9+",
//   ),
//   RecentFile(
//     icon: "assets/icons/female.svg",
//     keyNum: "523254",
//     name: "John Doe",
//     ab: "Thales",
//     tmo: "assets/icons/accept.svg",
//     office: "member",
//     degree: "9+",
//   ),
// ];


