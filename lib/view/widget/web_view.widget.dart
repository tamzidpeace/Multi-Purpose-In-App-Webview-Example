import 'package:weview/utils/export.util.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  State<Webview> createState() => WebviewState();
}

class WebviewState extends State<Webview> {
  final AppController _ctrl = AppController();

  @override
  void initState() {
    super.initState();
    _ctrl.pullToRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          InAppWebView(
            key: _ctrl.webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse(ksIntialUrl)),
            initialOptions: _ctrl.options,
            pullToRefreshController: _ctrl.pullToRefreshController,
            onWebViewCreated: (controller) {
              _ctrl.appOnWebViewCreated(controller);
            },
            onLoadStart: (controller, url) {
              setState(() {
                _ctrl.url = url.toString();
                _ctrl.urlController.text = _ctrl.url;
              });
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
            },
            onLoadStop: (controller, url) async {
              _ctrl.pullToRefreshController.endRefreshing();
              setState(() {
                _ctrl.url = url.toString();
                _ctrl.url;
              });
            },
            onLoadError: (controller, url, code, message) {
              _ctrl.pullToRefreshController.endRefreshing();
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                _ctrl.pullToRefreshController.endRefreshing();
              }
              setState(() {
                _ctrl.progress = progress / 100;
                _ctrl.urlController.text = _ctrl.url;
              });
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              setState(() {
                _ctrl.url = url.toString();
                _ctrl.urlController.text = _ctrl.url;
              });
            },
            onConsoleMessage: (controller, consoleMessage) {
              // print(consoleMessage);
            },
          ),
          _ctrl.progress < 1.0 ? LinearProgressIndicator(value: _ctrl.progress) : Container(),
        ],
      ),
    );
  }
}
