import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shope_app_test/layout/cubit/states.dart';
import 'package:shope_app_test/models/shop_app/categories_model.dart';
import 'package:shope_app_test/models/shop_app/change_favorities_model.dart';
import 'package:shope_app_test/models/shop_app/favorites_model.dart';
import 'package:shope_app_test/models/shop_app/home_model.dart';
import 'package:shope_app_test/models/shop_app/login_model.dart';
import 'package:shope_app_test/modules/shope_app/cateogries/categories_screen.dart';
import 'package:shope_app_test/modules/shope_app/favorites/favorites_screen.dart';
import 'package:shope_app_test/modules/shope_app/products/products_screen.dart';
import 'package:shope_app_test/modules/shope_app/settings/settings_screen.dart';
import 'package:shope_app_test/shared/components/constant.dart';
import 'package:shope_app_test/shared/network/end_points.dart';
import 'package:shope_app_test/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

   HomeModel? homeModel;
   Map<int,bool> favorite = {};
  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value)
    {
      homeModel = HomeModel.fromJson(value.data);
     homeModel!.data.products.forEach((element) {
       favorite.addAll({
         element.id: element.inFavorites
       });
     });
     print(favorite.toString());
      //printFullText(homeModel.data.banners[0].image);
      print(homeModel!.status);

      emit(ShopSuccessHomeDataState());
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategorise()
  {
    DioHelper.getData(
      url: GIT_CATEGORISE,
    ).then((value)
    {
      categoriesModel = CategoriesModel.fromJson(value.data);


      emit(ShopSuccessCategoriesState());
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeModelFavourite? changeModelFavourite;
  void changeFavorite(int productId){
    favorite[productId] = !favorite[productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
        url: FAVORITES,
        token: token,
        data: {
          'product_id' : productId,
        })
        .then((value){
          print(token);
          changeModelFavourite = ChangeModelFavourite.fromJson(value.data);
           if(!changeModelFavourite!.status){
             favorite[productId] = !favorite[productId]!;
       }
           else{
             getFavorite();
           }
          print(value.data);

    }).then((value){
      emit(ShopSuccessFavoritesState(changeModelFavourite!));
    })
        .catchError((error){
      favorite[productId] = !favorite[productId]!;
      emit(ShopErrorFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorite()
  {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value)
    {
      favoritesModel = FavoritesModel.fromJson(value.data);


      emit(ShopSuccessGetFavoritesState());

    }).catchError((error)
    {
      print(error.toString());

      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData()
  {
    emit(ShopLoadingGetUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value)
    {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessGetUserDataState());

    }).catchError((error)
    {
      emit(ShopErrorGetUserDataState());
    });
  }

  void updateUserData({
  required String name,
  required String email,
  required String phone,
})
  {
    emit(ShopLoadingUpdateUserDataState());
    DioHelper.putData(
      url: Update_PROFILE,
      token: token,
        data: {
        'name':name,
        'email':email,
        'phone':phone,
    }
    ).then((value)
    {
      userModel = ShopLoginModel.fromJson(value.data);
     // showToast(text:'The Update Is Success', state: ToastStates.SUCCESS);
      emit(ShopSuccessUpdateUserDataState(ShopLoginModel.fromJson(value.data)));

    }).catchError((error)
    {
      emit(ShopErrorUpdateUserDataState());
    });
  }
}
