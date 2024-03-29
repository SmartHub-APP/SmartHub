import '../config.dart';
import '../api/transaction.dart';
import '../object/transaction.dart';
import '../component/payment.dart';
import '../component/interaction.dart';
import '../component/transaction.dart';
import 'package:flutter/material.dart';
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
  int searchPayStatus = 0;
  bool sortAscend = true;
  TextEditingController filterAgent = TextEditingController(text: "");
  TextEditingController filterProjectName = TextEditingController(text: "");
  List<Transaction> transactions = [];

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
                                height: 7.h,
                                child: TextField(
                                  controller: filterAgent,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: uiStyle.roundCorner2),
                                    labelText: context.tr('payment_colAgent'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: SizedBox(
                                height: 7.h,
                                child: TextField(
                                  controller: filterProjectName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: uiStyle.roundCorner2),
                                    labelText: context.tr('customer_colProject'),
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
                                  items: ini.commissionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      searchPayStatus = ini.commissionStatus.indexWhere((element) => element == newValue);
                                    });
                                  },
                                  value: ini.commissionStatus[searchPayStatus],
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
                                  transactionEdit(context, Transaction.create(), 3, true).then((value) {
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
                                  setState(() {
                                    searchPayStatus = 0;
                                    filterAgent.text = '';
                                    filterProjectName.text = '';
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
                                icon: const Icon(Icons.payment_sharp),
                                tooltip: context.tr('payment_make'),
                                onPressed: () {
                                  List<Transaction> selects = [];
                                  for (var i in transactions) {
                                    if (i.onSelect) {
                                      selects.add(i);
                                    }
                                  }
                                  if (selects.isNotEmpty) {
                                    makePayment(context, selects).then((value) {
                                      if (value) {
                                        setState(() {
                                          for (var i in selects) {
                                            i.onSelect = false;
                                            putTransaction(
                                              TransactionPutRequest(
                                                id: i.id,
                                                name: i.name,
                                                projectName: i.projectName,
                                                status: i.status,
                                                payStatus: 1,
                                                unit: i.unit,
                                                launchDate: i.launchDate.toString(),
                                                saleDate: i.saleDate.toString(),
                                                appoint: i.appoint.map((e) => e.id.toString()).toList().join(ini.separator),
                                                price: i.price,
                                                commission: i.commission,
                                                agent: i.agent.map((e) => e.id.toString()).toList().join(ini.separator),
                                                client: i.client.map((e) => e.id.toString()).toList().join(ini.separator),
                                                description: i.description,
                                                developer: i.developer,
                                                documents: [],
                                                //i.documents.map((e) => e.id.toString()).toList().join(ini.separator),
                                                location: i.location,
                                                priceSQFT: i.priceSQFT,
                                              ),
                                            ).then((value) {
                                              if (value != "") {
                                                alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                              }
                                            });
                                          }
                                          searchTransaction();
                                        });
                                      }
                                    });
                                  } else {
                                    alertDialog(context, context.tr('error'), context.tr('noDataSelect'), context.tr('ok'));
                                  }
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
                                  for (var element in transactions) {
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
                            label: text3(context.tr('payment_colPrice'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                transactions.sort((a, b) => direction ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
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
                              DataCell(text3("\$ ${data.price}")),
                              DataCell(text3(ini.commissionStatus[data.payStatus])),
                              DataCell(text3(data.saleDate.toString().substring(0, 16))),
                              DataCell(Container(padding: const EdgeInsets.all(10), child: userShow(context, data.appoint))),
                              DataCell(text3("${data.commission} %")),
                              DataCell(text3((data.commission * data.price * 0.01).toStringAsFixed(3))),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    transactionEdit(context, data, 3, false).then((value) {
                                      if (value != "") {
                                        alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                      }
                                    });
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

  searchTransaction() {
    getTransactionList(
      TransactionGetRequest(
        name: "",
        projectName: filterProjectName.text,
        status: 0,
        payStatus: searchPayStatus,
        unit: "",
        launchDateStart: "",
        launchDateEnd: "",
        saleDateStart: "",
        saleDateEnd: "",
      ),
    ).then((value) {
      if (value != null) {
        transactions = value;
      } else {
        alertDialog(context, context.tr('error'), context.tr('emptySearch'), context.tr('ok'));
      }
      setState(() {});
    });
  }
}
