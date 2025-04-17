import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';

Future<String?> PdfExporter({
  required List<List<String>> data,
  String title = '',
  String docTitle = '',
  int maleCount = 0,
  int femaleCount = 0,
}) async {
  final pdf = pw.Document();
  // Assuming you have placed the Noto font files in the assets/fonts directory
  const String notoSansFont = 'assets/fonts/static/EBGaramond-Regular.ttf';
  const String notoSansBoldFont = 'assets/fonts/static/EBGaramond-Bold.ttf';
  const String imagePath = "assets/images/glLogo.png";
  const String imagePath2 = imagePath;

  final regularFont = pw.Font.ttf(await rootBundle.load(notoSansFont));
  final boldFont = pw.Font.ttf(await rootBundle.load(notoSansBoldFont));

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        final List<pw.Widget> children = [];

        // Add image if provided
        if (imagePath.isNotEmpty) {
          children.add(
            pw.Center(
              child: pw.Image(
                pw.MemoryImage(
                  File(imagePath2).readAsBytesSync(),
                ),
                height: 100,
              ),
            ),
          );
          children.add(pw.SizedBox(height: 5));
        }
        if (settingConst.abID > 0) {
          children.add(
            pw.Center(
              child: pw.Text(
                ABs[settingConst.abID]!,
                style: pw.TextStyle(font: boldFont, fontSize: 14),
              ),
            ),
          );
          children.add(pw.SizedBox(height: 5));
        }
        // Add title if provided
        if (title.isNotEmpty) {
          children.add(
            pw.Center(
              child: pw.Text(
                title,
                style: pw.TextStyle(font: boldFont, fontSize: 16),
              ),
            ),
          );
          children.add(pw.SizedBox(height: 3));
          children.add(
            pw.Center(
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total: ${maleCount + femaleCount}',
                    style: pw.TextStyle(font: boldFont, fontSize: 14),
                  ),
                  pw.Text(
                    'Females: $femaleCount ',
                    style: pw.TextStyle(font: boldFont, fontSize: 14),
                  ),
                  pw.Text(
                    'Males: $maleCount',
                    style: pw.TextStyle(font: boldFont, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
          children.add(pw.SizedBox(height: 5));
        }

        // Add table with data
        final rows = data.map((row) {
          return row.map((cell) {
            return pw.Text(cell, style: pw.TextStyle(font: regularFont));
          }).toList();
        }).toList();
        // Add header row with bold font style
        rows.insert(
          0,
          ['S/N', 'Key Number', 'Name', 'AB', 'TMO', 'Visitor', 'Office']
              .map((cell) {
            return pw.Text(cell, style: pw.TextStyle(font: boldFont));
          }).toList(),
        );
        children.add(
          pw.Table(
            children: rows.map((row) {
              return pw.TableRow(children: row);
            }).toList(),
          ),
        );

        return pw.Column(children: children);
      },
    ),
  );

  // Get the directory to save the PDF file
  String? filePath;
  try {
    // Request permission to access files
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
      if (!status.isGranted) {
        throw Exception('Permission denied to access storage.');
      }
    }

    // Use file picker to request path
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      filePath = '$result\\$docTitle.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
    }
  } catch (e) {
    print('Error saving PDF: $e');
    return null;
  }

  // Return the file path where the PDF is saved
  return filePath;
}
