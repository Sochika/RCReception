
import 'package:attendance/models/membersRecords.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:quickalert/quickalert.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../constants.dart';
import '../../data/sqlite.dart';

import 'action/importMembers.dart';
import 'components/header.dart';




class AddMember extends StatelessWidget {
  const AddMember({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddMemberData();
  }
}

class AddMemberData extends StatefulWidget {
  const AddMemberData({super.key});

  @override
  State<AddMemberData> createState() => _AddMemberDataState();
}

class _AddMemberDataState extends State<AddMemberData> {
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
    // print(lNameController.text);
    gcaController.text = '0';
    abController.text = '0';
    tmoController.text = '0';


    // var degree = ['N', 'Atrium 1', 'Atrium 2', 'Atrium 3', '1TD', '2TD', '3TD', '4TD', '5TD', '6TD', '7TD', '8TD', '9TD', '9+'];

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(title: 'Add Member',),
            const SizedBox(height: defaultPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const ImportMembers(),
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


                    // Expanded(
                    //   flex: 5,
                    //   child: Column(
                    //     children: [
                    //       MyFiles(),
                    //       SizedBox(height: defaultPadding),
                    //       MarkAttend(),
                    //       SizedBox(height: defaultPadding),
                    //       RecentFiles(),
                    //       if (Responsive.isMobile(context))
                    //         SizedBox(height: defaultPadding),
                    //       if (Responsive.isMobile(context)) StorageDetails(),
                    //     ],
                    //   ),
                    // ),
                    // if (!Responsive.isMobile(context))
                    //   SizedBox(width: defaultPadding),
                    // // On Mobile means if the screen is less than 850 we don't want to show it
                    // if (!Responsive.isMobile(context))
                    //   Expanded(
                    //     flex: 2,
                    //     child: StorageDetails(),
                    //   ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Key Number'),
                        keyboardType: TextInputType.number,
                        controller: keyNumController,
                        // textInputAction: TextInputAction.,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.number,
                        controller: phoneNumController,
                        // textInputAction: TextInputAction.,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
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
                        label: const Text('Gender'),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: '', label: ''),
                          DropdownMenuEntry(value: 'Male', label: 'Male'),
                          DropdownMenuEntry(value: 'Female', label: 'Female')
                          // Text('Male'),
                          // {'1':'Male'}
                        ],
                        onSelected: (value){
                          genderController.text = value!;
                        },
                        controller: genderController,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
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
                        label: const Text('Degree'),

                        dropdownMenuEntries:  const [
                          //
                          // DropdownMenuEntry(value: '', label: ''),
                          DropdownMenuEntry(value: 'N', label: 'N'),
                          DropdownMenuEntry(value: 'Atrium 1', label: 'Atrium 1'),
                          DropdownMenuEntry(value: 'Atrium 2', label: 'Atrium 2'),
                          DropdownMenuEntry(value: 'Atrium 3', label: 'Atrium 3'),
                          DropdownMenuEntry(value: '1TD', label: '1TD'),
                          DropdownMenuEntry(value: '2TD', label: '2TD'),
                          DropdownMenuEntry(value: '3TD', label: '3TD'),
                          DropdownMenuEntry(value: '4TD', label: '4TD'),
                          DropdownMenuEntry(value: '5TD', label: '5TD'),
                          DropdownMenuEntry(value: '6TD', label: '6TD'),
                          DropdownMenuEntry(value: '7TD', label: '7TD'),
                          DropdownMenuEntry(value: '8TD', label: '8TD'),
                          DropdownMenuEntry(value: '9TD', label: '9TD'),
                          DropdownMenuEntry(value: '9+', label: '9+'),


                        ],
                        onSelected: (value){
                          degreeController.text = value!;
                        },
                        // controller: degreeController,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      height: 90.0,
                      width: width /4,
                      child: DropdownMenu<String>(
                        width: width /4,
                        label: const Text('Office'),
                        dropdownMenuEntries: const [
                          // DropdownMenuEntry(value: '', label: ''),
                          DropdownMenuEntry(value: 'Member', label: 'Member'),
                          DropdownMenuEntry(value: 'Master', label: 'Master'),
                          DropdownMenuEntry(value: 'DM', label: 'DM'),
                          DropdownMenuEntry(value: 'Chaplain', label: 'Chaplain'),
                          DropdownMenuEntry(value: 'Chanter', label: 'Chanter'),
                          DropdownMenuEntry(value: 'Chanteress', label: 'Chanteress'),
                          DropdownMenuEntry(value: 'Matre', label: 'Matre'),
                          DropdownMenuEntry(value: 'Inner Guardian', label: 'Inner Guardian'),
                          DropdownMenuEntry(value: 'Outer Guardian', label: 'Outer Guardian'),
                          DropdownMenuEntry(value: 'GC', label: 'GC'),
                          DropdownMenuEntry(value: 'GCE', label: 'GCE'),
                          DropdownMenuEntry(value: 'RM', label: 'RM'),
                          DropdownMenuEntry(value: 'RME', label: 'RME'),

                        ],
                        onSelected: (value){
                          officeController.text = value!;
                        },
                        // controller: officeController,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    // SizedBox(
                    //   height: 90.0,
                    //   width: width /4,
                    //   child: DropdownMenu(
                    //     width: width /4,
                    //     label: const Text('TMO'),
                    //     dropdownMenuEntries: const [
                    //       // Text('Male'),
                    //     ],
                    //     controller: officeController,
                    //   ),
                    // ),
                    const SizedBox(width: defaultPadding),
                    const Text('TMO:'),
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      child: ToggleSwitch(
                        onToggle: (v){
                          // print(v);
                          tmoController.text = v.toString();
                        },
                        customWidths: const [90.0, 90.0],
                        cornerRadius: 20.0,
                        activeBgColors: const [
                          [Colors.redAccent],
                          [Colors.cyan],

                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        totalSwitches: 2,
                        labels: const ['NO', 'YES'],
                        icons: const [FontAwesomeIcons.xmark, FontAwesomeIcons.check, ],

                      ),
                    ),

                  ],
                ),
                SizedBox(width: width * 3 / 4 + (defaultPadding *2),

                    child: ElevatedButton(onPressed: () async {
                      if(fNameController.text == '' || lNameController.text == '' || keyNumController.text == '' || genderController.text == ''){
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text: 'Please fill the required Data',
                        );
                      }else{
                        Members member = Members(firstName: fNameController.text.trim(), lastName: lNameController.text.trim(), middleName: mNameController.text.trim(), keyNum: keyNumController.text.trim(), gender: genderController.text, ab: int.parse(abController.text), gca: int.parse(gcaController.text), degree: degreeController.text, office: officeController.text, email: emailController.text.trim(), phoneNum: phoneNumController.text.trim(), tmo: int.parse(tmoController.text), colombe: 0);

                        // print(fNameController.text);
                        // print(member.lastName);
                        var idNum = await db.insertMember(member);
                        print(idNum);
                        if (idNum > 0){
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "Member's Data Entered Successfully!",
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
}

