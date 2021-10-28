import 'package:url_launcher/url_launcher.dart';

class NavigationService {
  Future<void> navigateTo(double lat, double long) async {
    var uri = Uri.parse("google.navigation:q=$lat,$long&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
