class PenjualanInsight {
  final String produk;
  final int totalTerjual;
  final double totalPendapatan;

  PenjualanInsight({
    required this.produk,
    required this.totalTerjual,
    required this.totalPendapatan,
  });

  factory PenjualanInsight.fromJson(Map<String, dynamic> json) {
    return PenjualanInsight(
      produk: json['produk'],
      totalTerjual: json['total_terjual'],
      totalPendapatan: json['total_pendapatan'].toDouble(),
    );
  }
}

class StokRekomendasi {
  final String produk;
  final int stokSekarang;
  final int saranStok;
  final String alasan;

  StokRekomendasi({
    required this.produk,
    required this.stokSekarang,
    required this.saranStok,
    required this.alasan,
  });

  factory StokRekomendasi.fromJson(Map<String, dynamic> json) {
    return StokRekomendasi(
      produk: json['produk'],
      stokSekarang: json['stok_sekarang'],
      saranStok: json['saran_stok'],
      alasan: json['alasan'],
    );
  }
}

class PrediksiHabis {
  final String produk;
  final int stokSekarang;
  final int estimasiHabisHari;
  final String status;

  PrediksiHabis({
    required this.produk,
    required this.stokSekarang,
    required this.estimasiHabisHari,
    required this.status,
  });

  factory PrediksiHabis.fromJson(Map<String, dynamic> json) {
    return PrediksiHabis(
      produk: json['produk'],
      stokSekarang: json['stok_sekarang'],
      estimasiHabisHari: json['estimasi_habis_hari'],
      status: json['status'],
    );
  }
}
