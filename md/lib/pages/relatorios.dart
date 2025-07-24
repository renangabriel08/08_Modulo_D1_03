import 'package:flutter/material.dart';
import 'package:md/controllers/app.dart';
import 'package:md/widgets/toast.dart';
import 'package:pdfx/pdfx.dart';

class Relatorios extends StatefulWidget {
  const Relatorios({super.key});

  @override
  State<Relatorios> createState() => _RelatoriosState();
}

class _RelatoriosState extends State<Relatorios> {
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
                          professoresSelecionados.add(prof);
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
              child: Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  List cursosSelecionados = [];
  modalCursos() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ValueListenableBuilder(
        valueListenable: App.modal,
        builder: (context, value, child) => AlertDialog(
          title: Text('Selecionar cursos'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (var prof in App.cursos)
                  ListTile(
                    title: Text(prof['nomeCompleto']),
                    subtitle: Text(prof['nomeBreve']),
                    trailing: IconButton(
                      onPressed: () {
                        if (cursosSelecionados.contains(prof)) {
                          cursosSelecionados.remove(prof);
                        } else {
                          cursosSelecionados.add(prof);
                        }
                        App.modal.value++;
                      },
                      icon: Icon(
                        cursosSelecionados.contains(prof)
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
              child: Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  gerarRelatorio() async {
    if (cursosSelecionados.isEmpty && professoresSelecionados.isEmpty) {
      MyToast.get('Selecione ao menos um curso ou professor');
    } else {
      App.relatorio.clear();

      App.relatorio.text += 'Professores:\n';
      for (var prof in professoresSelecionados) {
        App.relatorio.text += '$prof\n';
      }

      App.relatorio.text += '\nCursos:\n';
      for (var prof in cursosSelecionados) {
        App.relatorio.text += '$prof\n';
      }

      App.pagina.value--;
      App.pagina.value++;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      height: height,
      child: App.file != null && App.pdfPinchController != null
          ? PdfViewPinch(controller: App.pdfPinchController!)
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: width,
                      height: 220,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Cores.preto),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Curso'),
                                trailing: IconButton(
                                  onPressed: () => modalCursos(),
                                  icon: Icon(Icons.search),
                                ),
                              ),
                              for (var prof in cursosSelecionados)
                                ListTile(
                                  title: Text(prof['nomeCompleto']),
                                  subtitle: Text(prof['nomeBreve']),
                                  trailing: IconButton(
                                    onPressed: () {
                                      cursosSelecionados.remove(prof);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Container(height: 16),
                    Container(
                      width: width,
                      height: 220,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Cores.preto),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Professores'),
                                trailing: IconButton(
                                  onPressed: () => modalProfessores(),
                                  icon: Icon(Icons.search),
                                ),
                              ),
                              for (var prof in professoresSelecionados)
                                ListTile(
                                  title: Text(prof['nome']),
                                  subtitle: Text(prof['descricao']),
                                  trailing: IconButton(
                                    onPressed: () {
                                      professoresSelecionados.remove(prof);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * .4, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        backgroundColor: Cores.azulClaro,
                      ),
                      onPressed: () => gerarRelatorio(),
                      child: Text(
                        'Gerar Relatório',
                        style: TextStyle(color: Cores.branco),
                      ),
                    ),
                    Container(height: 16),
                    TextFormField(
                      controller: App.relatorio,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {});
                      },
                      maxLines: 20,
                      readOnly: true,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
