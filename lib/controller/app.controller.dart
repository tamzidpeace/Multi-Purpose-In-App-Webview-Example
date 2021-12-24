import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:location/location.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:webviewx/webviewx.dart';
import 'package:weview/utils/export.util.dart';

class AppController extends GetxController {
  double progress = 0;
  late StreamSubscription subscription;
  late bool isConnected;
  late String platformVersion;
  late LocationData locationData;
  Map deviceInfo = {};
  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final RxString barcodeResult = RxString('initialResult');
  late WebViewXController webviewController;

  @override
  onInit() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        // log(result.toString());
        isConnectedToInternet(result);
      },
    );

    super.onInit();
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  Future<void> getInfo(InAppWebViewController controller) async {
    controller.addJavaScriptHandler(
      handlerName: 'AjaxHandler',
      callback: (args) async {
        // log('arags: ' + args.toString());
        //* args = [ip, location, connection, mac]
        String _args = args[2].toString();

        //! important:: unable to call async function in switch-case. so I have used if else

        if (_args == 'ip') {
          String ip = await getIP();
          log('IP Address: ' + ip);
          return {'getData': ip};
        } else if (_args == 'location') {
          try {
            var res = await getLocation();
            log('location: ' + res.toString());
            return {'getData': 'Location: ${res.toString()}'};
          } catch (e) {
            log(e.toString());
          }
        } else if (_args == 'connection') {
          log('Connection: ' + isConnected.toString());
          return {'getData': isConnected.toString()};
        } else if (_args == 'mac') {
          Map deviceInfo = await getDeviceInfo();
          log(deviceInfo.toString());
          //todo:: Please fetch your required info

          log('MAC Address: ' 'Mac Address: 00:0a:95:9d:68:16');
          return {'getData': 'Mac Address: 00:0a:95:9d:68:16'};
        } else if (_args == 'bcs') {
          // var res = await scanQrCode();
          // log('barcode: barcode');
          // return {'barcode': res};
        }
      },
    );
  }

  Future<void> getInfoWebViewX(
    WebViewXController controller,
  ) async {
    String _type = 'ip';
    controller
        .evalRawJavascript(
      'window.onPageFinishedFromFlutter("$_type")',
      inGlobalContext: false,
    )
        .then((value) async {
      value = value.toString();
      value = value.substring(1, value.length - 1);

      log('type: ' + value);
      if (value == 'ip') {
        String ip = await getIP();
        log('IP Address: ' + ip);
        _sendResponse(controller, ip);
      } else if (value == 'location') {
        try {
          var res = await getLocation();
          log('location: ' + res.toString());
          _sendResponse(controller, res.toString());
        } catch (e) {
          log(e.toString());
        }
      } else if (value == 'connection') {
        log('Connection: ' + isConnected.toString());
        _sendResponse(controller, isConnected.toString());
      } else if (value == 'mac') {
        String uid = '';
        if (Platform.isAndroid) {
          uid = deviceInfo['androidId'].toString();
          log('identifier: ' + deviceInfo['androidId'].toString());
        } else {
          uid = deviceInfo['identifierForVendor'].toString();
          log('identifier: ' + deviceInfo['identifierForVendor'].toString());
        }

        _sendResponse(webviewController, uid);
        log('MAC Address: ' 'uid: $uid');
      } else {
        log('false');
      }
    });
  }

  Future<void> sendIP() async {
    String ip = await getIP();
    log('IP Address: ' + ip);
    _sendResponse(webviewController, ip);
  }

  Future<void> sendLocation() async {
    try {
      var res = await getLocation();
      log('location: ' + res.toString());
      _sendResponse(webviewController, res.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendConnection() async {
    log('Connection: ' + isConnected.toString());
    _sendResponse(webviewController, isConnected.toString());
  }

  Future<void> sendUID() async {
    Map deviceInfo = await getDeviceInfo();
    String uid = '';
    if (Platform.isAndroid) {
      uid = deviceInfo['androidId'].toString();
      log('identifier: ' + deviceInfo['androidId'].toString());
    } else {
      uid = deviceInfo['identifierForVendor'].toString();
      log('identifier: ' + deviceInfo['identifierForVendor'].toString());
    }

    _sendResponse(webviewController, uid);
    log('MAC Address: ' 'uid: $uid');
  }

  void _sendResponse(controller, data) {
    controller
        .evalRawJavascript(
      'window.responseForFlutterRequest("$data")',
      inGlobalContext: false,
    )
        .then((value) {
      log('final response: ' + value.toString());
    });
  }

  Future<void> sendCodeData(controller, String data) async {
    log('here');
    controller.addJavaScriptHandler(
      handlerName: 'handlerFoo',
      callback: (args) async {
        log('sendcode data');
        return data;
      },
    );
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
        SnackBar(content: Text('no Permission')),
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

  Future<void> isConnectedToInternet(result) async {
    if (result.toString() == 'ConnectivityResult.mobile' || result.toString() == 'ConnectivityResult.wifi') {
      isConnected = true;
    } else {
      isConnected = false;
    }
    // log(isConnected.toString());
  }

  Future<dynamic> getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        log('location service not enabled');
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        log('location permission denied');
        return;
      }
    }

    try {
      locationData = await location.getLocation();
    } catch (e) {
      log(e.toString());
    }

    return {'latitude': locationData.latitude, 'longitude': locationData.longitude};
    // locationData.toString();
  }

  Future<Map> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap();
    return map;
  }
}
