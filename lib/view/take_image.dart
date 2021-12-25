import 'package:weview/utils/export.util.dart';

class TakeImage extends StatelessWidget {
  const TakeImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await Get.put<AppController>(AppController()).takeImage();
            },
            child: Text('data')),
      ),
    );
  }
}
