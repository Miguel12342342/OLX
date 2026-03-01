import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validadores/Validador.dart';

import '../controllers/novo_anuncio_controller.dart';
import '../../../../core/widgets/botao_customizado.dart';
import '../../../../core/widgets/input_customizado.dart';

import '../../infrastructure/datasources/anuncio_remote_datasource.dart';
import '../../infrastructure/datasources/storage_remote_datasource.dart';
import '../../infrastructure/repositories/anuncio_repository_impl.dart';
import '../../infrastructure/repositories/storage_repository_impl.dart';
import '../../domain/usecases/save_anuncio.dart';

import '../../../auth/infrastructure/datasources/auth_remote_datasource.dart';
import '../../../auth/infrastructure/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/get_current_user.dart';


class NovoAnuncioPage extends StatefulWidget {
  const NovoAnuncioPage({super.key});

  @override
  State<NovoAnuncioPage> createState() => _NovoAnuncioPageState();
}

class _NovoAnuncioPageState extends State<NovoAnuncioPage> {
  late final NovoAnuncioController _controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final authDS = AuthRemoteDataSourceImpl();
    final authRepo = AuthRepositoryImpl(authDS);
    
    final anuncioDS = AnuncioRemoteDataSourceImpl();
    final anuncioRepo = AnuncioRepositoryImpl(anuncioDS);
    
    final storageDS = StorageRemoteDataSourceImpl();
    final storageRepo = StorageRepositoryImpl(storageDS);

    _controller = NovoAnuncioController(
      saveAnuncioUseCase: SaveAnuncio(anuncioRepo),
      getCurrentUser: GetCurrentUser(authRepo),
      storageRepository: storageRepo,
      anuncioRepository: anuncioRepo,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSalvarPressed() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      
      bool sucesso = await _controller.salvarAnuncio();
      if (sucesso && mounted) {
        Navigator.pop(context); // Volta pra tela de Meus Anuncios
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo anúncio")),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Área das Imagens
                    FormField<List>(
                      initialValue: _controller.listaImagens,
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
                                itemCount: _controller.listaImagens.length + 1,
                                itemBuilder: (context, indice) {
                                  if (indice == _controller.listaImagens.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          _controller.selecionarImagemGaleria().then((_) {
                                            state.didChange(_controller.listaImagens);
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[400],
                                          radius: 50,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 40,
                                                color: Colors.grey[100],
                                              ),
                                              Text(
                                                "Adicionar",
                                                style: TextStyle(color: Colors.grey[100]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                                    _controller.listaImagens[indice],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Cancelar"),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    _controller.removerImagem(indice);
                                                    state.didChange(_controller.listaImagens);
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
                                        backgroundImage: FileImage(_controller.listaImagens[indice]),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
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
                                },
                              ),
                            ),
                            if (state.hasError)
                              Text(
                                "[${state.errorText}]",
                                style: const TextStyle(color: Colors.red, fontSize: 14),
                              ),
                          ],
                        );
                      },
                    ),
                    
                    // Dropdowns: Estado e Categoria
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              hint: const Text("Estados"),
                              initialValue: _controller.itemSelecionadoEstado,
                              style: const TextStyle(color: Colors.black, fontSize: 20),
                              items: _controller.listaItensDropEstados,
                              onSaved: _controller.setEstado,
                              validator: (valor) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                    .valido(valor);
                              },
                              onChanged: (String? valor) {
                                _controller.setEstado(valor);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              hint: const Text("Categorias"),
                              initialValue: _controller.itemSelecionadoCategoria,
                              onSaved: _controller.setCategoria,
                              style: const TextStyle(color: Colors.black, fontSize: 20),
                              items: _controller.listaItensDropCategorias,
                              validator: (valor) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                    .valido(valor);
                              },
                              onChanged: (String? valor) {
                                _controller.setCategoria(valor);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Título
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 15),
                      child: InputCustomizado(
                        hint: "Título",
                        onSaved: _controller.setTitulo,
                        validator: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(valor);
                        },
                      ),
                    ),
                    
                    // Preço
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: InputCustomizado(
                        hint: "Preço",
                        onSaved: _controller.setPreco,
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
                    
                    // Telefone
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: InputCustomizado(
                        hint: "Telefone",
                        onSaved: _controller.setTelefone,
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
                    
                    // Descrição
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: InputCustomizado(
                        hint: "Descrição (200 caracteres)",
                        onSaved: _controller.setDescricao,
                        maxLines: null,
                        validator: (valor) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .maxLength(200, msg: "Máximo de 200 caracteres")
                              .valido(valor);
                        },
                      ),
                    ),
                    
                    // Botão e Mensagem
                    if (_controller.isSaving)
                      const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Salvando anúncio..."),
                          ],
                        ),
                      )
                    else
                      BotaoCustomizado(
                        texto: 'Cadastrar anúncio',
                        onPressed: _onSalvarPressed,
                      ),
                      
                    if (_controller.mensagemErro.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          _controller.mensagemErro,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      )
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
