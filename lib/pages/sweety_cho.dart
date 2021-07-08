import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sweety_cho/flutkart.dart';

class SweetyChoPage extends StatefulWidget {
  SweetyChoPage({Key? key}) : super(key: key);

  @override
  _WebExampleTState createState() => _WebExampleTState();
}

class _WebExampleTState extends State<SweetyChoPage> {
  InAppWebViewController? _webViewController;
  double progress = 0;
  String url = '';

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        useOnDownloadStart: true,
      ),
      android: AndroidInAppWebViewOptions(
        initialScale: 100,
        useShouldInterceptRequest: true,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isloading = true;
    });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.blue),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _webViewController?.goBack();

        print("WebviewController>>$_webViewController");

        return Future.value(false);
      },
      child: Scaffold(
        //appBar: AppBar(
        // title: Text("Tect With Sam"),
        // centerTitle: true,
        // elevation: 0,
        // actions: [
        //   IconButton(
        //     onPressed: () => _webViewController?.reload(),
        //     icon: Icon(Icons.refresh),
        //   ),
        // ],
        //),
        body: //progress == 100
            Stack(
          children: [
            // progress < 1.0
            //     ? LinearProgressIndicator(
            //         value: progress,
            //         backgroundColor: Colors.white,
            //         valueColor: AlwaysStoppedAnimation<Color>(Colors.green[800]!),
            //         // semanticsLabel: "lll",
            //         // semanticsValue: "sdfdsf",
            //       )
            //     : Center(
            //         // child: Text("hello"),
            //         ),
            // Expanded(
            //   child:
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse('https://sweetychocosmetics.com/'),
                headers: {},
              ), // "https://unsplash.com/photos/odxB5oIG_iA"
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onDownloadStart: (controller, url) async {
                // downloading a file in a webview application
                print("onDownloadStart $url");
                await FlutterDownloader.enqueue(
                  url: url.toString(), // url to download
                  savedDir: (await getExternalStorageDirectory())!.path,
                  // the directory to store the download
                  fileName: 'downloads',
                  headers: {},
                  showNotification: true,
                  openFileFromNotification: true,
                );
              },
              onWebViewCreated: (controller) {
                print("web view create");
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                print("onLoadStart");
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              onLoadStop: (controller, url) async {
                print("onLoadStop");
                pullToRefreshController.endRefreshing();
                setState(() {
                  _isloading = false;
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                print("progress:$progress");
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print("consolemsg>>>$consoleMessage");
              },
            ),
            //),
            _isloading
                ? Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: Image.asset(
                                      'assets/sweety_cho.png',
                                      width: 110.0,
                                      height: 110.0,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  Text(
                                    Flutkart.name,
                                    style: TextStyle(
                                        color: Colors.pink[300],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                Text(
                                  Flutkart.wt1,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.pink[300]),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )
                : Stack(),
            // ButtonBar(
            //   buttonAlignedDropdown: true,
            //   buttonPadding: EdgeInsets.all(2),
            //   alignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     ElevatedButton(
            //       child: Icon(Icons.arrow_back),
            //       onPressed: () {
            //         _webViewController?.goBack();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: Icon(Icons.arrow_forward),
            //       onPressed: () {
            //         _webViewController?.goForward();
            //       },
            //     ),
            //     ElevatedButton(
            //       child: Icon(Icons.refresh),
            //       onPressed: () {
            //         _webViewController?.reload();
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
        //   ),
        // ),
        // : Center(
        //     child: CircularProgressIndicator(),
        //   ),
      ),
    );
  }
}
