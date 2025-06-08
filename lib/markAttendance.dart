import 'package:attendance/screens/dashboard/attendanceRecords.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:attendance/models/events.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  final DatabaseHelper db = DatabaseHelper();
  final TextEditingController keyNumController = TextEditingController();
  final TextEditingController colombeController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  bool _isDialogOpen = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    keyNumController.dispose();
    colombeController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance: ${eventCats[widget.events.event_typeID]}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed input section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildInputSection(size),
            ),

            // Scrollable members list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MembersRecord(event: widget.events),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInputSection(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.3,
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Key Number',
                  border: OutlineInputBorder(),
                ),
                controller: keyNumController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) => _handleKeyAttendance(value.trim(), isColombe: false),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Colombe',
                  border: OutlineInputBorder(),
                ),
                controller: colombeController,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) => _handleKeyAttendance(value.trim(), isColombe: true),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: () {
            if (keyNumController.text.isNotEmpty) {
              _handleKeyAttendance(keyNumController.text.trim(), isColombe: false);
            } else if (colombeController.text.isNotEmpty) {
              _handleKeyAttendance(colombeController.text.trim(), isColombe: true);
            } else {
              _showErrorDialog("Please enter either Key Number or Colombe");
            }
          },
          child: _isProcessing
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Enter'),
        ),
      ],
    );
  }

  Future<void> _handleKeyAttendance(String value, {required bool isColombe}) async {
    if (_isDialogOpen || value.isEmpty) {
      if (value.isEmpty) {
        _showErrorDialog("Please enter a value");
      }
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final members = isColombe
          ? await db.getMembers(keyNum: value, colombe: true)
          : await db.getMembers(keyNum: value);

      if (members.isEmpty) {
        _showInfoDialog(
          title: isColombe ? "Colombe: $value" : "Key Number: $value",
          message: "not found",
        );
        return;
      }

      setState(() => _isDialogOpen = true);
      await showDialog(
        context: context,
        builder: (context) => _buildMembersDialog(members),
      );
    } catch (e) {
      _showErrorDialog("Error searching: ${e.toString()}");
    } finally {
      setState(() {
        _isDialogOpen = false;
        _isProcessing = false;
        keyNumController.clear();
        colombeController.clear();
      });
    }
  }

  Widget _buildMembersDialog(List<Members> members) {
    return AlertDialog(
      title: const Text('Member(s) Found'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView.separated(
          itemCount: members.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => _buildMemberTile(members[index]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE'),
        ),
      ],
    );
  }

  Widget _buildMemberTile(Members member) {
    int? selectedOfficeId;

    return StatefulBuilder(
      builder: (context, setState) {
        return ListTile(
          title: Text(
            _formatMemberName(member),
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: member.colombe == 0 ? null : Text("Office: ${member.office}"),
          trailing: member.colombe == 0
              ? DropdownButton<int>(
            value: selectedOfficeId,
            hint: const Text('Select Office'),
            items: Office.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedOfficeId = value),
          )
              : null,
          onTap: () async => await _markAttendance(member, selectedOfficeId),
        );
      },
    );
  }

  String _formatMemberName(Members member) {
    final prefix = member.colombe == 0
        ? member.gender == 'Male' ? 'Fr.' : 'Sr.'
        : '';

    return [
      if (member.colombe == 0) '${member.keyNum}:',
      prefix,
      member.firstName,
      if (member.middleName != 'null') member.middleName,
      member.lastName,
    ].where((part) => part.isNotEmpty).join(' ');
  }

  Future<void> _markAttendance(Members member, int? officeId) async {
    final attendance = Attendances(
      keyNum: member.keyNum,
      gender: member.gender,
      office: officeId ?? 0,
      eventID: widget.events.id ?? 0,
    );
    final settings = await DatabaseHelper().getSetting();

    try {
      final result = await db.markAttendance(attendance);

      Navigator.pop(context); // Close member selection dialog first

      if (result == 1) {
        final role = officeId == null ? "" : " as ${Office[officeId]}";
        if(settings!.tts.isOdd){
          await _speak("${member.colombe == 1 ? "Colombe" : member.gender == "Male" ? "Frater" : "Soror"} ${member.firstName} ${member.lastName} marked present$role");
        }else if(settings.ttsimple.isOdd){
          await _speak("${member.colombe == 1 ? "Colombe" : member.gender == "Male" ? "Frater" : "Soror"} marked present$role");
        }
        _showSuccessDialog(
          title: "Success",
          message: "${member.colombe == 1 ? "Colombe" : member.gender == "Male" ? "Fr." : "Sr."} ${member.firstName} ${member.lastName} marked present$role",
        );
      }
      else if (result == 0) {
        _showInfoDialog(
          title: "Already Marked",
          message: "${member.firstName} ${member.lastName} is already present",
        );
      }
      else {
        _showErrorDialog("Failed to mark attendance");
      }
    }
    catch (e) {
      Navigator.pop(context);
      _showErrorDialog("Error: ${e.toString()}");
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-NG");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void _showSuccessDialog({required String title, required String message}) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: message,
      style: const AlertStyle(
          titleStyle: TextStyle(color: Colors.white),
          descStyle: TextStyle(color: Colors.white)
      ),
      buttons: [DialogButton(
        onPressed: () => Navigator.pop(context),
        color: Colors.redAccent,
        child: const Text("Close"),
      )],
    ).show();
  }

  void _showErrorDialog(String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error",
      desc: message,
      style: const AlertStyle(
          titleStyle: TextStyle(color: Colors.white),
          descStyle: TextStyle(color: Colors.white)
      ),
      buttons: [DialogButton(
        onPressed: () => Navigator.pop(context),
        color: Colors.redAccent,
        child: const Text("OK"),
      )],
    ).show();
  }

  void _showInfoDialog({required String title, required String message}) {
    Alert(
      context: context,
      type: AlertType.info,
      title: title,
      desc: message,
        style: const AlertStyle(
                titleStyle: TextStyle(color: Colors.white),
                descStyle: TextStyle(color: Colors.white)
            ),
      buttons: [DialogButton(
        onPressed: () => Navigator.pop(context),
        color: Colors.redAccent,
        child: const Text("Close",
        style: TextStyle(color: Colors.white, fontSize: 18)),
      ),],
    ).show();
  }
}
  // Future _speak(String word) async{
  //   late FlutterTts flutterTts;
  //   var result = await flutterTts.speak(word);
  //   if (result == 1) setState(() => ttsState = TtsState.playing);
  // }

