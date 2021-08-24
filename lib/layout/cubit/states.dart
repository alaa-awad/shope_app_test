import 'package:shope_app_test/models/shop_app/change_favorities_model.dart';
import 'package:shope_app_test/models/shop_app/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}
class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}
class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}
class ShopErrorCategoriesState extends ShopStates {}

class ShopSuccessFavoritesState extends ShopStates {
  final ChangeModelFavourite model;

  ShopSuccessFavoritesState(this.model);

}
class ShopChangeFavoritesState extends ShopStates {}
class ShopErrorFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}
class ShopLoadingGetFavoritesState extends ShopStates {}
class ShopErrorGetFavoritesState extends ShopStates {}

class ShopSuccessGetUserDataState extends ShopStates {}
class ShopLoadingGetUserDataState extends ShopStates {}
class ShopErrorGetUserDataState extends ShopStates {}


class ShopSuccessUpdateUserDataState extends ShopStates {
  final ShopLoginModel model;

  ShopSuccessUpdateUserDataState(this.model);

}
class ShopLoadingUpdateUserDataState extends ShopStates {}
class ShopErrorUpdateUserDataState extends ShopStates {}

//class ShopLoadingUpdateUserState extends ShopStates {}