import 'package:chat_application/contans/app_png_logo.dart';
import 'package:chat_application/screens/chat_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              child: SizedBox(
                height: 80,
                child: Center(
                  child: ListTile(
                    onTap: () {
                      print("print List Tile");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatView(userName: "Mukesh Kachhawaha"),
                          ));
                    },
                    leading: Image.asset(AppPngLogo.profile),
                    title: Text("Mukesh Kach"),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
