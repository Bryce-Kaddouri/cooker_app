import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text("Drawer Header"),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text("Order List"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart_outlined),
            title: Text("Add Order"),
            onTap: () {
              context.go('/add-order');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("Customer List"),
            onTap: () {
              context.go('/customers');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add_outlined),
            title: Text("Add Customer"),
            onTap: () {
              context.go('/customers/add');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text("Settings"),
            onTap: () {
              print('setting');
              context.go('/setting');
            },
          ),
        ],
      ),
    );
  }
}
