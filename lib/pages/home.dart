import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../Provider/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../Models/data_model.dart' as GameDataModel;


const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ScrollController _scrollController = new ScrollController();
  int _page = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    var dataBloc = Provider.of<DataProvider>(context, listen: false);
    dataBloc.resetStreams();
    dataBloc.fetchAllUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        dataBloc.setLoadingState(LoadMoreStatus.LOADING);
        dataBloc.fetchAllUsers();
      }
    });
  }

// Used to logout user
  _setSharedPreferencesLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isloggedin', false);
    Navigator.pushReplacementNamed(context, "/");
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(

      // APPBAR
      appBar: AppBar(
        title: Text('Flyingwolf',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: Builder(
        builder: (context) =>
        Container(
          margin: const EdgeInsets.only(top:4),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Transform.rotate(
                angle: 180 * math.pi / 180,child: IconButton(icon: Icon(Icons.short_text ,color: Colors.black, size: 30,), onPressed: () => Scaffold.of(context).openDrawer(),)),
          ),
        ),
        ),
      ),


      // DRAWER
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              ListTile(
                title: const Text('Logout'),
                onTap: () async{
                  //
                  await _setSharedPreferencesLoggedOut();
                },
              ),

            ],
          ),
        ),



        // BODY
        body:
        Consumer<DataProvider>(
          builder: (context, usersModel, child) {
            if (usersModel.allUsers != null && usersModel.allUsers.length > 0) {
              return _listView(usersModel);
            }
            return Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LoadingIndicator(
              indicatorType: Indicator.pacman,
              colors: _kDefaultRainbowColors,
                  strokeWidth: 4.0,
              ),
            ));
          },
        ),



      )
    );
  }



  // Widget for the infinite scroll
  Widget _listView(DataProvider dataProvider) {
    return
      OrientationBuilder(
        builder: (context, orientation) {
        return ListView.builder(
          itemCount: dataProvider.allUsers.length+1,
          controller: _scrollController,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {


            // At the 0th index add user details
            if (index == 0)
              return Column(
                children: [

                  // AVATAR , NAME , RATING
                  Container(
                    color: Colors.white,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: orientation == Orientation.portrait?MainAxisAlignment.start:MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('images/simon.jpeg'),
                            radius: 50,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            Text("Simon Baker",
                              style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                            SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color:  Color.fromRGBO(67,106,255, 1),width: 1.5),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(30.0) //                 <--- border radius here
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 5,),
                                  Text("2250",
                                    style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color.fromRGBO(67,106,255, 1), ),),
                                  SizedBox(width: 10,),
                                  Text("Elo rating",
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:  Color.fromRGBO(121,133,160, 1)),),
                                  SizedBox(width: 20,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),



                  // TOURNAMENT DETAILS
                  Container(
                    height: 100,
                    constraints: BoxConstraints(maxWidth: 600),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(

                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [ Color.fromRGBO(227,119,1, 1),Color.fromRGBO(237,168,0, 1)]),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),

                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("34",style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),),
                                Text("Tournaments Played",style: TextStyle(color: Colors.white, fontSize: 18),textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width:1),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(

                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [ Color.fromRGBO(68,34,151, 1),Color.fromRGBO(165,84,191, 1)]),


                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("09",style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),),
                                Text("Tournaments won",style: TextStyle(color: Colors.white, fontSize: 18),textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width:1),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(

                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [ Color.fromRGBO(237,83,68, 1),Color.fromRGBO(238,127,77, 1)]),


                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: Colors.pink
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("26%",style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),),
                                Text("Winning percentage",style: TextStyle(color: Colors.white, fontSize: 18),textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                  // RECOMMENDATIONS
                  SizedBox(height: 10),
                  Container(
                    width: 700,
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Recommended for you',style: TextStyle(color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold),),
                  ),

                ],
              );





            if ((index == dataProvider.allUsers.length - 1) &&
                dataProvider.allUsers.length < dataProvider.totalRecords) {
              return Center(child: LoadingIndicator(
                indicatorType: Indicator.pacman,
                colors: _kDefaultRainbowColors,
                strokeWidth: 4.0,
              ),
              );
            }

            // INFINITE LISTVIEW
            if(index == dataProvider.allUsers.length){// declare the boolean and return loading indicator
              return dataProvider.getLoadMoreStatus()==LoadMoreStatus.LOADING?Container(

                    child:Center(child: CircularProgressIndicator())):Container();
            }

            // The GAME CARD
            return _buildCard(dataProvider.allUsers[index]);
          },

        );
  },
      );
  }






  // Widget for the game card
  Widget _buildCard(GameDataModel.GameData gameData) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 15.0),
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(

              height: 140,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: NetworkImage( gameData.coverUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.bottomCenter,
                  children: [

                    Container(
                      height: 60,
                      alignment: Alignment.bottomCenter,
                      color: Colors.white,
                      child:    Row(
                        // mainAxisAlignment: MainAxisAlignment.,
                        children: [
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    gameData.name,style:TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                                SizedBox(height: 10,),
                                Text(
                                    gameData.gameName,style: TextStyle(color: Colors.black, fontSize: 14), overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          ),
                         IconButton(icon: Icon(Icons.chevron_right ,color: Colors.black38, size: 30,), onPressed: () => {}),
                        ],
                      ),
                    )
                  ]
              ),
            )
        )
    );

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

}
