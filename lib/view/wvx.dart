import 'dart:developer';

import 'package:get/get.dart';
import 'package:webviewx/webviewx.dart';
import 'package:weview/utils/export.util.dart';
import 'package:weview/view/barcode_scanner.dart';

class MyWebView extends StatelessWidget {
  MyWebView({Key? key}) : super(key: key);

  late WebViewXController webviewController;
  final AppController _ctrl = Get.put<AppController>(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: WebViewX(
                initialContent:
                    """
                    <!DOCTYPE html>
          <html lang="en">
          
          <head>
      
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
      
              <style> </style>
      
          </head>
      
          <body>
      
              
            
      
                <label for="">Scan result</label> 
               <textarea name="" id="text-field" cols="30" rows="10" disabled></textarea>
      
      
              <script>
          function myFunction() {
              // alert("I am an alert box!");
              // console.log('working');
              return 'working';
          }
      
          function fromFlutter(data) {
                // Do something
                console.log(data);
                document.getElementById("text-field").value = data;
                }
          </script>
      
          </body>
      
          </html>>
      
      """,
                initialSourceType: SourceType.html,
                onWebViewCreated: (controller) => webviewController = controller,
                height: 250,
                width: double.infinity,
              ),
            ),
            ElevatedButton(
              child: const Text("Scan"),
              onPressed: () {
                Get.to(() => BarcodeScanner(appController: _ctrl, iawvctrl: webviewController));
              },
            )
          ],
        ),
      ),
    );
  }
}
