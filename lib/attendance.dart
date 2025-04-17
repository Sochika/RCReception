// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class Attendance extends StatefulWidget {
//   const Attendance({super.key});
//
//   @override
//   State<Attendance> createState() => _AttendanceState();
// }
//
// class _AttendanceState extends State<Attendance> {
//   late TextEditingController speakerController = TextEditingController();
//   late TextEditingController timeController = TextEditingController();
//   late TextEditingController dateController = TextEditingController();
//
//   DateTime date = DateTime.now();
//   // String? testq;
//
//   void _showdate() async {
//     await showDatePicker(
//       context: context,
//       initialDate: date,
//       firstDate: DateTime.parse('2020-07-28'),
//       lastDate: DateTime.now(),
//       onDatePickerModeChange: (dat) {
//         date = DateTime.parse(dat.toString());
//       },
//     ).then((value) {
//       if (value != null) {
//         setState(() {
//           date = value;
//           dateController.text = DateFormat.yMMMMd().format(value);
//         });
//       }
//     });
//   }
//
//   void _picktime() async {
//     await showTimePicker(
//       initialTime: TimeOfDay.now(),
//       context: context,
//     ).then((time) {
//       timeController.text = DateFormat('hh:mm a')
//           .format(DateTime(2024, 2, 12, time!.hour, time.minute));
//       // });
//     });
//   }
//
//   final ButtonStyle flatButtonStyle = TextButton.styleFrom(
//     // primary: Colors.black87,
//     // minimumSize: const Size(88, 36),
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(2)),
//     ),
//   );
//   // void _zeroCounter(String dat) {
//   //   setState(() {
//   //
//   //     testq = dat;
//   late double _width;
//   @override
//   Widget build(BuildContext context) {
//
//     _width = MediaQuery.of(context).size.height;
//     return Row(
//       children: [
//         SizedBox(
//           width: _width/2,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   decoration: const InputDecoration(labelText: 'Date'),
//                   onTap: _showdate,
//                   controller: dateController,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   decoration: const InputDecoration(labelText: 'Time'),
//                   controller: timeController,
//                   onTap: _picktime,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   decoration: const InputDecoration(labelText: 'Name of Speaker'),
//                   controller: speakerController,
//                 ),
//               ),
//               // const ButtonBar()
//
//               ElevatedButton(onPressed: (){}, child: const Text('Enter'))
//               // const TextButton(
//               //   // style: ButtonStyle(TextButton.styleFrom(
//               //   //   primary: Colors.black87,
//               //   //   minimumSize: Size(88, 36),
//               //   //   padding: EdgeInsets.symmetric(horizontal: 16),
//               //   //   shape: RoundedRectangleBorder(
//               //   //     borderRadius: BorderRadius.all(Radius.circular(2)),
//               //   //   ),
//               //   // ),),
//               //   // style: TextButton.styleFrom(
//               //   //   primary: Colors.blue,
//               //   //   onSurface: Colors.red,
//               //   // ),
//               //   onPressed: null,
//               //   child: Text('Submit'),
//               // )
//
//
//               // )
//             ],
//           ),
//         ),
//         SizedBox(
//           width: _width/20,
//         ),
//         SizedBox(
//           width: _width/2,
//           child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//
//
//               children: <Widget>[
//                 Text('hello', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//                 // SizedBox(
//                 //     height: _height / 80
//                 // ),
//
//                 Text('Hrs: kk}', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
//
//               ]),
//         ),
//       ],
//     );
//   }
// }
