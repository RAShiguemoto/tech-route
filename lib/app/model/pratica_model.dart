class Pratica {
  int? id;
  String? dataCriacao;
  String? tecnologia;

  Pratica();

  @override
  String toString() {
    return "${'id: $id'}, dataCriação: $dataCriacao, tecnologia: $tecnologia";
  }
}
