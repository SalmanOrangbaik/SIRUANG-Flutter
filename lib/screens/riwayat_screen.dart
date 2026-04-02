import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siruangflutter/controller/riwayat_controller.dart';
import 'package:siruangflutter/controller/ruang_controller.dart';
import 'package:siruangflutter/models/booking_model.dart';
import 'package:siruangflutter/models/ruang_model.dart';

class RiwayatPage extends StatelessWidget {
  RiwayatPage({super.key});

  final RiwayatController controller = Get.put(RiwayatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.riwayatList.isEmpty) {
          return const Center(
            child: Text('Belum ada riwayat booking'),
          );
        }

        return ListView.builder(
          itemCount: controller.riwayatList.length,
          itemBuilder: (context, index) {
            final item = controller.riwayatList[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(
                  item.ruang?.nama ?? 'Ruangan tidak diketahui',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(
                    color: item.status == 'disetujui'
                        ? Colors.green
                        : item.status == 'ditolak'
                            ? Colors.red
                            : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isThreeLine: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text('Tanggal : ${item.tanggal}'),
                    Text('Jam : ${item.jamMulai} - ${item.jamSelesai}'),
                    const SizedBox(height: 10),
                    if (item.id != null && item.status != 'disetujui')
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _showEditDialog(context, item),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit'),
                          ),
                          TextButton.icon(
                            onPressed: () => _confirmCancel(item),
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            label: const Text(
                              'Batal',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Future<void> _confirmCancel(Booking booking) async {
    final shouldCancel = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Batalkan Booking'),
        content: Text(
          'Yakin ingin membatalkan booking untuk ${booking.ruang?.nama ?? 'ruangan ini'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (shouldCancel == true && booking.id != null) {
      controller.cancelBooking(booking.id!);
    }
  }

  Future<void> _showEditDialog(BuildContext context, Booking booking) async {
    final RuangController ruangController = Get.find<RuangController>();
    Ruangan? selectedRuang = ruangController.ruangList.firstWhereOrNull(
      (ruang) => ruang.id == booking.ruangId,
    );
    DateTime selectedDate = DateTime.parse(booking.tanggal);
    TimeOfDay startTime = _parseTime(booking.jamMulai);
    TimeOfDay endTime = _parseTime(booking.jamSelesai);

    await Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Edit Booking',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ruangan',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Ruangan>(
                    value: selectedRuang,
                    items: ruangController.ruangList
                        .map(
                          (ruang) => DropdownMenuItem<Ruangan>(
                            value: ruang,
                            child: Text(ruang.nama),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRuang = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tanggal',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Jam Mulai',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          startTime = pickedTime;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(_formatTime(startTime)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Jam Selesai',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          endTime = pickedTime;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(_formatTime(endTime)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Tutup'),
              ),
              ElevatedButton(
                onPressed: selectedRuang == null
                    ? null
                    : () {
                        final updatedBooking = Booking(
                          id: booking.id,
                          userId: booking.userId,
                          ruangId: selectedRuang!.id,
                          tanggal:
                              '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                          jamMulai: _formatTime(startTime),
                          jamSelesai: _formatTime(endTime),
                          status: booking.status,
                          ruang: selectedRuang,
                        );

                        Get.back();
                        controller.updateBooking(updatedBooking);
                      },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
