import 'package:crud_en_flutter/modelos/cliente.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:crud_en_flutter/pantallas/message_response.dart';
import 'package:crud_en_flutter/pantallas/modify_contact.dart';
import 'package:crud_en_flutter/pantallas/register_contact.dart';
import 'package:crud_en_flutter/peticiones/cliente.peticion.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String _title;
  MyHomePage(this._title);
  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  // @override
  // void initState() {
  //   listClient().then((clientes) {
  //     for (var item in clientes) {
  //       print(item.id);
  //       print(item.name);
  //       print(item.surname);
  //       print(item.phone);
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget._title),
      ),
      body: getClients(context, listClient()),
      
      floatingActionButton: CupertinoButton(
        color: CupertinoColors.black,
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (_) => RegisterContact()))
              .then((newContact) {
            setState(() {
              messageResponse(
                  context, newContact.name + " se registro xd");
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getClients(BuildContext context, Future<List<Client>> futureClient) {
    return FutureBuilder(
      future: futureClient,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          //En este case estamos a la espera de la respuesta, mientras tanto mostraremos el cargando...
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());

          case ConnectionState.done:
            if (snapshot.hasError)
              return Container(
                alignment: Alignment.center,
                child: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            // print(snapshot.data);
            return snapshot.data != null
                ? clientList(snapshot.data)
                : Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text('Sin Datos'),
                    ),
                  );
          default:
            return Text('Recarga la pantalla....!');
        }
      },
    );
  }

  Widget clientList(List<Client> clients) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ModifyContact(clients[index])))
                .then((newContact) {
              setState(() {
                messageResponse(
                    context, newContact.name + " fue modificado");
              });
            });
          },
          onLongPress: () {
            removeClient(context, clients[index]);
          },
          title: Text(clients[index].name ?? ''), //?? verifica que no sea nulo, en caso de que sea la app se detiene
          subtitle: Text(clients[index].phone ?? ''), //?? verifica que no sea nulo, en caso de que sea la app se detiene
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(clients[index].name.substring(0, 1) ?? true), //solo muestra una letra
          ),
        );
      },
    );
  }

  removeClient(BuildContext context, Client client) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Eliminar Cliente"),
              content: Text("quieres eliminar a " + client.name + "?"),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      deleteClient(client.id).then((cliente) {
                        if (cliente.id != '') {
                          setState(() {});
                        }
                      });
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Eliminar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ));
  }
}
