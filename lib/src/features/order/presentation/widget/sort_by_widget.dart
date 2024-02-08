import 'package:flutter/material.dart';

class SortByWidget extends StatelessWidget {
  const SortByWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(

      alignmentOffset: Offset(-190, 10),

      style: MenuStyle(
        minimumSize: MaterialStateProperty.all(
          Size(300, 430),
        ),
        backgroundColor:
        MaterialStateProperty.all(
            Theme.of(context)
                .primaryColor),
        shadowColor:
        MaterialStateProperty.all(
            Colors.black),
        elevation:
        MaterialStateProperty.all(
          1,
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.all(0),
        ),
        surfaceTintColor:
        MaterialStateProperty.all(
            Theme.of(context)
                .primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(
              width: 3,
              color: Theme.of(context)
                  .cardColor,
            ),
            borderRadius:
            BorderRadius.circular(10),
          ),
        ),
        fixedSize:
        MaterialStateProperty.all(
          Size(300, 430),
        ),

      ),

      menuChildren: [
      Container(
        width: double.infinity,
        child: Text('Sort by'),
      ),
      Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('Time'),
          RadioListTile(value: true, groupValue: true, onChanged: (value){}, title: Text('Ascending'),),
          RadioListTile(value: false, groupValue: true, onChanged: (value){}, title: Text('Descending'),),

        ],)
      ),
        Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
              Text('Order ID'),
              RadioListTile(value: true, groupValue: true, onChanged: (value){}, title: Text('Ascending'),),
              RadioListTile(value: false, groupValue: true, onChanged: (value){}, title: Text('Descending'),),

            ],)
        ),
        Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('Customer'),
              RadioListTile(value: true, groupValue: true, onChanged: (value){}, title: Text('A-Z'),),
              RadioListTile(value: false, groupValue: true, onChanged: (value){}, title: Text('Z-A'),),

            ],)
        ),
        Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('Items'),
              RadioListTile(value: true, groupValue: true, onChanged: (value){}, title: Text('Ascending'),),
              RadioListTile(value: false, groupValue: true, onChanged: (value){}, title: Text('Descending'),),

            ],)
        ),
        Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('Total'),
              RadioListTile(value: true, groupValue: true, onChanged: (value){}, title: Text('Ascending'),),
              RadioListTile(value: false, groupValue: true, onChanged: (value){}, title: Text('Descending'),),

            ],)
        ),
    ],
    builder: (context, menuController, child){
      return GestureDetector(
        onTap: () {
          if (menuController.isOpen) {
            menuController.close();
          } else {
            menuController.open();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 5, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).primaryColor,
          ),
          height: 40,
          child: Row(
            children: [
              Icon(Icons.sort_by_alpha_rounded),
              SizedBox(width: 8),
              Text('Sort by'),
            ],
          ),
        ),
      );
    },
    );
  }
}
