import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shope_app_test/models/shop_app/search_model.dart';
import 'package:shope_app_test/modules/shope_app/settings/cubit/states.dart';
import 'package:shope_app_test/shared/components/constant.dart';
import 'package:shope_app_test/shared/network/end_points.dart';
import 'package:shope_app_test/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchState>{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text){
    emit(SearchLoadingState());
    DioHelper.postData(
        url: Search,
        token: token,
        data: {
      'text' : text
        }).then((value){
          model =SearchModel.fromJson( value.data);
          emit(SearchSuccessState());
    }).catchError((error){
      print('Error Search is ${error.toString()}');
      emit(SearchErrorState());
    });
  }
}