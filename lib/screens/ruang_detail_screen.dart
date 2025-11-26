import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siruangflutter/models/ruang_model.dart';
import 'package:get/get.dart';

class RuangDetailScreen extends StatelessWidget {
  final Ruangan ruang;

  const RuangDetailScreen({super.key, required this.ruang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ruang.nama,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Ruang
            Row(
              children: [
                Icon(Icons.meeting_room_rounded,
                    size: 28, color: Colors.blue[700]),
                const SizedBox(width: 10),
                Text(
                  ruang.nama,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Kapasitas
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.people, color: Colors.blue[700]),
                  const SizedBox(width: 10),
                  Text(
                    "Kapasitas: ${ruang.kapasitas} orang",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Daftar Fasilitas",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            if (ruang.fasilitas.isNotEmpty)
              ...ruang.fasilitas.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        f,
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            else
              Text(
                "Tidak ada fasilitas",
                style: GoogleFonts.poppins(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
