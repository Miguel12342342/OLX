# OLX Clone - Marketplace com Flutter & Firebase

Este projeto é um aplicativo de marketplace inspirado na plataforma OLX, desenvolvido em **Flutter** com integração total ao **Firebase**. Ele permite que usuários anunciem itens, filtrem por categoria/estado e gerenciem suas postagens em tempo real.

---

## 🚀 Funcionalidades Principal

### 🏠 Visão Geral e Filtros
- **Listagem de Anúncios**: Exibição fluida de anúncios públicos.
- **Filtros Avançados**: Filtragem em tempo real por Estado (UF) e Categoria.
- **Detalhes do Anúncio**: Visualização detalhada com carrossel de fotos, preço e descrição.
- **Contato Direto**: Integração para ligar diretamente para o anunciante.

### 👤 Autenticação e Perfil
- **Login e Cadastro**: Sistema robusto de autenticação via Firebase Auth.
- **Validação de Campos**: Máscaras brasileiras (CPF, Telefone, CEP) e validações de formulário.

### 📦 Gerenciamento de Anúncios
- **Criação de Anúncios**: Upload de múltiplas imagens via Firebase Storage.
- **Meus Anúncios**: Dashboard para o usuário visualizar e excluir seus próprios anúncios.
- **Persistência de Dados**: Banco de dados NoSQL com Cloud Firestore.

---

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Backend**: [Firebase](https://firebase.google.com/)
  - **Authentication**: Gestão de usuários.
  - **Firestore**: Banco de dados escalável.
  - **Storage**: Armazenamento de imagens dos anúncios.
- **Bibliotecas Chave**:
  - `carousel_slider`: Para carrosséis de imagens intuitivos.
  - `brasil_fields`: Para formatação de dados nacionais.
  - `validadores`: Para segurança nos formulários.
  - `image_picker`: Para captura e seleção de fotos da galeria.

---

## 📦 Estrutura do Projeto

```text
lib/
├── models/           # Modelos de dados (Anúncio, Usuário, etc.)
├── services/         # Configurações e conexões (Firebase)
├── views/            # Telas da aplicação
│   ├── widgets/      # Componentes reutilizáveis
│   └── ...           # Telas específicas (Login, Novo Anúncio, etc.)
├── route_generator.dart # Gerenciamento centralizado de rotas
└── main.dart         # Ponto de entrada e configuração do tema
```

---

## ⚙️ Instalação e Execução

### Pré-requisitos
- Flutter SDK instalado.
- Um projeto configurado no Console do Firebase.

### Passos
1. **Clonar o repositório**:
   ```bash
   git clone https://github.com/seu-usuario/olx.git
   ```
2. **Instalar dependências**:
   ```bash
   flutter pub get
   ```
3. **Configuração do Firebase**:
   - Baixe o arquivo `google-services.json` (Android) e `GoogleService-Info.plist` (iOS) do seu console Firebase.
   - Coloque-os nas pastas correspondentes (`android/app/` e `ios/Runner/`).
   - *Nota: O arquivo `firebase_options.dart` deve ser gerado ou configurado manualmente.*
4. **Executar**:
   ```bash
   flutter run
   ```

---

## 🎨 Design System

O aplicativo utiliza um tema customizado definido em `lib/views/widgets/theme_data.dart`, garantindo consistência visual em todos os componentes, com foco na usabilidade e estética moderna.

---

## ⚖️ Licença

Este projeto está sob a licença [MIT](LICENSE).

---
*Desenvolvido com ❤️ por Miguel.*
