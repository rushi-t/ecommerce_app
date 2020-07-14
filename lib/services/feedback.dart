import 'package:ecommerce_app/models/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {

  FeedbackService();


  // collection reference
  final CollectionReference feedbackCollection = Firestore.instance.collection('feedback');

//  Future<void> addFeedbackData(String name, String phone, String email,String message) async {
//    return await feedbackCollection.document(uid).setData({
//      'name': name,
//      'phone': phone,
//      'email': email,
//      'message': message
//    });
//  }

//  // brew list from snapshot
//  List<Feedback> _feedbackListFromSnapshot(QuerySnapshot snapshot) {
//    return snapshot.documents.map((doc){
//      //print(doc.data);
//      return Feedback(
//          name: doc.data['name'] ?? '',
//         phone: doc.data['phone'] ?? '',
//         email: doc.data['email'] ?? '',
//        message: doc.data['message'] ?? '',
//      );
//    }).toList();
////  }
//
//  // get brews stream
//  Stream<List<Feedback>> get feedbackStream {
//    return feedbackCollection.snapshots()
//        .map(_feedbackListFromSnapshot);
//  }


  Future<void> createFeedback(Feedback feedback) async {
    print("----Inside the Service-----");
    print(feedback.uid);
    return await feedbackCollection.add(feedback.toMap());
  }

  Future<void> updateFeedback(Feedback feedback) async {
    return await feedbackCollection.document(feedback.uid).setData(feedback.toMap());
  }

  Future<void> deleteFeedback(Feedback feedback) async {
    return await feedbackCollection.document(feedback.uid).delete();
  }

  // Product list from snapshot
  List<Feedback> _feedbackListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((documentSnapshot) {
      return Feedback.fromFireBaseSnapshot(documentSnapshot.data);
    }).toList();
  }

  // get products stream
  Stream<List<Feedback>> get productsStream {
    return feedbackCollection.snapshots().map(_feedbackListFromSnapshot);
  }


}