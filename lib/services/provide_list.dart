import 'dart:collection';
import 'package:calculate_exchange_v2/services/data_save_load.dart';
import 'package:calculate_exchange_v2/services/payment_class.dart';

class ProvideList {
  List<PaymentClass> _paymentList = [];
  late String _currency = '';
  final Data _data = Data();
  late String _fileName;

  ProvideList(String pageName){
    _fileName = pageName;
    // loadData();
  }

  Future<bool> loadData() async {
    Map _map = await _data.loadData(_fileName);
    // print(_map);
    _currency = _map['currency'];
    _paymentList = _map['list'];
    // _paymentList = [
    //   PaymentClass(name: 'name', cost: 23, color: 1, description: 'something'),
    //   PaymentClass(name: 'nil', cost: 43, color: 2),
    //   PaymentClass(name: 'say', cost: 3, color: 3),
    //   PaymentClass(name: 'name', cost: 4.23, color: 1),
    //   PaymentClass(name: 'nil', cost: 4.32, color: 2, description: 'my descriptions are shit. \njust be it.'),
    // ];
    return true;
  }

  String get fileName => _fileName;
  String get currency => _currency;
  int get len => _paymentList.length;
  List<PaymentClass> get paymentList => _paymentList;

  set changeCurrency(String newCurrency) {
    _currency = newCurrency;
    _data.saveData(_fileName, _paymentList, _currency);
  }
  set setFileName(String filename){
    _fileName = filename;
  }

  void addToList(PaymentClass elem) {
    _paymentList.add(elem);
    _data.saveData(_fileName, _paymentList, _currency);
  }

  void removeFromList(int index) {
    _paymentList.removeAt(index);
    _data.saveData(_fileName, _paymentList, _currency);
  }

  void changeItem(int index, PaymentClass elem) {

    _paymentList[index] = elem;
    
    _data.saveData(_fileName, _paymentList, _currency);
  }

  double sum() {
    double _sum = 0;
    for (PaymentClass item in _paymentList) {
      _sum += item.cost;
    }
    return _sum;
  }

  Map calculatedResult() {
    Map peoplePays = {};
    for (PaymentClass item in _paymentList) {
      if (peoplePays.containsKey('${item.name},${item.color}')) {
        peoplePays['${item.name},${item.color}'] += item.cost;
      } else {
        peoplePays['${item.name},${item.color}'] = item.cost;
      }
    }
    // print('this is people: $peoplePays');

    double share = double.parse((sum() / peoplePays.length).toStringAsFixed(2));
    Map paybackTos = {}; // people who should pay
    Map paybackFroms = {}; // people who should be payed
    for (var key in peoplePays.keys.toList()) {
      double temp = double.parse((share - peoplePays[key]).toStringAsFixed(2));
      // print(key);
      // print(temp);
      temp < 0 ? paybackTos[key] = -temp : paybackFroms[key] = temp;
    }
    // print(paybackFroms);
    // print(paybackTos);

    var sortedKeys1 = paybackTos.keys.toList(growable: false)
      ..sort((k1, k2) => paybackTos[k2].compareTo(paybackTos[k1]));
    Map sortedto = LinkedHashMap.fromIterable(sortedKeys1,
        key: (k) => k, value: (k) => paybackTos[k]);

    var sortedKeys2 = paybackFroms.keys.toList(growable: false)
      ..sort((k1, k2) => paybackFroms[k1].compareTo(paybackFroms[k2]));
    Map sortedfrom = LinkedHashMap.fromIterable(sortedKeys2,
        key: (k) => k, value: (k) => paybackFroms[k]);
    return {'curr':_currency, 'paybackTos': sortedto, 'paybackFroms': sortedfrom};
  }
}
