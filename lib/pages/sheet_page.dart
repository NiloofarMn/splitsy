import 'dart:async';
import 'package:calculate_exchange_v2/pages/sheet_page/sheet_imports.dart';
import 'package:calculate_exchange_v2/services/service_requirements.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)!.settings.arguments as List;

    return ChangeNotifierProvider(
      create: (context) => Schedule(),
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            // Navigator.of(context).pop();
            return true;
          },
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
              child: Column(
                children: [
                  MyAppBar(
                      pageName: args[2],
                      colorInt: args[3],
                      appName: args[0],
                      sheetIndex: args[1]),
                  ListOfPayments(pageName: args[2]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatefulWidget {
  final String pageName;
  final int colorInt;
  final String appName;
  final int sheetIndex;
  const MyAppBar(
      {Key? key,
      required this.pageName,
      required this.colorInt,
      required this.appName,
      required this.sheetIndex})
      : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  final TextEditingController _controller = TextEditingController();
  bool enableButton = false;
  late FocusNode myFocusNode;

  @override
  void initState() {
    _controller.text = widget.pageName;
    Provider.of<Schedule>(context, listen: false).pageNameSet =
        _controller.text;
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void deleteAlldialog() {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: const Text("Continue"),
        onPressed: () {
          Provider.of<Schedule>(context, listen: false).changeRemoveAllStatuse =
              true;
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Do you want to delete all the data?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Widget appbarWidget() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.chevron_left,
                size: 35,
              )),
          Expanded(
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                overflow: TextOverflow.fade,
                fontFamily: 'aller',
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: 2,
                color: Theme.of(context).primaryColor,
              ),
              keyboardType: TextInputType.visiblePassword,
              enabled: enableButton,
              focusNode: myFocusNode,
              onSubmitted: (value) async {
                List getNames = await Data().allTheNames(widget.appName);
                if (!getNames.contains(_controller.text) ||
                    Provider.of<Schedule>(context, listen: false).pageName ==
                        _controller.text) {
                  enableButton = false;
                  await Data().editNameOfSheet(widget.appName,
                      widget.sheetIndex, _controller.text, widget.colorInt);
                  Provider.of<Schedule>(context, listen: false).pageNameSet =
                      _controller.text;
                  Provider.of<Schedule>(context, listen: false)
                      .changeNameStatus = true;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Do NOT use same name as previous sheets!'),
                  ));
                  myFocusNode.requestFocus();
                }
              },
            ),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      enableButton = true;
                    });
                    Timer(const Duration(milliseconds: 20), () {
                      myFocusNode.requestFocus();
                    });
                  },
                  child: const Icon(Icons.edit)),
              TextButton(
                  onPressed: () async {
                    if (Provider.of<Schedule>(context, listen: false).len > 0)
                      {deleteAlldialog();}
                  },
                  child: const Icon(Icons.delete_forever_outlined)),
            ],
          ),
        ],
      );
    }

    return appbarWidget();
  }
}
