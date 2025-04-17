
import 'package:attendance/models/settings.dart';
import 'package:flutter/material.dart';

import 'package:quickalert/quickalert.dart';

import '../../constants.dart';
import '../../data/sqlite.dart';

import 'components/header.dart';




class AddSetting extends StatelessWidget {
  const AddSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddSettingData();
  }
}

class AddSettingData extends StatefulWidget {
  const AddSettingData({Key? key}) : super(key: key);

  @override
  State<AddSettingData> createState() => _AddSettingDataState();
}

class _AddSettingDataState extends State<AddSettingData> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController gcaController = TextEditingController();
  final TextEditingController abController = TextEditingController();


  @override
  void initState() {
    super.initState();
    setDefaultValues();
  }

  Future<void> setDefaultValues() async {
    final db = DatabaseHelper();
    var settings = await db.getSetting();

    if (settings != null) {
      setState(() {
        gcaController.text = GCAs[settings.gcaID]!;
        abController.text = ABs[settings.abID]!;
        userController.text = settings.userName;
      });
    }
  }

  int? getKeyByValue(String value, Map<int, String> map) {
    for (var entry in map.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return null; // If the value is not found
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final db = DatabaseHelper();
    // awiat db.getSetting();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: 'Add Settings'),
            const SizedBox(height: defaultPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.5,
                      child: const Text('If this setting(s) is/are changed, Please Restart the Application', style: TextStyle(color: Colors.redAccent),)
                    ),

                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.25,
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'UserName'),
                        controller: userController,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      width: width * 0.25,
                      child: TextField(
                        controller: gcaController,
                        decoration: const InputDecoration(
                          labelText: 'GCA',
                          hintText: 'Select GCA',
                        ),
                        readOnly: true, // This prevents users from directly typing into the TextField
                        onTap: () {
                          // Show a dropdown dialog when the TextField is tapped
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Select GCA'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: GCAs.entries.map((entry) {
                                    return ListTile(
                                      title: Text(entry.value),
                                      onTap: () {
                                        // Set the selected GCA value to the text field
                                        setState(() {
                                          gcaController.text = entry.value;
                                        });
                                        Navigator.pop(context); // Close the dialog
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          );
                        },
                      ),

                    ),
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      width: width * 0.25,
                      child: TextField(
                        controller: abController,
                        decoration: const InputDecoration(
                          labelText: 'AB',
                          hintText: 'Select AB',
                        ),
                        readOnly: true, // This prevents users from directly typing into the TextField
                        onTap: () {
                          // Show a dropdown dialog when the TextField is tapped
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Select AB'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: ABs.entries.map((entry) {
                                    return ListTile(
                                      title: Text(entry.value),
                                      onTap: () {
                                        // Set the selected GCA value to the text field
                                        setState(() {
                                          abController.text = entry.value;
                                        });
                                        Navigator.pop(context); // Close the dialog
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          );
                        },
                      ),

                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                SizedBox(
                  width: width * 0.75,
                  child: ElevatedButton(
                    onPressed: () async {
                      final gcaText = gcaController.text.trim();
                      final abText = abController.text.trim();
                      final userText = userController.text.trim();
                      print(gcaText);
                      print(abText);
                      print(userText);

                      if (gcaText.isEmpty || abText.isEmpty || userText.isEmpty) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text: 'Please fill all the required fields.',
                        );
                        return;
                      }

                      // final gcaID = int.parse(gcaText);
                      // final abID = int.parse(abText);
                      //
                      // final setting = SettingsLoad(id: 1, abID: abID, gcaID: gcaID, userName: userText);
                      //
                      // final db = DatabaseHelper();
                      // final idNum = await db.setSettings(setting);
                      try {
                        final gcaID = getKeyByValue(gcaText, GCAs) ?? 0;
                        final abID = getKeyByValue(abText, ABs) ?? 0;

                        final setting = SettingsLoad(id: 1, abID: abID, gcaID: gcaID, userName: userText);


                        final idNum = await db.setSettings(setting);

                        if (idNum > 0) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "*Setting's Data Entered Successfully!\n Please Restart the Application",
                          );
                          setState(() {
                            // gcaController.clear();
                            // abController.clear();
                            // userController.clear();
                          });
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Oops...',
                            text: 'Sorry, something went wrong.',
                          );
                        }
                      } catch (e) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text: 'Invalid input. Please enter valid integers for GCA and AB.',
                        );
                      }
                    },
                    child: const Text('Enter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


