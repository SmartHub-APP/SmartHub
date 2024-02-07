import '../api/transaction.dart';
import '../config.dart';
import '../object/transaction.dart';
import '../component/interaction.dart';
import '../component/transaction.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int searchStatus = 0;
  List<Transaction> pubTransactions = [];
  TextEditingController filterName = TextEditingController(text: "");
  TextEditingController filterUnit = TextEditingController(text: "");

  @override
  void initState() {
    searchTransaction();

    super.initState();
  }

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
                                  transactionEdit(context, Transaction.create(), 2, true).then((value) {
                                    if (value != "") {
                                      alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                    }
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
                                    searchStatus = 0;
                                    filterName.text = filterUnit.text = '';
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
                                    List<Transaction> newPubTransactions = [];
                                    for (var i in pubTransactions) {
                                      if (!i.onSelect) {
                                        newPubTransactions.add(i);
                                      }
                                    }
                                    pubTransactions = newPubTransactions;
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
                  child: pubTransactions.isNotEmpty
                      ? MasonryGridView.count(
                          itemCount: pubTransactions.length,
                          crossAxisCount: isMobile ? 2 : 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                transactionEdit(context, pubTransactions[index], 1, false).then((value) {
                                  if (value != "") {
                                    alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text3("${context.tr('product_colName')} :\n"
                                        "    ${pubTransactions[index].name}"),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        text3("${context.tr('product_colPrice')} :\n    \$${pubTransactions[index].price}"),
                                        text3(" (\$${pubTransactions[index].priceSQFT}/sqft)"),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    text3("${context.tr('product_colLocation')} :\n"
                                        "    ${pubTransactions[index].location}"),
                                    const SizedBox(height: 5),
                                    text3("${context.tr('product_colDeveloper')} :\n"
                                        "    ${pubTransactions[index].developer}"),
                                    const SizedBox(height: 5),
                                    text3("${context.tr('product_colLaunchingData')} :\n"
                                        "    ${pubTransactions[index].launchDate.toString().substring(0, 10)}"),
                                    const SizedBox(height: 5),
                                    text3("${context.tr('product_colCommission')} :\n"
                                        "    ${pubTransactions[index].commission}%"),
                                    const SizedBox(height: 5),
                                    text3("${context.tr('product_colDescription')} :\n    ${pubTransactions[index].description}"),
                                    const SizedBox(height: 5),
                                    if (pubTransactions[index].documents.isNotEmpty) text3("${context.tr('product_colDocument')} :"),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: pubTransactions[index].documents.map((e) => text3("    ${e.fileName}")).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                          child: text1(context.tr('emptySearch')),
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
        name: filterName.text,
        projectName: "",
        status: searchStatus,
        payStatus: 0,
        unit: filterUnit.text,
        launchDateStart: "",
        launchDateEnd: "",
        saleDateStart: "",
        saleDateEnd: "",
      ),
    ).then((value) {
      if (value != null) {
        pubTransactions = value;
      } else {
        alertDialog(context, context.tr('error'), context.tr('emptySearch'), context.tr('ok'));
      }
      setState(() {});
    });
  }
}
