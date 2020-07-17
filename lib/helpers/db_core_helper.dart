import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference getAppDetailCollection() {
  return Firestore.instance.collection('app_detail');
}

CollectionReference getUserDetailCollection() {
  return Firestore.instance.collection('user_detail');
}

DocumentReference getAppDetailDocumentByPackageName(String packageName) {
  return getAppDetailCollection().document(packageName);
}

DocumentReference getUserDetailDocumentByEmail(String email) {
  return getUserDetailCollection().document(email);
}
