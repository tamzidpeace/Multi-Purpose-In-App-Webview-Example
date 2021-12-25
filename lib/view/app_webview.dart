import 'package:weview/utils/export.util.dart';

class AppWebView extends StatelessWidget {
  AppWebView({Key? key}) : super(key: key);

  final AppController _ctrl = Get.put<AppController>(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewX(
          key: const ValueKey(ksWebViewKey),
          javascriptMode: JavascriptMode.unrestricted,
          initialContent: ksURL,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          onWebViewCreated: (controller) async {
            _ctrl.webviewController = controller;
          },
          onPageFinished: (value) async {
            await _ctrl.setIPandUI();
          },
          dartCallBacks: _ctrl.appDartCallBacks,
        ),
      ),
    );
  }
}
