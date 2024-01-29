import 'member.dart';
import 'interaction.dart';
import '../config.dart';
import '../object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

/// - mode 1 : Customer
/// - mode 2 : Product
/// - mode 3 : Payment
Future<Transaction?> transactionEdit(BuildContext context, Transaction inputTrans, int mode) async {
  int editStatus = inputTrans.status;
  int editClaimed = inputTrans.payStatus;
  bool canSave = false;
  DateTime selectDate = inputTrans.saleDate;
  TextEditingController editUnit = TextEditingController(text: inputTrans.unit);
  TextEditingController editPrice = TextEditingController(text: inputTrans.price.toString());
  TextEditingController editCommission = TextEditingController(text: inputTrans.commission.toString());
  TextEditingController editProjectName = TextEditingController(text: inputTrans.projectName);
  TextEditingController editDescription = TextEditingController(text: inputTrans.description);
  List<Member> agents = inputTrans.agent;
  List<Member> clients = inputTrans.clients;
  List<Member> appoint = inputTrans.appoint == null ? [] : [inputTrans.appoint!];
  List<File> documents = inputTrans.documents;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero,
            content: SizedBox(
                width: 40.w,
                height: 80.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colClient')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, clients, RoleDefault.guest.id.toString()).then((value) {
                                  setState(() {
                                    clients = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 8.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, clients),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editProjectName,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colProject'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editUnit,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colUnit'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editPrice,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colPrice'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editCommission,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('payment_colPercent'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editDescription,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colDescription_optional'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colStatus')} : ")),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                              child: DropdownButton2(
                                underline: const SizedBox(),
                                iconStyleData: const IconStyleData(icon: SizedBox()),
                                hint: Text(context.tr('customer_selStatus')),
                                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                items: ini.transactionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    editStatus = ini.transactionStatus.indexWhere((element) => element == newValue);
                                  });
                                },
                                value: ini.transactionStatus[editStatus],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colDate')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                selectSingleDate(context, selectDate).then((value) {
                                  setState(() {
                                    selectDate = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 8.h,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 1.w),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: text3("${selectDate.year}/${selectDate.month}/${selectDate.day}"),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colAgent')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, agents, RoleDefault.agent.id.toString()).then((value) {
                                  setState(() {
                                    agents = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 8.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, agents),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colAppoint')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, appoint, RoleDefault.agent.id.toString()).then((value) {
                                  setState(() {
                                    appoint = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 8.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, appoint),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 10.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                text3("${context.tr('customer_colDocument')} : "),
                                IconButton(icon: const Icon(Icons.upload_file), onPressed: () {}),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                              child: documents.isEmpty
                                  ? Container(
                                      height: 8.h,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(5),
                                      child: text2(context.tr('emptyDocument')),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: text4(documents[index].fileName),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              documents.removeAt(index);
                                              setState(() {});
                                            },
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(bottom: 3.h),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(color: Colors.grey),
                  borderRadius: uiStyle.roundCorner2,
                ),
                child: IconButton(
                  icon: const Icon(Icons.cleaning_services_rounded),
                  tooltip: context.tr('clear'),
                  onPressed: () {
                    setState(() {
                      editProjectName.text = editUnit.text = editPrice.text = editCommission.text = editDescription.text = "";
                      editStatus = 0;
                      selectDate = ini.timeStart;
                      appoint = clients = agents = [];
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
                  icon: const Icon(Icons.close),
                  tooltip: context.tr('close'),
                  onPressed: () {
                    Navigator.pop(context);
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
                  icon: const Icon(Icons.save_alt_sharp),
                  tooltip: context.tr('save'),
                  onPressed: () {
                    if (editUnit.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyClass'),
                        context.tr('ok'),
                      );
                    } else if (editProjectName.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyName'),
                        context.tr('ok'),
                      );
                    } else if (editPrice.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPrice'),
                        context.tr('ok'),
                      );
                    } else if (editCommission.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPrice'),
                        context.tr('ok'),
                      );
                    } else if (editStatus == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyStatus'),
                        context.tr('ok'),
                      );
                    } else if (mode == 2 && editClaimed == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPayStatus'),
                        context.tr('ok'),
                      );
                    } else if (selectDate == ini.timeStart) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyDate') + ini.timeStart.toString().substring(0, 10),
                        context.tr('ok'),
                      );
                    } else {
                      canSave = true;
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );

  return canSave
      ? Transaction(
          onSelect: inputTrans.onSelect,
          id: inputTrans.id,
          price: int.parse(editPrice.text),
          priceSQFT: inputTrans.priceSQFT,
          status: editStatus,
          payStatus: (mode == 2) ? inputTrans.payStatus : editClaimed,
          commission: double.parse(editCommission.text),
          projectName: editProjectName.text,
          unit: editUnit.text,
          name: inputTrans.name,
          location: inputTrans.location,
          developer: inputTrans.developer,
          description: editDescription.text,
          clients: clients,
          saleDate: selectDate,
          launchDate: inputTrans.launchDate,
          appoint: appoint.isNotEmpty ? appoint[0] : null,
          agent: agents,
          documents: documents,
        )
      : null;
}
