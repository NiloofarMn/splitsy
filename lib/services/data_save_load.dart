import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculate_exchange_v2/services/service_requirements.dart';

class Data {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final currencyKey = 'currency';
  final listOfPaymentsKey = 'listOfPayments';
  final nameTag = 'name';
  final costTag = 'cost';
  final colorTag = 'color';
  final describTag = 'dscrib';

  Future<void> saveData(String nameOfTheFile, List<PaymentClass> listOfPayments,
      String currency) async {
    /*
    This function saves data as the name of file.
    */
    final SharedPreferences prefs = await _prefs;
    List<Map> mapOfPaymenys = [];
    for (var i = 0; i < listOfPayments.length; i++) {
      mapOfPaymenys.add({
        nameTag: listOfPayments[i].name,
        costTag: listOfPayments[i].cost,
        colorTag: listOfPayments[i].color,
        describTag: listOfPayments[i].description
      });
    }

    prefs.setString(nameOfTheFile,
        jsonEncode({listOfPaymentsKey: mapOfPaymenys, currencyKey: currency}));
  }

  Future<Map> loadData(String nameOfFile) async {
    /*
    This function returns a Map of list of Payments and currency.
    You can access it by simply asking for the file name.
    */
    List<PaymentClass> listOfPayments = [];
    final SharedPreferences prefs = await _prefs;

    String data = prefs.getString(nameOfFile) ?? '';
    Map dataJson = data != '' ? await jsonDecode(data) as Map : {};
    String currency = dataJson != {} ? dataJson[currencyKey] : '\$';
    List preListOfPayments = dataJson != {} ? dataJson[listOfPaymentsKey] : [];
    for (var i = 0; i < preListOfPayments.length; i++) {
      PaymentClass instance = PaymentClass(
        name: preListOfPayments[i][nameTag],
        cost: preListOfPayments[i][costTag],
        color: preListOfPayments[i][colorTag],
        description: preListOfPayments[i][describTag],
      );
      listOfPayments.add(instance);
    }
    return {'list': listOfPayments, 'currency': currency};
  }

  Future<void> saveAllNames(String nameOfApp, List names) async {
    /*
    This function saves all the names.
    */
    final SharedPreferences prefs = await _prefs;
    prefs.setString(nameOfApp, jsonEncode(names));
  }

  Future<List> loadAllNames(String nameOfApp) async {
    /*
    This function returns a Map of list of Payments and currency.
    You can access it by simply asking for the file name.
    */
    final SharedPreferences prefs = await _prefs;
    List names = [];

    String data = prefs.getString(nameOfApp) ?? '';
    // print(data);
    names = data != '' ? await jsonDecode(data) as List : [];
    // print('in load all names: $names');
    return names;
  }

  Future<void> deleteASheet(String nameOfApp, int index) async {
    final SharedPreferences prefs = await _prefs;
    List names = await loadAllNames(nameOfApp);
    prefs.remove(names[index][1]);
    names.removeAt(index);
    // print('in delete a sheet: $names');
    saveAllNames(nameOfApp, names);
  }

  Future<void> editNameOfSheet(
      String nameOfApp, int index, String newName, int colorInt) async {
    final SharedPreferences prefs = await _prefs;
    List names = await loadAllNames(nameOfApp);
    Map _data = await loadData(names[index][1]);
    // save data with new name
    if (newName != names[index][1]) {
      // print('in edit when name is different: $newName');
      saveData(newName, _data['list'], _data['currency']);
      //remove data with old name
      prefs.remove(names[index][1]);
      // change the name in list of names
      names[index][1] = newName;
    }
    // print('change color');
    names[index][0] = colorInt;
    saveAllNames(nameOfApp, names);
  }

  Future<List> allTheNames(String nameOfApp) async{
    List data = await loadAllNames(nameOfApp);
    List names = [];
    for (var x in data) {
      names.add(x[1]);
    }
    return names;
  }

  void deleteEverything() async {
    // !!!! danger
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }
}
