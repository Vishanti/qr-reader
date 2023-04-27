import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlMethod(BuildContext context, ScanModel scan) async {
  final Uri url = Uri.parse(scan.value);
  if (scan.type == 'http') {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}
