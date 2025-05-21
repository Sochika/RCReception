import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constants.dart';
import '../../../data/sqlite.dart';
import '../../../markAttendance.dart';
import '../../../models/MyFiles.dart';
import '../../../models/events.dart';

class FileInfoCard extends StatefulWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  _FileInfoCardState createState() => _FileInfoCardState();
}

class _FileInfoCardState extends State<FileInfoCard> {
  final DatabaseHelper db = DatabaseHelper();
  late TextEditingController speakerController;
  late TextEditingController eventController;
  late TextEditingController timeController;
  late TextEditingController dateController;
  late EventsDetails event;
  DateTime date = DateTime.now();
  late int idNum;
  List<DropdownMenuEntry<String>> dropdownMenuActivity = [];

  @override
  void initState() {
    super.initState();
    speakerController = TextEditingController();
    eventController = TextEditingController();
    timeController = TextEditingController();
    dateController = TextEditingController();
    // event = EventsDetails(speaker: '', event_typeID: null, time: '', date: ''); // Initialize event with default constructor
    // Populate dropdownMenuActivity
    dropdownMenuActivity = [
      const DropdownMenuEntry(value: '', label: ''),
      for (var entry in eventCats.entries)
        DropdownMenuEntry(value: entry.key.toString(), label: entry.value),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.info.eventDetail);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MarkAttendance(events: widget.info.eventDetail!)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: widget.info.color!.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SvgPicture.asset(
                    widget.info.svgSrc!,
                    colorFilter: ColorFilter.mode(
                        widget.info.color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          print('${widget.info.eventDetail?.id}');
                          List<EventsDetails> eventEdit =
                          await db.getEvent(widget.info.eventDetail!.id ?? 0);
                          dateController.text = eventEdit[0].date;
                          speakerController.text = eventEdit[0].speaker;
                          timeController.text = eventEdit[0].time;
                          eventController.text = "${eventEdit[0].event_typeID}";

                          Alert(
                            context: context,
                            style: const AlertStyle(
                              backgroundColor: bgColor,
                              titleStyle: TextStyle(color: Colors.white, fontSize: 20),
                              descStyle: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            title: 'Edit This Day Attendance',
                            desc: "Please Edit Activity, Time and Name of Master.",
                            content: SizedBox(
                              height: 300.0,
                              width: 250.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        labelText: 'Date',
                                        icon: Icon(FontAwesomeIcons.calendar),
                                      ),
                                      onTap: () async {
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
                                            date = value;
                                            dateController.text = DateFormat.yMMMMd().format(value);
                                          }
                                        });
                                      },
                                      controller: dateController,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: DropdownButtonFormField<String>(
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
                                      decoration: const InputDecoration(
                                        labelText: 'Time',
                                        icon: Icon(FontAwesomeIcons.clock),
                                      ),
                                      controller: timeController,
                                      onTap: () async {
                                        await showTimePicker(
                                          initialTime: TimeOfDay.now(),
                                          context: context,
                                        ).then((time) {
                                          timeController.text = DateFormat('hh:mm a')
                                              .format(DateTime(2024, 2, 12, time!.hour, time.minute));
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        labelText: 'Name of Master',
                                        icon: Icon(FontAwesomeIcons.person),
                                      ),
                                      controller: speakerController,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () async {
                                  print(eventController.text);
                                  event = EventsDetails(
                                    id: eventEdit[0].id,
                                    speaker: speakerController.text,
                                    time: timeController.text,
                                    date: dateController.text,
                                    event_typeID: int.parse(eventController.text),
                                  );
                                  idNum = await db.editEvent(widget.info.eventDetail?.id ?? 0, event);
                                  if(idNum>0){
                                    setState(() {

                                    });
                                  }
                                  Navigator.pop(context);
                                  // event.id = idNum;
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => MarkAttendance(events: event)),
                                  // );
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
                            ],
                          ).show();
                        },
                        child: const Icon(Icons.edit, color: Colors.blueGrey)),
                    GestureDetector(
                        onTap: () {
                          print('${widget.info.eventDetail?.id}');
                          Alert(
                            context: context,
                            type: AlertType.info,
                            title: "Confirm Deletion",
                            desc:
                            "Are you sure you want to delete this event?\n on ${widget.info.eventDetail?.date}, by ${widget.info.eventDetail?.speaker} Time: ${widget.info.eventDetail?.time}",
                            style: const AlertStyle(
                                titleStyle: TextStyle(color: Colors.white),
                                descStyle: TextStyle(color: Colors.blueGrey)),
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
                                  int success =
                                  await db.deleteEvent(widget.info.eventDetail?.id ?? 0);
                                  Navigator.pop(context); // Close the dialog
                                  if (success != 0) {
                                    Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title: "Success",
                                      desc: "Event deleted successfully",
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
                        child: const Icon(Icons.delete_forever, color: Colors.red)),
                  ],
                ),
              ],
            ),
            Text(
              widget.info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            ProgressLine(
              color: widget.info.color,
              percentage: widget.info.percentage,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.info.numOfMembers} Members",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white70),
                ),
                Text(
                  widget.info.date!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    speakerController.dispose();
    eventController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }
}


class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
