import 'package:attendance/models/membersRecords.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constants.dart';
import '../../../data/sqlite.dart';



class MembersRecord extends StatefulWidget {
  MembersRecord({super.key});
  DatabaseHelper db = DatabaseHelper();



  @override
  State<MembersRecord> createState() => _MembersRecordState();
}

class _MembersRecordState extends State<MembersRecord> {
  // List<Members> demoRecentFiles = [];
  static const String deleteMember = '';
  static const String editMember = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Members>>(
      future: getMembers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is being fetched, display a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurs during data fetching, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // If data fetching is successful, build the UI with the retrieved data
          List<Members> demoRecentFiles = snapshot.data ?? [];

          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Attendances",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: const [
                      DataColumn(label: Text("S/N")),
                      DataColumn(label: Text("Key Number")),
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("AB")),
                      DataColumn(label: Text("TMO")),
                      DataColumn(label: Text("Office")),
                      DataColumn(label: Text(deleteMember)),
                      DataColumn(label: Text(editMember)),
                      // DataColumn(label: Text("Office")),
                      // DataColumn(label: Text("Degree")),
                    ],
                    rows: List.generate(
                      demoRecentFiles.length,
                          (index) => recentFileDataRow(demoRecentFiles[index], index + 1),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<List<Members>> getMembers() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Get all data from the SQLite database
    List<Members> membersList = await dbHelper.members();
    // demoRecentFiles = membersList;

    return membersList;
  }





DataRow recentFileDataRow(Members member, int count) {
  TextEditingController degreeController = TextEditingController();
  TextEditingController officeController = TextEditingController();
  TextEditingController tmoController = TextEditingController();

  List<DropdownMenuEntry<String>> dropdownMenuAB = [
    const DropdownMenuEntry(value: '', label: ''),
    // const DropdownMenuEntry( child: Text(''), label: ''),
    for (var entry in eventCats.entries)
      DropdownMenuEntry(value:  entry.key.toString(), label: entry.value),
    // DropdownMenuItem(value: entry.key as String, child: Text(entry.value)),
  ];
  List<DropdownMenuEntry<String>> dropdownMenuYesNo = [
    const DropdownMenuEntry(value: '', label: ''),
    // const DropdownMenuEntry( child: Text(''), label: ''),
    for (var entry in eventCats.entries)
      DropdownMenuEntry(value:  entry.key.toString(), label: entry.value),
    // DropdownMenuItem(value: entry.key as String, child: Text(entry.value)),
  ];
  return DataRow(
    cells: [
      DataCell(Text('$count')),
      DataCell(
        Row(
          children: [
            member.gender == 'Female' ? SvgPicture.asset(
              "assets/icons/female.svg",
                height: 30,
                width: 30,
                color: Colors.pinkAccent,
              )
            :
              SvgPicture.asset(
                "assets/icons/male.svg",
                height: 30,
                width: 30,
                color: Colors.blueGrey,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(member.keyNum),
            ),
          ],
        ),
      ),
      DataCell(Text('${member.firstName} ${member.lastName}')),
      DataCell(Text(ABs[member.ab]!)),
      DataCell( member.tmo == 1 ?
        SvgPicture.asset(
          "assets/icons/accept.svg",
          height: 30,
          width: 30,
          color: Colors.greenAccent,
        ) : SvgPicture.asset(
        "assets/icons/cross.svg",
        height: 30,
        width: 30,
        color: Colors.redAccent,
      ),
      ),
      DataCell(Text(member.office ?? 'Member')),
      DataCell(GestureDetector(
          onTap: () async {

            // Attendances attendance = Attendances(keyNum: member.keyNum, gender: member.gender, eventID: widget.event.id??0);
            // List<Attendances> checkAttend = await widget.db.checkAttendMember(attendance);
            print('Check Attendee: ${member.id}');
            // widget.db.deleteAttendee();
            Alert(
              context: context,
              type: AlertType.info,
              title: "Confirm Deletion",
              desc: "Are you sure you want to delete this member?\n Key Number: ${member.keyNum}, ${member.firstName}  ${member.lastName}",
              style: const AlertStyle(titleStyle: TextStyle(color: Colors.white), descStyle: TextStyle(color:Colors.blueGrey)),
              buttons: [
                DialogButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DialogButton(
                  color: Colors.redAccent,
                  onPressed: () async {
                    // Perform deletion
                    // print('Check Attendee: ${checkAttend[0].id}');
                    int success = await widget.db.deleteMember(member.id??0);
                    // Show alert for successful deletion

                    // Close the dialog
                    Navigator.pop(context);
                    if(success != 0) {
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Success",
                        desc: "Member deleted successfully",
                        style: const AlertStyle(
                          titleStyle: TextStyle(color: Colors.white),
                          descStyle: TextStyle(color: Colors.white),
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the alert
                            },
                            color: Colors.greenAccent,
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ).show();
                      setState(() {

                      });
                    }
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ).show();
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return AlertDialog(
            //       title: Text("Confirm Deletion"),
            //       content: Text("Are you sure you want to delete this attendee?\n key Number: ${attendance.keyNum}, ${attendance.gender}"),
            //       actions: [
            //         TextButton(
            //           onPressed: () {
            //             Navigator.pop(context); // Close the dialog
            //           },
            //           child: Text("Cancel"),
            //         ),
            //         TextButton(
            //           onPressed: () async {
            //             // Perform deletion
            //             print('Check Attendee: ${checkAttend[0].id}');
            //             // await widget.db.deleteAttendee(attendance);
            //             // Close the dialog
            //             Navigator.pop(context);
            //           },
            //           child: Text("Delete"),
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
          child: const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ))),
      DataCell(GestureDetector(
          onTap: () async {

            // Attendances attendance = Attendances(keyNum: member.keyNum, gender: member.gender, eventID: widget.event.id??0);
            // List<Attendances> checkAttend = await widget.db.checkAttendMember(attendance);
            print('Check Attendee: ${member.id}');
            // widget.db.deleteAttendee();
            Alert(
              context: context,
              type: AlertType.info,
              title: "Edit ",
              desc: "Are you sure you want to edit this member?\n Key Number: ${member.keyNum}, ${member.firstName}  ${member.lastName}",
              style: const AlertStyle(titleStyle: TextStyle(color: Colors.white), descStyle: TextStyle(color:Colors.blueGrey)),
              content:SizedBox(
                height: 300.0,
                width: 250.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Office',
                          icon: Icon(FontAwesomeIcons.ankh),
                        ),
                        value: officeController.text,
                        onChanged: (value) {
                          setState(() {
                            officeController.text = value!;
                          });
                        },
                        items: dropdownMenuAB.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.value,
                            child: Text(entry.label),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'TMO?',
                          icon: Icon(FontAwesomeIcons.ankh),
                        ),
                        value: tmoController.text,
                        onChanged: (value) {
                          setState(() {
                            tmoController.text = value!;
                          });
                        },
                        items: dropdownMenuYesNo.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.value,
                            child: Text(entry.label),
                          );
                        }).toList(),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Office',
                          icon: Icon(FontAwesomeIcons.person),),
                        controller: officeController,
                      ),
                    ),
                    // const ButtonBar()

                    // ElevatedButton(onPressed: (){}, child: const Text('Enter'))

                  ],
                ),
              ),
              buttons: [
                DialogButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DialogButton(
                  color: Colors.blueAccent,
                  onPressed: () async {
                    // Perform deletion
                    // print('Check Attendee: ${checkAttend[0].id}');
                    int success = await widget.db.updateMember(member);
                    // Show alert for successful deletion

                    // Close the dialog
                    Navigator.pop(context);
                    if(success != 0) {
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Success",
                        desc: "Member deleted successfully",
                        style: const AlertStyle(
                          titleStyle: TextStyle(color: Colors.white),
                          descStyle: TextStyle(color: Colors.white),
                        ),

                        buttons: [
                          DialogButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the alert
                            },
                            color: Colors.greenAccent,
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ).show();
                      setState(() {

                      });
                    }
                  },
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ).show();
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return AlertDialog(
            //       title: Text("Confirm Deletion"),
            //       content: Text("Are you sure you want to delete this attendee?\n key Number: ${attendance.keyNum}, ${attendance.gender}"),
            //       actions: [
            //         TextButton(
            //           onPressed: () {
            //             Navigator.pop(context); // Close the dialog
            //           },
            //           child: Text("Cancel"),
            //         ),
            //         TextButton(
            //           onPressed: () async {
            //             // Perform deletion
            //             print('Check Attendee: ${checkAttend[0].id}');
            //             // await widget.db.deleteAttendee(attendance);
            //             // Close the dialog
            //             Navigator.pop(context);
            //           },
            //           child: Text("Delete"),
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
          child: const Icon(
            Icons.edit,
            color: Colors.blueGrey,
          ))),
      // DataCell(Text(member.office)),
      // DataCell(Text(member.degree)),
    ],
  );
}
}


