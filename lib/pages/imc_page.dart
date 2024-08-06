import 'package:flutter/material.dart';
import 'package:imc_application/model/imcSQLiteModel.dart';
import 'package:imc_application/services/imc_sqlite_repository.dart';

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> {
  ImcSQLiteRepository imcRepository = ImcSQLiteRepository();
  List<imcSQLiteModel> _imcs = [];
  var alturaController = TextEditingController(text: "");
  var pesoController = TextEditingController(text: "");
  var idController = TextEditingController(text: "");
  String _resultado = "";
  imcSQLiteModel imcModel = imcSQLiteModel();

  @override
  void initState() {
    super.initState();
    _listarImcs();
  }

  void _calcularIMC() {
    double? altura = double.tryParse(alturaController.text);
    double? peso = double.tryParse(pesoController.text);

    if (altura != null && peso != null) {
      imcModel.altura = altura;
      imcModel.peso = peso;
      setState(() {
        _resultado = imcModel.calculo(altura, peso);
        _limparCampos();
      });
    } else {
      setState(() {
        _resultado = "Por favor, insira valores válidos.";
      });
    }
  }

  void _salvarImc() async { 
    double? altura = double.tryParse(alturaController.text);
    double? peso = double.tryParse(pesoController.text);
    int? id = int.tryParse(idController.text);
    
    if(altura == 0 || peso == 0){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("valores  inválidos")),
        );
    } else {
    if (id != null) {
      imcModel.id = id;
      await imcRepository.atualizar(imcModel);
    } else {
      await imcRepository.salvar(imcModel);
    }
    _listarImcs();
    _limparCampos();
  }}

  void _excluirImc() async {
    int? id = int.tryParse(idController.text);
    if (id != null) {
      await imcRepository.remover(id);
      _listarImcs();
      _limparCampos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID inválido")),
      );
    }
  }

void _limparCampos() {
    alturaController.clear();
    pesoController.clear();
    idController.clear();
  }
  void _listarImcs() async {
    print("Chamando _listarImcs");
    var imcs = await imcRepository.obterDados(true);
    print("Dados obtidos: $imcs");
    setState(() {
      _imcs = imcs;
      print("_imcs atualizado: $_imcs");
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text("Calculadora de IMC"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "SEJA BEM VINDO",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  const Text(
                    "Digite sua altura",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: alturaController,
                      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: const InputDecoration(
                        hintText: "Altura",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    "Digite seu peso",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: pesoController,
                      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: const InputDecoration(
                        hintText: "Peso",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    "Digite o ID",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: idController,
                      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: const InputDecoration(
                        hintText: "ID",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _excluirImc,
                    child: const Text("Excluir"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularIMC,
                child: const Text("Calcular IMC"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarImc,
                child: const Text("Salvar IMC"),
              ),
              const SizedBox(height: 20),
              Text(
                _resultado,
                style: const TextStyle(color: Colors.yellow, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _imcs.length,
                itemBuilder: (context, index) {
                  var imc = _imcs[index];
                  return ListTile(
                    title: Text(
                      "Altura: ${imc.getAltura()}, Peso: ${imc.getPeso()}, IMC: ${imc.getImc()}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
