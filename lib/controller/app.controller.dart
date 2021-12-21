import 'dart:developer';
import 'dart:io';

import 'package:weview/utils/export.util.dart';

class AppController {
  double progress = 0;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  Future<void> getInfo(InAppWebViewController controller) async {
    String ip = await getIP();
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
            log('Location: ' 'Location: Dhaka');
            return {'getData': 'Location: Dhaka'};

          case "connection":
            log('Connection: ' 'is_connected: true');
            return {'getData': 'is_connected: true'};
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
}
