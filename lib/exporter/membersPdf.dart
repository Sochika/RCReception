// import 'dart:io';

import 'package:attendance/models/events.dart';


import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


import '../../../constants.dart';
import '../../../data/sqlite.dart';
import '../../exporter/pdfExporter.dart';
import '../models/MemberAttendance.dart';


class MembersRecordPDF extends StatefulWidget {
  const MembersRecordPDF({Key? key, required this.event}) : super(key: key);
  final EventsDetails event;

  @override
  State<MembersRecordPDF> createState() => _MembersRecordState();
}

class _MembersRecordState extends State<MembersRecordPDF> {
  List<List<String>>? attendanceData; // Store attendance data here
  int maleCount = 0;
  int femaleCount = 0;
  int colombeCount = 0;
  int candidateCount = 0;
  int count = 1;
  // var countM = {'male':maleCount, };

  @override
  void initState() {
    super.initState();
    fetchAttendanceData(); // Fetch attendance data when the widget initializes
  }

  void fetchAttendanceData() async {
    try {
      List<List<String>> data = await getAttendance(widget.event.id ?? 0);
      DatabaseHelper db = DatabaseHelper();
      int femaleC = await db.getAttendeeCount(widget.event.id!, female);
      int colombeC = await db.getColombeAttendeeCount(widget.event.id!);
      int maleC = await db.getAttendeeCount(widget.event.id!, male);
      int candidateC = await db.getCandidateCount(widget.event.id!, candidate);
      setState(() {
        attendanceData = data;
        femaleCount = femaleC;
        colombeCount = colombeC;
        maleCount = maleC;
        candidateCount = candidateC;
      });
    } catch (error) {
      print('Error fetching attendance data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var ab = '${eventCats[widget.event.event_typeID]} Attendances on ${widget.event.date}'.toUpperCase();
    var docTitle = '${widget.event.date}${eventCats[widget.event.event_typeID]}';
    return FutureBuilder<List<List<String>>>(
      future: attendanceData != null ? Future.value(attendanceData) : getAttendance(widget.event.id ?? 0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<List<String>> attendanceData = snapshot.data ?? [];

          // Build UI using attendanceData
          // For example:
          return ElevatedButton.icon(
            onPressed: () async {
              // attendanceData.insert(0, ['S/N', 'Key Number', 'Name', 'AB', 'TMO', 'Office']); // Add header
              try {
                String? filePath = await PdfExporter(data: attendanceData, title: ab, docTitle: docTitle, maleCount: maleCount, femaleCount: femaleCount, colombeCount: colombeCount, candidateCount: candidateCount);
                if (filePath != null) {
                  showExportAlert(context, filePath);
                } else {
                  // String result = await setAttendanceFolder();
                  // final pdf = pw.Document();
                  //   String filePath2 = '$result\\$docTitle.pdf';
                    // final file = File(filePath2);
                    // await file.writeAsBytes(await pdf.save());
                  // print(filePath2);
                  showFailedExportAlert(context, 'patherror: $filePath saved at Documents instead');
                }
              } catch (error) {
                print('Error exporting PDF: $error');
                // print(filePath);
                showFailedExportAlert(context, 'error:$error');
              }

            },
            icon: const Icon(Icons.arrow_downward),
            label: const Text("PDF"),
          );
        }
      },
    );
  }

  Future<List<List<String>>> getAttendance(int eventID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<MemberAttendance> members = await dbHelper.getEventMembers(eventID, 'ASC');
    print("Event id $eventID");

    // Convert Members data to List<List<String>>
    List<List<String>> attendanceData = members.map((member) {
      String? memOffice =  member.attendance.office != 0 ? Office[member.attendance.office] : member.member.office;
      List<String> rowData = [
        count.toString(), // Assuming count is the serial number
        member.member.colombe == 0 ? member.member.keyNum : member.member.office,
        '${member.member.colombe == 0 ? member.member.gender == 'Male' ? 'Fr.' : 'Sr.' : member.member.office} ${member.member.firstName} ${member.member.lastName}',
        ABs[member.member.ab] ?? '', // Assuming ABs is a map
        member.member.tmo == 1 ? 'Yes' : 'No', // Assuming tmo is a boolean
      member.member.ab == settingConst.abID ? '' : 'Yes',
        memOffice ?? "Member"
      ];

      count++; // Increment count for the next member
      return rowData;
    }).toList();

    return attendanceData;
  }

  void showExportAlert(BuildContext context, String filePath) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Exported Successful",
      desc: "PDF file exported successfully to:\n$filePath",
      style: const AlertStyle(titleStyle: TextStyle(color: Colors.green), descStyle: TextStyle(color:Colors.white)),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }
  void showFailedExportAlert(BuildContext context, String error) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Export Failed",
      desc: "PDF File did not Export.\nPlease Close the Previous Open Export from the same folder\n $error",
      style: const AlertStyle(titleStyle: TextStyle(color: Colors.redAccent), descStyle: TextStyle(color:Colors.white)),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }
}
