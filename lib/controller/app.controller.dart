import 'dart:io';

import 'package:weview/utils/export.util.dart';

class AppController {
  final GlobalKey webViewKey = GlobalKey();
  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  InAppWebViewController? webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      clearCache: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      clearSessionCache: true,
      cacheMode: AndroidCacheMode.LOAD_NO_CACHE,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  void pullToRefresh() {
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

  appOnWebViewCreated(controller) {
    webViewController = controller;
    controller.addJavaScriptHandler(
        handlerName: 'AndroidFunctions',
        callback: (args) {
          // print arguments coming from the JavaScript side!
          // print(args);
          if (args.toString() == "[CommonData]") {
            // return data to the JavaScript side!
            return {'MacAddress': '1597283465475_mKVFI3ShJd', 'IP': '192.168.7.164'};
          }
        });

    controller.addJavaScriptHandler(
        handlerName: 'AjaxHandler',
        callback: (args) {
          // print arguments coming from the JavaScript side!
          // log(args.toString());

          switch (args.toString()) {
            case "[AjaxSettingInfo]":
              return {'getData': 'AjaxIntervalTime:500,AjaxRetry:20'};

            case "[isConnectErrorMessage]":
              return {'getData': 'false'};

            case "[getIniUseVpn]":
              return {'getData': '0'};
          }
        });
  }
}
