import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sqflite/sqflite.dart';

import '../../../constants.dart';
import '../../../responsive.dart';

class ImportMembers extends StatelessWidget {
  const ImportMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            ),
          ),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              File file = File(result.files.single.path!);
              print(file.toString());

              int? dataSuccess;
              try {
                dataSuccess = await importExcel(file, context);
              } on Exception catch (e) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'Oops...',
                  text: e.toString(),
                ); // Catches all Only catches an exception of type `Exception`.
              } catch (e) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'Oops...',
                  text: e.toString(),
                ); // Catches all types of `Exception` and `Error`.
              }

              // if(dataSuccess == Error){
              //
              //   QuickAlert.show(
              //     context: context,
              //     type: QuickAlertType.error,
              //     title: 'Oops...',
              //     text: 'Sorry, something went wrong',
              //   );
              // }
              if (dataSuccess == 1) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: 'Transfer Completed Successfully!',
                );
              }
              // print(data);
            } else {
              // User canceled the picker
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'Oops...',
                text: 'Sorry, something went wrong',
              );
            }
          },
          icon: const Icon(Icons.file_present_rounded),
          label: const Text("Import Excel"),
        ),
        const SizedBox(width: defaultPadding),
        ElevatedButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding * 1.5,
              vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            ),
          ),
          onPressed: () async {
            _downloadFile(context);
          },
          icon: const Icon(Icons.download),
          label: const Text("Download Sample"),
        ),
      ],
    );
  }

  Future<int> importExcel(File file, BuildContext context) async {
    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Processing your Excel file',
      );

      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      final membersTable = excel.tables['Members'];
      if (membersTable == null) {
        if (context.mounted) {
          Navigator.of(context).pop();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'Excel file does not contain a "Members" sheet',
          );
        }
        return 0;
      }

      var databasesPath = await getDatabasesPath();
      var dbPath = join(databasesPath, 'membersAttendance.db');

      Database database = await openDatabase(dbPath, version: 3, onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS members (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          lastName TEXT,
          firstName TEXT,
          middleName TEXT,
          natalDay TEXT,
          phoneNumber TEXT,
          keyNum TEXT,
          gender TEXT,
          affiliatedNum TEXT,
          tmo INTEGER,
          late INTEGER,
          ab_id INTEGER,
          office TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS dues (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          keyNum TEXT,
          gender TEXT,
          affiliatedNum TEXT,
          affiliatedDate TEXT,
          UNIQUE(keyNum, gender) ON CONFLICT REPLACE
        )
      ''');
      });

      var batch = database.batch();
      int importedCount = 0;

      for (var row in membersTable.rows) {
        try {
          final lastName = _getCellValue(row, 1).trim();
          if (lastName.isEmpty) continue;

          // Get office value with proper null/empty handling and default to 'Member'
          final officeValue = _getCellValue(row, 13).trim();
          final office = (officeValue.isEmpty || officeValue.toLowerCase() == 'null')
              ? 'Member'
              : officeValue;


          // Insert or update member
          batch.insert(
            'members',
            {
              'lastName': lastName,
              'firstName': _getCellValue(row, 2).trim(),
              'middleName': _getCellValue(row, 3).trim(),
              'natalDay': _getCellValue(row, 4).trim(),
              'phoneNumber': _getCellValue(row, 5).trim(),
              'keyNum': _getCellValue(row, 6).trim(),
              'gender': _getCellValue(row, 7).trim().toUpperCase() == 'M' ? 'Male' : 'Female',
              'affiliatedNum': _getCellValue(row, 12).trim(),
              'tmo': _parseInt(_getCellValue(row, 8).trim()),
              'late': _parseInt(_getCellValue(row, 10).trim()),
              'ab_id': _parseInt(_getCellValue(row, 9).trim()),
              'office': office,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          if (lastName.length > 3) {
            // This will automatically replace if keyNum+gender exists
            batch.insert(
              'dues',
              {
                'keyNum': _getCellValue(row, 6).trim(),
                'gender': _getCellValue(row, 7).trim().toUpperCase() == 'M' ? 'Male' : 'Female',
                'affiliatedNum': _getCellValue(row, 12).trim(),
                'affiliatedDate': _getCellValue(row, 11).trim(),
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }

          importedCount++;
        } catch (e) {
          print('Error processing row: $e');
        }
      }

      await batch.commit();
      await database.close();

      if (context.mounted) {
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Imported $importedCount records successfully',
        );
      }

      return importedCount;
    } catch (e) {
      print('Import error: $e');
      if (context.mounted) {
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to import data: ${e.toString()}',
        );
      }
      return 0;
    }
  }

  String _getCellValue(List<Data?> row, int index) {
    if (row.length <= index) return '';
    final cell = row[index];
    return cell?.value?.toString() ?? '';
  }

  int _parseInt(String value) {
    return int.tryParse(value) ?? 0;
  }


  Future<void> _downloadFile(BuildContext context) async {
    // Check if storage permission is granted
    var status = await Permission.storage.status;

    // Request storage permission if not granted
    if (!status.isGranted) {
      await Permission.storage.request();
      // Optionally, check the status again after requesting
      status = await Permission.storage.status;
    }

    // Proceed with downloading the file if permission is granted
    if (status.isGranted) {
      try {
        final ByteData data =
            await rootBundle.load('assets/files/$fileToDownload');
        final List<int> bytes = data.buffer.asUint8List();
        // final String dir = (await getApplicationDocumentsDirectory()).path;
        final dir = await FilePicker.platform.getDirectoryPath();
        // if (dir != null) {
        //   filePath = '$dir/$docTitle.pdf';
        //   final file = File(filePath);
        //   await file.writeAsBytes(await pdf.save());
        // }
        final String path = '$dir/$fileToDownload';
        final File file = File(path);
        await file.writeAsBytes(bytes);
        print('File downloaded successfully');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Download Successfully',
          text: 'Downloaded to $dir!',
        );
      } catch (e) {
        print('Error downloading file: $e');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong:\n $e',
        );
      }
    } else {
      print('Storage permission not granted');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text:
            'Storage permission not granted\n Please give permission or change directory',
      );
    }
  }

// getData(File file){
//   // var file = 'Path_to_pre_existing_Excel_File/excel_file.xlsx';
//   var bytes = file.readAsBytesSync();
//   var excel = Excel.decodeBytes(bytes);
//   print(excel.tables.keys);
//   for (var table in excel.tables.keys) {
//     print(table); //sheet Name
//     print(excel.tables[table]?.maxColumns);
//     print(excel.tables[table]?.maxRows);
//     print(excel.tables[table]!.rows);
//     for (var row in excel.tables[table]!.rows) {
//       for (var cell in row) {
//         // print('cell ${cell?.rowIndex}/${cell?.columnIndex}');
//         // final value = cell?.value;
//         // final numFormat = cell?.cellStyle?.numberFormat ?? NumFormat.standard_0;
//         // // switch(value){
//         //   case null:
//         //     print('  empty cell');
//         //     print('  format: ${numFormat}');
//         //   case TextCellValue():
//         //     print('  text: ${value.value}');
//         //   case FormulaCellValue():
//         //     print('  formula: ${value.formula}');
//         //     print('  format: ${numFormat}');
//         //   case IntCellValue():
//         //     print('  int: ${value.value}');
//         //     print('  format: ${numFormat}');
//         //   case BoolCellValue():
//         //     print('  bool: ${value.value ? 'YES!!' : 'NO..' }');
//         //     print('  format: ${numFormat}');
//         //   case DoubleCellValue():
//         //     print('  double: ${value.value}');
//         //     print('  format: ${numFormat}');
//         //   case DateCellValue():
//         //     print('  date: ${value.year} ${value.month} ${value.day} (${value.asDateTimeLocal()})');
//         //   case TimeCellValue():
//         //     print('  time: ${value.hour} ${value.minute} ... (${value.asDuration()})');
//         //   case DateTimeCellValue():
//         //     print('  date with time: ${value.year} ${value.month} ${value.day} ${value.hour} ... (${value.asDateTimeLocal()})');
//         // }
//
//         // print('$row');
//       }
//     }
//   }
// }

//   Future<dynamic> importExcel1(File file) async {
//     // import excel and return as json extract as json path
// // Importing the excel file
//
//     // Reading the excel file
//     // var file;
//     final bytes = await file.readAsBytes();
//     final excel = Excel.decodeBytes(bytes);
//
//     // Extracting the data from the excel file
//     final sheet = excel['Sheet1'];
//     final rows = sheet.rows;
//     final headers = rows.first;
//     final data = rows.skip(1).map((row) {
//       Map<String, dynamic> rowData = Map.fromIterables(headers as Iterable<String>, row);
//       // final rowDatal = Map.fromIterables(headers, row);
//       // print(rowDatal);
//       return rowData;
//     }).toList();
//
//     // Converting the data to JSON format
//     // data.
//     final jsonData = jsonEncode(data);
//     print(jsonData);
//     print(data.length);
//
//     // Returning the JSON data
//     return data;
//   }

// Future<dynamic> importExcel(File file) async {
//   // var file = 'path/to/your/excel/file.xlsx';
//   var bytes = file.readAsBytesSync();
//   var excel = Excel.decodeBytes(bytes);
//
//   for (var table in excel.tables.keys) {
//     print(table); //sheet Name
//     print(excel.tables[table]!.maxColumns);
//     print(excel.tables[table]!.maxRows);
//     // print(excel.tables[table]!.max);
//     // print(excel.tables[table]!.maxContentCol);
//
//     List<Map<String, dynamic>> jsonData = [];
//
//     for (var row in excel.tables[table]!.rows) {
//       Map<String, dynamic> rowData = {};
//
//       for (int i = 0; i < excel.tables[table]!.maxColumns; i++) {
//         rowData[excel.tables[table]!.rows[0][i].toString()] = row[i].toString();
//       }
//
//       jsonData.add(rowData);
//     }
//
//     // Convert the list of maps to JSON
//     String jsonString = json.encode(jsonData);
//     print(jsonString);
//     return jsonString;
//
//     // Optionally, you can write the JSON to a file
//     // File('path/to/your/output/json/file.json').writeAsStringSync(jsonString);
//   }
// }
}
