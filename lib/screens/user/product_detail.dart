import 'dart:async';

import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';

class ProductDetail extends StatefulWidget {
  String productUid;

  ProductDetail({this.productUid});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<String> tags = [];
  Product product;
  double calculatedPrice;

  void recalculatePrice() {
    setState(() {
      calculatedPrice = product.price;
      tags.forEach((ingredient) {
        calculatedPrice += this.product.attributes["ingredients"].children[ingredient].priceOffset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width : 800;
    return StreamBuilder<Product>(
        stream: ProductService().productStream(widget.productUid),
        builder: (context, snapshot) {
          if (this.product == null && snapshot.hasData) {
            this.product = snapshot.data;
            this.calculatedPrice = this.product.price;
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: primaryColor,
              title: Text(product?.name ?? ""),
            ),
            body: Builder(builder: (context) {
              if (!snapshot.hasData) {
                return showLoadingWidget();
              } else {
                return Center(
                  child: Container(
                      width: 800,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: imageWidth,
                              height: imageWidth * 0.6,
                              child: product.imgUrl == null
                                  ? Image.asset('assets/plate.jpg')
                                  : Image.network(
                                      product.imgUrl,
                                      fit: BoxFit.cover,
                                    )),
                          Container(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text(product.name, style: h3),
                                      Text("₹ " + this.calculatedPrice.toString(),
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                          ))
                                    ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      product.description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                )),
                            if (product.attributes != null && product.attributes.containsKey("ingredients"))
                              Container(
                                padding: EdgeInsets.all(20),
                                color: Colors.grey[200],
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Choose Ingredients", style: h4),
                                    ChipsChoice<String>.multiple(
                                      value: tags,
                                      options: ChipsChoiceOption.listFrom<String, String>(
                                        source: product.attributes["ingredients"].children.keys.toList(),
                                        value: (i, v) => v,
                                        label: (i, v) => v,
                                      ),
                                      onChanged: (val) async => setState(() {
                                        tags = val;
                                        recalculatePrice();
                                      }),
                                      itemConfig: ChipsChoiceItemConfig(
                                        selectedColor: primaryColor,
                                        selectedBrightness: Brightness.dark,
                                        unselectedColor: primaryColor,
                                        unselectedBorderOpacity: .3,
                                      ),
                                      isWrapped: true,
                                    )
                                  ],
                                ),
                              ),
                          ])),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                color: Colors.grey[200],
                                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Total:  ₹" + this.calculatedPrice.toString(),
                                      style: primaryTextStyleDark,
                                    ),
                                    FlatBtn("Add to cart", () async {
                                      this.product.price = this.calculatedPrice;
                                      await CartItemService().createCartItem(CartItem(userId: AuthService().userInstance.uid, product: product, quantity: 1));
                                      showSnackBar(context, 'Item added to your cart');
                                      Timer(Duration(seconds: 2), () {
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                  ],
                                ),
                              )
                            ],
                          ))
                        ],
                      )),
                );
              }
            }),
          );
        });
  }
}
