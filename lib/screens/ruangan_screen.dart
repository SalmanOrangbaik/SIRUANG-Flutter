import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siruangflutter/models/ruang_model.dart';
import 'package:siruangflutter/screens/ruang_detail_screen.dart';
import '../controller/ruang_controller.dart';

class RuangScreen extends StatefulWidget {
  const RuangScreen({super.key});

  @override
  State<RuangScreen> createState() => _RuangScreenState();
}

class _RuangScreenState extends State<RuangScreen> {
  final RuangController ruangC = Get.put(RuangController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        final controller = ruangC;

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return _buildErrorWidget(controller);
        }

        if (controller.ruangList.isEmpty) {
          return _buildEmptyWidget(controller);
        }

        // 🔥 SORT DATA BERDASARKAN ABJAD
        final sortedList = List<Ruangan>.from(controller.ruangList)
          ..sort(
            (a, b) => (a.nama ?? '').compareTo(b.nama ?? ''),
          );

        return RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedList.length,
            itemBuilder: (context, index) {
              final ruang = sortedList[index];
              return _buildRoomCard(ruang);
            },
          ),
        );
      }),
    );
  }

  // ===================== WIDGET ERROR =====================
  Widget _buildErrorWidget(RuangController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat data',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.refreshData(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  // ===================== WIDGET KOSONG =====================
  Widget _buildEmptyWidget(RuangController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada data ruangan',
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshData(),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  // ===================== CARD RUANG =====================
  Widget _buildRoomCard(Ruangan ruang) {
    final String nama = ruang.nama ?? 'Nama tidak tersedia';
    final int kapasitas = ruang.kapasitas ?? 0;
    final List<String> fasilitas = ruang.fasilitas ?? [];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(_getRoomIcon(nama), color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    nama,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Kapasitas
            Row(
              children: [
                Icon(Icons.people_outline, size: 16, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Kapasitas: $kapasitas orang',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Fasilitas
            Text('Fasilitas:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            fasilitas.isNotEmpty
                ? Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: fasilitas
                        .map(
                          (f) => Chip(
                            label: Text(f,
                                style: GoogleFonts.poppins(fontSize: 12)),
                          ),
                        )
                        .toList(),
                  )
                : Text(
                    'Tidak ada fasilitas',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => RuangDetailScreen(ruang: ruang));
                },
                child: const Text('Unit Detail'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== ICON =====================
  IconData _getRoomIcon(String namaRuangan) {
    final name = namaRuangan.toLowerCase();
    if (name.contains('lab')) return Icons.computer;
    if (name.contains('musik')) return Icons.music_note;
    if (name.contains('aula')) return Icons.people;
    return Icons.meeting_room;
  }
}
