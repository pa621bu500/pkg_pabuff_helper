import 'dart:convert';
import 'dart:js_interop';

import 'package:buff_helper/pkg_buff_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

// import 'dart:html' as html;
import 'package:web/web.dart' as web;

class WgtBillRenderPdf extends StatefulWidget {
  const WgtBillRenderPdf({
    super.key,
    required this.billingInfo,
  });

  final Map<String, dynamic> billingInfo;

  @override
  State<WgtBillRenderPdf> createState() => _WgtBillRenderPdfState();
}

class _WgtBillRenderPdfState extends State<WgtBillRenderPdf> {
  String _fileName = 'bill';

  late final actions = <PdfPreviewAction>[
    // if (!kIsWeb)
    //   const PdfPreviewAction(
    //     icon: Icon(Icons.cloud_download),
    //     onPressed: _saveAsFile,
    //   )
    PdfPreviewAction(
      icon: const Icon(Icons.cloud_download),
      onPressed: _savePdf,
    )
  ];

  Future<String> _savePdf(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    String suffix = '';
    //if web
    if (kIsWeb) {
      await generateAndSavePdfWeb(
        build,
        pageFormat,
        '$_fileName$suffix',
      );
    } else {
      await generateAndSavePdfMobile(
        build,
        pageFormat,
        '$_fileName$suffix',
      );
    }
    return 'ok';
  }

  @override
  void initState() {
    super.initState();
    // _fileName = 'bill_${widget.billingInfo['billing_rec_index']}';
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 1000,
      ),
      child: PdfPreview(
        maxPageWidth: 700,
        allowSharing: false,
        canChangeOrientation: false,
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: false,
        canDebug: kDebugMode,
        build: (format) => generateInvoice(format, widget.billingInfo),
        actions: actions,
        loadingWidget: xtWait(
          size: 34,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPrinted: (context) {
          if (kDebugMode) {
            print('Printed');
          }
        },
        onShared: (context) {},
      ),
    );
  }
}

Future<void> generateAndSavePdfWeb(
  LayoutCallback build,
  PdfPageFormat pageFormat,
  String fileName,
) async {
  final bytes = await build(pageFormat);
  List<int> fileInts = List.from(bytes);
  final base64String = base64.encode(fileInts);

  web.HTMLAnchorElement()
    ..href = 'data:application/pdf;base64,$base64String'
    ..download = '$fileName.pdf'
    ..click();

  // html.AnchorElement(
  //     href:
  //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
  //   ..setAttribute("download", '$fileName.pdf')
  //   ..click();
}

Future<void> generateAndSavePdfMobile(
  LayoutCallback build,
  PdfPageFormat pageFormat,
  String fileName,
) async {
  final bytes = await build(pageFormat);

  final file = File('$fileName.pdf');
  await file.writeAsBytes(bytes);
}

Future<void> _saveAsFile(
  LayoutCallback build,
  PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  if (kDebugMode) {
    print('Save as file ${file.path} ...');
  }
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}
