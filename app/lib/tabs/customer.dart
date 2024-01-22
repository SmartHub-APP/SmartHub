import '../config.dart';
import '../object.dart';
import '../interaction.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
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
                              child: SizedBox(
                                height: 6.h,
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
                                height: 6.h,
                                child: TextField(
                                  controller: filterClass,
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
                                height: 6.h,
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
                                  height: 6.h,
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
                                  transactionCustomer(context, Transaction.create()).then((value) {
                                    setState(() {
                                      if (value != Transaction.create()) {
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
                                    selfTransactions = Transaction.create().fakeData(30);
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
                        columnSpacing: 2,
                        horizontalMargin: 20,
                        sortColumnIndex: colIndex,
                        sortAscending: sortAscend,
                        showCheckboxColumn: true,
                        columns: [
                          DataColumn(
                            label: text3(context.tr('customer_colProject'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                selfTransactions
                                    .sort((a, b) => direction ? a.projectName.compareTo(b.projectName) : b.projectName.compareTo(a.projectName));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('customer_colUnit'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                selfTransactions.sort((a, b) => direction ? a.unit.compareTo(b.unit) : b.unit.compareTo(a.unit));
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
                                  (a, b) => direction
                                      ? a.saleDate.toString().compareTo(b.saleDate.toString())
                                      : b.saleDate.toString().compareTo(a.saleDate.toString()),
                                );
                              });
                            },
                          ),
                          DataColumn(label: text3(context.tr('customer_colAgent'), isBold: true)),
                          DataColumn(label: text3(context.tr('customer_colDescription'), isBold: true)),
                          const DataColumn(label: SizedBox()),
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
                              DataCell(SizedBox(width: 7.w, child: text3(data.projectName))),
                              DataCell(SizedBox(width: 7.w, child: text3(data.unit))),
                              DataCell(SizedBox(width: 7.w, child: text3(data.price.toString()))),
                              DataCell(SizedBox(width: 9.w, child: text3(ini.transactionStatus[data.status]))),
                              DataCell(SizedBox(width: 6.w, child: text3(data.saleDate.toString().substring(0, 10)))),
                              DataCell(SizedBox(width: 10.w, child: text3(userShowText(data.agent)))),
                              DataCell(SizedBox(width: 12.w, child: text3(data.description ?? ""))),
                              DataCell(
                                IconButton(
                                  onPressed: () async {
                                    await transactionCustomer(context, data).then((value) {
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
              ],
            ),
          ),
        );
      },
    );
  }
}
