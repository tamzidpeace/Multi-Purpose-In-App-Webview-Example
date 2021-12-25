import 'package:flutter/cupertino.dart';
import 'package:weview/controller/take_image_controller.dart';
import 'package:weview/utils/export.util.dart';
export 'package:get/get.dart';

class TakeImage extends StatelessWidget {
  TakeImage({Key? key}) : super(key: key);

  final TakeImageController _ctrl = Get.put<TakeImageController>(TakeImageController());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          radius: 25,
        ),
      ),
    );
  }
}
