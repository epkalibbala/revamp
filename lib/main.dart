import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class LoanQualificationApp extends StatefulWidget {
  @override
  _LoanQualificationAppState createState() => _LoanQualificationAppState();
}

class _LoanQualificationAppState extends State<LoanQualificationApp> {
  List<List<dynamic>> csvData = [];
  List<List<dynamic>> filteredData = [];

  TextEditingController searchController = TextEditingController();

  Future<void> loadCsvData() async {
    final csvString = await rootBundle.loadString('assets/Book2.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
    setState(() {
      csvData = rowsAsListOfValues;
      filteredData = csvData;
    });
  }

  void filterData(String query) {
    setState(() {
      filteredData = csvData.where((row) {
        final name = row[1].toString().toLowerCase();
        final ipps = row[0].toString().toLowerCase();
        return name.contains(query) || ipps.contains(query);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadCsvData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Loan Qualification'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                onChanged: filterData,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final rowData = filteredData[index];
                  final name = rowData[1];
                  final phoneNumber = rowData[2];
                  final columnNames = ['6', '9', '12', '24', '36', '48', '60', '72', '84'];
                  final loanAmounts = rowData.sublist(4);

                  return name != "Name" ? ExpansionTile(
                    title: Text(name),
                    subtitle: Text('Phone Number: $phoneNumber'),
                    children: [
                    for (int i = 0; i < loanAmounts.length; i++)
                          Column(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              loanAmounts[i] != "" ? Text(style: const TextStyle(fontWeight: FontWeight.bold), columnNames[i]) : Container(),
                              loanAmounts[i] != "" ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${loanAmounts[i]}'),
                              ) : Container(),
                            ],
                          ),
                    ]
                    ,
                  ) : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(LoanQualificationApp());
}
