import 'package:calculate_exchange_v2/services/read_currencies.dart';
import 'package:calculate_exchange_v2/services/service_requirements.dart';
import 'package:flutter/material.dart';

class ChangeCurrency extends StatefulWidget {
  const ChangeCurrency({Key? key}) : super(key: key);

  @override
  State<ChangeCurrency> createState() => _ChangeCurrencyState();
}

class _ChangeCurrencyState extends State<ChangeCurrency> {
  List allCurrencies = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  final Tween<Offset> _offset =
      Tween(begin: const Offset(.1, .2), end: const Offset(0, 0));
  final Tween<double> _opacity = Tween(begin: 0, end: 1);
  TextEditingController controller = TextEditingController(text: '');
  bool searchIsEmpty = false;
  String searchValue = '';
  List searchList = [];

  Widget appbarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'Change Currency',
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

  Widget closeThisPageButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
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

  Future<void> getCurrs() async {
    List _data = await ReadCurrencies().load();
    // print(allCurrencies);
    Future ft = Future(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (List _x in _data) {
        ft = ft.then(
          (value) => Future.delayed(const Duration(milliseconds: 50), () {
            _addToList(_x);
          }),
        );
      }
    });
  }

  void _addToList(List _x) {
    allCurrencies.add(_x);
    _key.currentState?.insertItem(allCurrencies.length - 1);
  }

  Widget searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).primaryColor.withOpacity(.1),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: _inFieldButton(),
        ),
        textInputAction: TextInputAction.search,
        style: TextStyle(
          overflow: TextOverflow.fade,
          fontFamily: 'aller',
          fontWeight: FontWeight.w900,
          fontSize: 18,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _inFieldButton() {
    if (!searchIsEmpty) {
      return const Icon(Icons.search);
    }
    return IconButton(
      onPressed: () => controller.clear(),
      icon: const Icon(Icons.clear),
    );
  }

  List searchResult(String filter) {
    /// return search result
    if (filter.isNotEmpty) {
      return allCurrencies
          .where((element) =>
              element[0].toLowerCase().startsWith(filter.toLowerCase()))
          .toList();
    }
    return allCurrencies.map((e) => e).toList();
  }

  Widget currBody() {
    // print('len of the list: ${searchList.length}');
    return Expanded(
      child: AnimatedList(
          key: _key,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          initialItemCount: allCurrencies.length,
          itemBuilder: (context, index, animation) {
            return FadeTransition(
              opacity: _opacity.animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInQuad, //slowMiddle
                ),
              ),
              child: SlideTransition(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(allCurrencies[index][1]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          allCurrencies[index][0],
                          style: TextStyle(
                            fontFamily: 'aller',
                            fontSize: 20,
                            letterSpacing: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          allCurrencies[index][1],
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                position: _offset.animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutQuart,
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget currBody2() {
    // print('len of the list: ${searchList.length}');
    return Expanded(
      child: ListView.builder(
          itemCount: searchList.length,
          itemBuilder: (context, index) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).pop(searchList[index][1]);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      searchList[index][0],
                      style: TextStyle(
                        fontFamily: 'aller',
                        fontSize: 20,
                        letterSpacing: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      searchList[index][1],
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    getCurrs();
    controller.addListener(() {
      setState(() {
        searchIsEmpty = controller.text.isNotEmpty;
        searchValue = controller.text;
        searchList = searchResult(searchValue);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 1),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter, //bottomCenter
                end: Alignment.bottomCenter, //topCenter
                colors: GradientColors.cloudyKnoxville), //confidentCloud,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10.0, spreadRadius: 7.0),
            ],
          ),
          child: Column(
            children: [
              appbarWidget(),
              closeThisPageButton(),
              searchBar(),
              searchValue.isEmpty ? currBody() : currBody2(),
            ],
          ),
        ),
      ),
    );
  }
}
