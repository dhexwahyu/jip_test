import 'dart:math';
import 'package:base_project/helper/database_helper.dart';

class CouponGenerator {
  final DBHelper _dbHelper = DBHelper();

  Future<void> generateCoupons() async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      final existing = await txn.query('coupons');
      if (existing.isNotEmpty) {
        await _resetDatabase(txn);
      }

      final operators = await txn.query('operators');
      if (operators.isEmpty) {
        await txn.insert('operators', {'id': 1, 'name': 'andi'});
        await txn.insert('operators', {'id': 2, 'name': 'nando'});
      }

      final prizes = await txn.query('prizes');

      const totalCoupons = 10000;
      const totalBoxes = 10;
      const boxesPerBatch = 5;

      int totalPrizeQty =
      prizes.fold<int>(0, (sum, prize) => sum + (prize['quantity'] as int));

      if (totalPrizeQty != totalCoupons) {
        throw Exception("Jumlah total hadiah ($totalPrizeQty) tidak sama dengan 10.000 kupon!");
      }

      Map<int, int> perBoxComposition = {};
      Map<int, int> remainderPerPrize = {};

      for (var prize in prizes) {
        final prizeId = prize['id'] as int;
        final qty = prize['quantity'] as int;
        perBoxComposition[prizeId] = qty ~/ totalBoxes;
        remainderPerPrize[prizeId] = qty % totalBoxes;
      }

      List<String> serialNumbers =
      List.generate(totalCoupons, (i) => (i + 1).toString().padLeft(5, '0'));

      int serialIndex = 0;
      int boxCounter = 1;

      final operatorByBatch = {
        1: {'operator_id': 1, 'location': 'Surabaya'},
        2: {'operator_id': 2, 'location': 'Malang'},
      };

      for (int batchNumber = 1; batchNumber <= 2; batchNumber++) {
        final operatorInfo = operatorByBatch[batchNumber]!;

        final batchId = await txn.insert('batches', {
          'batch_number': batchNumber,
          'operator_id': operatorInfo['operator_id'],
          'location': operatorInfo['location'],
          'started_at': DateTime.now().toIso8601String(),
        });

        for (int i = 0; i < boxesPerBatch; i++) {
          List<int> boxPrizes = [];
          perBoxComposition.forEach((prizeId, count) {
            boxPrizes.addAll(List.generate(count, (_) => prizeId));
          });
          remainderPerPrize.forEach((prizeId, remainder) {
            if (boxCounter <= remainder) boxPrizes.add(prizeId);
          });

          boxPrizes = _shuffleNoAdjacent(boxPrizes);

          final boxId = await txn.insert('boxes', {
            'box_number': boxCounter,
            'batch_id': batchId,
            'total_coupons': boxPrizes.length,
          });

          final batch = txn.batch();
          for (int j = 0; j < boxPrizes.length; j++) {
            batch.rawInsert(
              'INSERT INTO coupons (serial_number, box_id, prize_id) VALUES (?, ?, ?)',
              [serialNumbers[serialIndex + j], boxId, boxPrizes[j]],
            );
          }
          await batch.commit(noResult: true);

          await txn.insert('production_log', {
            'batch_id': batchId,
            'operator_id': operatorInfo['operator_id'],
            'timestamp': DateTime.now().toIso8601String(),
          });

          serialIndex += boxPrizes.length;
          boxCounter++;
        }

        await txn.update('batches', {
          'finished_at': DateTime.now().toIso8601String(),
        }, where: 'id = ?', whereArgs: [batchId]);
      }

      print("Selesai! ${serialNumbers.length} kupon telah dibuat.");
    });
  }

  List<int> _shuffleNoAdjacent(List<int> list) {
    final random = Random();
    List<int> shuffled = List.from(list);

    for (int attempt = 0; attempt < 10; attempt++) {
      shuffled.shuffle(random);
      bool valid = true;
      for (int i = 1; i < shuffled.length; i++) {
        if (shuffled[i] == shuffled[i - 1]) {
          valid = false;
          break;
        }
      }
      if (valid) return shuffled;
    }

    for (int i = 1; i < shuffled.length; i++) {
      if (shuffled[i] == shuffled[i - 1]) {
        int swapIndex = (i + 2) % shuffled.length;
        final temp = shuffled[i];
        shuffled[i] = shuffled[swapIndex];
        shuffled[swapIndex] = temp;
      }
    }

    return shuffled;
  }

  Future<void> _resetDatabase(dynamic db) async {
    await db.delete('coupons');
    await db.delete('boxes');
    await db.delete('batches');
    await db.delete('production_log');
  }
}
