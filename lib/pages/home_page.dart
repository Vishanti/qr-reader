import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/addresses_page.dart';
import 'package:qr_reader/pages/maps_page.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/scan_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/custom_navigator_bar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                final scanListProvider =
                    Provider.of<ScanListProvider>(context, listen: false);
                scanListProvider.deleteAll();
              },
              icon: const Icon(Icons.delete_forever))
        ],
        title: const Text('Historial'),
        elevation: 0,
      ),
      body: const _HomePageBody(),
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    //Obtener el selected del currentIndex
    final uiProvider = Provider.of<UiProvider>(context);

    //Cambiar para mostrar la pagina respectiva
    final currentIndex = uiProvider.selectedMenuOpt;

    //Usar el Scan Provider
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.loadScanByType("geo");
        return const MapsPage();
      case 1:
        scanListProvider.loadScanByType("http");
        return const AddressesPage();
      default:
        return const MapsPage();
    }
  }
}
