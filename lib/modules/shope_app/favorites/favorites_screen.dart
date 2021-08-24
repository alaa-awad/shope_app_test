import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shope_app_test/layout/cubit/cubit.dart';
import 'package:shope_app_test/layout/cubit/states.dart';
import 'package:shope_app_test/models/shop_app/favorites_model.dart';
import 'package:shope_app_test/shared/components/components.dart';
import 'package:shope_app_test/shared/styles/colors.dart';
class FavoritesScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return ShopCubit.get(context).favoritesModel != null||
            ShopCubit.get(context).favoritesModel!.data!.data != null
        ?
          state is !ShopLoadingGetFavoritesState?
        ListView.separated(
          itemBuilder: (context, index) =>
              buildFavItem(ShopCubit.get(context).favoritesModel!.data!.data![index], context),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length,
        ):
        Center(child: CircularProgressIndicator())
            :Center(child: Text('No Item is favorite'));
      },
    );
  }


  Widget buildFavItem(DataProduct model, context){
    print('//////${ShopCubit.get(context).favoritesModel!.data!.data}');
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
                  image: NetworkImage(model.product.image),
                  width: 120.0,
                  height: 120.0,
                ),
                if (model.product.discount != 0)
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
                    model.product.name,
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
                        model.product.price.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.product.discount != 0)
                        Text(
                          model.product.oldPrice.toString(),
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
                          ShopCubit.get(context).changeFavorite(model.product.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                          ShopCubit.get(context).favorite[model.product.id]!
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
}
