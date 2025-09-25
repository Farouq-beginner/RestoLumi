abstract class Makanan {
  final int id;
  final String nama;
  double harga;

  Makanan(this.id, this.nama, this.harga);

  set setHarga(double value) => harga = value;

  String getInfo();
}

class MakananBerkuah extends Makanan {
  final bool adaKuah;

  MakananBerkuah(int id, String nama, double harga, {this.adaKuah = true}) : super(id, nama, harga);

  @override
  String getInfo() => "Berkuah: ${adaKuah ? 'Ya' : 'Tidak'}";
}

class MakananKering extends Makanan {
  final String tekstur;

  MakananKering(int id, String nama, double harga, this.tekstur) : super(id, nama, harga);

  @override
  String getInfo() => "Tekstur: $tekstur";
}
