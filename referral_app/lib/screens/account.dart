import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/message.dart';
import 'authentication/login.dart';
import 'home_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Row(
          children: [
            //babk home
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const HomePage()),
                      (route) => false);
                },
                icon: const Icon(Icons.arrow_back)),
            const Padding(padding: EdgeInsets.only(left: 90)),
            Text(
              "Wallet",
              // textAlign: TextAlign.end,
            )
          ],
        )),
        actions: [
          //exit icom
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                });
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: profileRef
              .where("refCode", isEqualTo: auth.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data!.docs[0];
            final earnings = data.get("refEarning");
            final userEmail = data.get("email");
            List referralsList = data.get("referrals");

            final refCode = data.get("refCode");

            return Container(
              padding: const EdgeInsets.all(10),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          "Your Referral Earnings: $earnings",
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(onPressed: (){
                          
                        }, icon: Icon(Icons.shopping_cart_checkout))
                      ],
                    ),
                    // child: Column(
                    //   children: [
                    //     Card(
                    //       child: ListTile(
                    //         title: Text("Earnings of $userEmail"),
                    //         subtitle: Text("NGN $earnings"),
                    //       ),
                    //     ),
                    //     const Divider(
                    //       thickness: 3,
                    //     ),
                    //     Card(
                    //       child: ListTile(
                    //         title: const Text("Referral Code"),
                    //         subtitle: Text(refCode),
                    //         trailing: IconButton(
                    //             onPressed: () {
                    //               ClipboardData data =
                    //                   ClipboardData(text: refCode);

                    //               Clipboard.setData(data);

                    //               showMessage(context, "Ref code copied");
                    //             },
                    //             icon: const Icon(Icons.copy)),
                    //       ),
                    //     ),
                    //     const Divider(
                    //       thickness: 3,
                    //     ),
                    //     Card(
                    //         child: Column(
                    //       children: [
                    //         const Padding(
                    //           padding: EdgeInsets.all(20),
                    //           child: Text(
                    //             "Share this referral code with friends and earn NGN500 reward!",
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //         Container(
                    //           child: TextButton(
                    //             onPressed: () {
                    //               String shareLink =
                    //                   "Welcome to the new best bank app that gives NGN500 for referrals\nUse your friends refferral code and help him earn NGN500\n$refCode";

                    //               Share.share(shareLink);
                    //             },
                    //             child: const Text("Share Link"),
                    //           ),
                    //         )
                    //       ],
                    //     )),
                    //     const Divider(
                    //       thickness: 3,
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           const Text("Referral"),
                    //           Text("${referralsList.length}")
                    //         ],
                    //       ),
                    //     ),
                    //     if (referralsList.isEmpty)
                    //       Text(
                    //         'No referrals',
                    //         style: TextStyle(fontSize: 20),
                    //       ),
                    //     ...List.generate(referralsList.length, (index) {
                    //       final data = referralsList[index];
                    //       return Container(
                    //         height: 50,
                    //         margin: const EdgeInsets.only(bottom: 10),
                    //         child: ListTile(
                    //           leading: CircleAvatar(
                    //             child: Text("${index + 1}"),
                    //           ),
                    //           title: Text(data),
                    //         ),
                    //       );
                    //     })
                    //   ],
                    // ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
