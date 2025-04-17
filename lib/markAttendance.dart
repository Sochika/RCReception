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
        title: Text('Mark Attendance; ${eventCats[widget.events.event_typeID]}'),
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
                      decoration: const InputDecoration(labelText: 'Key Number'),
                      controller: keyNumController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value)=>
                        keyAttend(value, width, height),
                    ),
                  ),
                  SizedBox(width: width / 12),
                  ElevatedButton(
                    onPressed: ()=>keyAttend(keyNumController.text, width, height),
                    child: const Text('Enter'),
                  ),
                ],
              ),
              MembersRecord(event: widget.events,),
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
        style: const AlertStyle(titleStyle: TextStyle(color: Colors.blueAccent), descStyle: TextStyle(color:Colors.blueAccent)),
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
        isDialogOpen = true; // Set isDialogOpen to true before opening the dialog
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: const Text('Member(s): Please Click on the Name'),
            icon: const Icon(Icons.people),
            content: SizedBox(
              width: width/3,
              height: height/4,
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text("${members[index].keyNum}: ${members[index].gender == 'Male' ? 'Fr.' : 'Sr.'} ${members[index].firstName} ${members[index].middleName == 'null' ? '' : members[index].middleName} ${members[index].lastName}, ${members[index].gender}"),
                    onTap: () async {
                      // () => Navigator.pop(context);
                      Attendances attendance = Attendances(keyNum: members[index].keyNum, gender: members[index].gender, eventID: widget.events.id ?? 0);
                      List<Attendances> checkAttend = await db.checkAttendMember(attendance);
                      print('Check Attendee: $checkAttend');
                      if(checkAttend.isNotEmpty){
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Key Number: ${members[index].keyNum}",
                          desc: "is already present here",
                          style: const AlertStyle(titleStyle: TextStyle(color: Colors.white), descStyle: TextStyle(color:Colors.white)),
                          buttons: [
                            DialogButton(
                              onPressed: () => Navigator.pop(context),
                              color: const Color.fromRGBO(229, 162, 27, 0.8),
                              child: const Text(
                                "Close",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ).show();
                        return;
                      }
                      var idNum = await db.markAttendances(attendance);

                      if (idNum == 1) {
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Key Number: ${members[index].keyNum}",
                          desc: "has been marked present",
                          style: const AlertStyle(titleStyle: TextStyle(color: Colors.white), descStyle: TextStyle(color:Colors.white)),
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
                      } else {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Key Number: ${members[index].keyNum}",
                          desc: "has not been marked present",
                          style: const AlertStyle(titleStyle: TextStyle(color: Colors.redAccent), descStyle: TextStyle(color:Colors.redAccent)),
                          buttons: [
                            DialogButton(
                              onPressed: () => Navigator.pop(context),
                              color: const Color.fromRGBO(242, 67, 60, 1.0),
                              child: const Text(
                                "Close",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ).show();
                      }
                    },

                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    isDialogOpen = false; // Set isDialogOpen to false when closing the dialog
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

