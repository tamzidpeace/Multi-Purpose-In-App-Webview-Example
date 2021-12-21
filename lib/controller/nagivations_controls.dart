// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class NavigationControls extends StatelessWidget {
//   final Future<WebViewController> _controllerFuture;

//   const NavigationControls(this._controllerFuture, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: _controllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> controller){
//         if(controller.hasData ){
//           return Row(
//             children: <Widget>[
//               _buildBackBtn(controller, context),
//               _buildRefreshBtn(controller),
//               _buildNextBtn(controller, context),
//             ],
//           );
//         }
//         return Container();
//       },
//     );
//   }

//   FlatButton  _buildBackBtn(AsyncSnapshot<WebViewController> controller, BuildContext context) {
//     return FlatButton(
//               textColor: Colors.white,
//                 child: Row(
//                   children: const <Widget>[
//                   Icon(Icons.arrow_left),
//                     Text('back'),
//               ],
//             ),
//               onPressed: () async{
//                 if(await controller.data!.canGoBack()){
//                   controller.data!.goBack();
//                   print('can go back');
//                 }else{
//                   print("can't go back");
//                   Scaffold.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           "can't go back",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       )
//                   );
//                 }
//               },
//             );
//   }

//   FlatButton _buildNextBtn(AsyncSnapshot<WebViewController> controller, BuildContext context) {
//     return FlatButton(
//               textColor: Colors.white,
//               child: Row(
//                 children: const <Widget>[
//                   Text('next'),
//                   Icon(Icons.arrow_right),
//                 ],
//               ),
//               onPressed: () async{
//                 if(await controller.data!.canGoForward()){
//                   controller.data?.goForward();
//                 }else{
//                   Scaffold.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           "can't go Next",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       )
//                   );
//                 }
//               },
//             );
//   }

//   IconButton _buildRefreshBtn(AsyncSnapshot<WebViewController> controller) {
//     return IconButton(
//               icon: Icon(Icons.refresh),
//               onPressed: (){
//                 controller.data?.reload();
//               },
//             );
//   }
// }
