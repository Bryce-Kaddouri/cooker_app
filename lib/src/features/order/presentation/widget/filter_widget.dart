/*
import 'dart:math' as math;

import 'package:cooker_app/src/core/helper/responsive_helper.dart';
import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/app_color.dart';
import '../../../category/model/category_model.dart';
import '../../../product/data/model/product_model.dart';
import '../../data/model/order_model.dart';
import '../provider/filter_provider.dart';
import '../provider/order_provider.dart';

class FilterWidget extends StatefulWidget {
  final DateTime selectedDate;
  const FilterWidget({super.key, required this.selectedDate});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<CategoryModel> lstCategory = [];
  List<ProductModel> lstProducts = [];
  double maxRangePrice = 100;

  @override
  void initState() {
    super.initState();
    context
        .read<OrderProvider>()
        .getOrdersByDate(
            widget.selectedDate,
            context.read<SortProvider>().sortType,
            context.read<SortProvider>().isAscending)
        .then((value) {
      List<OrderModel> lstOrders = value as List<OrderModel>;
      lstCategory =
          context.read<OrderProvider>().getAllCategoryOfSelectedDate(lstOrders);
      lstProducts =
          context.read<OrderProvider>().getAllProductOfSelectedDate(lstOrders);
      List<num> lstPrice = lstOrders.map((e) => e.totalAmount).toList();
      maxRangePrice = lstPrice.isNotEmpty ? lstPrice.reduce(math.max) : 100;
      context.read<FilterProvider>().setMaxRangePrice(
            maxRangePrice,
          );
      if (context.read<FilterProvider>().selectedMaxRangePrice == -1) {
        context.read<FilterProvider>().setSelectedMaxRangePrice(
              maxRangePrice,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return */
/*FutureBuilder(
      future: context.read<OrderProvider>().getOrdersByDate(
          selectedDate,
          context.read<SortProvider>().sortType,
          context.read<SortProvider>().isAscending),
      builder: (context, snapProduct) {
        if (snapProduct.connectionState == ConnectionState.done) {
          if (snapProduct.hasData) {
            List<OrderModel> lstOrders = snapProduct.data as List<OrderModel>;
            List<CategoryModel> lstCategory = context
                .read<OrderProvider>()
                .getAllCategoryOfSelectedDate(lstOrders);

            int selectedCategIndex =
                context.watch<FilterProvider>().selectedCategoryFilter;
            int selectedProdIndex =
                context.watch<FilterProvider>().selectedProductFilter;

            List<ProductModel> lstProducts = context
                .read<OrderProvider>()
                .getAllProductOfSelectedDate(lstOrders);

            if (selectedCategIndex != -1) {
              lstProducts = lstProducts
                  .where((element) =>
                      element.category!.id ==
                      lstCategory[selectedCategIndex].id)
                  .toList();
            }

            List<double> lstPrice =
                lstOrders.map((e) => e.totalAmount).toList();

            double maxRangePrice =
                lstPrice.isNotEmpty ? lstPrice.reduce(math.max) : 100;

            // add post frame callback to set the max range price
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              context.read<FilterProvider>().setMaxRangePrice(
                    maxRangePrice,
                  );

              if (context.read<FilterProvider>().selectedMaxRangePrice == -1) {
                context.read<FilterProvider>().setSelectedMaxRangePrice(
                      maxRangePrice,
                    );
              }
            });

            return*/ /*

        ResponsiveHelper.isDesktop(context)
            ? Container(
                */
/* padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 16),*/ /*

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor,
                ),
                height: 40,
                child: MenuAnchor(
                  // deplace the anchor to the right
                  alignmentOffset: Offset(-210, 10),
                  style: MenuStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(300, 430),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    shadowColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(
                      1,
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.all(0),
                    ),
                    surfaceTintColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          width: 3,
                          color: Theme.of(context).cardColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 16),
                      child: InkWell(
                        onTap: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            // pop menu at the right of the anchor

                            controller.open();
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.filter_alt_outlined),
                            SizedBox(width: 8),
                            Text('Filter'),
                          ],
                        ),
                      ),
                    );
                  },
                  menuChildren: [
                    // title filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).cardColor,
                            width: 3,
                          ),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text('Filter'),
                    ),
                    // end title filter
                    // start filter by time
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Time Range'),
                            TextButton(
                              onPressed: () {
                                */
