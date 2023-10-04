import 'package:flutter/material.dart';
import 'package:viacep_flutter_dio/models/enderecos_model.dart';
import 'package:viacep_flutter_dio/models/viacep_model.dart';
import 'package:viacep_flutter_dio/repositories/enderecos_salvos_repository.dart';
import 'package:viacep_flutter_dio/repositories/viacep_repository.dart';

class EnderecosPage extends StatefulWidget {
  const EnderecosPage({super.key});

  @override
  State<EnderecosPage> createState() => _EnderecosPageState();
}

class _EnderecosPageState extends State<EnderecosPage> {
  EnderecosSalvosRepository enderecosRepository = EnderecosSalvosRepository();
  var _enderecos = EnderecosModel([]);
  bool carregando = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarEnderecos();
  }

  void carregarEnderecos() async {
    setState(() {
      carregando = true;
    });
    _enderecos = await enderecosRepository.listarEnderecos();
    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Endereços Salvos"),
        ),
        body: ListView.builder(
          itemCount: _enderecos.results.length,
          itemBuilder: (BuildContext bc, int index) {
            var end = _enderecos.results[index];
            var cepController = TextEditingController(
                text: end.cep.replaceAll(RegExp(r'[^0-9]'), ""));
            return Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID: ${end.objectId.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "ID: ${end.cep.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(end.rua.toString()),
                            Text(end.bairro.toString()),
                            Text("${end.cidade} / ${end.estado}"),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            context: context,
                            builder: (BuildContext bc) {
                              var cepConsultado = ViaCepModel();
                              var viaCEPRepository = ViaCepRepository();
                              var enderecoSalvoRepository = EnderecosSalvosRepository();
                              bool loading = false;
                              return Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            maxLength: 8,
                                            keyboardType: TextInputType.number,
                                            controller: cepController,
                                          ),
                                          TextButton(
                                              onPressed: () async {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                Navigator.pop(context);
                                                var cep = cepController.text
                                                    .replaceAll(
                                                        RegExp(r'[^0-9]'), "");
                                                if (cep.length == 8) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  cepConsultado =
                                                      await viaCEPRepository
                                                          .consultarCEP(cep);
                                                  if (cepController.text !=
                                                      end.cep.replaceAll(
                                                          RegExp(r'[^0-9]'),
                                                          "")) {
                                                    EnderecosSalvosRepository endSalvos = EnderecosSalvosRepository();
                                                    bool verificaCep = await endSalvos.buscarEndereco(cepConsultado.cep ?? "");
                                                    if(verificaCep == true){
                                                      // ignore: use_build_context_synchronously
                                                      ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "O cep digitado já está na base de dados...")));
                                                                    carregarEnderecos();
                                                                    return;
                                                    }


                                                    // ignore: use_build_context_synchronously
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext bc) {
                                                          return AlertDialog(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            title: const Text(
                                                                "Atualizar Endereço"),
                                                            content: Wrap(
                                                              children: [
                                                                Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Text(
                                                                          "Novo endereço localizado:"),
                                                                      Text(cepConsultado
                                                                              .logradouro ??
                                                                          ""),
                                                                      Text(cepConsultado
                                                                              .bairro ??
                                                                          ""),
                                                                      Text(cepConsultado
                                                                              .localidade ??
                                                                          ""),
                                                                      Text(cepConsultado
                                                                              .uf ??
                                                                          ""),
                                                                    ]),
                                                              ],
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      "Cancelar")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      loading =
                                                                          true;
                                                                    });
                                                                    var cepAltera = EnderecoModel.adicionaEAtualiza(
                                                                        end
                                                                            .objectId,
                                                                        cepConsultado.cep ??
                                                                            "",
                                                                        cepConsultado.logradouro ??
                                                                            "",
                                                                        cepConsultado.bairro ??
                                                                            "",
                                                                        cepConsultado.localidade ??
                                                                            "",
                                                                        cepConsultado.uf ??
                                                                            "");
                                                                    await enderecoSalvoRepository
                                                                        .atualizar(
                                                                            cepAltera);
                                                                    setState(
                                                                        () {
                                                                      loading =
                                                                          false;
                                                                    });
                                                                    // ignore: use_build_context_synchronously
                                                                    Navigator.pop(
                                                                        context);
                                                                    carregarEnderecos();
                                                                  },
                                                                  child: const Text(
                                                                      "Atualizar"))
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    // ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Você não modificou o cep...")));
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                  "Verificar Endereço")),
                                          const Divider(height: 5),
                                          Visibility(
                                            visible: loading,
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                          Text(cepConsultado.logradouro ??
                                              end.rua),
                                          Text(cepConsultado.bairro ??
                                              end.bairro),
                                          Text(cepConsultado.localidade ??
                                              end.cidade),
                                          Text(cepConsultado.uf ?? end.estado),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(Icons.edit),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () async {
                          await enderecosRepository.remover(end.objectId);
                          carregarEnderecos();
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
