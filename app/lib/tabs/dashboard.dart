import 'package:easy_localization/easy_localization.dart';

import '../config.dart';
import '../object.dart';
import '../interaction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int viewIndex = 0;
  DateTimeRange selectRange = DateTimeRange(start: ini.timeStart, end: DateTime.now());
  List<DataPoint> pltData = [
    DataPoint('1', 5),
    DataPoint('2', 8),
    DataPoint('3', 3),
    DataPoint('4', 7),
    DataPoint('5', 4),
    DataPoint('6', 5),
    DataPoint('7', 8),
    DataPoint('8', 3),
    DataPoint('9', 7),
    DataPoint('10', 4),
  ];
  List<Transaction> recentTransactions = fakeTransactionGenerator(10);

  @override
  Widget build(BuildContext context) {
    List<String> views = [context.tr('dashboard_overview'), context.tr('dashboard_agent'), context.tr('dashboard_project')];
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        double sWidth = MediaQuery.of(context).size.width;
        bool isMobile = sWidth < 700;
        return Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 2.w : 10.w, vertical: 2.h),
            child: Center(
              child: SizedBox(
                width: 90.w,
                height: 95.h,
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(
                        width: 23.w,
                        height: 5.h,
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: views
                              .asMap()
                              .entries
                              .map(
                                (btn) => TextButton(
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  onPressed: () {
                                    setState(() {
                                      viewIndex = btn.key;
                                    });
                                  },
                                  child: Container(
                                    width: 6.w,
                                    height: 3.5.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: viewIndex == btn.key ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: text3(btn.value, color: viewIndex == btn.key ? Colors.black : Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      downloadBetween()
                    ]),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: statisticBlock(
                            context.tr('dashboard_totalRevenue'),
                            "+20.1% from last month",
                            "\$45,231.87",
                            const Icon(Icons.attach_money, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 1,
                          child: statisticBlock(
                            context.tr('dashboard_avgPayment'),
                            "+7% from last month",
                            "+32,234",
                            const Icon(Icons.support_agent_outlined, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 1,
                          child: statisticBlock(
                            context.tr('dashboard_conversionRate'),
                            "+6% from last month",
                            "36%",
                            const Icon(Icons.local_convenience_store_rounded, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 1,
                          child: statisticBlock(
                            context.tr('dashboard_sales'),
                            "+19% from last month",
                            "+12,234",
                            const Icon(Icons.credit_card, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(flex: 6, child: plotBlock()),
                        SizedBox(width: 2.w),
                        Expanded(flex: 4, child: recentSales()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget downloadBetween() {
    return SizedBox(
      width: 23.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {
              selectDateRange(context).then((value) {
                setState(() {
                  selectRange = value;
                });
              });
            },
            child: Container(
              width: 14.w,
              height: 5.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(5)),
              child: text3(
                "${selectRange.start.year}/${selectRange.start.month}/${selectRange.start.day} ~"
                "${selectRange.end.year}/${selectRange.end.month}/${selectRange.end.day}",
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {},
            child: Container(
              width: 6.w,
              height: 5.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
              child: text3(context.tr('download'), color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget statisticBlock(String title, subTitle, value, Icon icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      height: 18.h,
      margin: EdgeInsets.only(top: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text3(title, isBold: true), text1(value), text3(subTitle)],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 1.w),
              alignment: Alignment.topRight,
              child: icon,
            ),
          ),
        ],
      ),
    );
  }

  Widget plotBlock() {
    return Container(
      height: 60.h,
      margin: EdgeInsets.only(top: 5.h),
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: text3(context.tr('dashboard_overview'), isBold: true),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 16,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                edgeLabelPlacement: EdgeLabelPlacement.none,
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: '\$ (K)'),
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                edgeLabelPlacement: EdgeLabelPlacement.none,
              ),
              series: <ChartSeries>[
                ColumnSeries<DataPoint, String>(
                  dataSource: pltData,
                  xValueMapper: (DataPoint data, _) => data.x,
                  yValueMapper: (DataPoint data, _) => data.y,
                ),
              ],
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }

  Widget recentSales() {
    return Container(
      height: 60.h,
      margin: EdgeInsets.only(top: 5.h),
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 1,
            child: text3(context.tr('dashboard_recentTransactions'), isBold: true),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 16,
            child: SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: recentTransactions.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    childrenPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text2("\$ ${recentTransactions[index].price}", isBold: true),
                        text3(recentTransactions[index].saleDate.toString().substring(0, 16)),
                      ],
                    ),
                    children: [
                      text2(recentTransactions[index].name, isBold: true),
                      text3(recentTransactions[index].category),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text3(recentTransactions[index].appointment == null ? "" : recentTransactions[index].appointment!.name, isBold: true),
                          text3(recentTransactions[index].appointment == null ? "" : recentTransactions[index].appointment!.email ?? ""),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
