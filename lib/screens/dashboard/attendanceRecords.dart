import 'package:attendance/models/events.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constants.dart';
import '../../../data/sqlite.dart';
import '../../exporter/membersPdf.dart';

import '../../models/MemberAttendance.dart';
import '../../models/attendances.dart';

class MembersRecord extends StatefulWidget {
  const MembersRecord({Key? key, required this.event}) : super(key: key);
  final EventsDetails event;

  @override
  State<MembersRecord> createState() => _MembersRecordState();
}

class _MembersRecordState extends State<MembersRecord> {
  int count = 1;
  int maleCount = 0;
  int femaleCount = 0;
  int colombeCount = 0;
  int candidateCount = 0;
  late DatabaseHelper db;

  @override
  void initState() {
    super.initState();
    db = DatabaseHelper();
    fetchMemberCounts();
  }

  void fetchMemberCounts() async {
    int femaleCount = await db.getAttendeeCount(widget.event.id!, female);
    int maleCount = await db.getAttendeeCount(widget.event.id!, male);
    int colombeCount = await db.getColombeAttendeeCount(widget.event.id!);
    int candidateCount = await db.getCandidateCount(widget.event.id!, 17);
    setState(() {
      this.femaleCount = femaleCount;
      this.maleCount = maleCount;
      this.colombeCount = colombeCount;
      this.candidateCount = candidateCount;
    });
  }

  static const String deleteAttendee = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MemberAttendance>>(
      future: getAttendance(widget.event.id ?? 0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is being fetched, display a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurs during data fetching, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // If data fetching is successful, build the UI with the retrieved data
          List<MemberAttendance> demoRecentFiles = snapshot.data ?? [];

          count = demoRecentFiles.length;
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Attendances on ${widget.event.date}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Time: ${widget.event.time},",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Master: ${widget.event.speaker}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      MembersRecordPDF(event: widget.event,),
                      // ElevatedButton.icon(
                      //   onPressed: () async {
                      //     final List<List<String>> data = [
                      //       ['S/N', 'Key Number', 'Name', 'AB', 'TMO'],
                      //       // Add your data rows here
                      //     ];
                      //     await PdfExporter(data: data);
                      //     // await exporter.createPDF();
                      //     // Show a message or perform any other action after PDF creation
                      //   },
                      //   icon: const Icon(Icons.arrow_downward),
                      //   label: const Text("PDF"),
                      // ),

                    ],
                  ),
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
                      DataColumn(label: Text("Visitor")),
                      DataColumn(label: Text("Office")),
                      DataColumn(label: Text(deleteAttendee)),
                      // DataColumn(label: Text("Office")),
                      // DataColumn(label: Text("Degree")),
                    ],
                    rows: List.generate(
                      demoRecentFiles.length,
                          (index) => recentFileDataRow(demoRecentFiles[index], count--),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Attendees: ${maleCount + femaleCount}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Total Fraters: $maleCount",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Total Sorors: ${femaleCount - colombeCount}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Total Colombes: $colombeCount",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if(candidateCount > 0)
                        Text(
                          "Total Candidate: $candidateCount",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<List<MemberAttendance>> getAttendance(int eventID) async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Get all data from the SQLite database
    return dbHelper.getEntryMembers(eventID, 'DESC');
  }

  DataRow recentFileDataRow(MemberAttendance member, int count) {
    return DataRow(
      cells: [
        DataCell(Text('$count')),
        DataCell(
          Row(
            children: [
              if (member.member.gender == 'Female')
                SvgPicture.asset(
                  "assets/icons/female.svg",
                  height: 30,
                  width: 30,
                  color: Colors.pinkAccent,
                )
              else
                SvgPicture.asset(
                  "assets/icons/male.svg",
                  height: 30,
                  width: 30,
                  color: Colors.blueGrey,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(member.member.colombe == 0 ? member.member.keyNum : member.member.office),
              ),
            ],
          ),
        ),
        DataCell(Text('${member.member.colombe == 0 ? member.member.gender == 'Male' ? 'Fr.' : 'Sr.' : member.member.office} ${member.member.firstName} ${member.member.lastName}')),
        DataCell(Text(ABs[member.member.ab]!)),
        DataCell(
          member.member.tmo == 1
              ? SvgPicture.asset(
            "assets/icons/accept.svg",
            height: 30,
            width: 30,
            color: Colors.greenAccent,
          )
              : SvgPicture.asset(
            "assets/icons/cross.svg",
            height: 30,
            width: 30,
            color: Colors.redAccent,
          ),
        ),
        DataCell(Text(member.member.ab == settingConst.abID ? '' : 'Yes')),
        DataCell(Text(member.attendance.office != 0 ? Office[member.attendance.office]! : member.member.office)),
        DataCell(
          GestureDetector(
            onTap: () async {
              Attendances attendance = Attendances(keyNum: member.member.keyNum, gender: member.member.gender, office: 0, eventID: widget.event.id ?? 0);
              List<Attendances> checkAttend = await db.checkAttendMember(attendance);
              print('Check Attendee: ${checkAttend[0].id}');
              Alert(
                context: context,
                type: AlertType.info,
                title: "Confirm Deletion",
                desc: "Are you sure you want to delete this attendee?\n Key Number: ${attendance.keyNum}, ${attendance.gender}",
                style: const AlertStyle(titleStyle: TextStyle(color: Colors.white), descStyle: TextStyle(color: Colors.blueGrey)),
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
                      print('Check Attendee: ${checkAttend[0].id}');
                      int success = await db.deleteAttendee(attendance);
                      Navigator.pop(context);
                      if (success != 0) {
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
                        setState(() {});
                      }
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ).show();
            },
            child: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          ),
        ),
        // DataCell(Text(member.office)),
        // DataCell(Text(member.degree)),
      ],
    );
  }
}
