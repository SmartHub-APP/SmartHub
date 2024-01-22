import 'object.dart';
import 'interaction.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RowCtl {
  bool onSort;
  bool sortAscend;

  RowCtl({
    required this.onSort,
    required this.sortAscend,
  });
}

class RowTitle {
  String name;
  Function(bool) sort;

  RowTitle({
    required this.name,
    required this.sort,
  });
}

/*
[
                        RowTitle(
                          onSort: false,
                          sortAscend: false,
                          name: context.tr('customer_colProject'),
                          sort: (direction) {
                            setState(() {
                              selfTransactions
                                  .sort((a, b) => direction ? a.projectName.compareTo(b.projectName) : b.projectName.compareTo(a.projectName));
                            });
                          },
                        ),
                        RowTitle(
                          onSort: false,
                          sortAscend: false,
                          name: context.tr('customer_colUnit'),
                          sort: (direction) {
                            setState(() {
                              selfTransactions.sort((a, b) => direction ? a.unit.compareTo(b.unit) : b.unit.compareTo(a.unit));
                            });
                          },
                        ),
                        RowTitle(
                          onSort: false,
                          sortAscend: false,
                          name: context.tr('customer_colPrice'),
                          sort: (direction) {
                            setState(() {
                              selfTransactions.sort((a, b) => direction ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
                            });
                          },
                        ),
                        RowTitle(
                          onSort: false,
                          sortAscend: false,
                          name: context.tr('customer_colStatus'),
                          sort: (direction) {
                            setState(() {
                              selfTransactions.sort((a, b) => direction ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
                            });
                          },
                        ),
                        RowTitle(
                          onSort: false,
                          sortAscend: false,
                          name: context.tr('customer_colDate'),
                          sort: (direction) {
                            setState(() {
                              selfTransactions.sort(
                                    (a, b) => direction
                                    ? a.saleDate.toString().compareTo(b.saleDate.toString())
                                    : b.saleDate.toString().compareTo(a.saleDate.toString()),
                              );
                            });
                          },
                        ),
                        RowTitle(
                          onSort: false,
                          sortAscend: false,
                          name: context.tr('customer_colAgent'),
                          sort: (direction) {
                            setState(() {
                              selfTransactions.sort((a, b) =>
                              direction ? a.agent.toString().compareTo(b.agent.toString()) : b.agent.toString().compareTo(a.agent.toString()));
                            });
                          },
                        ),
                        RowTitle(
                          onSort: false,
                          sortAscend: false,
                          name: context.tr('customer_colDescription'),
                          sort: (direction) {
                            setState(() {
                              selfTransactions.sort((a, b) => direction
                                  ? a.description.toString().compareTo(b.description.toString())
                                  : b.description.toString().compareTo(a.description.toString()));
                            });
                          },
                        ),
                      ],
*/

class TableView extends StatefulWidget {
  const TableView({super.key, required this.data, required this.titles});

  final List<RowTitle> titles;
  final List<Transaction> data;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  bool allSelected = false;
  late List<RowCtl> rowCtl;

  @override
  void initState() {
    rowCtl = widget.titles.map((e) => RowCtl(onSort: false, sortAscend: false)).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 0.5.w),
            IconButton(
              onPressed: () {
                setState(() {
                  allSelected = !allSelected;
                  for (var element in widget.data) {
                    element.onSelect = allSelected;
                  }
                });
              },
              icon: allSelected ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
            ),
            SizedBox(width: 0.5.w),
            Expanded(
              child: Wrap(
                children: widget.titles.asMap().entries.map((e) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (!rowCtl[e.key].onSort) {
                          rowCtl[e.key].onSort = true;
                          rowCtl[e.key].sortAscend = true;
                          widget.titles[e.key].sort(true);
                        } else {
                          if (rowCtl[e.key].sortAscend) {
                            rowCtl[e.key].sortAscend = false;
                            widget.titles[e.key].sort(false);
                          } else {
                            rowCtl[e.key].onSort = false;
                          }
                        }
                      });
                    },
                    child: Container(
                      height: 5.h,
                      width: 10.w,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          text3(widget.titles[e.key].name, isBold: true),
                          if (rowCtl[e.key].onSort) rowCtl[e.key].sortAscend ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Container(color: Colors.blue, child: const Text("2")),
      ],
    );
  }
}
/*
* DataTable(
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
                      ),*/
