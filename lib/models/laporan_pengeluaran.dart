class LaporanPengeluaran {
  final int totalPengeluaran;
  final List<DetailPengeluaran> detail;

  LaporanPengeluaran({required this.totalPengeluaran, required this.detail});

  factory LaporanPengeluaran.fromJson(Map<String, dynamic> json) {
    double temp = json['total_pengeluaran'] != null
        ? double.tryParse(json['total_pengeluaran'].toString()) ?? 0.0
        : 0.0;
    return LaporanPengeluaran(
      totalPengeluaran: temp.toInt(),
      detail: json['detail'] != null
          ? (json['detail'] as List)
                .map((e) => DetailPengeluaran.fromJson(e))
                .toList()
          : [],
    );
  }
}

class DetailPengeluaran {
  final String deskripsi;
  final double jumlah;
  final String kasir;

  DetailPengeluaran({
    required this.deskripsi,
    required this.jumlah,
    required this.kasir,
  });

  factory DetailPengeluaran.fromJson(Map<String, dynamic> json) {
    return DetailPengeluaran(
      deskripsi: json['deskripsi'] ?? 'Deskripsi tidak tersedia',
      jumlah: json['jumlah'] != null
          ? double.tryParse(json['jumlah'].toString()) ?? 0.0
          : 0.0,
      kasir: json['kasir'] ?? 'Kasir tidak diketahui',
    );
  }
}
