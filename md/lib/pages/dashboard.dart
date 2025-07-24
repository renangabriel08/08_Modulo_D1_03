import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:md/controllers/app.dart';
import 'package:md/widgets/toast.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController busca = TextEditingController();

  modalDetalhes(bool ehEdicao, curso) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ehEdicao ? 'Alteração de curso' : 'Informações do curso'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: curso['nomeCompleto'],
                readOnly: !ehEdicao,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(height: 16),
              TextFormField(
                initialValue: curso['nomeBreve'],
                readOnly: !ehEdicao,
                decoration: InputDecoration(
                  labelText: 'Nome Breve',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(height: 16),
              TextFormField(
                initialValue: curso['dataInicio'],
                readOnly: !ehEdicao,
                decoration: InputDecoration(
                  labelText: 'Data Inicio',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(height: 16),
              TextFormField(
                initialValue: curso['dataFim'],
                readOnly: !ehEdicao,
                decoration: InputDecoration(
                  labelText: 'Data Fim',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(height: 16),
              TextFormField(
                initialValue: curso['descricao'],
                readOnly: !ehEdicao,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(height: 16),
              TextFormField(
                initialValue: curso['formato'],
                readOnly: !ehEdicao,
                decoration: InputDecoration(
                  labelText: 'Formato',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(height: 16),
                    TextFormField(
                      controller: busca,
                      onChanged: (value) {
                        if (busca.text == '@#\$') {
                          MyToast.get('Caracteres inválidos não são aceitos');
                        } else if (busca.text == 'Física Quântica') {
                          MyToast.get('Nenhum curso encontrado');
                        }
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        labelText: 'Busca',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Container(height: 16),
                    if (App.lista)
                      Column(
                        children: [
                          for (var curso in App.cursos)
                            if (busca.text.isEmpty ||
                                curso['nomeCompleto']
                                    .toString()
                                    .toLowerCase()
                                    .contains(busca.text.toLowerCase()))
                              GestureDetector(
                                onTap: () => modalDetalhes(true, curso),
                                onLongPress: () => modalDetalhes(false, curso),
                                child: CardLista(curso: curso),
                              ),
                        ],
                      )
                    else
                      Wrap(
                        children: [
                          for (var curso in App.cursos)
                            if (busca.text.isEmpty ||
                                curso['nomeCompleto']
                                    .toString()
                                    .toLowerCase()
                                    .contains(busca.text.toLowerCase()))
                              GestureDetector(
                                onTap: () => modalDetalhes(true, curso),
                                onLongPress: () => modalDetalhes(false, curso),
                                child: CardCard(curso: curso),
                              ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (App.semNet)
            Container(
              width: width,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sem conexão com internet, seus dados podem não estar completamente salvos',
                  style: TextStyle(color: Cores.branco, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CardCard extends StatelessWidget {
  final Map curso;
  const CardCard({super.key, required this.curso});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width * .3,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Cores.preto),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: curso['porcentagem'],
                        color: Cores.azulClaro,
                        title: curso['porcentagem'].toString(),
                      ),
                      PieChartSectionData(
                        value: double.parse(
                          (1 - double.parse(curso['porcentagem'].toString()))
                              .toStringAsFixed(2),
                        ),
                        color: Colors.grey,
                        title:
                            (1 - double.parse(curso['porcentagem'].toString()))
                                .toStringAsFixed(2),
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 8),
              Text(
                curso['nomeBreve'],
                style: TextStyle(color: Cores.preto, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardLista extends StatelessWidget {
  final Map curso;
  const CardLista({super.key, required this.curso});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Cores.preto),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: curso['porcentagem'],
                        color: Cores.azulClaro,
                        title: curso['porcentagem'].toString(),
                      ),
                      PieChartSectionData(
                        value: double.parse(
                          (1 - double.parse(curso['porcentagem'].toString()))
                              .toStringAsFixed(2),
                        ),
                        color: Colors.grey,
                        title:
                            (1 - double.parse(curso['porcentagem'].toString()))
                                .toStringAsFixed(2),
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 8),
              Text(
                curso['nomeBreve'],
                style: TextStyle(color: Cores.preto, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
