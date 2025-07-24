import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:md/controllers/app.dart';
import 'package:md/pages/dashboard.dart';
import 'package:md/pages/professores.dart';
import 'package:md/pages/relatorios.dart';
import 'package:md/widgets/toast.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:pdf/pdf.dart' hide PdfDocument;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  startApp() async {
    NoScreenshot.instance.screenshotOff();

    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result.contains(ConnectivityResult.none)) {
        App.semNet = true;
        MyToast.get('Sem conexão com internet.');

        if (App.pagina.value == 0) {
          App.pagina.value++;
          App.pagina.value--;
        }
      } else {
        App.semNet = false;

        if (App.pagina.value == 0) {
          App.pagina.value++;
          App.pagina.value--;
        }
      }
    });

    String json = await rootBundle.loadString('assets/dados.json');
    Map dados = jsonDecode(json);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cursos = prefs.getString('cursos');

    if (cursos != null) {
      App.cursos = jsonDecode(cursos);
    } else {
      App.cursos = dados['cursos'];
    }

    App.categorias = dados['categorias'];
    App.professores = dados['professores'];

    setState(() {});
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: App.pagina,
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => App.pagina.value = 0,
            icon: Icon(Icons.home),
          ),
          title: Text(
            value == 0
                ? 'Dashboard'
                : value == 1
                ? 'Professores'
                : 'Relatórios',
          ),
          actions: App.pagina.value == 2 && App.salvouPDF
              ? [
                  IconButton(
                    onPressed: () {
                      App.salvouPDF = false;
                      App.file = null;
                      App.pdfPinchController = null;

                      App.pagina.value--;
                      App.pagina.value++;
                    },
                    icon: Icon(Icons.close_rounded),
                  ),
                ]
              : App.pagina.value == 0
              ? [
                  IconButton(
                    onPressed: () {
                      App.lista = false;
                      App.pagina.value++;
                      App.pagina.value--;
                    },
                    icon: Icon(
                      Icons.grid_view,
                      color: App.lista ? Cores.preto : Colors.grey,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      App.lista = true;
                      App.pagina.value++;
                      App.pagina.value--;
                    },
                    icon: Icon(
                      Icons.list,
                      color: !App.lista ? Cores.preto : Colors.grey,
                    ),
                  ),
                ]
              : [],
        ),
        body: App.cursos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : IndexedStack(
                index: App.pagina.value,
                children: [Dashboard(), Professores(), Relatorios()],
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: App.pagina.value,
          selectedItemColor: Colors.grey,
          unselectedItemColor: Cores.preto,
          onTap: (value) {
            App.pagina.value = value;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Cursos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Professores',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_document),
              label: 'Relatórios',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: App.relatorio.text.isEmpty && value == 2
              ? Colors.grey
              : Cores.azulClaro,
          child: Icon(value == 2 ? Icons.save : Icons.add, color: Cores.branco),
          onPressed: () async {
            if (value == 0) {
              Navigator.pushNamed(context, '/cadastroCurso');
            } else if (value == 1) {
              Navigator.pushNamed(context, '/cadastroProf');
            } else {
              if (App.relatorio.text.isNotEmpty) {
                final pdf = pw.Document();
                pdf.addPage(
                  pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Text(
                          App.relatorio.text,
                          style: pw.TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
                );

                App.file = File(
                  "/storage/emulated/0/Download/${DateTime.now().millisecondsSinceEpoch}.pdf",
                );
                await App.file!.writeAsBytes(await pdf.save());
                App.pdfPinchController = PdfControllerPinch(
                  document: PdfDocument.openFile(App.file?.path ?? ''),
                );

                App.salvouPDF = true;
                App.pagina.value--;
                App.pagina.value++;

                MyToast.get('PDF salvo na pasta de downloads do dispositivo');
              }
            }
          },
        ),
      ),
    );
  }
}
