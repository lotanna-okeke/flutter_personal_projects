import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:referral_app/enums/state.dart';

class RefProvider extends ChangeNotifier {
  ViewState state = ViewState.Idle;
  String message = "";

  CollectionReference profileRef =
      FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;

  setReferral(String refCode) async {
    state = ViewState.Busy;
    notifyListeners();

    try {
      final value = await profileRef.where("refCode", isEqualTo: refCode).get();

      if (value.docs.isEmpty) {
        ///refcode doesn't exist
        message = "RefCode isn't available";
        state = ViewState.Error;
        notifyListeners();
      } else {
        ///It extist
        final data = value.docs[0];

        ///Get list of users that have used refCode referrals
        List referrals = data.get("referrals");
        //Add the refCode of the current user to the list of people tht have used that ref code
        referrals.add(auth.currentUser!.email);

        ///Update the earning
        final body = {
          "referrals": referrals,
          "refEarning": data.get("refEarning") + 500
        };

        await profileRef.doc(data.id).update(body);
        message = "Ref Success";
        state = ViewState.Success;
        notifyListeners();
      }
    } on FirebaseException catch (e) {
      // print('error $e');
      message = e.message.toString();
      state = ViewState.Error;
      notifyListeners();
    } catch(e){
      message = e.toString();
      state = ViewState.Error;
      notifyListeners();
    }
  }
}
