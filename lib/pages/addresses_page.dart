import 'package:flutter/material.dart';
import 'package:qr_reader/widgets/scan_tiles.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScanTiles(type: 'http');
  }
}
