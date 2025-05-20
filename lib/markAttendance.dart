import 'package:attendance/screens/dashboard/attendanceRecords.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:attendance/models/events.dart';

import 'constants.dart';
import 'data/sqlite.dart';

import 'models/membersRecords.dart';
import 'models/attendances.dart';

class MarkAttendance extends StatefulWidget {
  final EventsDetails events;

  const MarkAttendance({Key? key, required this.events}) : super(key: key);

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  // int numFemales = 0;
  // int numMales = 0;
  final DatabaseHelper db = DatabaseHelper();

  TextEditingController keyNumController = TextEditingController();

  bool isDialogOpen = false; // Move isDialogOpen to the state class

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Mark Attendance; ${eventCats[widget.events.event_typeID]}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Row(
              //   children: [
              //     ElevatedButton.icon(
              //       onPressed: () async {
              //
              //         final exporter = PdfExporter(
              //           // data: [
              //           //   ['S/N', 'Key Number', 'Name', 'AB', 'TMO'],
              //           //   // Add your data rows here
              //           // ],
              //         );
              //         // await exporter.createPDF();
              //         // Show a message or perform any other action after PDF creation
              //
              //       },
              //       icon: const Icon(Icons.arrow_downward),
              //       label: const Text("PDF"),
              //     ),
              //     SizedBox(width: width / 12),
              //
              //   ],
              // ),
              SizedBox(height: height / 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90.0,
                    width: width / 3,
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Key Number'),
                      controller: keyNumController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) =>
                          keyAttend(value.trim(), width, height),
                    ),
                  ),
                  SizedBox(width: width / 12),
                  ElevatedButton(
                    onPressed: () =>
                        keyAttend(keyNumController.text.trim(), width, height),
                    child: const Text('Enter'),
                  ),
                ],
              ),
              MembersRecord(
                event: widget.events,
              ),
            ],
          ),
        ),
      ),
    );
  }

  keyAttend(String value, double width, double height) async {
    // Check if dialog is already open
    if (isDialogOpen) {
      return;
    }

    String keyNumber = value;
    if (keyNumber.isEmpty) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Key Number",
        desc: "Please enter a Key Number",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            color: const Color.fromRGBO(0, 179, 134, 1.0),
            child: const Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ).show();
      return;
    }

    List<Members> members = await db.getMembers(keyNumber);

    if (members.isEmpty) {
      Alert(
        context: context,
        type: AlertType.info,
        title: "Key Number: $keyNumber",
        desc: "is not a Member of this Lodge",
        style: const AlertStyle(
            titleStyle: TextStyle(color: Colors.blueAccent),
            descStyle: TextStyle(color: Colors.blueAccent)),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            color: const Color.fromRGBO(65, 102, 211, 0.8),
            child: const Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ).show();
    } else {
      setState(() {
        isDialogOpen =
            true; // Set isDialogOpen to true before opening the dialog
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Member(s): Please Click on the Name'),
            icon: const Icon(Icons.people),
            content: SizedBox(
              width: width/3,
              height: height/4,
              child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (BuildContext context, int index) {
                int? selectedOfficeId; // Store the selected office ID

                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ListTile(
                      title: Text(
                          "${members[index].colombe == 0 ? members[index].keyNum : ''}: "
                              "${members[index].colombe == 0 ? members[index].gender == 'Male' ? 'Fr.' : 'Sr.' : members[index].office} "
                              "${members[index].firstName} "
                              "${members[index].middleName == 'null' ? '' : members[index].middleName} "
                              "${members[index].lastName}, ${members[index].gender}"
                      ),
                      trailing: DropdownButton<int>(
                        value: selectedOfficeId,
                        hint: const Text('Select Office'),
                        items: Office.entries.map((entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedOfficeId = newValue;
                          });
                        },
                      ),
                      onTap: () async {
                        if (selectedOfficeId == null) {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Office Required",
                            desc: "Please select an office before marking attendance",
                            style: const AlertStyle(
                                titleStyle: TextStyle(color: Colors.white),
                                descStyle: TextStyle(color: Colors.white)
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                color: const Color.fromRGBO(242, 67, 60, 1.0),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ).show();
                          return;
                        }

                        Attendances attendance = Attendances(
                            keyNum: members[index].keyNum,
                            gender: members[index].gender,
                            office: selectedOfficeId!, // Store the office title
                            // officeId: selectedOfficeId, // Store the office ID if your model supports it
                            eventID: widget.events.id ?? 0
                        );

                        // Rest of your attendance marking logic...
                        var idNum = await db.markAttendances(attendance);

                        if (idNum == 1) {
                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: "Key Number: ${members[index].keyNum}",
                            desc: "has been marked present as ${Office[selectedOfficeId]}",
                            style: const AlertStyle(
                                titleStyle: TextStyle(color: Colors.white),
                                descStyle: TextStyle(color: Colors.white)
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                color: const Color.fromRGBO(0, 179, 134, 1.0),
                                child: const Text(
                                  "Close",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ).show();
                        }
                        // Rest of your error handling...
                      },
                    );
                  },
                );
              },
            )
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    isDialogOpen = false;
                    keyNumController.text ='';
                  });
                  Navigator.pop(context);
                },
                child: const Text('CLOSE'),
              ),
            ],
          );
        },
      );
    }
  }
}
