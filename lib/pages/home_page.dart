import 'package:flutter/material.dart';
import 'package:viacep_flutter_dio/models/viacep_model.dart';
import 'package:viacep_flutter_dio/repositories/viacep_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var cepController = TextEditingController(text: "");
  var cepConsultado = ViaCepModel();
  var viaCEPRepository = ViaCepRepository();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Consulta de cep com ViaCEP")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50,),
              const Text("Consultar CEP"),
              const SizedBox(height: 50,),
              TextField(
                maxLength: 8,
                keyboardType: TextInputType.number,
                controller: cepController,
                onChanged: (value) async {
                  var cep = value.replaceAll(RegExp(r'[^0-9]'), "");
                  if(cep.length == 8){
                    setState(() {
                      loading = true;
                    });
                    cepConsultado = await viaCEPRepository.consultarCEP(cep);
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
              Visibility(
                visible: loading,
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(height: 50,),
              Text(cepConsultado.logradouro ?? ""),
              const SizedBox(height: 10,),
              Text(cepConsultado.bairro ?? ""),
              const SizedBox(height: 10,),
              Text("${cepConsultado.localidade ?? ""} / ${cepConsultado.uf ?? ""}"),
            ],
          ),
        ),
      ),
    );
  }
}