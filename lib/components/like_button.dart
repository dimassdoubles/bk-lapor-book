import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/models/laporan.dart';

class LikeButton extends StatefulWidget {
  final Laporan _laporan;
  const LikeButton({super.key, required Laporan laporan}) : _laporan = laporan;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  final String colletionName = "likes";

  bool isLoading = false;

  bool liked = false;
  late String userId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void checkIfUserLiked() async {
    debugPrint("check status like");
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(colletionName)
          .where('laporanId', isEqualTo: widget._laporan.docId)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // ubah status like user
        debugPrint("laporan sudah kamu like");
        setState(() {
          liked = true;
        });
      }
    } catch (e) {
      print(e);
    }
    // mendapatkan daftar like

    // cari like yang userId dan loperanId nya sesuai
    // jika ditemukan like yang sesuai ubah liked => true
  }

  void like() async {
    setState(() {
      isLoading = true;
    });
    debugPrint(widget._laporan.judul);
    // tambahkan like

    try {
      CollectionReference likesCollection =
          _firestore.collection(colletionName);
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      await likesCollection.doc().set({
        'userId': userId,
        'laporanId': widget._laporan.docId,
        'tanggal': timestamp,
      }).catchError((e) {
        throw e;
      });

      // hilangkan tombol like
      // setState(() {
      //   liked = true;
      // });
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    userId = auth.currentUser!.uid;
    checkIfUserLiked();
  }

  @override
  Widget build(BuildContext context) {
    return liked
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  debugPrint("Like dipanggil");
                  like();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red[200],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    isLoading ? "Loading..." : "Sukai",
                    style: TextStyle(color: Colors.red[200]),
                  ),
                ],
              ),
            ),
          );
  }
}
