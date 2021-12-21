import 'package:weview/utils/export.util.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  State<Webview> createState() => WebviewState();
}

class WebviewState extends State<Webview> {
  final AppController _ctrl = AppController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //* info:: webview
        InAppWebView(
          initialData: InAppWebViewInitialData(data: initailData),
          initialOptions: _ctrl.options,
          onWebViewCreated: (InAppWebViewController controller) async {
            await _ctrl.getInfo(controller);
          },
          onConsoleMessage: (controller, consoleMessage) {
            // log('console Message: ' + consoleMessage.toString());
          },
        ),
        _ctrl.progress < 1.0 ? LinearProgressIndicator(value: _ctrl.progress) : Container(),
      ],
    );
  }
}
