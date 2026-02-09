import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/util/configuracoes.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'package:olx/views/widgets/input_customizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({super.key});

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  List<File> listaImagens = [];
  List<DropdownMenuItem<String>> listaItensDropEstados = [];
  List<DropdownMenuItem<String>> listaItensDropCategorias = [];
  Anuncio? anuncio;
  BuildContext? dialogContext;
  String mensagemErro = "";

  final formKey = GlobalKey<FormState>();

  String? itemSelecionadoEstado;
  String? itemSelecionadoCategoria;

  Future selecionarImagemGaleria() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagemSelecionada = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagemSelecionada != null) {
      setState(() {
        listaImagens.add(File(imagemSelecionada.path));
      });
    }
  }

  Future abrirDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        dialogContext = ctx;
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Salvando anúncio..."),
            ],
          ),
        );
      },
    );
  }

 Future salvarAnuncio() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? usuarioLogado = auth.currentUser;

  if (usuarioLogado == null) return;

  String idUsuarioLogado = usuarioLogado.uid;

  try {
    await uploadImagens();

    await db.collection("meus_anuncios")
      .doc(idUsuarioLogado)
      .collection("anuncios")
      .doc(anuncio!.id)
      .set(anuncio!.toMap());

    await db.collection("anuncios")
      .doc(anuncio!.id)
      .set(anuncio!.toMap());

    if (!mounted) return;
    Navigator.pop(context);

  } catch (e) {
    setState(() {
      mensagemErro = "Erro ao salvar anúncio";
    });
  }
}

Future uploadImagens() async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference pastaRaiz = storage.ref();

  for (var imagem in listaImagens) {
    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    Reference arquivo = pastaRaiz
      .child("meus_anuncios")
      .child(anuncio!.id!)
      .child(nomeImagem);

    UploadTask task = arquivo.putFile(imagem);
    await task.whenComplete(() async {
      String url = await arquivo.getDownloadURL();
      anuncio!.fotos!.add(url);
    });
  }
}

  @override
  void initState() {
    super.initState();
    carregarItensDropdown();

    anuncio = Anuncio.gerarId();
  }

  Future carregarItensDropdown() async {
    //Categorias

    listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados

    listaItensDropEstados = Configuracoes.getEstados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo anúncio")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: listaImagens,
                  validator: (imagens) {
                    if (imagens == null || imagens.isEmpty) {
                      return "Necessário selecionar pelo menos uma imagem!";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listaImagens.length + 1,
                            itemBuilder: (context, indice) {
                              if (indice == listaImagens.length) {
                                return Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (listaImagens.isNotEmpty) {
                                return Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.file(
                                                  listaImagens[indice],
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text("Cancelar"),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    listaImagens.removeAt(
                                                      indice,
                                                    );
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Excluir"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(
                                        listaImagens[indice],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.6,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        if (state.hasError)
                          Text(
                            "[${state.errorText}]",
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: DropdownButtonFormField(
                          hint: Text("Estados"),
                          initialValue: itemSelecionadoEstado,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: listaItensDropEstados,
                          onSaved: (estado) {
                            anuncio!.estado = estado;
                          },
                          validator: (valor) {
                            return Validador()
                                .add(
                                  Validar.OBRIGATORIO,
                                  msg: "Campo Obrigatório",
                                )
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              itemSelecionadoEstado = valor;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: DropdownButtonFormField(
                          hint: Text("Categorias"),
                          onSaved: (categoria) {
                            anuncio!.categoria = categoria;
                          },
                          initialValue: itemSelecionadoCategoria,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: listaItensDropCategorias,
                          validator: (valor) {
                            return Validador()
                                .add(
                                  Validar.OBRIGATORIO,
                                  msg: "Campo Obrigatório",
                                )
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              itemSelecionadoCategoria = valor;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "Título",
                    onSaved: (titulo) {
                      anuncio!.titulo = titulo;
                    },
                    inputFormatters: [],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Preço",
                    onSaved: (preco) {
                      anuncio!.preco = preco;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(),
                    ],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Telefone",
                    onSaved: (telefone) {
                      anuncio!.telefone = telefone;
                    },
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Descrição (200 caracteres)",
                    onSaved: (descricao) {
                      anuncio!.descricao = descricao;
                    },
                    maxLines: null,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor);
                    },
                  ),
                ),
                BotaoCustomizado(
                  texto: 'Cadastrar anúncio',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      dialogContext = context;
                      salvarAnuncio();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