// class RecentFiles extends StatelessWidget {
//   const RecentFiles({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Members>>(
//       future: getMembers(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // While data is being fetched, display a loading indicator
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // If an error occurs during data fetching, display an error message
//           return Text('Error: ${snapshot.error}');
//         } else {
//           // If data fetching is successful, build the UI with the retrieved data
//           List<Members> demoRecentFiles = snapshot.data ?? [];
//
//           return Container(
//             padding: const EdgeInsets.all(defaultPadding),
//             decoration: const BoxDecoration(
//               color: secondaryColor,
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Recent Attendances",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 SizedBox(
//                   width: double.infinity,
//                   child: DataTable(
//                     columnSpacing: defaultPadding,
//                     columns: const [
//                       DataColumn(label: Text("Key Number")),
//                       DataColumn(label: Text("Name")),
//                       // DataColumn(label: Text("AB")),
//                       DataColumn(label: Text("TMO")),
//                       // DataColumn(label: Text("Office")),
//                       // DataColumn(label: Text("Degree")),
//                     ],
//                     rows: List.generate(
//                       demoRecentFiles.length,
//                           (index) => recentFileDataRow(demoRecentFiles[index]),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
//
//   Future<List<Members>> getMembers() async {
//     DatabaseHelper dbHelper = DatabaseHelper();
//
//     // Get all data from the SQLite database
//     List<Members> membersList = (await dbHelper.members()).cast<Members>();
//     // demoRecentFiles = membersList;
//
//     return membersList;
//   }
//
//   // Replace this with your actual implementation
//   DataRow recentFileDataRow(Members member) {
//     return DataRow(
//       cells: [
//         DataCell(Text(member.keyNum)),
//         DataCell(Text('${member.firstName} ${member.lastName}' )),
//         // DataCell(Text(member.ab as String)),
//         DataCell(Text(member.tmo as String)),
//         // DataCell(Text(member.phoneNum)),
//         // DataCell(Text(member.degree)),
//       ],
//     );
//   }
// }

