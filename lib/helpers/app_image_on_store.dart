import 'package:http/http.dart' as http;

// play store에 있는 app icon 이미지 url 을 가져옴
Future<String> getIconImageUrl() async {
  var url = 'https://play.google.com/store/apps/details?id=mobile.Byung.Cargo';
  var re = http.read(url);

  re.then((value) {
    var regex = RegExp(r'[\"]https://lh3.googleusercontent.com.*?[\"]');
    var match = regex.firstMatch(value);
    if (match != null) {
      String str = value.substring(match.start, match.end);
      return str;
    } else {
      return 'https://lh3.googleusercontent.com/bklJDdaWKb3pkVJJvwxjNIpMeo2ZnLVzh5I9FMhsNx7P2B-eKgzPXgyRY9XM6kw0ouU=s180-rw';
    }
  });

  return null;
}
