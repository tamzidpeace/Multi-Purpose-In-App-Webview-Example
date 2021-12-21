import 'package:weview/utils/export.util.dart';

class Webview extends StatelessWidget {
  Webview({Key? key}) : super(key: key);

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
