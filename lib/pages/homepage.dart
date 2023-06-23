
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:busca_gif_aula/globals.dart';
import 'package:busca_gif_aula/data.dart';
import 'package:busca_gif_aula/widget/color_circ_prog_ind.dart';
import 'package:busca_gif_aula/pages/gifpage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? _searchStr;
  final TextEditingController searchEdCtrl = TextEditingController();


  //evento onsubmitted
  void _onSubmittedSearch(String text) {
    setState(() {
      apiOffset = 0;
      apiPage = 1;
      _searchStr = text;
    });
  }


  //evento onpressed
  void _onPressedGifFrameItem(int index, BuildContext context, AsyncSnapshot snapshot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GifPage(gifData: snapshot.data?["data"][index]),
      ),
    );
  }


  //evento onlongpress
  void _onLongPressGifFrameItem(int index, AsyncSnapshot snapshot) {
    Share.share(snapshot.data?["data"][index]["images"]["fixed_height"]["url"]);
  }


  //evento onpressed
  void _onPressedNavIcons(bool right) {
    setState(() {
      if (right == true) {
        apiOffset += apiPageCount;
        apiPage++;
      }
      else if (apiPage > 1) {
        apiOffset -= apiPageCount;
        apiPage--;
      }
    });
  }


  //cria fundo de imagens
  Widget _buildGifBottom() {
    if (apiPage > 1) {
      return _buildGifBottomX();
    }
    else {
      return _buildGifBottom1();
    }
  }


  //cria fundo de imagens para pagina 1
  Widget _buildGifBottom1() {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const Text(
            "Primeira pagina",
            style: TextStyle(
              color: fontCl_,
              fontSize: 16,
            ),
          ),
          const Expanded(
            child: Divider(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(42),
              backgroundColor: const Color(0xFF111111),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Carregar mais imagens",
                  style: TextStyle(
                    color: fontCl_,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_circle_right,
                  color: fontCl_,
                  size: 32,
                ),
              ],
            ),
            onPressed: () {
              _onPressedNavIcons(true);
            },
          ),
        ],
      ),
    );
  }


  //cria botoes de navegacao de paginas
  Widget _buildGifNavIcons(bool right) {
    late IconData inIcon;

    if (right == true) {
      inIcon = Icons.arrow_circle_right;
    }
    else {
      inIcon = Icons.arrow_circle_left;
    }

    return IconButton(
      icon: Icon(
        inIcon,
        color: fontCl_,
      ),
      iconSize: 32,
      color: const Color(0xFF111111),
      onPressed: (){
        _onPressedNavIcons(right);
      },
    );
  }


  //cria fundo de imagens para pagina além da 1
  Widget _buildGifBottomX() {
    const double dist = 10;
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGifNavIcons(false),
          const SizedBox(width: dist),
          Text(
            "Pagina $apiPage",
            style: const TextStyle(
              color: fontCl_,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: dist),
          _buildGifNavIcons(true),
        ],
      ),
    );
  }


  //cria painel de imagens gif
  Widget _buildGifFrame(BuildContext context, AsyncSnapshot snapshot) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data?["data"].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCrossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot.data?["data"][index]["images"]["fixed_height"]["url"],
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    _onPressedGifFrameItem(index, context, snapshot);
                  },
                  onLongPress: () {
                    _onLongPressGifFrameItem(index, snapshot);
                  },
                );
              },
            ),
            _buildGifBottom(),
          ],
        ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBGCl_,
        title: Image.network(logoImgURL),
        centerTitle: true,
      ),
      backgroundColor: bodyBGCl_,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Buscar GIFs",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(2)
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.amberAccent,
              ),
              onSubmitted: _onSubmittedSearch,
              controller: searchEdCtrl,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getGifs(_searchStr),
              builder: (BuildContext context, AsyncSnapshot snapshot) {

                //verifica estado conexao
                switch(snapshot.connectionState) {

                  case ConnectionState.none: //conexao - esperando
                  case ConnectionState.waiting:

                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: ColorCircularProgressIndicator(), //CircularProgressIndicator();
                    );

                  //conexao - resposta padrao
                  default:

                    //se tem erros
                    if(snapshot.hasError) {
                      return const Text(
                        "ERRO: Não foi possível carregar!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                        ),
                      );
                    }

                    //se nenhum erro
                    else {
                      if (modoTESTE == true) {
                        print(snapshot.data ?? "[]");
                      }
                      return _buildGifFrame(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
