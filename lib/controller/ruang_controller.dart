import 'package:get/get.dart';
import '../models/ruang_model.dart';
import '../services/api_service.dart';

class RuangController extends GetxController {
  var isLoading = true.obs;
  var ruangList = <Ruangan>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRuang();
  }

  Future<void> fetchRuang() async {
    try {
      print(' [CONTROLLER] Memulai fetchRuang...');
      isLoading(true);
      errorMessage('');

      final ruangan = await ApiService().getRuang();

      // Summary debug
      print('''
     [CONTROLLER] FetchRuang Selesai:
   - Total ruangan: ${ruangan.length}
   - Fasilitas summary:''');

      for (var ruang in ruangan) {
        print(
            '      ${ruang.nama}: ${ruang.fasilitas.length} fasilitas - ${ruang.fasilitas}');
      }

      ruangList.assignAll(ruangan);
    } catch (e) {
      errorMessage('Terjadi kesalahan: ${e.toString()}');
      print(' [CONTROLLER] Error fetching ruangan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<Ruangan?> fetchRuangDetail(int id) async {
    try {
      return await ApiService().getRuangDetail(id);
    } catch (e) {
      print('Error fetching ruangan detail: $e');
      return null;
    }
  }

  Future<void> refreshData() async {
    print(' [CONTROLLER] Manual refresh...');
    await fetchRuang();
  }
}
