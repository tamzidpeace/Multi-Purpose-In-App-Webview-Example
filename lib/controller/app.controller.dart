import 'dart:io';
import 'dart:developer';
import 'package:weview/utils/export.util.dart';

class AppController extends GetxController {
  Map deviceInfo = {};
  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final RxString barcodeResult = RxString('initialResult');
  late WebViewXController webviewController;

  Future<void> setIPandUI() async {
    String ip = await getIP();
    webviewController
        .evalRawJavascript(
      'window.setIP("$ip")',
      inGlobalContext: false,
    )
        .then((value) {
      log('final response: ' + value.toString());
    });

    Map deviceInfo = await getDeviceInfo();
    String uid = '';
    if (Platform.isAndroid) {
      uid = deviceInfo['androidId'].toString();
      log('identifier: ' + deviceInfo['androidId'].toString());
    } else {
      uid = deviceInfo['identifierForVendor'].toString();
      log('identifier: ' + deviceInfo['identifierForVendor'].toString());
    }

    webviewController
        .evalRawJavascript(
      'window.setUI("$uid")',
      inGlobalContext: false,
    )
        .then((value) {
      log('final response: ' + value.toString());
    });
  }

  Future<String> onQRViewCreated(QRViewController controller) async {
    var res = '1';
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      res = scanData.code.toString();
    });
    log(res);
    controller.pauseCamera();
    return res;
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<String> getIP() async {
    String _ip = '';
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        _ip = '${addr.address} ${addr.host}';
      }
    }
    return _ip;
  }

  Future<Map> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap();
    return map;
  }

  Set<DartCallback> appDartCallBacks = {
    DartCallback(
      name: ksScanCallBack,
      callBack: (msg) {
        log('scan');
        Get.to(
          () => BarcodeScanner(
            appController: Get.put<AppController>(AppController()),
            iawvctrl: Get.put<AppController>(AppController()).webviewController,
          ),
        );
      },
    ),
    DartCallback(
      name: ksTakeImageCallBack,
      callBack: (msg) {
        log('take image');
      },
    ),
  };
}
