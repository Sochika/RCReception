import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../constants.dart';

Future<String?> PdfExporter({
  required List<List<String>> data,
  String title = '',
  String docTitle = '',
  int maleCount = 0,
  int femaleCount = 0,
  int colombeCount = 0,
  int candidateCount = 0,
}) async {
  final pdf = pw.Document();
  const String notoSansFont = 'assets/fonts/static/EBGaramond-Regular.ttf';
  const String notoSansBoldFont = 'assets/fonts/static/EBGaramond-Bold.ttf';
  const String imagePath = "assets/images/glLogo.png";

  try {
    // Load fonts and images
    final regularFont = pw.Font.ttf(await rootBundle.load(notoSansFont));
    final boldFont = pw.Font.ttf(await rootBundle.load(notoSansBoldFont));
    final imageBytes = await rootBundle.load(imagePath);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginLeft: 20,
          marginRight: 20,
          marginTop: 20,
          marginBottom: 20,
        ),
        header: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(imageBytes.buffer.asUint8List()),
                  height: 100,
                  fit: pw.BoxFit.contain,
                ),
              ),
              pw.SizedBox(height: 2),
              if (settingConst.abID > 0)
                pw.Center(
                  child: pw.Text(
                    ABs[settingConst.abID]!,
                    style: pw.TextStyle(font: boldFont, fontSize: 12),
                  ),
                ),
              pw.SizedBox(height: 3),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.TextStyle(font: regularFont, fontSize: 10),
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            // Title section
            if (title.isNotEmpty) pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 14,
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Center(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Text(
                        'Total: ${maleCount + femaleCount}',
                        style: pw.TextStyle(font: boldFont, fontSize: 10),
                      ),
                      pw.Text(
                        'Sorors: ${femaleCount - colombeCount}',
                        style: pw.TextStyle(font: boldFont, fontSize: 10),
                      ),
                      pw.Text(
                        'Fraters: $maleCount',
                        style: pw.TextStyle(font: boldFont, fontSize: 10),
                      ),
                      pw.Text(
                        candidateCount!= 0 ? 'Candidate: $candidateCount' : "",
                        style: pw.TextStyle(font: boldFont, fontSize: 10),
                      ),
                      pw.Text(
                        'Colombe: $colombeCount',
                        style: pw.TextStyle(font: boldFont, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 6),
              ],
            ),

            // Table
            pw.Table.fromTextArray(
              context: context,
              border: pw.TableBorder.all(
                width: 0.5,
                color: PdfColors.grey400,
              ),
              headerStyle: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue700,
              ),
              cellStyle: pw.TextStyle(
                font: regularFont,
                fontSize: 9,
              ),
              cellPadding: const pw.EdgeInsets.all(4),
              columnWidths: {
                0: const pw.FixedColumnWidth(20),  // S/N
                1: const pw.FixedColumnWidth(50),  // Key Number
                2: const pw.FixedColumnWidth(100),    // Name
                3: const pw.FixedColumnWidth(60),  // AB
                4: const pw.FixedColumnWidth(40),  // TMO
                5: const pw.FixedColumnWidth(30),  // Visitor
                6: const pw.FixedColumnWidth(60),  // Office
              },
              headers: ['S/N', 'Key Number', 'Name', 'AB', 'TMO', 'Visitor', 'Office'],
              data: data,
            ),
          ];
        },
      ),
    );

    // Save the PDF file
    final directory = await setAttendanceFolder();
    if (directory.isEmpty) {
      throw Exception('Could not get documents directory');
    }

    final filePath = path.join(directory, '$docTitle.pdf');
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  } catch (e) {
    print('Error generating PDF: $e');
    return null;
  }
}

Future<String> setAttendanceFolder() async {
  Directory? targetDirectory;

  try {
    // Try to get downloads directory (works better for mobile)
    if (Platform.isAndroid || Platform.isIOS) {
      targetDirectory = await getDownloadsDirectory();
    }
    // For Windows, use Documents directory
    else if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null) {
        targetDirectory = Directory(path.join(userProfile, 'Documents'));
      }
    }
    // Fallback to application documents directory
    targetDirectory ??= await getApplicationDocumentsDirectory();

    // Create attendance folder if needed
    final attendancePath = path.join(targetDirectory.path, 'attendance');
    final attendanceDir = Directory(attendancePath);

    if (!await attendanceDir.exists()) {
      await attendanceDir.create(recursive: true);
    }

    return attendancePath;
  } catch (e) {
    print('Error setting attendance folder: $e');
    return '';
  }}