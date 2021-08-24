import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shope_app_test/layout/cubit/cubit.dart';
import 'package:shope_app_test/layout/cubit/states.dart';
import 'package:shope_app_test/models/shop_app/categories_model.dart';
import 'package:shope_app_test/models/shop_app/home_model.dart';
import 'package:shope_app_test/shared/components/components.dart';

dynamic mapFavourite;

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessFavoritesState){
          if(!state.model.status){
            showToast(
                text: state.model.message,
                state:ToastStates.ERROR );
          }
        }
      },
      builder: (context, state) {
        return (ShopCubit.get(context).homeModel != null&&ShopCubit.get(context).categoriesModel != null)
            ? builderWidget(ShopCubit.get(context).homeModel,ShopCubit.get(context).categoriesModel,context)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget builderWidget(HomeModel? model,CategoriesModel? categoriesModel , context) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model!.data.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 100.0,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            buildCategoryItem(categoriesModel!.data.dataModel[index]),
                        separatorBuilder: (context, index) => SizedBox(
                          width: 10.0,
                        ),
                        itemCount: categoriesModel!.data.dataModel.length,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'New Products',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.5,
                crossAxisCount: 2,
                children: List.generate(
                  model.data.products.length,
                  (index) => GridProductItem(model.data.products[index],context),
                ),
              ),
            ),
          ],
        ),
      );
}

Widget buildCategoryItem(DataModel model) => Stack(
  alignment: AlignmentDirectional.bottomCenter,
  children:
  [
    Image(
      image: NetworkImage(model.image),
      height: 100.0,
      width: 100.0,
      fit: BoxFit.cover,
    ),
    Container(
      color: Colors.black.withOpacity(.8,),
      width: 100.0,
      child: Text(
        model.name,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  ],
);

Widget GridProductItem(ProductModel product,context) {
  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: NetworkImage(
            product.image,
          ),
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${product.price}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  if (product.discount != 0)
                    Text(
                      '${product.oldPrice}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                       ShopCubit.get(context).changeFavorite(product.id);
                      },
                      icon: Icon(
                        Icons.favorite,
                      color: ShopCubit.get(context).favorite[product.id]! ?Colors.blue:Colors.grey,)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
