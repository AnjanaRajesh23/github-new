import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class ChessGamePage extends StatefulWidget {
  final String accessToken;

  ChessGamePage({required this.accessToken});

  @override
  _ChessGamePageState createState() => _ChessGamePageState();
}

class _ChessGamePageState extends State<ChessGamePage> {
  final ChessBoardController _controller = ChessBoardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chess Game')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChessBoard(
            controller: _controller,
            boardColor: BoardColor.brown,
            boardOrientation: PlayerColor.white,
            enableUserMoves: true,
          ),
          SizedBox(height: 20),
          Text(
            "Access Token: ${widget.accessToken.substring(0, 10)}...",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
