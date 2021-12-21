import 'package:weview/utils/export.util.dart';

class ManGoInAppWebView extends StatelessWidget {
  const ManGoInAppWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Title(
          color: Colors.black,
          child: const Text('App Name'),
        ),
      ),
      body: const SafeArea(
        child: Webview(),
      ),
    );
  }
}
