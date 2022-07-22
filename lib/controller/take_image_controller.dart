import 'package:weview/utils/export.util.dart';

class TakeImageController extends GetxController {
  @override
  void onInit() async{
    await Get.put<AppController>(AppController()).takeImage();
    super.onInit();
  }
}
