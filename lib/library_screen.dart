import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

typedef MenuOption = void Function();

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) => print("Carregando: \$url"),
            onPageFinished: (url) => print("Carregado: \$url"),
            onWebResourceError: (error) => print("Erro: \${error.description}"),
          ),
        );
    }
  }

  void _openWebView(String url) async {
    if (kIsWeb) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      _controller.loadRequest(Uri.parse(url));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text("Navegador"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: WebViewWidget(controller: _controller),
          ),
        ),
      );
    }
  }

  void _navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biblioteca"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "logout") {
                // Implementar logout
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "settings",
                child: Text("Configurações"),
              ),
              PopupMenuItem(
                value: "logout",
                child: Text("Sair"),
              ),
            ],
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: Text("Usuário")),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ExpansionTile(
              leading: Icon(Icons.library_books),
              title: Text("Biblioteca"),
              children: [
                ListTile(
                  title: Text("Biblioteca Capes"),
                  onTap: () => _openWebView("https://www.periodicos.capes.gov.br/"),
                ),
                ListTile(
                  title: Text("Papervest Editora"),
                  onTap: () => _openWebView("https://drive.google.com/drive/folders/1EAF82kUC8_hsRxAlktCx8XaI7GA05Kaa"),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.notes),
              title: Text("Notas e Frequência"),
              onTap: () => _navigateTo("/grades"),
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text("O Que Vamos Estudar"),
              onTap: () => _navigateTo("/study_plan"),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[300]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _openWebView("https://www.periodicos.capes.gov.br/"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Biblioteca Capes"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _openWebView("https://drive.google.com/drive/folders/1EAF82kUC8_hsRxAlktCx8XaI7GA05Kaa"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Papervest Editora"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
