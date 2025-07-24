import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:md/controllers/app.dart';
import 'package:md/widgets/toast.dart';

class CadastroProf extends StatefulWidget {
  const CadastroProf({super.key});

  @override
  State<CadastroProf> createState() => _CadastroProfState();
}

class _CadastroProfState extends State<CadastroProf> {
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telefone = MaskedTextController(
    mask: '(00) 00000-0000',
  );
  TextEditingController desc = TextEditingController();

  File? img;

  tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      img = File(image.path);
    }

    setState(() {});
  }

  salvar() {
    if (nome.text.isEmpty) {
      MyToast.get('Nome é obrigatório');
    } else {
      App.professores.add({
        "id": App.professores.last['id'] + 1,
        "nome": nome.text,
        "email": email.text,
        "telefone": telefone.text,
        "descricao": desc.text,
      });

      Navigator.pop(context);
      App.pagina.value++;
      App.pagina.value--;
      MyToast.get('Professor salvo com sucesso!');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Professores - Novo'),
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
                  key: const Key('nome'),
                  controller: nome,
                  maxLength: 60,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),

                TextFormField(
                  key: const Key('email'),
                  controller: email,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    if (email.text == 'robson.denneremailcom') {
                      MyToast.get('Formato de email inválido');
                    }

                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),

                TextFormField(
                  key: const Key('telefone'),
                  controller: telefone,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),

                TextFormField(
                  key: const Key('desc'),
                  controller: desc,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {});
                  },
                  maxLength: 200,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Imagem',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(height: 16),
                GestureDetector(
                  onTap: () => tirarFoto(),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Cores.preto),
                    ),
                    child: img != null
                        ? InteractiveViewer(
                            child: Image.file(img!, fit: BoxFit.cover),
                          )
                        : Center(child: Icon(Icons.camera_alt)),
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
                      onPressed: () {
                        Navigator.pop(context);
                        App.pagina.value = 0;
                      },
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
