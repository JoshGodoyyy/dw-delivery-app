import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/app/pages/auth/register/register_controller.dart';
import 'package:delivery_app/app/pages/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/base_state/base_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final _formKey = GlobalKey<FormState>();

  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          register: () => showLoader(),
          error: () {
            hideLoader();
            showError('Erro ao registrar usuário');
          },
          success: () {
            hideLoader();
            showSuccess('Cadastro realizado com sucesso');
            Navigator.pop(context);
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppbar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cadastro',
                    style: context.textStyles.textTitle,
                  ),
                  Text(
                    'Preencha os campos abaixo para criar o seu cadastro.',
                    style: context.textStyles.textMedium.copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: Validatorless.required('Nome Obrigatório'),
                    controller: _nameEC,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: Validatorless.multiple([
                      Validatorless.required('E-mail obrigatório'),
                      Validatorless.email('E-mail inválido'),
                    ]),
                    controller: _emailEC,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: Validatorless.multiple([
                      Validatorless.required('Senha obrigatória'),
                      Validatorless.min(
                          6, 'A senha deve ter pelo menos 6 caracteres')
                    ]),
                    controller: _passwordEC,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: Validatorless.multiple([
                      Validatorless.required('Você precisa confirmar a senha'),
                      Validatorless.compare(
                          _passwordEC, 'As duas senhas precisam ser iguais')
                    ]),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar senha',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: DeliveryButton(
                      onPressed: () {
                        final valid =
                            _formKey.currentState?.validate() ?? false;
                        if (valid) {
                          controller.register(
                            _nameEC.text,
                            _emailEC.text,
                            _passwordEC.text,
                          );
                        }
                      },
                      label: 'CADASTRAR',
                      width: double.infinity,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
