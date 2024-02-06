import '../config.dart';
import '../api/transaction.dart';
import '../object/transaction.dart';
import '../component/interaction.dart';
import '../component/transaction.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class RowCtl {
  bool onSort;
  bool sortAscend;

  RowCtl({
    required this.onSort,
    required this.sortAscend,
  });
}

class RowTitle {
  double width;
  String name;
  Function(bool) sort;

  RowTitle({
    required this.width,
    required this.name,
    required this.sort,
  });
}

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  int colIndex = 0;
  int numColumn = 8;
  int searchStatus = 0;
  bool sortAscend = true;
  bool allSelected = false;
  DateTimeRange searchRange = DateTimeRange(start: ini.timeStart, end: DateTime.now());
  TextEditingController filterName = TextEditingController(text: "");
  TextEditingController filterUnit = TextEditingController(text: "");
  List<Transaction> selfTransactions = [];
  late List<RowCtl> rowCtl;

  @override
  void initState() {
    rowCtl = List.generate(numColumn, (index) => RowCtl(onSort: false, sortAscend: false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RowTitle> titles = [
      RowTitle(
        width: 6.w,
        name: context.tr('customer_colName'),
        sort: (direction) {
          setState(() {
            selfTransactions.sort((a, b) => direction ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
          });
        },
      ),
      RowTitle(
        width: 10.w,
        name: context.tr('customer_colProject'),
        sort: (direction) {
          setState(() {
            selfTransactions.sort((a, b) => direction ? a.projectName.compareTo(b.projectName) : b.projectName.compareTo(a.projectName));
          });
        },
      ),
      RowTitle(
        width: 6.w,
        name: context.tr('customer_colUnit'),
        sort: (direction) {
          setState(() {
            selfTransactions.sort((a, b) => direction ? a.unit.compareTo(b.unit) : b.unit.compareTo(a.unit));
          });
        },
      ),
      RowTitle(
        width: 6.w,
        name: context.tr('customer_colPrice'),
        sort: (direction) {
          setState(() {
            selfTransactions.sort((a, b) => direction ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
          });
        },
      ),
      RowTitle(
        width: 10.w,
        name: context.tr('customer_colStatus'),
        sort: (direction) {
          setState(() {
            selfTransactions.sort((a, b) => direction ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
          });
        },
      ),
      RowTitle(
        width: 7.w,
        name: context.tr('customer_colDate'),
        sort: (direction) {
          setState(() {
            selfTransactions.sort(
              (a, b) => direction ? a.saleDate.toString().compareTo(b.saleDate.toString()) : b.saleDate.toString().compareTo(a.saleDate.toString()),
            );
          });
        },
      ),
      RowTitle(
        width: 10.w,
        name: context.tr('customer_colAgent'),
        sort: (direction) {
          setState(() {
            selfTransactions.sort((a, b) =>
                direction ? userShowText(a.agent).compareTo(userShowText(b.agent)) : userShowText(b.agent).compareTo(userShowText(a.agent)));
          });
        },
      ),
      RowTitle(
        width: 16.w,
        name: context.tr('customer_colDescription'),
        sort: (direction) {
          setState(() {
            selfTransactions.sort((a, b) => direction
                ? a.description.toString().compareTo(b.description.toString())
                : b.description.toString().compareTo(a.description.toString()));
          });
        },
      ),
    ];
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        double sWidth = MediaQuery.of(context).size.width;
        bool isMobile = sWidth < 700;
        return Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 2.w : 10.w, vertical: 2.h),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 7.h,
                                child: TextField(
                                  controller: filterName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: uiStyle.roundCorner2),
                                    labelText: context.tr('customer_colName'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: SizedBox(
                                height: 7.h,
                                child: TextField(
                                  controller: filterUnit,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: uiStyle.roundCorner2),
                                    labelText: context.tr('customer_colUnit'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Container(
                                height: 7.h,
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: DropdownButton2(
                                  underline: const SizedBox(),
                                  iconStyleData: const IconStyleData(icon: SizedBox()),
                                  hint: Text(context.tr('customer_selStatus')),
                                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                  items: ini.transactionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      searchStatus = ini.transactionStatus.indexWhere((element) => element == newValue);
                                    });
                                  },
                                  value: ini.transactionStatus[searchStatus],
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                onPressed: () {
                                  selectDateRange(context).then((value) {
                                    setState(() {
                                      searchRange = value;
                                    });
                                  });
                                },
                                child: Container(
                                  height: 7.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                  child: text3(
                                    "${searchRange.start.year}/${searchRange.start.month}/${searchRange.start.day} ~"
                                    "${searchRange.end.year}/${searchRange.end.month}/${searchRange.end.day}",
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: uiStyle.roundCorner2,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                tooltip: context.tr('add'),
                                onPressed: () {
                                  transactionEdit(context, Transaction.create(), 1, true).then((value) {
                                    if (value != "") {
                                      alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                    }
                                    searchTransaction();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: uiStyle.roundCorner2,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.search),
                                tooltip: context.tr('search'),
                                onPressed: () {
                                  searchTransaction();
                                },
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: uiStyle.roundCorner2,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.cleaning_services_rounded),
                                tooltip: context.tr('clear'),
                                onPressed: () {
                                  clearFilter();
                                },
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.grey),
                                borderRadius: uiStyle.roundCorner2,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete_forever_outlined),
                                tooltip: context.tr('delete'),
                                onPressed: () {
                                  List<int> deletes = [];
                                  for (var element in selfTransactions) {
                                    if (element.onSelect) {
                                      deletes.add(element.id);
                                    }
                                  }
                                  if (deletes.isEmpty) {
                                    alertDialog(context, context.tr('error'), context.tr('noDataSelect'), context.tr('ok'));
                                    return;
                                  }
                                  deleteTransaction(deletes).then((value) {
                                    if (value != "") {
                                      alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                    }
                                    searchTransaction();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: uiStyle.roundCorner2,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 0.5.w),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  allSelected = !allSelected;
                                  for (var element in selfTransactions) {
                                    element.onSelect = allSelected;
                                  }
                                });
                              },
                              icon: allSelected ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                            ),
                            SizedBox(width: 0.5.w),
                            Expanded(
                              child: Wrap(
                                children: titles.asMap().entries.map((e) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (rowCtl[e.key].onSort) {
                                          if (rowCtl[e.key].sortAscend) {
                                            rowCtl[e.key].sortAscend = false;
                                            titles[e.key].sort(false);
                                          } else {
                                            rowCtl[e.key].onSort = false;
                                          }
                                        } else {
                                          for (var element in rowCtl) {
                                            element.onSort = false;
                                            element.sortAscend = false;
                                          }
                                          rowCtl[e.key].onSort = true;
                                          rowCtl[e.key].sortAscend = true;
                                          titles[e.key].sort(true);
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 5.h,
                                      width: titles[e.key].width,
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          text3(titles[e.key].name, isBold: true),
                                          if (rowCtl[e.key].onSort)
                                            rowCtl[e.key].sortAscend ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: selfTransactions.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  SizedBox(width: 0.5.w),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selfTransactions[index].onSelect = !selfTransactions[index].onSelect;

                                        allSelected = true;
                                        for (var element in selfTransactions) {
                                          if (!element.onSelect) {
                                            allSelected = false;
                                          }
                                        }
                                      });
                                    },
                                    icon: selfTransactions[index].onSelect ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                                  ),
                                  SizedBox(width: 0.5.w),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 1.h),
                                      child: Wrap(
                                        children: [
                                          text3(selfTransactions[index].name),
                                          text3(selfTransactions[index].projectName),
                                          text3(selfTransactions[index].unit),
                                          text3(selfTransactions[index].price.toString()),
                                          text3(ini.transactionStatus[selfTransactions[index].status]),
                                          text3(selfTransactions[index].saleDate.toString().substring(0, 10)),
                                          text3(userShowText(selfTransactions[index].agent)),
                                          text3(selfTransactions[index].description),
                                        ].asMap().entries.map((e) => SizedBox(width: titles[e.key].width, child: e.value)).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w),
                                  IconButton(
                                    onPressed: () {
                                      transactionEdit(context, selfTransactions[index], 1, false).then((value) {
                                        if (value != "") {
                                          alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                        }
                                        searchTransaction();
                                      });
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  SizedBox(width: 0.5.w),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      },
    );
  }

  clearFilter() {
    filterName.text = "";
    filterUnit.text = "";
    searchStatus = 0;
    searchRange = DateTimeRange(start: ini.timeStart, end: DateTime.now());
    setState(() {});
  }

  searchTransaction() {
    getTransactionList(
      TransactionGetRequest(
        name: filterName.text,
        projectName: "",
        status: searchStatus,
        payStatus: 0,
        unit: filterUnit.text,
        launchDateStart: "",
        launchDateEnd: "",
        saleDateStart: searchRange.start.toString(),
        saleDateEnd: searchRange.end.toString(),
      ),
    ).then((value) {
      if (value != null) {
        selfTransactions = value;
      } else {
        alertDialog(context, context.tr('error'), context.tr('emptySearch'), context.tr('ok'));
      }
      setState(() {});
    });
  }
}
