class LaporanBulananResponse {
  final bool status;
  final String periode;
  final String bulan;
  final String tahun;
  final PenjualanBulanan penjualan;
  final PengeluaranBulanan pengeluaran;
  final RingkasanBulanan ringkasan;

  LaporanBulananResponse({
    required this.status,
    required this.periode,
    required this.bulan,
    required this.tahun,
    required this.penjualan,
    required this.pengeluaran,
    required this.ringkasan,
  });

  factory LaporanBulananResponse.fromJson(Map<String, dynamic> json) {
    return LaporanBulananResponse(
      status: json['status'] ?? false,
      periode: json['periode'] ?? '',
      bulan: json['bulan'] ?? '',
      tahun: json['tahun'] ?? '',
      penjualan: json['penjualan'] != null
          ? PenjualanBulanan.fromJson(json['penjualan'])
          : PenjualanBulanan.empty(),
      pengeluaran: json['pengeluaran'] != null
          ? PengeluaranBulanan.fromJson(json['pengeluaran'])
          : PengeluaranBulanan.empty(),
      ringkasan: json['ringkasan'] != null
          ? RingkasanBulanan.fromJson(json['ringkasan'])
          : RingkasanBulanan.empty(),
    );
  }
}

class PenjualanBulanan {
  final int totalPenjualan;
  final int totalTransaksi;

  PenjualanBulanan({
    required this.totalPenjualan,
    required this.totalTransaksi,
  });

  factory PenjualanBulanan.fromJson(Map<String, dynamic> json) {
    return PenjualanBulanan(
      totalPenjualan: (json['total_penjualan'] as num?)?.toInt() ?? 0,
      totalTransaksi: (json['total_transaksi'] as num?)?.toInt() ?? 0,
    );
  }

  factory PenjualanBulanan.empty() {
    return PenjualanBulanan(totalPenjualan: 0, totalTransaksi: 0);
  }
}

class PengeluaranBulanan {
  final int totalPengeluaran;

  PengeluaranBulanan({required this.totalPengeluaran});

  factory PengeluaranBulanan.fromJson(Map<String, dynamic> json) {
    double temp = json['total_pengeluaran'] != null
        ? double.tryParse(json['total_pengeluaran'].toString()) ?? 0.0
        : 0.0;
    return PengeluaranBulanan(totalPengeluaran: temp.toInt());
  }

  factory PengeluaranBulanan.empty() {
    return PengeluaranBulanan(totalPengeluaran: 0);
  }
}

class RingkasanBulanan {
  final int labaKotor;
  final int totalPengeluaran;
  final int labaBersih;

  RingkasanBulanan({
    required this.labaKotor,
    required this.totalPengeluaran,
    required this.labaBersih,
  });

  factory RingkasanBulanan.fromJson(Map<String, dynamic> json) {
    return RingkasanBulanan(
      labaKotor: (json['laba_kotor'] as num?)?.toInt() ?? 0,
      totalPengeluaran: (json['total_pengeluaran'] as num?)?.toInt() ?? 0,
      labaBersih: (json['laba_bersih'] as num?)?.toInt() ?? 0,
    );
  }

  factory RingkasanBulanan.empty() {
    return RingkasanBulanan(labaKotor: 0, totalPengeluaran: 0, labaBersih: 0);
  }
}
