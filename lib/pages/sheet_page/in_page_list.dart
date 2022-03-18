import 'dart:async';
import 'package:calculate_exchange_v2/pages/sheet_page/sheet_imports.dart';
import 'package:calculate_exchange_v2/services/service_requirements.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//class that contains overview of top part and
// almost all parts of bottom part.
class ListOfPayments extends StatefulWidget {
  final String pageName;
  const ListOfPayments({
    Key? key,
    required this.pageName,
  }) : super(key: key);

  @override
  ListOfPaymentsState createState() => ListOfPaymentsState();
}

class ListOfPaymentsState extends State<ListOfPayments> {
  late Widget _screen;
  late ProvideList _listProvider;
  late String pageName;

  //data for animated list:
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  final int durationMs = 150;
  final Tween<Offset> _offset =
      Tween(begin: const Offset(.1, .2), end: const Offset(0, 0));
  final Tween<double> _opacity = Tween(begin: 0, end: 1);

  int get len => _listProvider.len;

  @override
  void initState() {
    _screen = loading();
    pageName = widget.pageName;
    // until we have a data.
    // then in below, after loading data, the screen changes.
    initPage(widget.pageName);
    super.initState();
  }

  Future<void> initPage(String nameOfpage) async {
    _listProvider = ProvideList(nameOfpage);
    bool loaded = await _listProvider.loadData();
    // print(_listProvider.len);
    // print(_listProvider.paymentList);
    setState(() {
      if (loaded) {
        _listProvider.len == 0
            ? _screen = const Empty()
            : initAnimationList(_listProvider.paymentList
                .map((PaymentClass _x) => _x)
                .toList());
      }
    });
  }

  Future<void> onChangeName() async {
    String newName = Provider.of<Schedule>(context, listen: false).pageName;
    if (newName != pageName) {
      pageName = newName;
      _listProvider = ProvideList(newName);
      await _listProvider.loadData();
      setState(() {
        makeAnimatedList();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Schedule>(
      builder: (BuildContext context, value, Widget? child) {
        if (value.isRemoveAllActive) {
          removeAll();
        }
        if (value.didNameChange) {
          onChangeName();
        }
        return Expanded(
          child: Column(
            children: [
              _screen,
              showSum(_listProvider.sum(), _listProvider.currency),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                child: bottomButtons(),
              )
            ],
          ),
        );
      },
    );
  }

  Widget loading() {
    /*
    Until the data is loaded, this widget shows loading page.
    */
    return const Expanded(
      child: SpinKitFadingCircle(
        color: Colors.blueGrey,
        size: 100.0,
      ),
    );
  }

  void _addToList(PaymentClass _x) {
    _listProvider.addToList(_x);
    _key.currentState?.insertItem(_listProvider.len - 1);
    Provider.of<Schedule>(context, listen: false).changeLen = _listProvider.len;
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut));
    });
  }

  void removeAll() {
    int n = _listProvider.len;
    Future ft = Future(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var i = 0; i < n; i++) {
        ft = ft.then(
          (value) => Future.delayed(Duration(milliseconds: durationMs), () {
            _removeFromList(0);
          }),
        );
      }
    });
  }

  void _removeFromList(int index) {
    PaymentClass item = _listProvider.paymentList[index];
    AnimatedListRemovedItemBuilder builder =
        (BuildContext context, Animation<double> animation) =>
            buildItems(item, index, animation);
    _key.currentState?.removeItem(index, builder);
    _listProvider.removeFromList(index);
    Provider.of<Schedule>(context, listen: false).changeLen = _listProvider.len;
    setState(() {
      if (_listProvider.paymentList.isEmpty) _screen = const Empty();
    });
  }

  Future<void> goToEditPage(int index) async {
    PaymentClass item = _listProvider.paymentList[index];
    PaymentClass edited = await Navigator.pushNamed(context, '/sheet/edit',
        arguments: _listProvider.paymentList[index]) as PaymentClass;

    Timer(const Duration(milliseconds: 200), () {
      AnimatedListRemovedItemBuilder builder =
          (BuildContext context, Animation<double> animation) =>
              buildItems(item, index, animation);
      _key.currentState?.removeItem(index, builder);
      _listProvider.changeItem(index, edited);
      _key.currentState?.insertItem(index);
    });
  }

  void initAnimationList(List<PaymentClass> paymentsList) {
    int n = _listProvider.len;
    for (var i = 0; i < n; i++) {
      _listProvider.removeFromList(0);
    }
    Future ft = Future(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (PaymentClass _x in paymentsList) {
        ft = ft.then(
          (value) => Future.delayed(Duration(milliseconds: durationMs), () {
            _addToList(_x);
          }),
        );
      }
    });
    Provider.of<Schedule>(context, listen: false).changeLen = _listProvider.len;
    _screen = makeAnimatedList();
  }

  Widget makeAnimatedList() {
    return Expanded(
      child: AnimatedList(
          key: _key,
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          initialItemCount: _listProvider.len,
          itemBuilder: (context, index, animation) =>
              buildItems(_listProvider.paymentList[index], index, animation)),
    );
  }

  Widget buildItems(PaymentClass item, int index, Animation<double> animation) {
    return FadeTransition(
      opacity: _opacity.animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInQuad, //slowMiddle
        ),
      ),
      child: SlideTransition(
        child: ListTile(
          title: PaymentCard(
            name: item.name,
            cost: '${_listProvider.currency} ${item.cost}',
            colorInt: item.color,
            description: item.description,
          ),
          onLongPress: () {
            // print('long press $index');
          },
          trailing: PopupMenuButton(
            child: Icon(
              Icons.more_vert,
              color: MyColors.people[item.color],
            ),
            onSelected: (value) {
              if (value == 1) {
                goToEditPage(index);
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
                value: 0,
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
                onTap: () => _removeFromList(index),
              ),
            ],
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
  }

  Widget showSum(double sumOfCosts, String currency) {
    return SizedBox(
      height: 70,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        child: Text(
          '$currency ${sumOfCosts.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Row bottomButtons() {
    /*
    buttons in bottom are defined in this widget.
    */
    var evStyle = ElevatedButton.styleFrom(
      primary: Theme.of(context).primaryColor.withOpacity(.7),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
              onPressed: () async {
                var curr =
                    await Navigator.of(context).pushNamed('/sheet/change');
                if (curr != null) {
                  setState(() {
                    _listProvider.changeCurrency = curr.toString();
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: ImageIcon(
                  AssetImage("assets/images/change.png"),
                  size: 40,
                ),
              ),
              style: evStyle),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 3,
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/sheet/calculate',
                    arguments: _listProvider.calculatedResult());
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.calculate,
                    size: 40,
                  ),
                  Text(
                    'Calculate',
                    style: TextStyle(
                      fontFamily: 'aller',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              style: evStyle),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
              onPressed: () async {
                var newData =
                    await Navigator.of(context).pushNamed('/sheet/add');
                if (newData != null) {
                  if (_listProvider.paymentList.isEmpty) {
                    setState(() {
                      _screen = makeAnimatedList();
                    });
                  }
                  Timer(const Duration(milliseconds: 300), () {
                    _addToList(newData as PaymentClass);
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: ImageIcon(
                  AssetImage("assets/images/credit-card1.png"),
                  size: 40,
                ),
              ),
              style: evStyle),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
