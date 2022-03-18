import 'dart:async';
import 'package:calculate_exchange_v2/services/service_requirements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nameOfApp = 'Splitsy';
  final Data _data = Data();
  List allPrevNames = [];
  late Widget insideScreen;

  @override
  void initState() {
    // _data.deleteEverything();
    insideScreen = loading();
    _loadNames();
    super.initState();
  }

  Future<void> _loadNames() async {
    allPrevNames = await _data.loadAllNames(nameOfApp);
    setState(() {
      insideScreen = allPrevNames.isEmpty ? emptySheets() : gridShow();
    });
    // TODO   add a page when there is nothing in list
  }

  Widget emptySheets() {
    // print('in empty');
    return SliverFillRemaining(
      child: Container(
        // width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(.2),
        ),
        child: Icon(
          Icons.note_add,
          size: MediaQuery.of(context).size.width / 3,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget loading() {
    /*
    Until the data is loaded, this widget shows loading page.
    */
    return const SliverToBoxAdapter(
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.blueGrey,
          size: 100.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget pageSetup() {
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       //TODO: change to slide view
            //       print('slideview');
            //     },
            //     child: const Icon(Icons.view_carousel),
            //   )
            // ],
            title: Text(
              nameOfApp,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontFamily: 'aller',
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: 2,
                color: Theme.of(context).primaryColor,
              ),
              maxLines: 2,
            ),
          ),
          //TODO change this to slide when the button is pressed
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: insideScreen,
          ),
        ],
      );
    }

    return Scaffold(
      body: Center(
        child: pageSetup(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.note_add,
          size: 30,
        ),
        onPressed: () {
          makeNewSheet();
        },
      ),
    );
  }

  Widget gridShow() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          String name = allPrevNames[index][1];
          int colorInt = allPrevNames[index][0];
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            width: 200,
            height: 200,
            decoration: MyColors.sheetColors[colorInt],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 2,
                    ),
                    popupMore(index, colorInt, name),
                  ],
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await Navigator.of(context).pushNamed('/sheet',
                          arguments: [nameOfApp, index, name, colorInt]);
                      _loadNames();
                    },
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      padding: const EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: MyColors.fontColors[colorInt],
                            shadows: const <Shadow>[
                              Shadow(
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              Shadow(
                                blurRadius: 4.0,
                                color: Color.fromARGB(125, 255, 255, 255),
                              ),
                            ],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        childCount: allPrevNames.length,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
    );
  }

  void makeNewSheet() {
    // set up the buttons
    TextEditingController _nameController = TextEditingController();
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () async {
        List getNames = await _data.allTheNames(nameOfApp);
        if (allPrevNames.isEmpty || !getNames.contains(_nameController.text)) {
          Navigator.of(context).pop();
          if (_nameController.text.isEmpty) {
            _nameController.text =
                DateTime.now().toIso8601String().substring(2, 19);
          }
          setState(() {
            allPrevNames.add([1, _nameController.text]);
            _data.saveAllNames(nameOfApp, allPrevNames);
            insideScreen = gridShow();
          });
          _data.saveData(_nameController.text, [], '\$');
          await Navigator.of(context).pushNamed('/sheet', arguments: [
            nameOfApp,
            allPrevNames.length - 1,
            _nameController.text,
            1
          ]);
          setState(() {
            _loadNames();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Do NOT use same name as previous sheets!'),
          ));
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Set name of your new file:"),
      content: TextField(
        controller: _nameController,
      ),
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

  Widget popupMore(int index, int colorInt, String name) {
    return PopupMenuButton(
      child: const Icon(
        Icons.more_vert,
      ),
      onSelected: (value) async {
        if (value == 1) {
          var _changes = await Navigator.of(context)
              .pushNamed('/edit', arguments: [colorInt, name]);
          // print(_changes);
          if (_changes != null) {
            _changes as List;
            if (_changes[0] != allPrevNames[index][0] ||
                _changes[1] != allPrevNames[index][1]) {
              // print(_changes);
              await _data.editNameOfSheet(
                  nameOfApp, index, _changes[1], _changes[0]);
              _loadNames();
            }
          }
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text('Delete'),
            ],
          ),
          onTap: () => _remove(index),
        ),
      ],
    );
  }

  Future<void> _remove(int index) async {
    await _data.deleteASheet(nameOfApp, index);
    setState(() {
      _loadNames();
    });
  }
}
