import 'package:get/get.dart';
import '../models/ruang_model.dart';

class RuangController extends GetxController {
  var ruangs = <Ruangan>[].obs;
  RxBool isLoading = false.obs;

  final GetConnect _getConnect = GetConnect();

  Future<void> fetchRuangs() async {
    const url = 'http://192.168.100.112:8000/api/ruangan';
    try {
      isLoading.value = true;
      final response = await _getConnect.get(url);

      if (response.status.hasError) {
        throw Exception(response.statusText);
      }

      if (response.body is Map && response.body['data'] is List) {
        var data = response.body['data'] as List;
        ruangs.value = data.map((e) => Ruangan.fromJson(e)).toList();
      } else {
        ruangs.clear();
      }
    } catch (e) {
      print("Error fetch ruangan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchRuangs();
  }
}
