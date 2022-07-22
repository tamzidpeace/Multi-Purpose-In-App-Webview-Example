import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:weview/controller/take_image_controller.dart';
import 'package:weview/utils/export.util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weview/view/take_image.dart';

class AppController extends GetxController {
  late WebViewXController webviewController;
  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final RxString barcodeResult = RxString('initialResult');
  Map deviceInfo = {};

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
      callBack: (msg) async {
        Get.to(() => TakeImage());
        log('take image');
      },
    ),
  };

  Future<void> takeImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? _image = await _picker.pickImage(source: ImageSource.camera);
      if (_image != null) {
        final List<int> imageBytes = await _image.readAsBytes();
        final String base64Image = base64Encode(imageBytes);
        final String image = 'data:image/png;base64,' + base64Image;
        // log('image: ' + image);
        Get.back();
        Get.back();
        webviewController
            .evalRawJavascript(
          'window.setImage("$image")',
          inGlobalContext: false,
        )
            .then((value) {
          log('final response: ' + value.toString());
        });
        Get.delete<TakeImageController>();
      } else {
        log('image not selected');
        return;
      }
    } on PlatformException catch (e) {
      log("Failed to Pick Image $e");
    }
  }
  
  Future<void> prcessQrCodeScan() async {
    
  }
  
  //* end
}
