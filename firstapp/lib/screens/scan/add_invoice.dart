import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../../constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firstapp/database/invoice_database.dart';
import 'package:firstapp/database/details_database.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class Details {
  String? invNum;
  String? seller;
  String? address;
  String? date;
  String? time;
  List<InvoiceDetail> details;
  Details(
      {this.invNum,
      this.address,
      this.seller,
      this.date,
      this.time,
      required this.details});
}

class InvoiceDetail {
  String name;
  String quantity;
  String price;
  InvoiceDetail(
      {required this.name, required this.quantity, required this.price});
}

class AddInvoice extends StatefulWidget {
  const AddInvoice({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddInvoice();
}

DateTime now = DateTime.now();
DateTime date = DateTime(now.year, now.month, now.day);

class _AddInvoice extends State<AddInvoice> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  Details details =
      Details(details: [InvoiceDetail(name: '', quantity: '', price: '')]);

  String _date = '';
  String _time = '';
  @override
  void initiState() {
    super.initState();

    details.details = List<InvoiceDetail>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _uiWidget(),
    );
  }

  Widget _uiWidget() {
    return Form(
        key: globalKey,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FormHelper.inputFieldWidgetWithLabel(
                          context, "invNum", "發票號碼", "", (onValidateVal) {
                        if (onValidateVal.isEmpty) {
                          return '發票號碼不能為空';
                        }
                        return null;
                      }, (onSavedVal) {
                        details.invNum = onSavedVal;
                      },
                          borderFocusColor: kPrimaryColor,
                          borderColor: kSecondaryColor,
                          borderRadius: 15,
                          fontSize: 14,
                          labelFontSize: 14,
                          paddingLeft: 0,
                          paddingRight: 0),
                      FormHelper.inputFieldWidgetWithLabel(
                          context, "seller", "賣家", "", (onValidateVal) {
                        if (onValidateVal.isEmpty) {
                          return '賣家不能為空';
                        }
                        return null;
                      }, (onSavedVal) {
                        details.seller = onSavedVal;
                      },
                          borderFocusColor: kPrimaryColor,
                          borderColor: kSecondaryColor,
                          borderRadius: 15,
                          fontSize: 14,
                          labelFontSize: 14,
                          paddingLeft: 0,
                          paddingRight: 0),
                      FormHelper.inputFieldWidgetWithLabel(
                          context, "address", "地址", "", (onValidateVal) {
                        if (onValidateVal.isEmpty) {
                          return '地址不能為空';
                        }
                        return null;
                      }, (onSavedVal) {
                        details.address = onSavedVal;
                      },
                          borderFocusColor: kPrimaryColor,
                          borderColor: kSecondaryColor,
                          borderRadius: 15,
                          fontSize: 14,
                          labelFontSize: 14,
                          paddingLeft: 0,
                          paddingRight: 0),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'yyyy/MM/dd',
                          initialValue: date.toString(),
                          decoration: InputDecoration(
                              labelText: '日期',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          onChanged: (val) => setState(() => _date = val),
                          validator: (val) {
                            setState(() => _date = val ?? '');
                            return null;
                          },
                          onSaved: (val) => setState(() => _date = val ?? ''),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: DateTimePicker(
                          type: DateTimePickerType.time,
                          decoration: InputDecoration(
                              labelText: '時間',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          //controller: _controller4,
                          initialValue: '00:00', //_initialValue,

                          use24HourFormat: true,
                          onChanged: (val) => setState(() => _time = val),
                          validator: (val) {
                            setState(() => _time = val ?? '');
                            return null;
                          },
                          onSaved: (val) => setState(() => _time = val ?? ''),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _detailContainer(),
                      const SizedBox(height: 30),
                      Center(
                        child: FormHelper.submitButton("儲存", () {
                          if (validateAndSave()) {
                            final splitted = _date.split('-');
                            String tmpdate = splitted[0] +
                                '/' +
                                splitted[1] +
                                '/' +
                                splitted[2][0] +
                                splitted[2][1];

                            int tmpyear = int.parse(splitted[0]) - 1911;
                            String tmpmonth = int.parse(splitted[1]).toString();
                            String tag = tmpyear.toString() + tmpmonth;
                            int amount = 0;

                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.confirm,
                              confirmBtnColor: kPrimaryColor,
                              onConfirmBtnTap: () async {
                                for (InvoiceDetail element in details.details) {
                                  amount += int.parse(element.quantity) *
                                      int.parse(element.price);
                                  DetailHelper.instance.add(invoice_details(
                                      tag: tag,
                                      invNum: details.invNum ?? "",
                                      name: element.name,
                                      date: tmpdate,
                                      quantity: element.quantity,
                                      amount: element.price));
                                }
                                HeaderHelper.instance.add(Header(
                                    tag: tag,
                                    date: tmpdate,
                                    time: _time,
                                    seller: details.seller ?? "",
                                    address: details.address ?? "",
                                    invNum: details.invNum ?? "",
                                    barcode: "manual",
                                    amount: amount.toString()));
                                showTopSnackBar(
                                  context,
                                  const CustomSnackBar.success(
                                    message: "新增成功",
                                    backgroundColor: kSecondaryColor,
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              text: "確認新增",
                            );
                          }
                        }, btnColor: kPrimaryColor, borderColor: kPrimaryColor),
                      )
                    ]))));
  }

  Widget _detailContainer() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text("明細",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [_detailUI(index)],
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: details.details.length,
          )
        ]);
  }

  Widget _detailUI(index) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Flexible(
            child: FormHelper.inputFieldWidget(
                context, "detail", "明細_${index + 1}", (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return '明細不能為空';
              }
              return null;
            }, (onSavedVal) {
              details.details[index].name = onSavedVal;
            },
                borderFocusColor: kPrimaryColor,
                hintFontSize: 13,
                hintColor: kTextColor,
                borderColor: kSecondaryColor,
                borderRadius: 15,
                fontSize: 14,
                paddingLeft: 2,
                paddingRight: 2),
          ),
          Flexible(
            child: FormHelper.inputFieldWidget(context, "quentity", "數量",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return '數量不能為空';
              }
              return null;
            }, (onSavedVal) {
              details.details[index].quantity = onSavedVal;
            },
                borderFocusColor: kPrimaryColor,
                borderColor: kSecondaryColor,
                hintFontSize: 13,
                hintColor: kTextColor,
                borderRadius: 15,
                fontSize: 14,
                paddingLeft: 2,
                paddingRight: 2),
          ),
          Flexible(
            child: FormHelper.inputFieldWidget(context, "amount", "小計",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return '金額不能為空';
              }
              return null;
            }, (onSavedVal) {
              details.details[index].price = onSavedVal;
            },
                borderFocusColor: kPrimaryColor,
                borderColor: kSecondaryColor,
                borderRadius: 15,
                fontSize: 14,
                hintFontSize: 13,
                hintColor: kTextColor,
                paddingLeft: 2,
                paddingRight: 2),
          ),
          Visibility(
            child: SizedBox(
                width: 35,
                child: IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () {
                    addDetailsControl();
                  },
                )),
            visible: index == details.details.length - 1,
          ),
          Visibility(
            child: SizedBox(
                width: 35,
                child: IconButton(
                  icon:
                      const Icon(Icons.remove_circle, color: Colors.redAccent),
                  onPressed: () {
                    removeDetailsControl(index);
                  },
                )),
            visible: index > 0,
          ),
        ]));
  }

  void addDetailsControl() {
    setState(() {
      details.details.add(InvoiceDetail(name: '', quantity: '', price: ''));
    });
  }

  void removeDetailsControl(index) {
    setState(() {
      details.details.removeAt(index);
    });
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
