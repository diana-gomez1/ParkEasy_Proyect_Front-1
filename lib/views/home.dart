import 'package:flutter/material.dart';
import 'package:memes/views/caja/caja_list_view.dart';
import 'package:memes/views/establecimiento/establecimiento_list_view.dart';
import 'package:memes/views/factura/factura_list_view.dart';

import 'package:memes/views/tipovehiculo/tipovehiculo_list_view.dart';
//import 'package:memes/config/theme/app_theme.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 32, 126, 220),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.free_cancellation_rounded),
            label: 'Factura',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Caja',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_parking),
            icon: Icon(Icons.free_cancellation_rounded),
            label: 'Info',
          ),
        ],
      ),
      body: <Widget>[
        const TipoVehiculoListView(),
        const FacturaListView(),

        // /// Notifications page
        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Column(
        //     children: <Widget>[
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 1'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //       Card(
        //         child: ListTile(
        //           leading: Icon(Icons.notifications_sharp),
        //           title: Text('Notification 2'),
        //           subtitle: Text('This is a notification'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const CajaListView(),
        const EstablecimientoListView(),
      ][currentPageIndex],
    );
  }
}
