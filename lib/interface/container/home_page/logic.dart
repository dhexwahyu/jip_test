import 'package:base_project/helper/database_helper.dart';
import 'package:base_project/helper/generate_coupon.dart';
import 'package:get/get.dart';

import 'state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();
  final DBHelper _dbHelper = DBHelper();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDataCoupon();
  }

  Future<void> loadDataCoupon() async {
    // Jadi setiap load data, akan generate ulang kuponnya
    state.isLoading.value = true;
    final db = await _dbHelper.database;
    final generator = CouponGenerator();
    await generator.generateCoupons();
    await Future.delayed(const Duration(milliseconds: 200));

    final result = await db.rawQuery('''
        SELECT 
          b.id AS batch_id,
          b.batch_number,
          o.name AS operator_name,
          b.location,
          b.started_at,
          bx.box_number,
          c.serial_number,
          p.amount AS nominal,
          p.description AS keterangan
        FROM batches b
        JOIN operators o ON o.id = b.operator_id
        JOIN boxes bx ON bx.batch_id = b.id
        JOIN coupons c ON c.box_id = bx.id
        JOIN prizes p ON p.id = c.prize_id
        ORDER BY b.batch_number, bx.box_number, c.serial_number;
      ''');

    if (result.isEmpty) {
      print("Data result kosong!");
    }

    Map<int, BatchReport> grouped = {};
    for (var row in result) {
      final batchId = row['batch_id'] as int;
      grouped.putIfAbsent(batchId, () {
        return BatchReport(
          batchId: batchId,
          batchNumber: row['batch_number'] as int,
          operatorName: row['operator_name'] as String,
          location: row['location'] as String,
          startedAt: row['started_at'] as String,
          boxes: [],
        );
      });

      grouped[batchId]!.boxes.add(BoxDetail(
        boxNumber: row['box_number'] as int,
        serialNumber: row['serial_number'] as String,
        nominal: row['nominal'] as int,
        note: row['keterangan'] as String,
      ));
    }

    state.reports.value = grouped.values.toList();
    state.isLoading.value = false;
  }

  Future<void> checkVolumeCoupon() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT 
        p.amount AS nominal,
        COUNT(c.id) AS jumlah_kupon
      FROM coupons c
      JOIN prizes p ON p.id = c.prize_id
      WHERE p.amount > 0
      GROUP BY p.amount
      ORDER BY p.amount DESC
    ''');

    for (var row in result) {
      print('Nominal: ${row['nominal']}, Jumlah Kupon: ${row['jumlah_kupon']}');
    }
  }
}
