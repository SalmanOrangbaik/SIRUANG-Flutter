import 'dart:convert';

class Ruangan {
  final int id;
  final String cover;
  final String nama;
  final int kapasitas;
  final List<String> fasilitas;
  final String? createdAt;
  final String? updatedAt;

  Ruangan({
    required this.id,
    required this.cover,
    required this.nama,
    required this.kapasitas,
    required this.fasilitas,
    this.createdAt,
    this.updatedAt,
  });

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    print(' [MODEL] Memulai parsing Ruangan dari JSON');
    print('    Data masuk: $json');

    final parsedRuangan = Ruangan(
      id: json['id'] ?? 0,
      cover: json['cover'] ?? '',
      nama: json['nama'] ?? 'Unknown',
      kapasitas: _parseKapasitas(json['kapasitas']),
      fasilitas: _parseFasilitas(json['fasilitas']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );

    print('''
    [MODEL] Berhasil parsing Ruangan:
      - id: ${parsedRuangan.id}
      - nama: ${parsedRuangan.nama}
      - kapasitas: ${parsedRuangan.kapasitas}
      - fasilitas count: ${parsedRuangan.fasilitas.length}
      - fasilitas items: ${parsedRuangan.fasilitas}
''');

    return parsedRuangan;
  }

  static int _parseKapasitas(dynamic kapasitas) {
    if (kapasitas == null) return 0;
    if (kapasitas is int) return kapasitas;
    if (kapasitas is String) {
      return int.tryParse(kapasitas) ?? 0;
    }
    if (kapasitas is double) return kapasitas.toInt();
    return 0;
  }

  static List<String> _parseFasilitas(dynamic fasilitas) {
    print('    [MODEL] Parsing fasilitas:');
    print('      - Nilai: $fasilitas');
    print('      - Tipe: ${fasilitas?.runtimeType}');

    // Jika null, return empty list
    if (fasilitas == null) {
      print('      Fasilitas null, return []');
      return [];
    }

    // CASE 1: Jika sudah List<String>
    if (fasilitas is List<String>) {
      print('       Sudah List<String>, return as is');
      return fasilitas
          .where((item) => item != null && item.toString().isNotEmpty)
          .map((item) => item.toString().trim())
          .toList();
    }

    // CASE 2: Jika List<dynamic>
    if (fasilitas is List) {
      print('     Processing List<dynamic> dengan ${fasilitas.length} items');
      final result = fasilitas
          .map((item) {
            if (item == null) return '';
            if (item is String) return item.trim();
            if (item is Map) {
              // Handle berbagai kemungkinan key dalam map
              return item['nama']?.toString().trim() ??
                  item['name']?.toString().trim() ??
                  item['fasilitas']?.toString().trim() ??
                  item['description']?.toString().trim() ??
                  item.toString().trim();
            }
            return item.toString().trim();
          })
          .where((item) => item.isNotEmpty)
          .toList();

      print('       Hasil parsing List: $result');
      return result;
    }

    // CASE 3: Jika String (mungkin JSON string atau comma separated)
    if (fasilitas is String) {
      print('     Processing String');

      // Coba parse sebagai JSON array
      final trimmed = fasilitas.trim();
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        try {
          print('     Mencoba parse sebagai JSON array');
          final parsed = json.decode(trimmed);
          if (parsed is List) {
            return _parseFasilitas(parsed);
          }
        } catch (e) {
          print('      Gagal parse JSON: $e');
        }
      }

      // Coba parse sebagai JSON object
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        try {
          print('     Mencoba parse sebagai JSON object');
          final parsed = json.decode(trimmed);
          if (parsed is Map) {
            // Extract semua values yang string
            return parsed.values
                .whereType<String>()
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
          }
        } catch (e) {
          print('      Gagal parse JSON object: $e');
        }
      }

      // Split by comma sebagai fallback
      final result = fasilitas
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();

      print('       Hasil parsing String: $result');
      return result;
    }

    // CASE 4: Format tidak dikenali
    print('      Format tidak dikenali, return []');
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cover': cover,
      'nama': nama,
      'kapasitas': kapasitas,
      'fasilitas': fasilitas,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'Ruangan{id: $id, nama: $nama, kapasitas: $kapasitas, fasilitas: $fasilitas}';
  }
}
