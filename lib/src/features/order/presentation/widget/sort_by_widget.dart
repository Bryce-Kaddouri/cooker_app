import 'package:cooker_app/src/core/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/sort_provider.dart';

class SortByWidget extends StatelessWidget {
  const SortByWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? MenuAnchor(
            alignmentOffset: Offset(-190, 10),
            style: MenuStyle(
              minimumSize: MaterialStateProperty.all(
                Size(300, 430),
              ),
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
              shadowColor: MaterialStateProperty.all(Colors.black),
              elevation: MaterialStateProperty.all(
                1,
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.all(0),
              ),
              surfaceTintColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(
                    width: 3,
                    color: Theme.of(context).cardColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              fixedSize: MaterialStateProperty.all(
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
                      Container(
                        child: Row(
                          children: [
                            Text('Time'),
                            Checkbox(
                                value: context.watch<SortProvider>().sortType ==
                                    SortType.time,
                                onChanged: (value) {
                                  if (value == true) {
                                    context
                                        .read<SortProvider>()
                                        .setSortType(SortType.time);
                                  }
                                })
                          ],
                        ),
                      ),
                      RadioListTile(
                        value: true,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.time
                            ? (value) {
                                context.read<SortProvider>().setAscending(true);
                              }
                            : null,
                        title: Text('Ascending'),
                        toggleable: false,
                      ),
                      RadioListTile(
                          value: false,
                          groupValue: context.watch<SortProvider>().isAscending,
                          onChanged: context.watch<SortProvider>().sortType ==
                                  SortType.time
                              ? (value) {
                                  context
                                      .read<SortProvider>()
                                      .setAscending(false);
                                }
                              : null,
                          title: Text('Descending'),
                          toggleable: false),
                    ],
                  )),
              Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('Order ID'),
                            Checkbox(
                                value: context.watch<SortProvider>().sortType ==
                                    SortType.orderId,
                                onChanged: (value) {
                                  if (value == true) {
                                    context
                                        .read<SortProvider>()
                                        .setSortType(SortType.orderId);
                                  }
                                })
                          ],
                        ),
                      ),
                      RadioListTile(
                        value: true,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.orderId
                            ? (value) {
                                context.read<SortProvider>().setAscending(true);
                              }
                            : null,
                        title: Text('Ascending'),
                      ),
                      RadioListTile(
                        value: false,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.orderId
                            ? (value) {
                                context
                                    .read<SortProvider>()
                                    .setAscending(false);
                              }
                            : null,
                        title: Text('Descending'),
                      ),
                    ],
                  )),
              Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('Customer'),
                            Checkbox(
                                value: context.watch<SortProvider>().sortType ==
                                    SortType.customer,
                                onChanged: (value) {
                                  if (value == true) {
                                    context
                                        .read<SortProvider>()
                                        .setSortType(SortType.customer);
                                  }
                                })
                          ],
                        ),
                      ),
                      RadioListTile(
                        value: true,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.customer
                            ? (value) {
                                context.read<SortProvider>().setAscending(true);
                              }
                            : null,
                        title: Text('A-Z'),
                      ),
                      RadioListTile(
                        value: false,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.customer
                            ? (value) {
                                context
                                    .read<SortProvider>()
                                    .setAscending(false);
                              }
                            : null,
                        title: Text('Z-A'),
                      ),
                    ],
                  )),
              Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('Items'),
                            Checkbox(
                                value: context.watch<SortProvider>().sortType ==
                                    SortType.items,
                                onChanged: (value) {
                                  if (value == true) {
                                    context
                                        .read<SortProvider>()
                                        .setSortType(SortType.items);
                                  }
                                })
                          ],
                        ),
                      ),
                      RadioListTile(
                        value: true,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.items
                            ? (value) {
                                context.read<SortProvider>().setAscending(true);
                              }
                            : null,
                        title: Text('Ascending'),
                      ),
                      RadioListTile(
                        value: false,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.items
                            ? (value) {
                                context
                                    .read<SortProvider>()
                                    .setAscending(false);
                              }
                            : null,
                        title: Text('Descending'),
                      ),
                    ],
                  )),
              Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('Total'),
                            Checkbox(
                                value: context.watch<SortProvider>().sortType ==
                                    SortType.total,
                                onChanged: (value) {
                                  if (value == true) {
                                    context
                                        .read<SortProvider>()
                                        .setSortType(SortType.total);
                                  }
                                })
                          ],
                        ),
                      ),
                      RadioListTile(
                        value: true,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.total
                            ? (value) {
                                context.read<SortProvider>().setAscending(true);
                              }
                            : null,
                        title: Text('Ascending'),
                      ),
                      RadioListTile(
                        value: false,
                        groupValue: context.watch<SortProvider>().isAscending,
                        onChanged: context.watch<SortProvider>().sortType ==
                                SortType.total
                            ? (value) {
                                context
                                    .read<SortProvider>()
                                    .setAscending(false);
                              }
                            : null,
                        title: Text('Descending'),
                      ),
                    ],
                  )),
            ],
            builder: (context, menuController, child) {
              return GestureDetector(
                onTap: () {
                  if (menuController.isOpen) {
                    menuController.close();
                  } else {
                    menuController.open();
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
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
          )
        : Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            height: 50,
            width: 50,
            child: InkWell(
              child: Icon(Icons.sort_by_alpha_rounded),
              onTap: () {
                showModalBottomSheet(
                    anchorPoint: Offset(0.5, 0.5),
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.6,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    isScrollControlled: true,
                    useSafeArea: true,
                    enableDrag: true,
                    showDragHandle: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text('Sort by'),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Time'),
                                          Checkbox(
                                              value: context
                                                      .watch<SortProvider>()
                                                      .sortType ==
                                                  SortType.time,
                                              onChanged: (value) {
                                                if (value == true) {
                                                  context
                                                      .read<SortProvider>()
                                                      .setSortType(
                                                          SortType.time);
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                    RadioListTile(
                                      value: true,
                                      groupValue: context
                                          .watch<SortProvider>()
                                          .isAscending,
                                      onChanged: context
                                                  .watch<SortProvider>()
                                                  .sortType ==
                                              SortType.time
                                          ? (value) {
                                              context
                                                  .read<SortProvider>()
                                                  .setAscending(true);
                                            }
                                          : null,
                                      title: Text('Ascending'),
                                    ),
                                    RadioListTile(
                                        value: false,
                                        groupValue: context
                                            .watch<SortProvider>()
                                            .isAscending,
                                        onChanged: context
                                                    .watch<SortProvider>()
                                                    .sortType ==
                                                SortType.time
                                            ? (value) {
                                                context
                                                    .read<SortProvider>()
                                                    .setAscending(false);
                                              }
                                            : null,
                                        title: Text('Descending')),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Order ID'),
                                          Checkbox(
                                              value: context
                                                      .watch<SortProvider>()
                                                      .sortType ==
                                                  SortType.orderId,
                                              onChanged: (value) {
                                                if (value == true) {
                                                  context
                                                      .read<SortProvider>()
                                                      .setSortType(
                                                          SortType.orderId);
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                    RadioListTile(
                                      value: true,
                                      groupValue: context
                                          .watch<SortProvider>()
                                          .isAscending,
                                      onChanged: context
                                                  .watch<SortProvider>()
                                                  .sortType ==
                                              SortType.orderId
                                          ? (value) {
                                              context
                                                  .read<SortProvider>()
                                                  .setAscending(true);
                                            }
                                          : null,
                                      title: Text('Ascending'),
                                    ),
                                    RadioListTile(
                                      value: false,
                                      groupValue: context
                                          .watch<SortProvider>()
                                          .isAscending,
                                      onChanged: context
                                                  .watch<SortProvider>()
                                                  .sortType ==
                                              SortType.orderId
                                          ? (value) {
                                              context
                                                  .read<SortProvider>()
                                                  .setAscending(false);
                                            }
                                          : null,
                                      title: Text('Descending'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Customer'),
                                          Checkbox(
                                              value: context
                                                      .watch<SortProvider>()
                                                      .sortType ==
                                                  SortType.customer,
                                              onChanged: (value) {
                                                if (value == true) {
                                                  context
                                                      .read<SortProvider>()
                                                      .setSortType(
                                                          SortType.customer);
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                    RadioListTile(
                                      value: true,
                                      groupValue: context
                                          .watch<SortProvider>()
                                          .isAscending,
                                      onChanged: context
                                                  .watch<SortProvider>()
                                                  .sortType ==
                                              SortType.customer
                                          ? (value) {
                                              context
                                                  .read<SortProvider>()
                                                  .setAscending(true);
                                            }
                                          : null,
                                      title: Text('A-Z'),
                                    ),
                                    RadioListTile(
                                      value: false,
                                      groupValue: context
                                          .watch<SortProvider>()
                                          .isAscending,
                                      onChanged: context
                                                  .watch<SortProvider>()
                                                  .sortType ==
                                              SortType.customer
                                          ? (value) {
                                              context
                                                  .read<SortProvider>()
                                                  .setAscending(false);
                                            }
                                          : null,
                                      title: Text('Z-A'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text('Items'),
                                          Checkbox(
                                              value: context
                                                      .watch<SortProvider>()
                                                      .sortType ==
                                                  SortType.items,
                                              onChanged: (value) {
                                                if (value == true) {
                                                  context
                                                      .read<SortProvider>()
                                                      .setSortType(
                                                          SortType.items);
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                    RadioListTile(
                                      value: true,
                                      groupValue: context
                                          .watch<SortProvider>()
                                          .isAscending,
                                      onChanged: context
                                                  .watch<SortProvider>()
                                                  .sortType ==
                                              SortType.items
                                          ? (value) {
                                              context
                                                  .read<SortProvider>()
                                                  .setAscending(true);
                                            }
                                          : null,
                                      title: Text('Ascending'),
                                    ),
                                    RadioListTile(
                                      value: false,
                                      groupValue: context
                                          .watch<SortProvider>()
                                          .isAscending,
                                      onChanged: context
                                                  .watch<SortProvider>()
                                                  .sortType ==
                                              SortType.items
                                          ? (value) {
                                              context
                                                  .read<SortProvider>()
                                                  .setAscending(false);
                                            }
                                          : null,
                                      title: Text('Descending'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          );
  }
}
