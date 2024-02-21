import 'package:cooker_app/src/core/helper/date_helper.dart';
import 'package:cooker_app/src/features/setting/presentation/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            DateTime date = DateTime.now();
            String dateStr = DateHelper.getFormattedDate(date);
            context.goNamed('orders', pathParameters: {
              'date': dateStr,
            });
          },
        ),
        automaticallyImplyLeading: true,
        title: Text('Setting'),
      ),
      body: ListView(
        children: [
          ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Mode'),
              trailing: Switch.adaptive(
                  value: context.watch<SettingProvider>().isDarkMode,
                  onChanged: (value) {
                    context.read<SettingProvider>().saveTheme(value);
                    // change theme
                  })),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              // navigate to profile screen
            },
          ),
          ListTile(
            title: Text('Change Password'),
            onTap: () {
              // navigate to change password screen
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // logout
            },
          ),
        ],
      ),
    );
  }
}
