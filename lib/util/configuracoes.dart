import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes {

static List<DropdownMenuItem<String>> getCategorias() {
    return [
      const DropdownMenuItem(value: null, child: Text("Categoria",
      style: TextStyle(
        color: Color(0xff9c27b0)
      ),)),
      const DropdownMenuItem(value: "auto", child: Text("Automóvel")),
      const DropdownMenuItem(value: "imovel", child: Text("Imóvel")),
      const DropdownMenuItem(value: "eletro", child: Text("Eletrônicos")),
      const DropdownMenuItem(value: "moda", child: Text("Moda")),
      const DropdownMenuItem(value: "esportes", child: Text("Esportes")),
    ];
  }

static List<DropdownMenuItem<String>> getEstados() {
  return [

    const DropdownMenuItem(
      value: null, 
      child: Text(
        "Região",
        style: TextStyle(color: Color(0xff9c27b0), fontWeight: FontWeight.bold),
      ),
    ),
    ...Estados.listaEstadosSigla.map((estado) {
      return DropdownMenuItem(value: estado, child: Text(estado));
    }),
  ];
}}