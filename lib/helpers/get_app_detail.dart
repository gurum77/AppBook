import 'package:cloud_firestore/cloud_firestore.dart';

// package의 comment를 모두 가져온다.
Future<List<String>> getAppComments(String packageName) {
  var collection = Firestore.instance.collection('app_detail');
  var doc = collection.document(packageName);
  return doc.get().then((DocumentSnapshot ds) {
    var comments = List<String>();
    if (ds.data != null && ds.data['comments'] != null) {
      for (var comment in ds.data['comments']) {
        comments.add(comment.toString());
      }
    }

    return comments;
  });
}

// package의 comment의 개수를 리턴
Future<int> getAppCommentCount(String packageName) async {
  var comments = await getAppComments(packageName);
  return comments.length;
}
