import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:md/controllers/app.dart';
import 'package:md/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroCursos extends StatefulWidget {
  const CadastroCursos({super.key});

  @override
  State<CadastroCursos> createState() => _CadastroCursosState();
}

class _CadastroCursosState extends State<CadastroCursos> {
  TextEditingController completo = TextEditingController();
  TextEditingController breve = TextEditingController();
  TextEditingController inicio = TextEditingController();
  TextEditingController fim = TextEditingController();
  TextEditingController sumario = TextEditingController();

  String? formato;
  Map? categoria;

  bool visivel = true;

  List<String> formatos = [
    'Atividade Única',
    'Formato Social',
    'Formato tópicos',
    'Formato semanal',
  ];

  DateTime dtInicio = DateTime.now();
  DateTime dtFim = DateTime.now();

  List professoresSelecionados = [];
  modalProfessores() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ValueListenableBuilder(
        valueListenable: App.modal,
        builder: (context, value, child) => AlertDialog(
          title: Text('Selecionar professor'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (var prof in App.professores)
                  ListTile(
                    title: Text(prof['nome']),
                    subtitle: Text(prof['descricao']),
                    trailing: IconButton(
                      onPressed: () {
                        if (professoresSelecionados.contains(prof)) {
                          professoresSelecionados.remove(prof);
                        } else {
                          if (professoresSelecionados.length < 5) {
                            professoresSelecionados.add(prof);
                          } else {
                            MyToast.get('Selecione no máximo 5 professores');
                          }
                        }
                        App.modal.value++;
                      },
                      icon: Icon(
                        professoresSelecionados.contains(prof)
                            ? Icons.remove
                            : Icons.add,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  salvar() async {
    if (completo.text.isEmpty) {
      MyToast.get('Nome completo é obrigatório');
    } else if (completo.text.length < 10) {
      MyToast.get('Nome completo precisa de 10 caracteres');
    } else if (!completo.text.contains(' ') ||
        completo.text.indexOf(' ') == 0 ||
        completo.text.indexOf(' ') == completo.text.length - 1) {
      MyToast.get('Formato de nome inválido');
    } else if (breve.text.isEmpty) {
      MyToast.get('Nome breve é obrigatório');
    } else if (categoria == null) {
      MyToast.get('Categoria é obrigatório');
    } else if (inicio.text.isEmpty) {
      MyToast.get('Data início é obrigatória');
    } else if (dtInicio.isBefore(DateTime.now())) {
      MyToast.get('Data início não pode ser anterior ao dia atual');
    } else if (dtFim.isBefore(dtInicio)) {
      MyToast.get('Data fim não pode ser anterior a data de início');
    } else if (professoresSelecionados.isEmpty) {
      MyToast.get('Selecione ao menos um professor');
    } else {
      App.cursos.add({
        "id": App.cursos.last['id'] + 1,
        "nomeCompleto": completo.text,
        "nomeBreve": breve.text,
        "categoria_id": categoria!['id'],
        "visivel": visivel,
        "dataInicio": inicio.text,
        "dataFim": fim.text,
        "descricao": sumario.text,
        "formato": formato ?? 'Atividade Única',
        "professores_id": [
          for (var prof in professoresSelecionados) prof['id'],
        ],
        "porcentagem": 0.0,
      });

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('cursos', jsonEncode(App.cursos));

      Navigator.pop(context);
      App.pagina.value++;
      App.pagina.value--;
      MyToast.get('Curso salvo com sucesso!');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cursos - Novo'),
        leading: IconButton(
          onPressed: () {
            App.pagina.value = 0;
            Navigator.pop(context);
          },
          icon: Icon(Icons.home),
        ),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 16),
                TextFormField(
                  key: const Key('completo'),
                  controller: completo,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome Completo',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),
                TextFormField(
                  key: const Key('breve'),
                  controller: breve,
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome Breve',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),
                DropdownButtonFormField(
                  key: const Key('categoria'),
                  value: categoria,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var cat in App.categorias)
                      DropdownMenuItem(value: cat, child: Text(cat['nome'])),
                  ],
                  onChanged: (value) {
                    categoria = value as Map;
                    setState(() {});
                  },
                ),
                Container(height: 16),
                Row(
                  children: [
                    Text(
                      'Visível',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: visivel,
                      onChanged: (value) => setState(() {
                        visivel = !visivel;
                      }),
                    ),
                  ],
                ),
                Container(height: 16),
                TextFormField(
                  key: const Key('inicio'),
                  controller: inicio,
                  readOnly: true,
                  onTap: () =>
                      showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2300),
                        initialDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          dtInicio = value;
                          inicio.text = DateFormat("dd/MM/yyyy").format(value);
                        }

                        setState(() {});
                      }),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Data Início',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),
                TextFormField(
                  key: const Key('fim'),
                  controller: fim,
                  readOnly: true,
                  onTap: () =>
                      showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2300),
                        initialDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          dtFim = value;
                          fim.text = DateFormat("dd/MM/yyyy").format(value);
                        }

                        setState(() {});
                      }),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Data Fim',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),
                TextFormField(
                  key: const Key('sumario'),
                  controller: sumario,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {});
                  },
                  maxLines: 5,
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText: 'Sumário do cursos',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),
                DropdownButtonFormField(
                  value: formato,
                  decoration: InputDecoration(
                    labelText: 'Formato',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (var format in formatos)
                      DropdownMenuItem(value: format, child: Text(format)),
                  ],
                  onChanged: (value) {
                    formato = value.toString();
                    setState(() {});
                  },
                ),
                Container(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Professores',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => modalProfessores(),
                      icon: Icon(Icons.add_box_outlined),
                    ),
                  ],
                ),
                Container(height: 16),
                Container(
                  width: width,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Cores.preto),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var prof in professoresSelecionados)
                            Slidable(
                              key: ValueKey(prof['id']),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    flex: 2,
                                    onPressed: (context) {
                                      professoresSelecionados.remove(prof);
                                      setState(() {});
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Remover',
                                  ),
                                ],
                              ),

                              child: ListTile(
                                title: Text(prof['nome']),
                                subtitle: Text(prof['descricao']),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * .4, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        backgroundColor: Cores.azulClaro,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Cores.branco),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * .4, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        backgroundColor: Cores.azulClaro,
                      ),
                      onPressed: () => salvar(),
                      child: Text(
                        'Salvar',
                        style: TextStyle(color: Cores.branco),
                      ),
                    ),
                  ],
                ),
                Container(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
