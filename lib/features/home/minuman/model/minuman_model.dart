abstract class Minuman {
  final int id;
  final String nama;
  double harga;

  Minuman(this.id, this.nama, this.harga);

  set setHarga(double value) => harga = value;

  String getInfo();
}

class MinumanDingin extends Minuman {
  final bool adaEs;

  MinumanDingin(int id, String nama, double harga, {this.adaEs = true})
    : super(id, nama, harga);

  @override
  String getInfo() =>
      "Dingin: ${adaEs ? "Ya" : "Tidak"}";
}

class MinumanPanas extends Minuman {
  final int suhu;

  MinumanPanas(int id, String nama, double harga, this.suhu)
    : super(id, nama, harga);

  @override
  String getInfo() => "Suhu: $suhu°C";
}
