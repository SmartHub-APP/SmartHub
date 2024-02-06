import 'interaction.dart';
import '../config.dart';
import '../object/transaction.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

import 'transaction.dart';

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

class TableView extends StatefulWidget {
  const TableView({super.key, required this.data, required this.numColumn});

  final int numColumn;
  final List<Transaction> data;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  bool allSelected = false;
  late List<RowCtl> rowCtl;

  @override
  void initState() {
    rowCtl = List.generate(widget.numColumn, (index) => RowCtl(onSort: false, sortAscend: false));

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
            widget.data.sort((a, b) => direction ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
          });
        },
      ),
      RowTitle(
        width: 10.w,
        name: context.tr('customer_colProject'),
        sort: (direction) {
          setState(() {
            widget.data.sort((a, b) => direction ? a.projectName.compareTo(b.projectName) : b.projectName.compareTo(a.projectName));
          });
        },
      ),
      RowTitle(
        width: 6.w,
        name: context.tr('customer_colUnit'),
        sort: (direction) {
          setState(() {
            widget.data.sort((a, b) => direction ? a.unit.compareTo(b.unit) : b.unit.compareTo(a.unit));
          });
        },
      ),
      RowTitle(
        width: 6.w,
        name: context.tr('customer_colPrice'),
        sort: (direction) {
          setState(() {
            widget.data.sort((a, b) => direction ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
          });
        },
      ),
      RowTitle(
        width: 10.w,
        name: context.tr('customer_colStatus'),
        sort: (direction) {
          setState(() {
            widget.data.sort((a, b) => direction ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
          });
        },
      ),
      RowTitle(
        width: 7.w,
        name: context.tr('customer_colDate'),
        sort: (direction) {
          setState(() {
            widget.data.sort(
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
            widget.data.sort((a, b) =>
                direction ? userShowText(a.agent).compareTo(userShowText(b.agent)) : userShowText(b.agent).compareTo(userShowText(a.agent)));
          });
        },
      ),
      RowTitle(
        width: 16.w,
        name: context.tr('customer_colDescription'),
        sort: (direction) {
          setState(() {
            widget.data.sort((a, b) => direction
                ? a.description.toString().compareTo(b.description.toString())
                : b.description.toString().compareTo(a.description.toString()));
          });
        },
      ),
    ];
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
        Expanded(
          child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  SizedBox(width: 0.5.w),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.data[index].onSelect = !widget.data[index].onSelect;

                        allSelected = true;
                        for (var element in widget.data) {
                          if (!element.onSelect) {
                            allSelected = false;
                          }
                        }
                      });
                    },
                    icon: widget.data[index].onSelect ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                  ),
                  SizedBox(width: 0.5.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Wrap(
                        children: [
                          text3(widget.data[index].name),
                          text3(widget.data[index].projectName),
                          text3(widget.data[index].unit),
                          text3(widget.data[index].price.toString()),
                          text3(ini.transactionStatus[widget.data[index].status]),
                          text3(widget.data[index].saleDate.toString().substring(0, 10)),
                          text3(userShowText(widget.data[index].agent)),
                          text3(widget.data[index].description),
                        ]
                            .asMap()
                            .entries
                            .map(
                              (e) => SizedBox(
                                width: titles[e.key].width,
                                child: e.value,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 0.5.w),
                  IconButton(
                    onPressed: () {
                      transactionEdit(context, widget.data[index], 1, false).then((value) {
                        if (value != "") {
                          alertDialog(context, context.tr('error'), value, context.tr('ok'));
                        }
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
    );
  }
}
