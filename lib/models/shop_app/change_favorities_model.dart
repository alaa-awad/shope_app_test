class ChangeModelFavourite {

  late bool status;
  late String message;

  ChangeModelFavourite.fromJson(Map<String,dynamic> json){
    status = json['status'];
    message = json['message'];

  }
}