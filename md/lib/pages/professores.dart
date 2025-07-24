import 'package:flutter/material.dart';
import 'package:md/controllers/app.dart';

class Professores extends StatefulWidget {
  const Professores({super.key});

  @override
  State<Professores> createState() => _ProfessoresState();
}

class _ProfessoresState extends State<Professores> {
  TextEditingController busca = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 16),
              TextFormField(
                controller: busca,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  labelText: 'Busca',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(height: 16),
              for (var prof in App.professores)
                ListTile(
                  onLongPress: () {
                    prof['press'] == null || !prof['press']
                        ? prof['press'] = true
                        : prof['press'] = false;

                    setState(() {});
                  },
                  title: Text(prof['nome']),
                  subtitle: Text(prof['descricao']),
                  trailing: prof['press'] == null || !prof['press']
                      ? null
                      : Icon(Icons.delete),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
