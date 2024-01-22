import '../config.dart';
import '../object.dart';
import '../component/interaction.dart';
import 'package:flutter/material.dart';
import '../component/transaction.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int colIndex = 0;
  int searchStatus = 0;
  bool sortAscend = true;
  TextEditingController filterName = TextEditingController(text: "");
  List<Transaction> transactions = Transaction.create().fakeData(10);

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
                              child: Container(
                                height: 7.6.h,
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: DropdownButton2(
                                  underline: const SizedBox(),
                                  iconStyleData: const IconStyleData(icon: SizedBox()),
                                  hint: Text(context.tr('customer_selStatus')),
                                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                  items: ini.commissionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      searchStatus = ini.commissionStatus.indexWhere((element) => element == newValue);
                                    });
                                  },
                                  value: ini.commissionStatus[searchStatus],
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
                                  transactionPayment(context, Transaction.create()).then((value) {
                                    setState(() {
                                      if (value != Transaction.create()) {
                                        transactions.add(value);
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
                                    transactions = Transaction.create().fakeData(30);
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
                                    filterName.text = '';
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
                                    List<Transaction> newTransactions = [];
                                    for (var i in transactions) {
                                      if (!i.onSelect) {
                                        newTransactions.add(i);
                                      }
                                    }
                                    transactions = newTransactions;
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
                  flex: 9,
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
                            label: text3(context.tr('payment_colID'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                transactions.sort((a, b) => direction ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('payment_colStatus'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                transactions.sort((a, b) => direction ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('payment_colSoldDate'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                transactions.sort(
                                  (a, b) => direction
                                      ? a.saleDate.toString().compareTo(b.saleDate.toString())
                                      : b.saleDate.toString().compareTo(a.saleDate.toString()),
                                );
                              });
                            },
                          ),
                          DataColumn(label: text3(context.tr('payment_colAgent'), isBold: true)),
                          DataColumn(label: text3(context.tr('payment_colBankInfo'), isBold: true)),
                          DataColumn(
                            label: text3(context.tr('payment_colPercent'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                transactions.sort((a, b) => direction ? a.commission.compareTo(b.commission) : b.commission.compareTo(a.commission));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('payment_colCommission'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                transactions.sort((a, b) => direction
                                    ? (a.commission * a.price).compareTo(b.commission * b.price)
                                    : (b.commission * b.price).compareTo(a.commission * a.price));
                              });
                            },
                          ),
                          DataColumn(label: text3(context.tr('edit'), isBold: true)),
                        ],
                        rows: transactions.map((data) {
                          return DataRow(
                            selected: data.onSelect,
                            onSelectChanged: (selected) {
                              setState(() {
                                data.onSelect = selected ?? false;
                              });
                            },
                            cells: [
                              DataCell(text3(data.id)),
                              DataCell(text3(ini.commissionStatus[data.payStatus])),
                              DataCell(text3(data.saleDate.toString().substring(0, 16))),
                              DataCell(Container(
                                  padding: const EdgeInsets.all(10),
                                  child: data.appoint == null ? const SizedBox() : userShow(context, [data.appoint!]))),
                              DataCell(
                                data.appoint == null
                                    ? const SizedBox()
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [text3(data.appoint!.bankCode ?? ""), text3(data.appoint!.bankAccount ?? "")],
                                      ),
                              ),
                              DataCell(text3("${data.commission} %")),
                              DataCell(text3((data.commission * data.price * 0.01).toStringAsFixed(3))),
                              DataCell(
                                IconButton(
                                  onPressed: () async {
                                    await transactionPayment(context, data).then((value) {
                                      setState(() {
                                        transactions[transactions.indexWhere((element) => element == data)] = value;
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
