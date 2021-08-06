import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'label_value.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'De olho na Fila',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'De olho no Fila'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _coronavac = "0";
  DateFormat _dateFormatOrigin = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateFormat _dateFormatFinal = DateFormat("HH:mm dd/MM/yyyy");
  var _pfizer = "0";
  var _astrazeneca = "0";
  final _url = Uri.parse(
      "https://deolhonafila.prefeitura.sp.gov.br/processadores/dados.php");
  late List<dynamic> _data = List.empty();
  late List<dynamic> _filteredData = List.empty();
  TextEditingController _textController = TextEditingController();

  void _callExternalService() async {
    final body = await http.post(_url, body: {"dados": "dados"});
    _data = jsonDecode(body.body);
    _filteredData = _data;
    _coronavac = _pfizer = _astrazeneca = "0";
    _textController.text = "";
    setState(() {});
  }

  void _filterData() {
    if (_coronavac == "0" && _pfizer == "0" && _astrazeneca == "0") {
      _filteredData = _data;
    } else {
      _filteredData = _data
          .where((element) =>
              element["coronavac"] == _coronavac &&
              element["astrazeneca"] == _astrazeneca &&
              element["pfizer"] == _pfizer)
          .toList();
    }
    var text = _textController.text.toLowerCase().trim();
    _filteredData = _filteredData
        .where((element) =>
            element["equipamento"].toString().toLowerCase().contains(text) ||
            element["endereco"].toString().toLowerCase().contains(text))
        .toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _callExternalService();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _textController,
                        textInputAction: TextInputAction.search,
                        autofocus: false,
                        decoration: InputDecoration(hintText: "Posto de saúde"),
                        onSubmitted: (value) {
                          _filterData();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("Disponibilidade de segunda dose:")),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        children: [
                          LabelCheckbox("Coronavac", (checked) {
                            _coronavac = checked;
                            setState(() {});
                          }, _coronavac),
                          LabelCheckbox("Pfizer", (checked) {
                            _pfizer = checked;
                            setState(() {});
                          }, _pfizer),
                          LabelCheckbox("Astrazeneca", (checked) {
                            _astrazeneca = checked;
                            setState(() {});
                          }, _astrazeneca)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      child: MaterialButton(
                        onPressed: _filterData,
                        child: Text("Pesquisar"),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(5)),
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        var item = _filteredData[index];

                        return Padding(
                          child: Card(
                              borderOnForeground: true,
                              elevation: 3,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LabelValue("Posto:", item["equipamento"]),
                                      LabelValue("Endereço:", item["endereco"]),
                                      LabelValue(
                                          "Ultimo update:",
                                          _dateFormatFinal.format(
                                              _dateFormatOrigin
                                                  .parse(item["data_hora"]))),
                                      LabelIconStatus(
                                          "Fila:",
                                          item["status_fila"],
                                          item["indice_fila"]),
                                      Center(
                                        child: Text(
                                            "Disponibilidade de segundad dose:"),
                                      ),
                                      Row(
                                        children: [
                                          LabelIconVaccine(
                                              "Coronavac:", item["coronavac"]),
                                          LabelIconVaccine(
                                              "Pfizer:", item["pfizer"]),
                                          LabelIconVaccine("Astrazeneca:",
                                              item["astrazeneca"]),
                                        ],
                                      )
                                    ],
                                  ))),
                          padding: EdgeInsets.all(2),
                        );
                      },
                      itemCount: _filteredData.length)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _callExternalService,
            tooltip: 'Refresh',
            child: Icon(Icons.refresh),
          ),
        ));
  }
}
