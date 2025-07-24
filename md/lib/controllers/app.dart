import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class App {
  static File? file;
  static PdfControllerPinch? pdfPinchController;

  static List cursos = [];
  static List professores = [];
  static List categorias = [];

  static bool lista = true;
  static bool semNet = false;
  static bool salvouPDF = false;
  static TextEditingController relatorio = TextEditingController();

  static ValueNotifier pagina = ValueNotifier<int>(0);
  static ValueNotifier modal = ValueNotifier<int>(0);
  static ValueNotifier alguma = ValueNotifier<int>(0);
}

class Cores {
  static Color branco = const Color(0xFFFCFCFC);
  static Color preto = const Color(0xFF101010);
  static Color azulClaro = const Color(0xFF5a00fb);
  static Color azulMedio = const Color(0xFF3c00a7);
  static Color azulEscuro = const Color(0xFF1e0053);
}
