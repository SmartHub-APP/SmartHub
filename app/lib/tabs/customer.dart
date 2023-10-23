import 'package:easy_localization/easy_localization.dart';

import '../config.dart';
import '../object.dart';
import '../interaction.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  int total = 0;
  int numGet = 0;
  int nowPage = 1;
  int maxPage = 30;
  int perPage = 50;
  int colIndex = 0;
  int searchStatus = 0;
  bool sortAscend = true;
  DateTimeRange searchRange = DateTimeRange(start: ini.timeStart, end: DateTime.now());
  TextEditingController filterName = TextEditingController(text: "");
  TextEditingController filterClass = TextEditingController(text: "");
  List<Transaction> selfTransactions = [];

  @override
  Widget build(BuildContext context) {
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
                              child: TextField(
                                controller: filterName,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: context.tr('customer_colName'),
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: TextField(
                                controller: filterClass,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: context.tr('customer_colClass'),
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Container(
                                height: 7.6.h,
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
                                  height: 7.6.h,
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
                                  transactionData(context, newTransaction).then((value) {
                                    setState(() {
                                      if (value != newTransaction) {
                                        selfTransactions.add(value);
                                      }
                                    });
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
                                  setState(() {
                                    selfTransactions = fakeTransactionGenerator(30);
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
                                icon: const Icon(Icons.cleaning_services_rounded),
                                tooltip: context.tr('clear'),
                                onPressed: () {
                                  setState(() {
                                    searchStatus = 0;
                                    filterName.text = filterClass.text = '';
                                    searchRange = DateTimeRange(start: ini.timeStart, end: DateTime.now());
                                  });
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
                                  setState(() {
                                    List<Transaction> newSelfTransactions = [];
                                    for (var i in selfTransactions) {
                                      if (!i.onSelect) {
                                        newSelfTransactions.add(i);
                                      }
                                    }
                                    selfTransactions = newSelfTransactions;
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
                    width: 94.w,
                    child: SingleChildScrollView(
                      child: DataTable(
                        dataRowMaxHeight: 10.h,
                        sortColumnIndex: colIndex,
                        sortAscending: sortAscend,
                        showCheckboxColumn: true,
                        columns: [
                          DataColumn(
                            label: text3(context.tr('customer_colName'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                selfTransactions.sort((a, b) => direction ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('customer_colClass'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                selfTransactions.sort((a, b) => direction ? a.category.compareTo(b.category) : b.category.compareTo(a.category));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('customer_colPrice'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                selfTransactions.sort((a, b) => direction ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('customer_colStatus'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                selfTransactions.sort((a, b) => direction ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('customer_colDate'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                selfTransactions.sort(
                                      (a, b) => direction ? a.saleDate.toString().compareTo(b.saleDate.toString()) : b.saleDate.toString().compareTo(a.saleDate.toString()),
                                );
                              });
                            },
                          ),
                          /*
                        DataColumn(label: text3(context.tr('customer_colClient'), isBold: true)),
                        DataColumn(label: text3(context.tr('customer_colAgent'), isBold: true)),
                        DataColumn(label: text3(context.tr('customer_colAppoint'), isBold: true)),*/
                          DataColumn(label: text3(context.tr('edit'), isBold: true)),
                        ],
                        rows: selfTransactions.map((data) {
                          return DataRow(
                            selected: data.onSelect,
                            onSelectChanged: (selected) {
                              setState(() {
                                data.onSelect = selected ?? false;
                              });
                            },
                            cells: [
                              DataCell(text3(data.name)),
                              DataCell(text3(data.category)),
                              DataCell(text3(data.price.toString())),
                              DataCell(text3(ini.transactionStatus[data.status])),
                              DataCell(text3(data.saleDate == null ? "" : data.saleDate.toString().substring(0, 10))),
                              /*DataCell(Container(padding: const EdgeInsets.all(10), child: userShow(context, data.customer))),
                            DataCell(Container(padding: const EdgeInsets.all(10), child: userShow(context, data.agent))),
                            DataCell(data.appointment == null
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.all(10),
                                    child: userShow(context, [data.appointment!]),
                                  )),*/
                              DataCell(
                                IconButton(
                                  onPressed: () async {
                                    await transactionData(context, data).then((value) {
                                      setState(() {
                                        selfTransactions[selfTransactions.indexWhere((element) => element == data)] = value;
                                      });
                                    });
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.edit_note_outlined),
                                  tooltip: context.tr('edit'),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          backgroundColor: nowPage > 1 ? Colors.transparent : Colors.blueGrey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (nowPage > 1) {
                            setState(() {
                              nowPage--;
                            });
                          }
                        },
                        child: SizedBox(
                          width: 15.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_circle_left_outlined),
                              SizedBox(width: 1.w),
                              text3(context.tr('pagePast'), isBold: true),
                            ],
                          ),
                        ),
                      ),
                      text3(sprintf(context.tr('customer_statistic'), [total, numGet, nowPage, maxPage, perPage])),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 1.w),
                            text3(context.tr('customer_go2Page'), isBold: true),
                            DropdownButton2(
                              underline: const SizedBox(),
                              buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                              items: List.generate(
                                maxPage,
                                    (pID) => (pID + 1).toString(),
                              ).map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  nowPage = int.parse(newValue ?? "1");
                                });
                              },
                              value: nowPage.toString(),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          setState(() {
                            nowPage++;
                          });
                        },
                        child: SizedBox(
                          width: 15.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              text3(context.tr('pageNext'), isBold: true),
                              SizedBox(width: 1.w),
                              const Icon(Icons.arrow_circle_right_outlined),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
