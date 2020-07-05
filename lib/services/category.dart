import 'package:ecommerce_app/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  CategoryService();
  // collection reference
  final CollectionReference categoryCollection = Firestore.instance.collection('categories');

  Future<void> createCategory(Category category) async {
    return await categoryCollection.add(category.toMap());
  }

  Future<void> updateCategory(Category category) async {
    return await categoryCollection.document(category.uid).setData(category.toMap());
  }

  Future<void> deleteCategory(Category category) async {
    return await categoryCollection.document(category.uid).delete();
  }

  // Category list from snapshot
  List<Category> _categoryListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((documentSnapshot){
      return Category.fromFireBaseSnapshot(documentSnapshot.data);
    }).toList();
  }

  // get categories stream
  Stream<List<Category>> get categoriesStream {
    return categoryCollection.snapshots()
      .map(_categoryListFromSnapshot);
  }

}