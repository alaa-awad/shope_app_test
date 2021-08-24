class CategoriesModel{

  late bool status;
//  late String message;
  late CategoriseDataModel data;

  CategoriesModel.fromJson(Map<String,dynamic> json){
    status = json['status'];
   // message = json['message'];
    data = CategoriseDataModel.fromJson(json['data']);
  }
}

class CategoriseDataModel{

late int currentPage ;
List<DataModel> dataModel = [];
CategoriseDataModel.fromJson(Map<String,dynamic> json){
  currentPage = json['current_page'];
  json['data'].forEach((element){
    dataModel.add(DataModel.fromJson(element));
  });
}
}

class DataModel{
  late int id;
  late String name;
  late String image;
  DataModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}