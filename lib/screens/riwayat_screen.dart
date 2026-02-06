import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siruangflutter/controller/riwayat_controller.dart';

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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal : ${item.tanggal}'),
                    Text('Jam : ${item.jamMulai} - ${item.jamSelesai}'),
                  ],
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
              ),
            );
          },
        );
      }),
    );
  }
}
