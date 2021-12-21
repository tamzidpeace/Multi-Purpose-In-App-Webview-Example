// import 'package:weview/utils/export.util.dart';

// class BackNextReloadBtn extends StatelessWidget {
//   const BackNextReloadBtn({
//     Key? key,
//     required AppController ctrl,
//   })  : _ctrl = ctrl,
//         super(key: key);

//   final AppController _ctrl;

//   @override
//   Widget build(BuildContext context) {
//     return ButtonBar(
//       alignment: MainAxisAlignment.center,
//       children: [
//         ElevatedButton(
//           child: const Icon(Icons.arrow_back),
//           onPressed: () {
//             _ctrl.webViewController?.goBack();
//           },
//         ),
//         ElevatedButton(
//           child: const Icon(Icons.arrow_forward),
//           onPressed: () {
//             _ctrl.webViewController?.goForward();
//           },
//         ),
//         ElevatedButton(
//           child: const Icon(Icons.refresh),
//           onPressed: () {
//             _ctrl.webViewController?.reload();
//           },
//         ),
//       ],
//     );
//   }
// }
