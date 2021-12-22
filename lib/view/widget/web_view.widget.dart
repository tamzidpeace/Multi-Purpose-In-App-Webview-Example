import 'dart:developer';

import 'package:get/get.dart';
import 'package:weview/utils/export.util.dart';
import 'package:weview/view/barcode_scanner.dart';



class Webview extends StatelessWidget {
   Webview({Key? key}) : super(key: key);
  final AppController _ctrl = Get.put<AppController>(AppController()) ;

  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //* info:: webview
        InAppWebView(
          initialData: InAppWebViewInitialData(data: initailData),
          initialUrlRequest: URLRequest(url: Uri.parse(ksIntialUrl)),
          initialOptions: _ctrl.options,
          onWebViewCreated: (InAppWebViewController controller) async {
            await _ctrl.getInfo(controller);
          },
          onConsoleMessage: (controller, consoleMessage) {
            log('console Message: ' + consoleMessage.toString());
            if (consoleMessage.message.toString() == 'bcs') {
              ///* info:: bcs = bar code scan
              log('scan now');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BarcodeScanner()),
              );
            }
          },
        ),
        _ctrl.progress < 1.0 ? LinearProgressIndicator(value: _ctrl.progress) : Container(),
      ],
    );
  }
}
