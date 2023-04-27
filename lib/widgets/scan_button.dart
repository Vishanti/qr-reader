import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_provider.dart';
import 'package:qr_reader/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation: 0,
        onPressed: () async {
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              '#3D8BEF', 'Cancelar', false, ScanMode.QR);
          if (barcodeScanRes == '-1') return;
          final scanListProvider =
              Provider.of<ScanListProvider>(context, listen: false);
          final newScan = await scanListProvider.newScan(barcodeScanRes);
          launchUrlMethod(context, newScan);
        },
        child: const Icon(Icons.filter_center_focus));
  }
}
