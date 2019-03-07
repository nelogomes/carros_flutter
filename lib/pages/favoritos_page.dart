
import 'package:carros/domain/carro.dart';
import 'package:carros/domain/db/CarroDB.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:carros/firebase/favorito_service.dart';
import 'package:carros/pages/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/carros_listView.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {

    //Banco de Dados
    //Future<List<Carro>> future = CarroDB.getInstance().getCarros();

    final service = FavoritoService();

    return Container(
      padding: EdgeInsets.all(12),
      child: StreamBuilder<QuerySnapshot>(
        stream: service.getCarros(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

//            final List<Carro> carros = snapshot.data;
            List<Carro> carros = snapshot.data.documents
                .map((document) => Carro.fromJson(document.data) )
                .toList();

            return CarrosListView(carros);
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Sem dados",style: TextStyle(
                  color: Colors.grey,
                  fontSize: 26,
                  fontStyle: FontStyle.italic
              ),),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }


}
