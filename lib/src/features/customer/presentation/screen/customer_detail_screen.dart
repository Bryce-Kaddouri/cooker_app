import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../order/data/model/order_model.dart';
import '../../../order/presentation/provider/order_provider.dart';
import '../../../status/model/status_model.dart';
import '../../data/model/customer_model.dart';
import '../provider/customer_provider.dart';

class OrderByDateModel {
  final DateTime date;
  final List<OrderModel> orders;

  OrderByDateModel({
    required this.date,
    required this.orders,
  });
}

class CustomerDetailScreen extends StatelessWidget {
  final int id;
  CustomerDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<dynamic>>(
              future: Future.wait([
                context.read<CustomerProvider>().getCustomerById(id),
                context.read<OrderProvider>().getOrdersByCustomerId(id),

                /* OrderDataSource().getOrdersBySupplierId(id),*/
              ]),
              builder: (context, snapshot) {
/*
                print(snapshot.data);
*/
                if (snapshot.hasData) {
                  print('-' * 50);
                  print(snapshot.data);
                  print('-' * 50);
                  CustomerModel customerModel = snapshot.data![0];
                  print(customerModel.fName);
                  print(customerModel.lName);
                  print(customerModel.phoneNumber);

                  List<OrderModel> orderList = snapshot.data![1];
                  print('order list length');

                  List<OrderByDateModel> orderByDateList = [];
                  for (int i = 0; i < orderList.length; i++) {
                    bool isExist = false;
                    for (int j = 0; j < orderByDateList.length; j++) {
                      if (orderByDateList[j].date == orderList[i].date) {
                        isExist = true;
                        orderByDateList[j].orders.add(orderList[i]);
                      }
                    }
                    if (!isExist) {
                      orderByDateList.add(OrderByDateModel(
                        date: orderList[i].date,
                        orders: [orderList[i]],
                      ));
                    }
                  }
                  print(orderByDateList.length);

                  return Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text('First Name: ${customerModel.fName}'),
                            Text('Last Name: ${customerModel.lName}'),
                            Text('Phone Number: ${customerModel.phoneNumber}'),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: Column(
                          children:
                              List.generate(orderByDateList.length, (index) {
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                      'Date: ${orderByDateList[index].date}'),
                                  color: Colors.blue,
                                ),
                                Column(
                                  children: List.generate(
                                      orderByDateList[index].orders.length,
                                      (index2) {
                                    StatusModel statusModel =
                                        orderByDateList[index]
                                            .orders[index2]
                                            .status;
                                    Color statusColor = Color.fromRGBO(
                                        statusModel.color.red,
                                        statusModel.color.green,
                                        statusModel.color.blue,
                                        1);
                                    return Card(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    child: Text(
                                                        '${orderByDateList[index].orders[index2].id}'),
                                                  ),
                                                  Text(
                                                    '${orderByDateList[index].orders[index2].status.name}',
                                                    style: TextStyle(
                                                        color: statusColor),
                                                  ),
                                                  Text(
                                                      '${orderByDateList[index].orders[index2].time.hour}:${orderByDateList[index].orders[index2].time.minute}'),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(Icons.arrow_forward_ios),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
