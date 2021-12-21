// import 'package:weview/utils/export.util.dart';

// class SearchBar extends StatelessWidget {
//   const SearchBar({
//     Key? key,
//     required AppController ctrl,
//   })  : _ctrl = ctrl,
//         super(key: key);

//   final AppController _ctrl;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
//       controller: _ctrl.urlController,
//       keyboardType: TextInputType.url,
//       onSubmitted: (value) {
//         var url = Uri.parse(value);
//         if (url.scheme.isEmpty) {
//           url = Uri.parse("$ksGoogleUrl?q=" + value);
//         }
//         _ctrl.webViewController?.loadUrl(urlRequest: URLRequest(url: url));
//       },
//     );
//   }
// }
