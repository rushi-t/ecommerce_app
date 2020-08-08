import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget getHomeAppBar(String title, {onPressed}) {
  return SliverAppBar(
    pinned: false,
    floating: false,
    snap: false,
    leading: IconButton(
      icon: Icon(
        Icons.menu,
        color: white,
      ),
      onPressed: onPressed,
    ),
    backgroundColor: primaryColor,
    title: Text(title, style: logoWhiteStyle, textAlign: TextAlign.center),
  );
}

AlertDialog showProgressWithMessage(BuildContext context, String message) {
  AlertDialog alertDialog = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text(message)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
  return alertDialog;
}

Widget showLoadingWidget() {
  return Center(child: CircularProgressIndicator());
}

class SearchBar extends StatelessWidget {
  String value;
  final onChanged;
  final onTap;
  final onSubmitted;

  SearchBar({this.value, this.onChanged, this.onTap, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shadowColor: primaryColor,
      elevation: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: null,
              cursorColor: primaryColor,
              controller: TextEditingController(text: value ?? ""),
              onTap: onTap,
              onChanged: (value) {
                this.value = value;
                onChanged(value);
              },
              onSubmitted: onSubmitted,
//              autofocus: true,
            ),
          )),
          Container(
              child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    if (onSubmitted != null) onSubmitted(this.value);
                  }))
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String url;
  final String defaultAssetPath;
  final double width;
  final BoxFit boxFit;

  ImageWidget(this.url, this.defaultAssetPath, {this.width, this.boxFit});

  @override
  Widget build(BuildContext context) {
    if (this.url != null && this.url != "") {
      return kIsWeb
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: this.url,
              width: this.width,
              fit: this.boxFit,
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                this.defaultAssetPath,
                width: this.width,
                fit: BoxFit.cover,
              ),
            )
          : CachedNetworkImage(
              width: this.width,
              imageUrl: this.url,
              fit: this.boxFit,
//        placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset(
                this.defaultAssetPath,
                width: this.width,
                fit: BoxFit.cover,
              ),
            );
    } else {
      return Image.asset(
        this.defaultAssetPath,
        width: this.width,
        fit: BoxFit.cover,
      );
    }
  }
}
