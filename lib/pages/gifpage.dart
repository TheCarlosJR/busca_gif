
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:busca_gif_aula/globals.dart';

class GifPage extends StatelessWidget {
  const GifPage({Key? key, required this.gifData}) : super(key: key);

  final Map gifData;
  static const double _fontSizeDef_ = 18;
  static const double _iconSizeDef_ = 64;


  Widget buildGifText(String txtLabel, Color txtColor)
  {
    if (txtLabel.isEmpty) {
      txtLabel = "?";
    }

    return Text(
      txtLabel,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: txtColor,
        fontSize: _fontSizeDef_,
      ),
    );
  }


  //mostra imagem de perfil de usuario
  Widget buildUserImage(String? urlUser) {

    if ((urlUser == null) || (urlUser.isEmpty)) {
      return const Icon(
          Icons.question_mark_rounded,
          size: _iconSizeDef_,
          color: fontCl_,
      );
    }

    return Image.network(
      urlUser,
      width: _iconSizeDef_,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBGCl_,
        centerTitle: true,
        title: const Text("Detalhes da imagem"),
      ),
      backgroundColor: bodyBGCl_,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                gifData["images"]["fixed_height"]["url"],
              ),
              const Divider(),

              IconButton(
                onPressed: () {
                  Share.share(gifData["images"]["fixed_height"]["url"]);
                },
                iconSize: _iconSizeDef_,
                icon: const Icon(
                  Icons.share_rounded,
                  color: fontCl_,
                ),
              ),
              const Divider(),

              buildGifText(
                gifData["title"] ?? "Sem título", fontCl_,
              ),
              const Divider(),

              buildGifText(
                "Upload:", Colors.amber
              ),
              buildGifText(
                gifData["import_datetime"] ?? "Data desconhecida", fontCl_,
              ),
              const Divider(),

              buildGifText(
                "Origem:", Colors.amber,
              ),
              buildGifText(
                gifData["source"] ?? "?", fontCl_,
              ),
              const Divider(),

              buildGifText(
                gifData["user"]?["username"] ?? "Usuário", Colors.amber,
              ),
              buildGifText(
                gifData["user"]?["profile_url"] ?? "Não definido", fontCl_,
              ),
              buildUserImage(gifData["user"]?["avatar_url"]),
            ],
          ),
        ),
      ),
    );
  }
}
