import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tic tac toe'),
        ),
        body: const Center(
          child: Board(),
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final _arr = [0,0,0,0,0,0,0,0,0];
  int _turn = 1;
  final _arr2 = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
  ];
  static const _borderWidth = BorderSide(width: 5,color:Colors.blue);
  final _borders=[const Border(right:_borderWidth,bottom: _borderWidth), const Border(right: _borderWidth), const Border(bottom: _borderWidth), null];
  final _borderSides=[0,0,2,0,0,2,1,1,3];
  int _win = 0;
  double _top = 0;
  double _left = 0;
  double _angle = 0;
  double _slantWidth = 0;

  void _handleClick(index) {
    setState(() {
      if (_arr[index] == 0&&_win==0) {
        _arr[index] = _turn;
        _turn = 3 - _turn;
      }
      if(_win>0)return;
      for(var i=0;i<7;i+=3){
        if(_arr[i]!=0&&(_arr[i+1]==_arr[i]&&_arr[i+2]==_arr[i])){
          if(i!=3)_top=i==0?-70:72.5;
          _win = _turn;
          break;
        }
      }
      for(var i=0;i<3;i++){
        if(_arr[i]!=0&&(_arr[i+3]==_arr[i]&&_arr[i+6]==_arr[i])){
          _angle = 1.5708;
          if(i!=1)_left=i==0?-72.5:70;
          else _left=-2.5;
          _win = _turn;
          break;
        }
      }
      if(_arr[4]!=0){
        if((_arr[0]==_arr[4]&&_arr[4]==_arr[8])||(_arr[2]==_arr[4]&&_arr[4]==_arr[6])){
          _angle = (_arr[0]==_arr[8]&&_arr[0]==_arr[4])?0.7854:-0.7854;
          _slantWidth = 40.0;
          _win = _turn;
        }
      }
      for(var i=0;i<9;i++)if(_arr[i]==0||_win!=0)return;
      _win=3;
    });
  }

  void _resetBoard(){
    setState((){
      _turn=1;
      _arr.setAll(0, [0,0,0,0,0,0,0,0,0]);
      _win=0;
      _top = 0;
      _left = -2.5;
      _angle = 0;
      _slantWidth = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Text(
          "Tic Tac Toe",
          style: TextStyle(fontSize: 35),
        ),
      ),
      Stack(
        children:[
      Column(
          children: _arr2
              .map((eachRow) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: eachRow
                        .map((eachEle) => GestureDetector(
                            onTap: () => _handleClick(eachEle),
                            child: Container(
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(5),
                                border:_borders[_borderSides[eachEle]],
                              ),
                              width: 70,
                              height: 70,
                              // margin: const EdgeInsets.all(5.0),
                              child: Center(
                                child: _arr[eachEle]==0?const Text(''):_arr[eachEle]==1?const Icon(size:45,color:Colors.blue,Icons.close):const Icon(size:45,color:Colors.blue,Icons.panorama_fish_eye),
                              ),
                            )))
                        .toList(),
                  ))
              .toList()),
              if(_win!=0&&_win!=3)Positioned(left:(MediaQuery.of(context).size.width-210-_slantWidth)/2,top:-2.5,child: Container(width:210+_slantWidth,height: 210,child:Transform.translate(offset:Offset(_left,_top),child:Transform.rotate(angle: _angle, child:Divider(thickness: 5, color: Colors.black,)))))
              ]),
      Padding(
        padding:
            const EdgeInsets.only(top: 50),
        child: Text(
          _win<=0?_turn == 1 ? 'X\'s turn' : 'O\'s turn':_win==1?'O won':_win==2?'X won':'Draw',
          style: const TextStyle(fontSize: 35),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
          onPressed: _resetBoard,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.fromLTRB(18, 10, 18, 10)),
          child: const Text('Reset',style: TextStyle(fontSize: 15),),
        ),
      ),
      
    ]);
  }
}
