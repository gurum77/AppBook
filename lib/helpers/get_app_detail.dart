import 'db_helper.dart';

// package의 comment의 개수를 리턴
Future<int> getAppCommentCount(String packageName) async {
  var comments = await getAppComments(packageName);
  return comments.length;
}
