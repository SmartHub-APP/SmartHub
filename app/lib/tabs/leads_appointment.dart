import '../config.dart';
import '../object.dart';
import '../component/appointment.dart';
import '../component/interaction.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class LeadsAppointment extends StatefulWidget {
  const LeadsAppointment({super.key});

  @override
  State<LeadsAppointment> createState() => _LeadsAppointmentState();
}

class _LeadsAppointmentState extends State<LeadsAppointment> {
  int colIndex = 0;
  int searchStatus = 0;
  bool sortAscend = true;
  DateTimeRange searchRange = DateTimeRange(start: ini.timeStart, end: DateTime.now());
  TextEditingController filterName = TextEditingController(text: "");
  TextEditingController filterProjectName = TextEditingController(text: "");
  List<Appointment> leadAppointments = Appointment.create().fakeData(30);

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
                        flex: 10,
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
                                  items: ini.appointmentLeadStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      searchStatus = ini.appointmentLeadStatus.indexWhere((element) => element == newValue);
                                    });
                                  },
                                  value: ini.appointmentLeadStatus[searchStatus],
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
                                  appointmentData(context, Appointment.create()).then((value) {
                                    setState(() {
                                      if (value != Appointment.create()) {
                                        leadAppointments.add(value);
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
                                  setState(() {});
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
                                    filterProjectName.text = '';
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
                                    List<Appointment> newLeadAppointments = [];
                                    for (var i in leadAppointments) {
                                      if (!i.onSelect) {
                                        newLeadAppointments.add(i);
                                      }
                                    }
                                    leadAppointments = newLeadAppointments;
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
                            label: text3(context.tr('customer_colProject'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                leadAppointments
                                    .sort((a, b) => direction ? a.projectName.compareTo(b.projectName) : b.projectName.compareTo(a.projectName));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('leadsAppointment_colStatus'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                leadAppointments.sort((a, b) => direction ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
                              });
                            },
                          ),
                          DataColumn(
                            label: text3(context.tr('leadsAppointment_colTime'), isBold: true),
                            onSort: (int colID, bool direction) {
                              setState(() {
                                colIndex = colID;
                                sortAscend = direction;
                                leadAppointments.sort(
                                  (a, b) => direction
                                      ? a.appointDate.toString().compareTo(b.appointDate.toString())
                                      : b.appointDate.toString().compareTo(a.appointDate.toString()),
                                );
                              });
                            },
                          ),
                          DataColumn(label: text3(context.tr('leadsAppointment_colLeads'), isBold: true)),
                          DataColumn(label: text3(context.tr('leadsAppointment_colAgent'), isBold: true)),
                          const DataColumn(label: SizedBox()),
                        ],
                        rows: leadAppointments.map((data) {
                          return DataRow(
                            selected: data.onSelect,
                            onSelectChanged: (selected) {
                              setState(() {
                                data.onSelect = selected ?? false;
                              });
                            },
                            cells: [
                              DataCell(text3(data.projectName)),
                              DataCell(text3(ini.appointmentLeadStatus[data.status])),
                              DataCell(text3(data.appointDate.toString().substring(0, 16))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: userShow(context, data.lead == null ? [] : [data.lead!]),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: userShow(context, data.agent == null ? [] : [data.agent!]),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  onPressed: () async {
                                    await appointmentData(context, data).then((value) {
                                      setState(() {
                                        leadAppointments[leadAppointments.indexWhere((element) => element == data)] = value;
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
