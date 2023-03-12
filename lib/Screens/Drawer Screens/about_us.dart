import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:uber_rider_app/Screens/page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Global/constants.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaScreen(
      child: Scaffold(
        backgroundColor: getBackgroundColor(context),
        appBar: AppBar(
          backgroundColor: SPLASH_SCREEN_COLOR,
          elevation: 1,
          title: const Text(
            "About Us",
            style: TextStyle(
              fontFamily: FONT_BOLT_BOLD,
              fontSize: 16,
              color: TXT_COLOR_LIGHT,
            ),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: getSize(context).width > 800
                ? getSize(context).width * 0.3
                : getSize(context).width,
            height: getSize(context).height,
            child: FooterView(
              flex: 6,
              footer: Footer(
                backgroundColor: SPLASH_SCREEN_COLOR,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                              height: 45.0,
                              width: 45.0,
                              child: Center(
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25.0), // half of height and width of Image
                                  ),
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    tooltip: "Website",
                                    icon: const Icon(
                                      FontAwesomeIcons.paperclip,
                                      size: 12.0,
                                    ),
                                    onPressed: () {
                                      _launchUrl(
                                          Uri.parse("https://faxwoid.com"));
                                    },
                                  ),
                                ),
                              )),
                          SizedBox(
                              height: 45.0,
                              width: 45.0,
                              child: Center(
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25.0), // half of height and width of Image
                                  ),
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    tooltip: "Email",
                                    icon: const Icon(
                                      FontAwesomeIcons.at,
                                      size: 12.0,
                                    ),
                                    onPressed: () {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: 'info@faxwoid.com',
                                      );
                                      _launchUrl(emailLaunchUri);
                                    },
                                  ),
                                ),
                              )),
                          SizedBox(
                              height: 45.0,
                              width: 45.0,
                              child: Center(
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25.0), // half of height and width of Image
                                  ),
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    tooltip: "Twitter",
                                    icon: const Icon(
                                      FontAwesomeIcons.twitter,
                                      size: 14.0,
                                    ),
                                    onPressed: () {
                                      _launchUrl(Uri.parse(
                                          "https://twitter.com/Faxwoid007?t=NFJ04QZMaeZXgR5fT11-4g&s=08"));
                                    },
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  tooltip: "Instagram",
                                  icon: const Icon(
                                    FontAwesomeIcons.instagram,
                                    size: 16.0,
                                  ),
                                  onPressed: () {
                                    _launchUrl(
                                      Uri.parse(
                                        "https://www.instagram.com/faxwoid/",
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "Copyright © 2022 Uber Clone",
                      style: TextStyle(
                        fontFamily: FONT_BOLT_REGULAR,
                        fontSize: 16,
                        color: TXT_COLOR_LIGHT,
                      ),
                    ),
                    const Text(
                      "Powered by FAXWOID.",
                      style: TextStyle(
                        fontFamily: FONT_BOLT_REGULAR,
                        fontSize: 16,
                        color: TXT_COLOR_LIGHT,
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Column(
                  children: const [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "About FAXWOID",
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: FONT_BOLT_BOLD,
                        color: TXT_COLOR_DARK,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Faxwoid is a Software development company which have a strong team of 7+ developers and 5+ years experience in building mobile apps (Flutter, iOS, Android), WordPress , Wix ,  Shopify, Full Stack Web-Development, Python development, Blockchain Smart Contract Development, API’s development and Integration using latest technologies for clients across the world.",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: FONT_BOLT_REGULAR,
                          color: TXT_COLOR_DARK,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Why Choose FAXWOID?",
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: FONT_BOLT_BOLD,
                        color: TXT_COLOR_DARK,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "The main purpose of Faxwoid is to develop and promote advanced information technologies. We love to fix your complex and complicated problems with unique and innovative solutions. FAXWOID’s business moto is to assure the highest quality product, client satisfaction, timely delivery of solutions and the best quality/price ratio found in the industry",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: FONT_BOLT_REGULAR,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
