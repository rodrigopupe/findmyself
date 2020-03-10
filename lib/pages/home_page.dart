import 'package:find_myself/model/user.dart';
import 'package:find_myself/pages/user_location_map_page.dart';
import 'package:find_myself/provider/user_location_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserLocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Find myself on the map'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<User>(
                stream: provider.outputUser,
                builder: (_, snapshot) {
                  var message = 'Pressione o botão para visualizar o mapa';
                  if (snapshot.hasData) {
                    var user = snapshot.data;
                    message =
                        "Você está no bairro ${user.neighborhood}, da cidade de ${user.city}, que fica no estado ${user.state} e no país ${user.country}";
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.map),
        onPressed: () {
          // Para que já busque a localização atual do usuário
          provider.updateAddressFromCoordinate(provider.currentPosition);

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => UserLocationMapPage(),
            ),
          );
          // Navigator.pop(context);
        },
      ),
    );
  }
}
