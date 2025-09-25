String formatRupiah(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return 'Rp${buffer.toString()}';
}

abstract class Karyawan {
  final int id;
  final String nama;
  double gaji;

  Karyawan(this.id, this.nama, this.gaji);

  set setGaji(double value) => gaji = value;

  String getInfo();
}

class KaryawanTetap extends Karyawan {
  final double tunjangan;

  KaryawanTetap(int id, String nama, double gaji, this.tunjangan)
    : super(id, nama, gaji);

  @override
  String getInfo() =>
      "ID: $id, Nama: $nama, Gaji: ${formatRupiah(gaji as int)}, Tunjangan: ${formatRupiah(tunjangan as int)}";
}

class KaryawanKontrak extends Karyawan {
  final int durasiKontrak;

  KaryawanKontrak(int id, String nama, double gaji, this.durasiKontrak)
    : super(id, nama, gaji);

  @override
  String getInfo() =>
      "ID: $id, Nama: $nama, Gaji: ${formatRupiah(gaji as int)}, Durasi Kontrak: $durasiKontrak bulan";
}
