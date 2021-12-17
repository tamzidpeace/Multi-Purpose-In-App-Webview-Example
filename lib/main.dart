import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
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
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text("Official InAppWebView website")),
          body: SafeArea(
              child: Column(children: <Widget>[
            TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
              controller: urlController,
              keyboardType: TextInputType.url,
              onSubmitted: (value) {
                var url = Uri.parse(value);
                if (url.scheme.isEmpty) {
                  url = Uri.parse("https://www.google.com/search?q=" + value);
                }
                webViewController?.loadUrl(urlRequest: URLRequest(url: url));
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: Uri.parse("https://inappwebview.dev/")),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest: (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources, action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

                      if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                        if (await canLaunch(url)) {
                          // Launch the App
                          await launch(
                            url,
                          );
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });

                      //js test
                      await controller.injectJavascriptFileFromUrl(
                          urlFile: Uri.parse('https://code.jquery.com/jquery-3.3.1.min.js'),
                          scriptHtmlTagAttributes: ScriptHtmlTagAttributes(
                              id: 'jquery',
                              onLoad: () {
                                log("jQuery loaded and ready to be used!");
                              },
                              onError: () {
                                log("jQuery not available! Some error occurred.");
                              }));
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                  progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Icon(Icons.arrow_back),
                  onPressed: () {
                    webViewController?.goBack();
                  },
                ),
                ElevatedButton(
                  child: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    webViewController?.goForward();
                  },
                ),
                ElevatedButton(
                  child: const Icon(Icons.refresh),
                  onPressed: () {
                    webViewController?.reload();
                  },
                ),
              ],
            ),
          ]))),
    );
  }
}


//https://virtualq.ca/apis/v1.1/payment?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDAwZWU1MTA0YzQzZWJlNDQ1ZmQzMDg0ZThhMzUzYzg0MzQxZmY4OGJkM2E5ZTFhODY5YmQ3ZTdmYjA1YWU2Y2VlODVjODRmOGFkYjUxMWIiLCJpYXQiOjE2Mzg0MjQ3NDAsIm5iZiI6MTYzODQyNDc0MCwiZXhwIjoxNjY5OTYwNzQwLCJzdWIiOiI1OCIsInNjb3BlcyI6W119.lN_hWMnc446abWVTYEA3EvCMWcmr31uS4jzhS6PkpL56PlYUf8XYjDInHnOJBDBsHee-lLr-8bH5RmLkFAInmzAXZ5M7X-2O7AIUnPdMFvMbzNFFWZWqTUCRe_QCQJmRSwLR5nxNHp8r26THKHwa_2XpbHaMpBH5vhbfyvjOUrql_TWEo5Mw5Mr5Ef0N9eKUYA5JE0ZCfVKEBnhZrntY3eSoInfGj79CNiPQOZNO7-pT4MGgPC0ANeQEhTV2EfAdRKyCflrLt9T038rHrpXZzaXMBIfZbz06abjaYf1vNMw7Mcig1Txj0MmlUMeAJ-Hlj90gjZwca6QiMkUBM-_fpLlyQ71bj6H98XsoIu0vR4dEI76-RkwGcvkO9OR85WgtlJSW7TJaAEOKRzh1PSz-DWb8u8Dtdpp_0fbo1wnkgm5Tul59M8SUeyNEHf4MLSMA6DZa3gbufujQhJYzTrX6V_GA8iWTBUW9R3h9h5ps9-VrQYA6tZ_hUSpBsgQla1IFWOxPxx0hVeb6AByi4Z3w2f2GUJSRfFJ5BplOYORAUwsuU76C9_yrE6q19Wvl5yRn7MXlPRiwoZcc8ZfPTzs7157DU8akzFUFG8SALnVlHC0bB2DGggdy9BIqG1xpOx2WJdZa7NwL5BPIWCje3sGvt77qg1lFOMCgiDXV64qnS5Q