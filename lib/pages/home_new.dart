import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sweety_cho/pages/home.dart';

class HomeNewPage extends StatefulWidget {
  final HomePage inAppBrowser = HomePage();
  HomeNewPage({Key? key}) : super(key: key);

  @override
  _HomeNewPageState createState() => _HomeNewPageState();
}

class _HomeNewPageState extends State<HomeNewPage> {
  String _url = "https://sweetychocosmetics.com/";

  var options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(
        //hidden: true,
        hideToolbarTop: true,
        toolbarTopBackgroundColor: Colors.white,
        //hideProgressBar: true,
      ),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          useOnLoadResource: true,
          javaScriptEnabled: true,
          cacheEnabled: true,
          transparentBackground: true,
          //disableContextMenu: true,
        ),
      ));

  @override
  void initState() {
    super.initState();

    widget.inAppBrowser.openUrlRequest(
        urlRequest: URLRequest(url: Uri.parse(_url)), options: options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   brightness: Brightness.light,
      //   backgroundColor: Colors.white,
      // ),
      body: Center(),
    );
  }
}
