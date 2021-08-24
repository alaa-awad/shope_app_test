import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shope_app_test/layout/cubit/cubit.dart';
import 'package:shope_app_test/models/shop_app/search_model.dart';
import 'package:shope_app_test/modules/shope_app/settings/cubit/cubit.dart';
import 'package:shope_app_test/modules/shope_app/settings/cubit/states.dart';
import 'package:shope_app_test/shared/components/components.dart';
import 'package:shope_app_test/shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                        controller: searchController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'write a word to search..';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          prefixIcon: Icon(Icons.search),
                        ),
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (value) {
                          SearchCubit.get(context).search(value);
                          print('This is SearchModel : ${SearchCubit.get(context).model!.data!.data!.length}');
                        },
                        onChanged: (value) {
                          SearchCubit.get(context).search(value);
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    if (state is SearchLoadingState) LinearProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          itemBuilder: (context, index){
                            print('item product is ${SearchCubit.get(context).model!.data!.data![index].name}');
                            return buildProductItem(
                                SearchCubit.get(context)
                                    .model!
                                    .data!
                                    .data![index],
                                context,
                                isFavorite: false);
                          },
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: SearchCubit.get(context)
                              .model!
                              .data!
                              .data!
                              .length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
Widget buildProductSearchItem(Product model, context,{bool isFavorite=true}){
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(
        children:
        [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children:
            [
              Image(
                image: NetworkImage(model.image.toString()),
                width: 120.0,
                height: 120.0,
              ),
              if (model.discount != 0 && isFavorite)
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontSize: 8.0,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.3,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      model.price.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: defaultColor,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    if (model.discount != 0 && isFavorite)
                      Text(
                        model.oldPrice.toString(),
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Spacer(),
                    IconButton(
                      onPressed: ()
                      {
                        ShopCubit.get(context).changeFavorite(model.id);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                        backgroundColor:
                        ShopCubit.get(context).favorite[model.id]!
                            ? defaultColor
                            : Colors.grey,
                        child: Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
