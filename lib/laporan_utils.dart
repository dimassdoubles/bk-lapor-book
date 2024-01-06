import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LaporanUtils {
  LaporanUtils._();

  static Future<int> countLike(String laporanId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection("likes")
          .where('laporanId', isEqualTo: laporanId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }
}
