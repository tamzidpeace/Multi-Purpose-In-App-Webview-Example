import 'package:weview/utils/export.util.dart';

class ManGoInAppWebView extends StatelessWidget {
  const ManGoInAppWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Webview(),
      ),
    );
  }
}
