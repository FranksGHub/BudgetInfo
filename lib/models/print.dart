import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import '../l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:budget_info/models/filename_helper.dart';
import 'budget_settings.dart';
import '../models/year_item.dart';
import '../models/export_import_files.dart';
import 'dart:io';
import 'dart:convert';

class PrintPdf {

  Future<String> getFilePath(String fileName) async {
    late String dataPath;
    dataPath = await ExportImportFiles.getPrivateDirectoryPath();
    return p.join(dataPath, ExportImportFiles.getSaveFilename(fileName));
  }

  Future<bool> printBlockDetails(BuildContext context, BudgetSettings settings) async {
    // Header title
    String title = '${settings.titleLine}';
    // try to load list data
    String filePathName = await (settings.workplanFilename.length == 0 ? getFilePath(FilenameHelper.getDefaultLeftFilename(true)) : getFilePath(settings.workplanFilename)) + '.json';
    List<YearItem> leftItems = <YearItem>[];
    try {
      if (File(filePathName).existsSync()) {
        String json = File(filePathName).readAsStringSync();
        List<dynamic> data = jsonDecode(json);
        leftItems = List<YearItem>.from(data.map((e) => YearItem.fromJson(e)));
      }
    } catch (e) {
      return false;
    }
    if (leftItems.isEmpty) return false;

    final pdf = pw.Document(title: AppLocalizations.of(context)!.appTitle, author: AppLocalizations.of(context)!.appNameWithSpaces, subject: title, keywords: 'stundenplan, timetable, worklist, print, pdf');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(18),
        build: (pw.Context ctx) {
          return <pw.Widget>[

            // Titel
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Text(AppLocalizations.of(context)!.title + ':   ' + title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.black), textAlign: pw.TextAlign.left),
            ),
            pw.SizedBox(height: 12),

            // Items
            for (final item in leftItems) ...[
              // Item-Text (linksbündig, etwas Abstand nach unten)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Text( item.text, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.left),
              ),

              // Subitems: eingerückt, jede in einer Zeile mit Icon, Status-Text und Subitem-Text
              for (final sub in item.subitems)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 12, bottom: 4),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      // Status Icon: kleiner Kreis, grün wenn "(F)" sonst gelb
                      pw.Container( width: 8, height: 8,
                        decoration: pw.BoxDecoration(
                          color: sub.status == "(F)" ? PdfColors.green : PdfColors.yellow,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                      pw.SizedBox(width: 4),

                      // Status Text
                      pw.Text( sub.status ?? '', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(width: 8),

                      // Subitem Text (nimmt restlichen Platz)
                      pw.Expanded(child: pw.Text( sub.text, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal)) ),
                    ],
                  ),
                ),

              // Abstand zwischen Items
              pw.SizedBox(height: 8),
            ],

            // pw.Spacer(),
            // // Footer / Print notice (optional)
            pw.SizedBox(height: 12),  // Distance according to the table
            pw.Container( alignment: pw.Alignment.centerRight, padding: const pw.EdgeInsets.only(right: 6),
              child: pw.Text(AppLocalizations.of(context)!.printingFooter(DateTime.now().toLocal().toString().split('.').first), style: pw.TextStyle(fontSize: 10, color: PdfColors.grey))
            )

          ];
        },
      ),
    );

    try {
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
      return true;
    } catch (e) {
      return false;
    }
  }

}