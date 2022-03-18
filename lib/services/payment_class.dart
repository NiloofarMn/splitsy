
class PaymentClass {
  String name; // name for ui
  double cost; // time in that location
  String description; // url to an asset flag icon
  int color; // location url for api endpoint
  
  PaymentClass(
      {required this.name,
      required this.cost,
      required this.color,
      this.description = '',
      }); //, required this.discription, required this.color

}
