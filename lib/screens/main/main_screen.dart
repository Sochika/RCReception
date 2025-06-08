import 'package:attendance/constants.dart';
import 'package:attendance/responsive.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../data/sqlite.dart';
import '../../markAttendance.dart';
import '../dashboard/dashboard_screen.dart';
import 'components/side_menu.dart';
import 'package:attendance/models/events.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late TextEditingController speakerController = TextEditingController();
  late TextEditingController eventController = TextEditingController();
  late TextEditingController timeController = TextEditingController();
  late TextEditingController dateController = TextEditingController();
  late EventsDetails event;
  DateTime date = DateTime.now();
  final db = DatabaseHelper();
  late  int idNum;
  List<DropdownMenuEntry<String>> dropdownMenuActivity = [
    const DropdownMenuEntry(value: '', label: ''),
    // const DropdownMenuEntry( child: Text(''), label: ''),
    for (var entry in eventCats.entries)
      DropdownMenuEntry(value:  entry.key.toString(), label: entry.value),
      // DropdownMenuItem(value: entry.key as String, child: Text(entry.value)),
  ];
  @override
  Widget build(BuildContext context) {
    // DateTime date = DateTime.now();



    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey,

      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            const Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Attendance Record',
        child: const Icon(Icons.add),
        onPressed: () async {
          await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime.parse('2020-07-28'),
            lastDate: DateTime.parse('2200-07-28'),
            onDatePickerModeChange: (dat) {
              date = DateTime.parse(dat.toString());
            },
          ).then((value) {
            if (value != null) {
              setState(() {
                date = value;
                dateController.text = DateFormat.yMMMMd().format(value);
                Alert(
                        context: context,
                        style: const AlertStyle(
                          backgroundColor: bgColor,
                          titleStyle: TextStyle(color: Colors.white, fontSize: 20),
                          descStyle: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        title: 'This Day Attendance',
                        desc: "Please Input Activity, Time and Name of Master.",
                  content:SizedBox(
                    height: 300.0,
                    width: 250.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Date',
                              icon: Icon(FontAwesomeIcons.calendar),),
                            onTap: _showdate,
                            controller: dateController,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: DropdownButtonFormField<String>(
                          isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Activity',
                              icon: Icon(FontAwesomeIcons.ankh),
                            ),
                            value: eventController.text,
                            onChanged: (value) {
                              setState(() {
                                eventController.text = value!;
                              });
                            },
                            items: dropdownMenuActivity.map((entry) {
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
                            decoration: const InputDecoration(labelText: 'Time',
                              icon: Icon(FontAwesomeIcons.clock),),
                            controller: timeController,
                            onTap: _picktime,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Name of Master',
                              icon: Icon(FontAwesomeIcons.person),),
                            controller: speakerController,
                          ),
                        ),
                        // const ButtonBar()

                        // ElevatedButton(onPressed: (){}, child: const Text('Enter'))

                      ],
                    ),
                  ),
                    buttons: [
                      DialogButton(
                        onPressed: () async{
                          print(eventController.text);
                event = EventsDetails(speaker: speakerController.text, time: timeController.text, date: dateController.text, event_typeID: int.parse(eventController.text));



                  idNum = await db.insertEvent(event);
                event.id = idNum;
                          // print(idNum);
                 // () => Navigator.pop(context);
                              () => Navigator.pop(context);
                              setState(() {

                              });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MarkAttendance(events:event)),
                          );
                        },
                        color: Colors.greenAccent,
                        child: const Text(
                          "ENTER",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      DialogButton(
                        color: Colors.redAccent,
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]
                ).show();
              });
            }
          });
        },
      ),
    );
  }
  void _showdate() async {
    await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.parse('2020-07-28'),
      lastDate: DateTime.now(),
      onDatePickerModeChange: (dat) {
        date = DateTime.parse(dat.toString());
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          date = value;
          dateController.text = DateFormat.yMMMMd().format(value);
        });
      }
    });
  }

  void _picktime() async {
    await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((time) {
      timeController.text = DateFormat('hh:mm a')
          .format(DateTime(2024, 2, 12, time!.hour, time.minute));
      // });
    });
  }

}

