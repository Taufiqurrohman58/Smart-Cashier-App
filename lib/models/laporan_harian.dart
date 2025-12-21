class LaporanHarianResponse {
  final bool status;
  final String periode;
  final String tanggal;
  final Penjualan penjualan;
  final Pengeluaran pengeluaran;
  final Ringkasan ringkasan;

  LaporanHarianResponse({
    required this.status,
    required this.periode,
    required this.tanggal,
    required this.penjualan,
    required this.pengeluaran,
    required this.ringkasan,
  });

  factory LaporanHarianResponse.fromJson(Map<String, dynamic> json) {
    return LaporanHarianResponse(
      status: json['status'] ?? false,
      periode: json['periode'] ?? '',
      tanggal: json['tanggal'] ?? '',
      penjualan: json['penjualan'] != null
          ? Penjualan.fromJson(json['penjualan'])
          : Penjualan.empty(),
      pengeluaran: json['pengeluaran'] != null
          ? Pengeluaran.fromJson(json['pengeluaran'])
          : Pengeluaran.empty(),
      ringkasan: json['ringkasan'] != null
          ? Ringkasan.fromJson(json['ringkasan'])
          : Ringkasan.empty(),
    );
  }
}

class Penjualan {
  final int totalTransaksi;
  final int totalPenjualan;
  final List<DetailPenjualan> detail;

  Penjualan({
    required this.totalTransaksi,
    required this.totalPenjualan,
    required this.detail,
  });

  factory Penjualan.fromJson(Map<String, dynamic> json) {
    return Penjualan(
      totalTransaksi: (json['total_transaksi'] as num?)?.toInt() ?? 0,
      totalPenjualan: (json['total_penjualan'] as num?)?.toInt() ?? 0,
      detail: json['detail'] != null
          ? (json['detail'] as List)
                .map((e) => DetailPenjualan.fromJson(e))
                .toList()
          : [],
    );
  }

  factory Penjualan.empty() {
    return Penjualan(totalTransaksi: 0, totalPenjualan: 0, detail: []);
  }
}

class DetailPenjualan {
  final String invoice;
  final String kasir;
  final List<ItemPenjualan> items;
  final int total;

  DetailPenjualan({
    required this.invoice,
    required this.kasir,
    required this.items,
    required this.total,
  });

  factory DetailPenjualan.fromJson(Map<String, dynamic> json) {
    return DetailPenjualan(
      invoice: json['invoice'] ?? '',
      kasir: json['kasir'] ?? '',
      items: json['items'] != null
          ? (json['items'] as List)
                .map((e) => ItemPenjualan.fromJson(e))
                .toList()
          : [],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class ItemPenjualan {
  final String produk;
  final int qty;
  final int subtotal;

  ItemPenjualan({
    required this.produk,
    required this.qty,
    required this.subtotal,
  });

  factory ItemPenjualan.fromJson(Map<String, dynamic> json) {
    return ItemPenjualan(
      produk: json['produk'] ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toInt() ?? 0,
    );
  }
}

class Pengeluaran {
  final int totalPengeluaran;
  final List<DetailPengeluaran> detail;

  Pengeluaran({required this.totalPengeluaran, required this.detail});

  factory Pengeluaran.fromJson(Map<String, dynamic> json) {
    double temp = json['total_pengeluaran'] != null
        ? double.tryParse(json['total_pengeluaran'].toString()) ?? 0.0
        : 0.0;
    return Pengeluaran(
      totalPengeluaran: temp.toInt(),
      detail: json['detail'] != null
          ? (json['detail'] as List)
                .map((e) => DetailPengeluaran.fromJson(e))
                .toList()
          : [],
    );
  }

  factory Pengeluaran.empty() {
    return Pengeluaran(totalPengeluaran: 0, detail: []);
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

class Ringkasan {
  final int totalPenjualan;
  final int totalPengeluaran;
  final int labaBersih;

  Ringkasan({
    required this.totalPenjualan,
    required this.totalPengeluaran,
    required this.labaBersih,
  });

  factory Ringkasan.fromJson(Map<String, dynamic> json) {
    return Ringkasan(
      totalPenjualan: (json['total_penjualan'] as num?)?.toInt() ?? 0,
      totalPengeluaran: (json['total_pengeluaran'] as num?)?.toInt() ?? 0,
      labaBersih: (json['laba_bersih'] as num?)?.toInt() ?? 0,
    );
  }

  factory Ringkasan.empty() {
    return Ringkasan(totalPenjualan: 0, totalPengeluaran: 0, labaBersih: 0);
  }
}
