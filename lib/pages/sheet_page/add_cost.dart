import 'package:calculate_exchange_v2/services/service_requirements.dart';
import 'package:flutter/material.dart';

class AddFunction extends StatefulWidget {
  const AddFunction({
    Key? key,
  }) : super(key: key);

  @override
  State<AddFunction> createState() => _AddFunctionState();
}

class _AddFunctionState extends State<AddFunction> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController payController = TextEditingController();
  final TextEditingController describeController = TextEditingController();
  int colorNumber = 1;
  List<Color> gradientColor = GradientColors.cloudyKnoxville;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    payController.dispose();
    describeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void returnData(String name, double cost, int color, String description) {
      // navigate to home screen
      Navigator.pop(
        context,
        PaymentClass(
            name: name, cost: cost, color: color, description: description),
      );
    }

    void goBackDialog() {
      // print('in void');
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
          Navigator.of(context).popUntil(ModalRoute.withName('/sheet'));
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Attention!"),
        content: const Text("The Data you added will be lost. Proceed?"),
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

    Widget closeThisPageButton() {
      return TextButton(
        onPressed: () {
          if (nameController.text.isNotEmpty || payController.text.isNotEmpty) {
            goBackDialog();
          } else {
            Navigator.pop(context);
          }
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Icon(
            Icons.keyboard_arrow_down,
            size: 40,
          ),
        ),
      );
    }

    Widget colorChoose() {
      List<Widget> actions = [];
      FloatingActionButton colors(int number) => FloatingActionButton(
            onPressed: () {
              setState(() {
                colorNumber = number;
              });
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.color_lens_outlined,
            ),
            backgroundColor: MyColors.people[number],
          );
      for (int i = 1; i < MyColors.people.length + 1; i++) {
        actions.add(colors(i));
      }
      return AlertDialog(
        title: Text(
            "Choose ${nameController.text.isNotEmpty ? nameController.text : 'person'}'s Color!"),
        content: SizedBox(
          height: 320,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions.sublist(0, 2),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions.sublist(2, 4),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions.sublist(4, 6),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions.sublist(6, 8),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions.sublist(8),
              ),
            ],
          ),
        ),
      );
    }

    Widget appbarWidget() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Add Payment Details',
          style: TextStyle(
            fontFamily: 'aller',
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    Widget getDataFromUser() {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                // autofillHints: <String>['john', 'mike', 'nicole'],
                controller: nameController,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  label: Text('Enter Name'),
                  // hintText: 'PLEASE ENTER AMOUNT OF COST',
                  // hintStyle: TextStyle(color:Theme.of(context).primaryColor),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: payController,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  icon: Icon(Icons.payment),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  label: Text('Enter Cost'),
                  // hintText: 'PLEASE ENTER AMOUNT OF COST',
                  // hintStyle: TextStyle(color:Theme.of(context).primaryColor),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              // height: 200,
              child: TextField(
                maxLines: 2,
                controller: describeController,
                // textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  icon: Icon(Icons.short_text),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  label: Text('Description (Optional)'),
                  // hintText: 'You can leave this part blank.',
                  // hintStyle: TextStyle(color:Theme.of(context).primaryColor),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.color_lens,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return colorChoose();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: MyColors.people[colorNumber],
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    child: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter, //bottomCenter
                end: Alignment.bottomCenter, //topCenter
                colors: gradientColor), //confidentCloud,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10.0, spreadRadius: 7.0),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(child: appbarWidget()),
              closeThisPageButton(),
              getDataFromUser(),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            if (describeController.text.isEmpty) describeController.text = '';

            if (nameController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text('DO NOT let the NAME empty!'),
                  );
                },
              );
            } else if (payController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text('DO NOT let the COST empty!'),
                  );
                },
              );
            } else {
              try {
                returnData(
                    nameController.text,
                    double.parse(payController.text),
                    colorNumber,
                    describeController.text);
                // ignore: unused_catch_clause
              } on FormatException catch (e) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content:
                          Text('You DID NOT enter a number in cost field.'),
                    );
                  },
                );
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3,
                vertical: 15),
            child: const Icon(Icons.check_outlined),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
