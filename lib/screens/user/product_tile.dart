import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/user/product_detail.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final double cardWidth;

  ProductTile(this.product, this.cardWidth);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildProductItemCard(context),
//        _buildProductItemCard(context),
      ],
    );
  }

  _buildProductItemCard(BuildContext context) {
//    print("cardWidth= " + cardWidth.toString());
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ProductDetail(
                  productUid: product.uid,
                )));
      },
      child: Container(
        width: cardWidth,
        child: Card(
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: product.imgUrl != null && product.imgUrl != ""
                    ? Image.network(
                        product.imgUrl,
                        width: cardWidth,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/plate.jpg",
                        width: cardWidth,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: primaryTextStyleDark,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "₹ " + (product.price != null ? product.price.toString() : "0"),
                          style: primaryTextStyle,
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor: primaryColor,
                              elevation: 0,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              onPressed: () async {
                                if (!AuthService().isLoggedIn()) {
                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: Auth(null)));
                                } else {
                                  await CartItemService().createCartItem(CartItem(userId: AuthService().userInstance.uid, product: product, quantity: 1));
                                  showSnackBar(context, 'Item added to your cart');
                                }
                              }),

//                          child:FlatBtn('Add', () async{
//                            if(!AuthService().isLoggedIn()) {
//                              Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SignIn(null)));
//                            }
//                            else{
//                              await CartItemService().createCartItem(CartItem(userId: AuthService().userInstance.uid, product: product, quantity: 1));
//                              showSnackBar(context, 'Item added to your cart');
//                            }
//                          })
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
