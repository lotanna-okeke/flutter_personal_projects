// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:v2n_merchants/data.dart';
// import 'package:v2n_merchants/models/merchant.dart';
// import 'package:v2n_merchants/providers/merchant_provier.dart';
// import 'package:v2n_merchants/screens/admin/merchant%20list/merchant_list.dart';
// import 'package:v2n_merchants/screens/admin/new_merchant.dart';
// import 'package:v2n_merchants/widgets/admin_drawer.dart';

// class AdminScreen extends ConsumerStatefulWidget {
//   const AdminScreen({super.key});

//   @override
//   ConsumerState<AdminScreen> createState() => _AdminScreenState();
// }

// class _AdminScreenState extends ConsumerState<AdminScreen> {
//   late Future<void> _merchantsFuture;
//   List<Merchant> merchants = [];
//   var _isLoading = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {
//       _isLoading = true;
//     });
//     // _merchantsFuture =
//     //     ref.read(MerchantHandlerProvider.notifier).loadMerchants();
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _addMerchant() async {
//     final newMerchant = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NewMerchant(),
//       ),
//     );
//     if (newMerchant == null) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _merchantsFuture =
//     //     ref.read(MerchantHandlerProvider.notifier).loadMerchants();
//     merchants = ref.watch(MerchantHandlerProvider);

//     Widget display = const CircularProgressIndicator();

//     Widget content = Center(
//       child: Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 30, bottom: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Card(
//                   child: Expanded(
//                     child: TextField(
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                       ),
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(Icons.search),
//                         prefixIconColor: logoColors[1],
//                         hintText: 'Username',
//                         hintStyle: TextStyle(
//                           color: logoColors[1],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'Search',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: MerchantList(merchants: merchants),
//           ),
//         ],
//       ),
//     );

//     if (!_isLoading) {
//       display = content;
//     }

//     return Scaffold(
//       // backgroundColor: logoColors[2],
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         title: const Text(
//           'VasAdmin',
//         ),
//         backgroundColor: logoColors[1]!.withOpacity(0.9),
//       ),
//       drawer: const AdminDrawer(),
//       body: display,
//       floatingActionButton: FloatingActionButton(
//         elevation: 5,
//         backgroundColor: Colors.white,
//         foregroundColor: logoColors[1],
//         onPressed: _addMerchant,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
