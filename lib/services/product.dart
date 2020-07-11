import 'package:ecommerce_app/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  ProductService();

  // collection reference
  final CollectionReference productCollection = Firestore.instance.collection('products');

  Future<void> createProduct(Product product) async {
    return await productCollection.add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    return await productCollection.document(product.uid).setData(product.toMap());
  }

  Future<void> deleteProduct(Product product) async {
    return await productCollection.document(product.uid).delete();
  }

  // Product list from snapshot
  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((documentSnapshot) {
      return Product.fromFireBaseSnapshot(documentSnapshot.data);
    }).toList();
  }

  // get products stream
  Stream<List<Product>> get productsStream {
    return productCollection.snapshots().map(_productListFromSnapshot);
  }
}
