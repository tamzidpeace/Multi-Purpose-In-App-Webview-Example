import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:location/location.dart';
import 'package:weview/utils/export.util.dart';

class AppController {
  double progress = 0;
  late StreamSubscription subscription;
  late bool isConnected;
  late String platformVersion;
  late LocationData locationData;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  Future<void> getInfo(InAppWebViewController controller) async {
    String ip = await getIP();
    await getLocation();
    controller.addJavaScriptHandler(
      handlerName: 'AjaxHandler',
      callback: (args) {
        switch (args[0].toString()) {
          case "ip":
            log('IP Address: ' + ip);
            return {'getData': ip};

          case "mac":
            log('MAC Address: ' 'Mac Address: 00:0a:95:9d:68:16');
            return {'getData': 'Mac Address: 00:0a:95:9d:68:16'};

          case "location":
            // log('Location: ' 'Location: ${getLocation()}');
            return {'getData': 'Location: ${getLocation()}'};

          case "connection":
            log('Connection: ' + isConnected.toString());
            return {'getData': isConnected.toString()};
        }
      },
    );
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
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      isConnected = true;
    } else {
      isConnected = false;
    }
  }

  Future<dynamic> getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    log('location: $locationData');
    // return locationData.toString();
  }
}
