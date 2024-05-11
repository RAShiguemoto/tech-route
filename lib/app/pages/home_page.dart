import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_route/app/controller/home_page_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Tech Route",
            style:
                TextStyle(color: Color.fromARGB(255, 33, 35, 38), fontSize: 16),
          ),
        ),
        backgroundColor: Colors.amber[600],
      ),
      body: MyBody(formKey),
      bottomNavigationBar: MyBottomNavigatorBar(),
    );
  }
}

class MyBody extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const MyBody(this.formKey, {super.key});

  @override
  State<MyBody> createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  @override
  Widget build(BuildContext context) {
    final homePageController = context.watch<HomePageController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              key: widget.formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Image.asset('assets/images/home_page.png'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: homePageController.tecnologiaEstudo,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe uma tecnologia para estudo!';
                      }
                      return null;
                    },
                    onSaved: (newValue) =>
                        homePageController.tecnologiaEstudo = newValue,
                    decoration: const InputDecoration(
                      labelText: 'Tecnologias:',
                      hintText: 'Ex: Java, JPA, Spring Boot ...',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.amber[600],
                      elevation: 3,
                    ),
                    onPressed: () {
                      if (widget.formKey.currentState?.validate() ?? false) {
                        widget.formKey.currentState?.save();
                        homePageController.criarNovaPratica(context);
                      }
                    },
                    child: const Text(
                      'Criar Nova Prática',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBottomNavigatorBar extends StatefulWidget {
  const MyBottomNavigatorBar({super.key});

  @override
  State<MyBottomNavigatorBar> createState() => _MyBottomNavigatorBarState();
}

class _MyBottomNavigatorBarState extends State<MyBottomNavigatorBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.amber[600],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('praticas');
        },
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.library_books,
                size: 35,
                color: const Color.fromARGB(255, 33, 35, 38),
              ),
              Text(
                'Visualizar Práticas',
                style: TextStyle(color: const Color.fromARGB(255, 33, 35, 38)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
