import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference getAppDetailCollection() {
  return Firestore.instance.collection('app_detail');
}

CollectionReference getUserDetailCollection() {
  return Firestore.instance.collection('user_detail');
}

CollectionReference getConfigCollection() {
  return Firestore.instance.collection('config');
}

// app_detail - [packageName]
DocumentReference getAppDetailDocumentByPackageName(String packageName) {
  return getAppDetailCollection().document(packageName);
}

// user_detail - [email]
DocumentReference getUserDetailDocumentByEmail(String email) {
  return getUserDetailCollection().document(email);
}

// config - exp
DocumentReference getExpDocumentInConfig() {
  return getConfigCollection().document('exp');
}
