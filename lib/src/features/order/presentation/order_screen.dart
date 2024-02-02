import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
/*
            Navigator.of(context).pop();
*/
          },
        ),
        title: Row(
          children: [
            ElevatedButton(

                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,  foregroundColor: Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),elevation: 0, minimumSize: const Size(0, 50)),
                onPressed: (){}, child: Row(
              children: const [
                Icon(Icons.dashboard_outlined),
                SizedBox(width: 5),
                Text('Dashboard'),
              ],

            )),ElevatedButton(

                style: ElevatedButton.styleFrom(backgroundColor: Colors.white,  foregroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),elevation: 2, minimumSize: const Size(0, 50)),
                onPressed: (){}, child: Row(
              children: const [
                Icon(Icons.event_note_outlined),
                SizedBox(width: 5),
                Text('Live orders'),
              ],

            )),
            ElevatedButton(

                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,  foregroundColor: Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),elevation: 0, minimumSize: const Size(0, 50)),
                onPressed: (){}, child: Row(
              children: const [
                Icon(Icons.dashboard_outlined),
                SizedBox(width: 5),
                Text('Products'),
              ],

            ))
          ],
        )
      ),
      body: const Center(
        child: Text('Order Screen'),
      ),
    );
  }
}
