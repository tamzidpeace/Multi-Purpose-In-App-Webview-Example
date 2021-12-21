import 'package:weview/utils/export.util.dart';


class ManGoInAppWebView extends StatefulWidget {
  const ManGoInAppWebView({Key? key}) : super(key: key);

  @override
  _ManGoInAppWebViewState createState() => _ManGoInAppWebViewState();
}

class _ManGoInAppWebViewState extends State<ManGoInAppWebView> {
  final AppController _ctrl = AppController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              //* info:: search bar
              SearchBar(ctrl: _ctrl),

              //* info:: webview
              const Webview(),

              //* info:: back, next, reload btn
              BackNextReloadBtn(ctrl: _ctrl),
            ],
          ),
        ),
      ),
    );
  }

  //* end
}


