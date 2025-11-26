import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siruangflutter/models/ruang_model.dart';
import 'package:siruangflutter/screens/ruang_detail_screen.dart';
import '../controller/ruang_controller.dart';

class RuangScreen extends StatelessWidget {
  const RuangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RuangController ruangC = Get.put(RuangController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        final controller = ruangC;

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return _buildErrorWidget(controller);
        }

        if (controller.ruangList.isEmpty) {
          return _buildEmptyWidget(controller);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.ruangList.length,
            itemBuilder: (context, index) {
              final ruang = controller.ruangList[index];
              return _buildRoomCard(ruang);
            },
          ),
        );
      }),
    );
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Obx(() => Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                  ),
                )),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.refreshData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Coba Lagi',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(RuangController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada data ruangan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Ruangan ruang) {
    // Validasi data dengan null safety yang lebih baik
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
            // Header dengan nama ruangan dan icon
            Row(
              children: [
                Icon(
                  _getRoomIcon(nama),
                  color: Colors.blue[700],
                  size: 24,
                ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Kapasitas: $kapasitas orang',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Fasilitas Label
            Text(
              'Fasilitas:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 8),

            // Fasilitas Chips
            if (fasilitas.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: fasilitas.map((fasilitasItem) {
                  return Chip(
                    label: Text(
                      fasilitasItem,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.blue[50],
                    side: BorderSide.none,
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  );
                }).toList(),
              )
            else
              Text(
                'Tidak ada fasilitas',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),

            const SizedBox(height: 16),

            // Tombol Unit Detail
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman detail ruangan
                  Get.to(() => RuangDetailScreen(ruang: ruang));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Unit Detail',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoomIcon(String namaRuangan) {
    final String lowerName = namaRuangan.toLowerCase();
    if (lowerName.contains('lab')) {
      return Icons.computer_rounded;
    } else if (lowerName.contains('musik')) {
      return Icons.music_note_rounded;
    } else if (lowerName.contains('aula')) {
      return Icons.people_alt_rounded;
    } else {
      return Icons.meeting_room_rounded;
    }
  }

  void _showRoomDetail(Ruangan ruang) {
    // Validasi data dengan null safety
    final String nama = ruang.nama ?? 'Nama tidak tersedia';
    final int kapasitas = ruang.kapasitas ?? 0;
    final List<String> fasilitas = ruang.fasilitas ?? [];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getRoomIcon(nama),
                        color: Colors.blue[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          nama,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Kapasitas
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Kapasitas: $kapasitas orang',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Fasilitas
              Text(
                'Fasilitas yang tersedia:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              if (fasilitas.isNotEmpty)
                ...fasilitas.map((fasilitasItem) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green[500], size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              fasilitasItem,
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ))
              else
                Text(
                  'Tidak ada fasilitas',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),

              const SizedBox(height: 20),

              // Tombol Tutup
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Tutup',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
