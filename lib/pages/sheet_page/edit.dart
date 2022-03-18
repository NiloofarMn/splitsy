import 'package:calculate_exchange_v2/services/service_requirements.dart';
import 'package:flutter/material.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController payController = TextEditingController();
  final TextEditingController describeController = TextEditingController();
  int colorNumber = 1;
  bool firstRefresh = true;

  void returnData(String name, double cost, int color, String description) {
    // navigate to home screen
    Navigator.pop(
      context,
      PaymentClass(
          name: name, cost: cost, color: color, description: description),
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
      content: SizedBox(
        height: 320,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions.sublist(0, 4),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions.sublist(4, 8),
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

  Widget makeTextFileds(controller, IconData icon, String name) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        icon: Icon(icon),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        label: Text(name),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget colorContainer() {
    return Container(
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
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    payController.dispose();
    describeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (firstRefresh){
      firstRefresh = false;
      PaymentClass arg =
        ModalRoute.of(context)!.settings.arguments as PaymentClass;
      nameController.text = arg.name;
      payController.text = arg.cost.toString();
      describeController.text = arg.description;
      colorNumber = arg.color;
    }

    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        var snackbar = null;
        if (nameController.text.isEmpty) {
          snackbar = const SnackBar(
            content: Text('DO NOT let the NAME empty!'),
          );
        } else if (payController.text.isEmpty) {
          snackbar = const SnackBar(
            content: Text('DO NOT let the COST empty!'),
          );
        } else {
          try {
            returnData(nameController.text, double.parse(payController.text),
                colorNumber, describeController.text);
            // ignore: unused_catch_clause
          } on FormatException catch (e) {
            const SnackBar(
              content: Text('You DID NOT enter a number in cost field.'),
            );
          }
        }
        if (snackbar!=null) ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
    );

    return Theme(
      data: ThemeData(canvasColor: Colors.grey.withOpacity(.4)),
      child: Scaffold(
        body: Center(
          child: Container(
            width: 300,
            height: 500,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            color: Colors.white,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                makeTextFileds(nameController, Icons.person, 'Name'),
                makeTextFileds(payController, Icons.payment, 'Cost'),
                TextField(
                  maxLines: 2,
                  controller: describeController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.short_text),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    label: Text('Description (Optional)'),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                colorContainer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    continueButton,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
