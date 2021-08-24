import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shope_app_test/layout/cubit/cubit.dart';
import 'package:shope_app_test/layout/cubit/states.dart';
import 'package:shope_app_test/modules/shope_app/search/search_screen.dart';
import 'package:shope_app_test/shared/components/components.dart';
import 'package:shope_app_test/shared/components/constant.dart';
import 'package:shope_app_test/shared/network/local/cache_helper.dart';
class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Shop App'),
            actions: [

              IconButton(onPressed: (){
                navigateTo(context,SearchScreen());
              }, icon: Icon(Icons.search)),
              IconButton(onPressed: (){
                isDark = !isDark!;
                CacheHelper.saveData(key: 'isDark', value: isDark);
              }, icon: Icon(Icons.wb_sunny_outlined)),
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
            label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.view_module_rounded),
                label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favourite'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings'),
          ],
            currentIndex: cubit.currentIndex,
            onTap: (index){
            print(index);
            cubit.changeBottom(index);
            },
         ),
        );
      },
    );
  }
}
