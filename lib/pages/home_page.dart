import 'package:flutter/material.dart';
import 'package:viacep_flutter_dio/models/enderecos_model.dart';
import 'package:viacep_flutter_dio/models/viacep_model.dart';
import 'package:viacep_flutter_dio/pages/enderecos_page.dart';
import 'package:viacep_flutter_dio/repositories/enderecos_salvos_repository.dart';
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
                const SizedBox(
                  height: 50,
                ),
                const Text("Consultar CEP"),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  controller: cepController,
                  onChanged: (value) async {
                    var cep = value.replaceAll(RegExp(r'[^0-9]'), "");
                    if (cep.length == 8) {
                      FocusManager.instance.primaryFocus?.unfocus();
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
                const SizedBox(
                  height: 50,
                ),
                Text(cepConsultado.logradouro ?? ""),
                const SizedBox(
                  height: 10,
                ),
                Text(cepConsultado.bairro ?? ""),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    "${cepConsultado.localidade ?? ""} ${cepConsultado.uf ?? ""}"),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              FocusManager.instance.primaryFocus?.unfocus();
              if(cepController.text.length == 8){
                setState(() {
                  loading = true;
                });

                EnderecosSalvosRepository endSalvos = EnderecosSalvosRepository();
                bool verificaCep = await endSalvos.buscarEndereco(cepConsultado.cep ?? "");

                if(verificaCep == false){
                  await endSalvos.adicionar(EnderecoModel.adicionar(cepConsultado.cep ?? "", cepConsultado.logradouro ?? "", cepConsultado.bairro ?? "", cepConsultado.localidade ?? "", cepConsultado.uf ?? ""));
                  cepController.text = "";
                  cepConsultado = ViaCepModel();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("O endereço foi adicionado com sucesso!.")
                    )
                  );
                  setState(() {});
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Este endereço já existe no banco de dados.")
                    )
                  );
                  cepController.text = "";
                }

                setState(() {
                  loading = false;
                });              

                
               

              }else{
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Você precisa digitar um cep válido para salvar.")
                  )
                );
                cepController.text = "";
                return;
              }
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                if (value == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EnderecosPage()));
                }
              },
              currentIndex: 0,
              items: const [
                BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    label: "Endereços Salvos", icon: Icon(Icons.history)),
              ])),
    );
  }
}
