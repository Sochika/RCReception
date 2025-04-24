
import 'package:attendance/models/membersRecords.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:quickalert/quickalert.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../constants.dart';
import '../../data/sqlite.dart';

import 'action/importMembers.dart';
import 'components/header.dart';




class AddColombe extends StatelessWidget {
  const AddColombe({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddColombeData();
  }
}

class AddColombeData extends StatefulWidget {
  const AddColombeData({super.key});

  @override
  State<AddColombeData> createState() => _AddColombeDataState();
}

class _AddColombeDataState extends State<AddColombeData> {
  @override
  Widget build(BuildContext context) {
    final db = DatabaseHelper();
    // final dba = db.open();
    // dba.

    final double width = MediaQuery.of(context).size.width;
    TextEditingController lNameController = TextEditingController();
    TextEditingController fNameController = TextEditingController();
    TextEditingController mNameController = TextEditingController();
    TextEditingController keyNumController = TextEditingController();
    TextEditingController genderController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneNumController = TextEditingController();
    TextEditingController gcaController = TextEditingController();
    TextEditingController abController = TextEditingController();
    TextEditingController degreeController = TextEditingController();
    TextEditingController officeController = TextEditingController();
    TextEditingController tmoController = TextEditingController();
    TextEditingController dobController = TextEditingController();
    // print(lNameController.text);
    // gcaController.text = '0';
    // abController.text = '0';
    tmoController.text = '0';
    emailController.text = 'colombe@amorc.org.ng';
    phoneNumController.text = '080200000';
    // officeController.text = 'Colombe';
    int? _selectedAbId;



    // var degree = ['N', 'Atrium 1', 'Atrium 2', 'Atrium 3', '1TD', '2TD', '3TD', '4TD', '5TD', '6TD', '7TD', '8TD', '9TD', '9+'];

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(title: 'Add Colombe',),
            const SizedBox(height: defaultPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // const ImportMembers(),
                const SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'First Name',),
                        controller: fNameController,
                        // textInputAction: TextInputAction.,
                      ),
                    ),

                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Middle Name'),
                        controller: mNameController,
                        // textInputAction: TextInputAction.,
                      ),
                    ),
                    const SizedBox(width: defaultPadding * 1.5),

                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        controller: lNameController,
                        // textInputAction: TextInputAction.,
                      ),
                    ),



                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: DropdownMenu(
                        width: width /4,
                        label: const Text('GCA'),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: '', label: ''),
                          DropdownMenuEntry(value: '1', label: 'Rivers East'),
                          DropdownMenuEntry(value: '2', label: 'Rivers West'),
                        ],
                        onSelected: (value){
                          gcaController.text = value!;
                        },
                        controller: gcaController,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: DropdownMenu(
                        width: width /4,
                        label: const Text('AB'),
                        dropdownMenuEntries: const [
                          // Text('Male'),
                          DropdownMenuEntry(value: '', label: ''),
                          DropdownMenuEntry(value: '1', label: 'Thales Lodge'),
                          DropdownMenuEntry(value: '2', label: 'Dabaye Amaso Lodge'),
                          DropdownMenuEntry(value: '3', label: 'Akhnaton Chapter'),
                          DropdownMenuEntry(value: '4', label: 'Ee-Dee Pronaos'),
                          DropdownMenuEntry(value: '5', label: 'St Germain Pronaos'),
                          DropdownMenuEntry(value: '6', label: 'Arcane Pronaos'),
                          DropdownMenuEntry(value: '7', label: 'The Rose Pronaos'),

                        ],
                        onSelected: (value){
                          abController.text = value!;
                        },
                        // controller: abController,
                      ),
                    ),


                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      height: 90.0,
                      width: width / 4,
                      child: TextField(
                        controller: dobController, // Create a TextEditingController for this
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true, // This prevents the keyboard from appearing
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                            dobController.text = formattedDate;
                          }
                        },
                      ),
                    ),

                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: DropdownMenu<String>(
                        width: width /4,
                        label: const Text('Office'),
                        dropdownMenuEntries: const [
                          // DropdownMenuEntry(value: '', label: ''),
                          DropdownMenuEntry(value: 'Colombe', label: 'Colombe'),
                          DropdownMenuEntry(value: 'CE', label: 'Colombe Emeritus'),
                          DropdownMenuEntry(value: 'CIW', label: 'Colombe-In-Waiting'),

                        ],
                        onSelected: (value){
                          officeController.text = value!;
                        },
                        // controller: officeController,
                      ),
                    ),

                  ],
                ),

                SizedBox(width: width * 3 / 4 + (defaultPadding *2),

                    child: ElevatedButton(onPressed: () async {
                      if(fNameController.text == '' || lNameController.text == '' || dobController.text == '' || officeController.text == ''){
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text: 'Please fill the required Data',
                        );
                      }else{
                        Members member = Members(firstName: fNameController.text, lastName: lNameController.text.trim(), middleName: mNameController.text.trim(), keyNum: fNameController.text.toLowerCase().trim() + lNameController.text.toLowerCase().trim(), gender: female, ab: int.parse(abController.text), gca: int.parse(gcaController.text), degree: degreeController.text, office: officeController.text, email: emailController.text.trim(), phoneNum: phoneNumController.text.trim(), tmo: 0, colombe: 1, dateOfBirth: dobController.text ?? '');

                        // print(fNameController.text);
                        // print(member.lastName);
                        var idNum = await db.insertColombe(member);
                        print(idNum);
                        if (idNum > 0){
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "Colombe's Data Entered Successfully!",
                          );
                          setState(() {
                            genderController.text = '';
                            gcaController.text = '';
                            abController.text = '';
                            degreeController.text = '';
                            officeController.text = '';
                          });
                        }else{
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Oops...',
                            text: 'Sorry, something went wrong',
                          );
                        }

                      }

                      print(await getDatabasesPath());
                    }, child: const Text('Enter'),))
              ],
            )
          ],
        ),
      ),
    );

  }

  DateTime? parseDateOfBirth(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }
}

