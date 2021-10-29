import 'package:url_launcher/url_launcher.dart';

class NavigationService {
  static void navigateToMarker(double lat, double long) async {
    String googleUrl = "google.navigation:q=$lat,$long&mode=d";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not launch $googleUrl';
    }
  }
}
