import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/model/customer_model.dart';
import '../provider/customer_provider.dart';
import 'package:animated_search_bar/animated_search_bar.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:  BackButton(
          onPressed: (){
            context.go('/orders');
          },
        ),
        centerTitle: true,
        title: const Text('Customers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSearchBar(
              controller: context.read<CustomerProvider>().searchController,
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              searchStyle: const TextStyle(
                color: Colors.black,
              ),
              cursorColor: Colors.white,
              searchDecoration:  InputDecoration(
                hintText: "Search Customer ...",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),

              onChanged: (value) {
                context.read<CustomerProvider>().setSearchText(value);
              },
            ),
          ),
        )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: FutureBuilder<List<CustomerModel>?>(
              future: context.read<CustomerProvider>().getCustomers(),
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                print('data');
                print(snapshot.data);
                if (snapshot.hasData) {
                  List<CustomerModel>? customerList = snapshot.data;
                  customerList = customerList?.where((element) {
                    String fullName = '${element.fName!} ${element.lName!}';
                    return fullName.toLowerCase().contains(context.watch<CustomerProvider>().searchText.toLowerCase());
                  }
                  ).toList();
                  print('customerList');
                  if(customerList?.isEmpty ?? true) {
                    return const Center(child: Text('No Customers'));
                  }
                  return ListView.builder(
                    itemCount: customerList?.length,
                    itemBuilder: (context, index) {
                      return Card(child:ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          child: Text(snapshot.data?[index].fName?[0] ?? '')
                        ),
                        title: Text(snapshot.data?[index].fName ?? ''),
                        subtitle: Text(snapshot.data?[index].lName ?? ''),
                        onTap: () {
                          context.goNamed('customer-details', pathParameters: {'id': snapshot.data![index].id.toString()});
                        },
                      ),);
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),

      ),

    );
  }
}