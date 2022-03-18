import 'package:calculate_exchange_v2/services/service_requirements.dart';
import 'package:flutter/material.dart';

class EditMore extends StatefulWidget {
  const EditMore({Key? key}) : super(key: key);

  @override
  _EditMoreState createState() => _EditMoreState();
}

class _EditMoreState extends State<EditMore> {
  final TextEditingController nameController = TextEditingController();
  int colorNumber = 1;
  bool firstRefresh = true;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (firstRefresh) {
      firstRefresh = false;
      List arg = ModalRoute.of(context)!.settings.arguments as List;
      nameController.text = arg[1];
      colorNumber = arg[0]-1;
    }

    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        if (nameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('DO NOT let the NAME empty!'),
          ));
        } else {
          returnData(nameController.text, colorNumber);
        }
      },
    );

    return Theme(
      data: ThemeData(canvasColor: Colors.grey.withOpacity(.4)),
      child: Scaffold(
        body: Center(
          child: Container(
            width: 300,
            height: 480,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                makeTextFileds(nameController, Icons.text_fields, 'Name Of File'),
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

  void returnData(String name, int color) {
    // navigate to home screen
    Navigator.pop(context, [color+1, name]);
  }

  Widget colorChoose() {
    List<Widget> actions = [];
    List<bool> isSelected =
        List.filled(MyColors.sheetColors.length, false, growable: true);
    isSelected[colorNumber] = true;
    for (var i = 0; i < MyColors.sheetColors.length; i++) {
      actions.add(Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(5),
        height: 50,
        width: 50,
        decoration: MyColors.sheetColors[i + 1],
      ));
    }
    ToggleButtons partButtons(int begin, int end) => ToggleButtons(
          children: actions.sublist(begin, end),
          onPressed: (int index) {
            setState(() {
              isSelected[colorNumber] = false;
              colorNumber = index+begin;
            });
          },
          isSelected: isSelected.sublist(begin,end),
        );
    List<Widget> rowsOfButtons = [];
    int count = 3;
    for (var i = 0; i < isSelected.length; i += count) {
      i < (isSelected.length - count)
          ? rowsOfButtons.add(partButtons(i, i + count))
          : rowsOfButtons.add(partButtons(i, isSelected.length));
    }
    return Column(
      children: rowsOfButtons,
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
          colorChoose()
        ],
      ),
    );
  }
}
