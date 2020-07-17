import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AttributeChild{
  String name;
  double priceOffset;
  bool isSelected;

  AttributeChild({this.name, this.priceOffset, this.isSelected});

  Map<String, dynamic> toJson() {
    return {'name': this.name, "priceOffset": this.priceOffset, "isSelected": this.isSelected};
  }

  AttributeChild.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        priceOffset = json["priceOffset"],
        isSelected = json["isSelected"];
}

class Attribute {
  String name;
  bool isMutuallyExclusive;
  Map<String, AttributeChild> children;

  Attribute({this.name, this.isMutuallyExclusive, this.children});

  AttributeChild addChild(String name, double priceOffset, bool isSelected){
    children ??= Map<String, AttributeChild>();
    children[name] = AttributeChild(name: name, priceOffset: priceOffset, isSelected: isSelected);
    return children[name];
  }

  void selectChildren(String itemName){
    if(isMutuallyExclusive){
      children.forEach((attributeChildName, attributeChild) { attributeChild.isSelected =false; });
    }
    children[itemName]?.isSelected = true;
  }

  Map<String, dynamic> toChildrenJson(){
    Map<String, dynamic> attributeItemsJson = Map<String, dynamic>();
    this?.children?.forEach((attributeChildName, attributeChild) { attributeItemsJson[attributeChildName] = attributeChild.toJson();});
    return attributeItemsJson;
  }

  static Map<String, AttributeChild> fromChildrenJsonToAChildren(Map<String, dynamic> childrenJson) {
    Map<String, AttributeChild> children = Map<String, AttributeChild>();
    childrenJson?.forEach((childName, child) { children[childName] = AttributeChild.fromJson(child); });
    return children;
  }

  Map<String, dynamic> toJson() {
    return {'name': this.name, "isMutuallyExclusive": this.isMutuallyExclusive, "children": this.toChildrenJson() };
  }

  Attribute.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        isMutuallyExclusive = json["isMutuallyExclusive"],
        children = fromChildrenJsonToAChildren(json["children"]);
}

class Product {
  String uid = Uuid().v1();
  String name;
  String imgUrl;
  double price;
  bool enabled = true;
  String description;
  String categoryUid;
  Map<String, Attribute> attributes;

  Product({this.name, this.imgUrl, this.price, this.enabled, this.description, this.categoryUid, this.attributes});

  Attribute addAttribute(String attributeName, bool isMutuallyExclusive)
  {
    attributes ??= Map<String, Attribute>();
    attributes[attributeName] = Attribute(name: attributeName, isMutuallyExclusive: isMutuallyExclusive);
    return attributes[attributeName];
  }

  void deleteAttribute(String attributeName){
    attributes?.remove(attributeName);
  }

  Map<String, dynamic> toAttributeJson(){
    Map<String, dynamic> attributeJson = Map<String, dynamic>();
    this?.attributes?.forEach((attributeName, attribute) { attributeJson[attributeName] = attribute.toJson();});
    return attributeJson;
  }

  static Map<String, Attribute> fromAttributeJsonToAttributes(Map<String, dynamic> attributeJson) {
    Map<String, Attribute> attributes = Map<String, Attribute>();
    attributeJson?.forEach((attributeName, attribute) { attributes[attributeName] = Attribute.fromJson(attribute); });
    return attributes;
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'name': this.name,
      'imgUrl': this.imgUrl,
      'price': this.price,
      'enabled': this.enabled,
      'description': this.description,
      'categoryUid': this.categoryUid,
      'attributes': this.toAttributeJson()
    };
  }

  Product.fromJson(Map snapshot)
      : uid = snapshot['uid'],
        name = snapshot['name'],
        imgUrl = snapshot['imgUrl'],
        price = snapshot['price'],
        enabled = true,
        description = snapshot['description'],
        categoryUid = snapshot['categoryUid'],
        attributes = fromAttributeJsonToAttributes(snapshot['attributes']);
}
