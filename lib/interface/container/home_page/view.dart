import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'logic.dart';
import 'state.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      assignId: true,
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: const Text('Laporan Produksi Kupon', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blueAccent,
          ),
          body: Obx(() {
            if (state.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.reports.isEmpty) {
              return const Center(child: Text("Belum ada data produksi."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final report = state.reports[index];
                final date = DateTime.tryParse(report.startedAt);
                final formattedDate = date != null
                    ? DateFormat('dd-MMM-yyyy / HH:mm').format(date)
                    : report.startedAt;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("No Batch: ${report.batchNumber}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text("Nama Operator: ${report.operatorName}",
                            style: const TextStyle(fontSize: 13)),
                        Text("Lokasi: ${report.location}",
                            style: const TextStyle(fontSize: 13)),
                        Text("Tanggal / Jam: $formattedDate",
                            style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 10),
                        const Divider(thickness: 1),
                        _Table(report, context),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  Widget _Table(BatchReport report, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Daftar Kupon:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          width: screenWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DataTable(
            dataRowMinHeight: 36,
            dataRowMaxHeight: 42,
            horizontalMargin: 6,
            columnSpacing: 12,
            headingRowHeight: 36,
            dividerThickness: 0.4,
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300, width: 0.4),
            ),
            headingRowColor:
            WidgetStateProperty.all(Colors.blue.shade50.withOpacity(0.8)),

            columns: const [
              DataColumn(
                  label: Expanded(
                      child: Text("No Box",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)))),
              DataColumn(
                  label: Expanded(
                      child: Text("No Kupon",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)))),
              DataColumn(
                  label: Expanded(
                      child: Text("Nominal",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)))),
              DataColumn(
                  label: Expanded(
                      child: Text("Keterangan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)))),
            ],

            rows: report.boxes.take(5).map((box) {
              return DataRow(
                cells: [
                  DataCell(Center(
                      child: Text(box.boxNumber.toString(),
                          style: const TextStyle(fontSize: 12)))),
                  DataCell(Center(
                      child: Text(box.serialNumber,
                          style: const TextStyle(fontSize: 12)))),
                  DataCell(Center(
                      child: Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: '',
                            decimalDigits: 0,
                          ).format(box.nominal),
                          style: const TextStyle(fontSize: 12)))),
                  DataCell(Center(
                      child: Text(
                        box.note,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ))),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 6),
        const Text("dan seterusnya...",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
      ],
    );
  }
}
