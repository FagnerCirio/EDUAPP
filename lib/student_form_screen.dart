import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StudentFormScreen extends StatefulWidget {
  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _dateController = TextEditingController();
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final _cnpjMask = MaskTextInputFormatter(mask: '##.###.###/####-##');
  final _cepMask = MaskTextInputFormatter(mask: '#####-###');
  final _dateMask = MaskTextInputFormatter(mask: '##/##/####');

  bool _isCnpj = false;

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Cadastro de Alunos',
                  style: pw.TextStyle(fontSize: 24),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Nome: ${_nameController.text}'),
                pw.Text('CPF/CNPJ: ${_cpfCnpjController.text}'),
                pw.Text('Data de Nascimento: ${_dateController.text}'),
                pw.Text('CEP: ${_cepController.text}'),
                pw.Text('Rua: ${_streetController.text}'),
                pw.Text('Número: ${_numberController.text}'),
                pw.Text('Cidade: ${_cityController.text}'),
                pw.Text('Estado: ${_stateController.text}'),
              ],
            ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/cadastro_aluno.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PDF gerado em: ${file.path}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Alunos")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Cadastro de Alunos",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Digite o nome' : null,
              ),
              SwitchListTile(
                title: Text("É CNPJ?"),
                value: _isCnpj,
                onChanged: (val) {
                  setState(() {
                    _isCnpj = val;
                    _cpfCnpjController.clear();
                  });
                },
              ),
              TextFormField(
                controller: _cpfCnpjController,
                decoration: InputDecoration(
                  labelText: _isCnpj ? "CNPJ" : "CPF",
                ),
                inputFormatters: [
                  _isCnpj ? _cnpjMask : _cpfMask,
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Digite ${_isCnpj ? "o CNPJ" : "o CPF"}'
                            : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: "Data de Nascimento"),
                keyboardType: TextInputType.number,
                inputFormatters: [_dateMask],
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Digite a data de nascimento'
                            : null,
              ),
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: "CEP"),
                keyboardType: TextInputType.number,
                inputFormatters: [_cepMask],
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Digite o CEP' : null,
              ),
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(labelText: "Rua"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Digite a rua' : null,
              ),
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(labelText: "Número"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Digite o número'
                            : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: "Cidade"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Digite a cidade'
                            : null,
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: "Estado"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Digite o estado'
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _generatePdf();
                  }
                },
                icon: Icon(Icons.picture_as_pdf),
                label: Text("Gerar PDF"),
              ),
              SizedBox(height: 20),
              Text(
                "Desenvolvido por Fágner Berto Cirio e Diego Amaral 2025",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
