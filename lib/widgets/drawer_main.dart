import 'package:food_info_app/providers/barcode_provider.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/screens/main_screen.dart';
import 'package:food_info_app/widgets/my_list_tile.dart';
import 'package:provider/provider.dart';

class DrawerMain extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const DrawerMain(
      {super.key, required this.onProfileTap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(child: Consumer<BarcodeProvider>(
        builder: (context, barcode, child) {
          return ListView(children: [
            const DrawerHeader(
                child: Icon(
              Icons.person,
              color: Colors.indigo,
              size: 64,
            )),

            MyListTile(
              icon: Icons.home,
              text: 'Home',
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(text: ""),
                  ),
                );
              },
            ),

            MyListTile(
              icon: Icons.person,
              text: 'Profile',
              onTap: onProfileTap,
            ),

            MyListTile(
              icon: Icons.logout,
              text: 'Log Out',
              onTap: onSignOut,
            )

            // ListTile(
            //   leading: Icon(Icons.volume_up, color: primary),
            //   title: const Text("Sound", style: TextStyle(fontSize: 16)),
            //   trailing: Switch(
            //       value: !barcode.isMuted,
            //       onChanged: (value) => barcode.toggleSound()),
            // ),
            // ListTile(
            //   leading: Icon(Icons.volume_up, color: primary),
            //   title: const Text("Sound", style: TextStyle(fontSize: 16)),
            //   trailing: Switch(
            //       value: !barcode.isMuted,
            //       onChanged: (value) => barcode.toggleSound()),
            // ),
            // ListTile(
            //   leading: Icon(Icons.vibration, color: primary),
            //   title: const Text("Vibration", style: TextStyle(fontSize: 16)),
            //   trailing: Switch(
            //       value: !barcode.isVibrateOff,
            //       onChanged: (value) => barcode.toggleVibration()),
            // ),
          ]);
        },
      )),
    );
  }
}
