import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TestInAppWebView extends StatefulWidget {
  const TestInAppWebView({Key? key}) : super(key: key);

  @override
  _TestInAppWebViewState createState() => _TestInAppWebViewState();
}

class _TestInAppWebViewState extends State<TestInAppWebView> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text("JavaScript Handlers")),
          body: SafeArea(
              child: Column(children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialData: InAppWebViewInitialData(data: """
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    </head>
    <body>
        <h1>JavaScript Handlers</h1>
        <script>
            window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                window.flutter_inappwebview.callHandler('handlerFoo')
                  .then(function(result) {
                    // print to the console the data coming
                    // from the Flutter side.
                    console.log(JSON.stringify(result));
                    
                    window.flutter_inappwebview
                      .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);
                });
            });
        </script>
    </body>
</html>
                      """),
                initialOptions: options,
                onWebViewCreated: (controller) {
                  controller.addJavaScriptHandler(
                      handlerName: 'handlerFoo',
                      callback: (args) {
                        // return data to the JavaScript side!
                        return {'Mac': 'Atiar mac', 'IP': 'Atiar IP'};
                      });

                  controller.addJavaScriptHandler(
                      handlerName: 'handlerFooWithArgs',
                      callback: (args) {
                        print(args);
                        // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                      });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                  // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                },
              ),
            ),
          ]))),
    );
  }
}