/* context
                                                                    .read<
                                                                    FilterProvider>()
                                                                    .resetSelectedCategoryFilter();*/ /*

                              },
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('From:',
                                        style: TextStyle(
                                            color: AppColor.lightBlackTextColor,
                                            fontSize: 12)),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 1,

                                          surfaceTintColor:
                                              Theme.of(context).primaryColor,
                                          shadowColor: Colors.black,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          foregroundColor:
                                              AppColor.lightBlackTextColor,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 2,
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? time =
                                              await showTimePicker(
                                                      context: context,
                                                      initialTime: context
                                                          .read<
                                                              FilterProvider>()
                                                          .selectedStartTime)
                                                  .then((value) {
                                            if (value != null) {
                                              int startSeconds =
                                                  value.hour * 3600 +
                                                      value.minute * 60;
                                              int endSeconds = context
                                                          .read<
                                                              FilterProvider>()
                                                          .selectedEndTime
                                                          .hour *
                                                      3600 +
                                                  context
                                                          .read<
                                                              FilterProvider>()
                                                          .selectedEndTime
                                                          .minute *
                                                      60;

                                              if (startSeconds < endSeconds) {
                                                context
                                                    .read<FilterProvider>()
                                                    .setSelectedStartTime(
                                                        value);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    showCloseIcon: true,
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'Start time must be less than end time'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            }
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(context
                                                .watch<FilterProvider>()
                                                .selectedStartTime
                                                .format(context)),
                                            Icon(Icons.access_time_outlined),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('To:',
                                        style: TextStyle(
                                            color: AppColor.lightBlackTextColor,
                                            fontSize: 12)),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 1,
                                          surfaceTintColor:
                                              Theme.of(context).primaryColor,
                                          shadowColor: Colors.black,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          foregroundColor:
                                              AppColor.lightBlackTextColor,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 2,
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? time =
                                              await showTimePicker(
                                                      errorInvalidText:
                                                          'Invalid time',
                                                      context: context,
                                                      initialTime: context
                                                          .read<
                                                              FilterProvider>()
                                                          .selectedEndTime)
                                                  .then((TimeOfDay? value) {
                                            if (value != null) {
                                              // check if the selected time is greater than the start time
                                              int endSeconds =
                                                  value.hour * 3600 +
                                                      value.minute * 60;
                                              int startSeconds = context
                                                          .read<
                                                              FilterProvider>()
                                                          .selectedStartTime
                                                          .hour *
                                                      3600 +
                                                  context
                                                          .read<
                                                              FilterProvider>()
                                                          .selectedStartTime
                                                          .minute *
                                                      60;

                                              print(endSeconds);
                                              print(startSeconds);
                                              if (endSeconds > startSeconds) {
                                                context
                                                    .read<FilterProvider>()
                                                    .setSelectedEndTime(value);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    showCloseIcon: true,
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'End time must be greater than start time'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            }
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(context
                                                .watch<FilterProvider>()
                                                .selectedEndTime
                                                .format(context)),
                                            Icon(Icons.access_time_outlined),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // end filter by time
                    // statrt category filter

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).cardColor,
                            width: 3,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Category'),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<FilterProvider>()
                                      .resetSelectedCategoryFilter();
                                },
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            child: SubmenuButton(
                                controller: context
                                    .read<FilterProvider>()
                                    .menuControllerCategory,
                                onClose: () {
                                  print('closed');
                                },
                                alignmentOffset: Offset(14, 10),
                                menuChildren: List.generate(
                                    lstCategory.length,
                                    (index) => Container(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                            child: RadioListTile(
                                              value: index,
                                              groupValue: context
                                                  .watch<FilterProvider>()
                                                  .selectedCategoryFilter,
                                              title:
                                                  Text(lstCategory[index].name),
                                              onChanged: (value) {
                                                print(value);
                                                context
                                                    .read<FilterProvider>()
                                                    .setSelectedCategoryFilter(
                                                        value ?? -1);
                                                // close submenu
                                                Future.delayed(
                                                    Duration(milliseconds: 500),
                                                    () {
                                                  context
                                                      .read<FilterProvider>()
                                                      .menuControllerCategory
                                                      .close();
                                                });
                                              },
                                            ),
                                          ),
                                        )),
                                child: context
                                            .watch<FilterProvider>()
                                            .selectedCategoryFilter ==
                                        -1
                                    ? Text(
                                        'All',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    : Container(
                                        child: Text(
                                          lstCategory[context
                                                  .watch<FilterProvider>()
                                                  .selectedCategoryFilter]
                                              .name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColor.lightBlackTextColor,
                                          ),
                                        ),
                                      )),
                          )
                        ],
                      ),
                    ),
                    //end category filter
                    // start product filter
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Product'),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<FilterProvider>()
                                    .resetSelectedProductFilter();
                              },
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: SubmenuButton(
                            controller:
                                context.read<FilterProvider>().menuController,
                            onClose: () {
                              print('closed');
                            },
                            alignmentOffset: Offset(14, 10),
                            menuChildren: List.generate(
                                lstProducts.length,
                                (index) => Container(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Theme.of(context).cardColor,
                                        ),
                                        child: RadioListTile(
                                          value: index,
                                          groupValue: context
                                              .watch<FilterProvider>()
                                              .selectedProductFilter,
                                          title: Text(lstProducts[index].name),
                                          onChanged: (value) {
                                            print(value);
                                            context
                                                .read<FilterProvider>()
                                                .setSelectedProductFilter(
                                                    value ?? -1);
                                            // close submenu
                                            Future.delayed(
                                                Duration(milliseconds: 500),
                                                () {
                                              context
                                                  .read<FilterProvider>()
                                                  .menuController
                                                  .close();
                                            });
                                          },
                                        ),
                                      ),
                                    )),
                            child: context
                                        .watch<FilterProvider>()
                                        .selectedProductFilter ==
                                    -1
                                ? Text(
                                    'All',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                : Container(
                                    child: Text(
                                      lstProducts[context
                                              .watch<FilterProvider>()
                                              .selectedProductFilter]
                                          .name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColor.lightBlackTextColor,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    // end product filter
                    // start price filter
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Price range'),
                            Checkbox(
                              value: context
                                  .watch<FilterProvider>()
                                  .isFilteringByPrice,
                              onChanged: (value) {
                                print(maxRangePrice);
                                if (value!) {
                                  context
                                      .read<FilterProvider>()
                                      .setSelectedMaxRangePrice(maxRangePrice);
                                }
                                context
                                    .read<FilterProvider>()
                                    .setIsFilteringByPrice(value!);
                              },
                            ),
                          ],
                        ),
                        // slider with two thumbs
                        RangeSlider(
                            min: 0,
                            max: context
                                    .watch<FilterProvider>()
                                    .isFilteringByPrice
                                ? maxRangePrice
                                : 100,
                            values: RangeValues(
                                context
                                        .watch<FilterProvider>()
                                        .isFilteringByPrice
                                    ? context
                                        .watch<FilterProvider>()
                                        .selectedMinRangePrice
                                    : 0,
                                context
                                        .watch<FilterProvider>()
                                        .isFilteringByPrice
                                    ? context
                                        .watch<FilterProvider>()
                                        .selectedMaxRangePrice
                                    : 100),
                            labels: RangeLabels('test', 'test1'),
                            onChanged: context
                                    .watch<FilterProvider>()
                                    .isFilteringByPrice
                                ? (RangeValues value) {
                                    context
                                        .read<FilterProvider>()
                                        .setSelectedMinRangePrice(value.start);
                                    context
                                        .read<FilterProvider>()
                                        .setSelectedMaxRangePrice(value.end);
                                  }
                                : null),
                      ],
                    ),
                    // end price filter
                    // reset all and apply now button
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).cardColor,
                            width: 3,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              context
                                  .read<FilterProvider>()
                                  .resetSelectedCategoryFilter();
                              context
                                  .read<FilterProvider>()
                                  .resetSelectedProductFilter();
                              context
                                  .read<FilterProvider>()
                                  .setIsFilteringByPrice(false);
                            },
                            child: Text(
                              'Reset all',
                              style: TextStyle(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // close the menu
                              context
                                  .read<FilterProvider>()
                                  .menuController
                                  .close();
                            },
                            child: Text(
                              'Apply now',
                              style: TextStyle(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(Icons.filter_alt_outlined),
              );
    */
/* } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );*/ /*

  }
}
*/
