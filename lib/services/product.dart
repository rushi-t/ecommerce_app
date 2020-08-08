import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  ProductService();

  // collection reference
  final CollectionReference productCollection = Firestore.instance.collection('products');

  Future<void> createProduct(Product product) async {
    return await productCollection.add(product.toJson());
  }

  Future<void> updateProduct(Product product) async {
//    product.addAttribute("Ingredient", false);
//    product.attributes["Ingredient"].addChild("extra cheese", 10, false);
//    product.attributes["Ingredient"].addChild("extra tomato", 0, false);
//    product.attributes["Ingredient"].addChild("extra butter", 0, false);
//    product.attributes["Ingredient"].addChild("no butter", 0, false);
//    product.attributes["Ingredient"].addChild("spicy", 0, false);
    List<String> searchKeywords = product.name.toLowerCase().trim().split(" ") + product.description.toLowerCase().trim().split(" ");
    product.searchKeywords = searchKeywords;
    return await productCollection.document(product.uid).setData(product.toJson());
  }

  Future<void> deleteProduct(Product product) async {
    print("Deleteing- "+ product.uid);
    return await productCollection.document(product.uid).delete();
  }

  // Product list from snapshot
  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((documentSnapshot) {
//      print(documentSnapshot.data.toString());
      Product product;
      try {
        product = Product.fromJson(documentSnapshot.data);

      } catch (e) {
        print(e);
      }
//      print("ddd"+ product.toJson().to);
      return product;
    }).toList();
  }

  // get products stream
  Stream<List<Product>> get productsStream {
    return productCollection.snapshots().map(_productListFromSnapshot);
  }

  Stream<Product> productStream(String uid) {
    return productCollection.document(uid).snapshots().map((documentSnapshot) => Product.fromJson(documentSnapshot.data));
  }

  Stream<List<Product>> filterStream({List<Category> categoryList, String searchStr}) {
    Query query = productCollection;

    query = searchStr != null && searchStr.isNotEmpty ?  query.where('searchKeywords', arrayContains: searchStr): query;
    query = categoryList != null  && categoryList.isNotEmpty ?  query.where('categoryUid', whereIn: categoryList.map((category) => category.uid).toList()): query;
    return query.snapshots().map(_productListFromSnapshot);
  }
}
