import 'package:intl/intl.dart';

String formatarStringDataParaPersistir(String dataOriginal) {
  DateTime data = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dataOriginal);
  String novaDataString = DateFormat('yyyy-MM-dd HH:mm:ss').format(data);

  return novaDataString;
}

String formatarStringDataParaExibir(String? dataOriginal) {
  DateTime data = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dataOriginal!);
  String novaDataString = DateFormat('dd/MM/yyyy HH:mm:ss').format(data);

  return novaDataString;
}
