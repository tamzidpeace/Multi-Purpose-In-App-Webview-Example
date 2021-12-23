import 'dart:developer';

import 'dart:io';

import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:weview/utils/export.util.dart';
import 'package:weview/view/barcode_scanner.dart';

class Webview extends StatelessWidget {
  Webview({Key? key}) : super(key: key);
  final AppController _ctrl = Get.put<AppController>(AppController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //* info:: progress bar
        _ctrl.progress < 1.0 ? LinearProgressIndicator(value: _ctrl.progress) : Container(),

        //* info:: webview
        Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.6,
          child: InAppWebView(
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
        ),

        const Divider(height: 2, color: Colors.grey),
        ElevatedButton(
            onPressed: () {
              // _ctrl.qrViewController?.resumeCamera();
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('AlertDialog Title'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: QRView(
                              key: _ctrl.qrKey,
                              onQRViewCreated: _ctrl.onQRViewCreated,
                              overlay: QrScannerOverlayShape(
                                borderColor: Colors.blue,
                                borderRadius: 10,
                                borderLength: 40,
                                borderWidth: 5,
                                cutOutSize: (MediaQuery.of(context).size.height * 0.22),
                              ),
                              onPermissionSet: (ctrl, p) => _ctrl.onPermissionSet(context, ctrl, p),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Approve'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('data')),
        //* info:: camera
        // Expanded(
        //   child: Container(
        //     padding: const EdgeInsets.all(8),
        //     width: MediaQuery.of(context).size.width,
        //     child: QRView(
        //       key: _ctrl.qrKey,
        //       onQRViewCreated: _ctrl.onQRViewCreated,
        //       overlay: QrScannerOverlayShape(
        //         borderColor: Colors.blue,
        //         borderRadius: 10,
        //         borderLength: 40,
        //         borderWidth: 5,
        //         cutOutSize: (MediaQuery.of(context).size.height * 0.22),
        //       ),
        //       onPermissionSet: (ctrl, p) => _ctrl.onPermissionSet(context, ctrl, p),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
