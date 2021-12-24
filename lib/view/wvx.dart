import 'dart:developer';

import 'package:get/get.dart';
import 'package:webviewx/webviewx.dart';
import 'package:weview/utils/export.util.dart';
import 'package:weview/utils/webviewx_initial_content.dart';
import 'package:weview/view/barcode_scanner.dart';

class MyWebView extends StatelessWidget {
  MyWebView({Key? key}) : super(key: key);

  final AppController _ctrl = Get.put<AppController>(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: WebViewX(
                initialContent: webviewxInitialContent,
                initialSourceType: SourceType.html,
                onWebViewCreated: (controller) async {
                  _ctrl.webviewController = controller;
                  // await _ctrl.getInfoWebViewX(_ctrl.webviewController);
                },
                onPageFinished: (value) async {
                  await _ctrl.getInfoWebViewX(_ctrl.webviewController);
                  // webviewController
                  //     .evalRawJavascript(
                  //   'window.onPageFinishedFromFlutter("hello webviewx")',
                  //   inGlobalContext: false,
                  // )
                  //     .then((value) {
                  //   if (value.toString() == '1') {
                  //     webviewController.evalRawJavascript(
                  //       'window.responseForFlutterRequest("192.168.0.1")',
                  //       inGlobalContext: false,
                  //     );
                  //   }

                  //   log('second: '  + value.toString());
                  // }).then((value) => log(value.toString()));
                  // await _ctrl.getInfoWebViewX(webviewController);
                },
                height: 250,
                width: double.infinity,
              ),
            ),
            ElevatedButton(
              child: const Text("Scan"),
              onPressed: () {
                Get.to(() => BarcodeScanner(appController: _ctrl, iawvctrl: _ctrl.webviewController));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Get IP"),
                  onPressed: () async {
                    await _ctrl.sendIP();
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    child: const Text("Get Location"),
                    onPressed: () async {
                      log('message');
                      await _ctrl.sendLocation();
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Get Connection"),
                  onPressed: () async {
                    _ctrl.sendConnection();
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  child: const Text("Get UID"),
                  onPressed: () async {
                    _ctrl.sendUID();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
