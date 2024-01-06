import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/laporan_utils.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:lapor_book/models/laporan.dart';

class ListItem extends StatefulWidget {
  final Laporan laporan;
  final Akun akun;
  final bool isLaporanku;
  const ListItem(
      {super.key,
      required this.laporan,
      required this.akun,
      required this.isLaporanku});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  void deleteLaporan() async {
    try {
      await _firestore.collection('laporan').doc(widget.laporan.docId).delete();

      // menghapus gambar dari storage
      if (widget.laporan.gambar != '') {
        await _storage.refFromURL(widget.laporan.gambar!).delete();
      }
      // ignore: use_build_context_synchronously
      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: {
            'laporan': widget.laporan,
            'akun': widget.akun,
          });
        },
        onLongPress: () {
          if (widget.isLaporanku) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete ${widget.laporan.judul}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteLaporan();
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  );
                });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: widget.laporan.gambar != ''
                  ? Image.network(
                      widget.laporan.gambar!,
                    )
                  : Image.asset(
                      'assets/istock-default.jpg',
                      // height: 130,
                    ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                widget.laporan.judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: warningColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                        ),
                        border: const Border.symmetric(
                            vertical: BorderSide(width: 1))),
                    alignment: Alignment.center,
                    child: Text(
                      widget.laporan.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(5)),
                        border: const Border.symmetric(
                            vertical: BorderSide(width: 1))),
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      initialData: 0,
                      future: LaporanUtils.countLike(widget.laporan.docId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "${snapshot.data} likes",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }

                        return const Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    // child: Text(
                    //   DateFormat('dd/MM/yyyy').format(widget.laporan.tanggal),
                    //   maxLines: 1,
                    //   style: const TextStyle(
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
