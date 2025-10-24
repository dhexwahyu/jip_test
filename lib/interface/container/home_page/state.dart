import 'package:get/get.dart';

class HomeState {
  var reports = <BatchReport>[].obs;
  var isLoading = true.obs;
  HomeState() {
    ///Initialize variables
  }
}

class BatchReport {
  final int batchId;
  final int batchNumber;
  final String operatorName;
  final String location;
  final String startedAt;
  final List<BoxDetail> boxes;

  BatchReport({
    required this.batchId,
    required this.batchNumber,
    required this.operatorName,
    required this.location,
    required this.startedAt,
    required this.boxes,
  });
}

class BoxDetail {
  final int boxNumber;
  final String serialNumber;
  final int nominal;
  final String note;

  BoxDetail({
    required this.boxNumber,
    required this.serialNumber,
    required this.nominal,
    required this.note,
  });
}
