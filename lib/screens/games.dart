import 'package:flutter/material.dart';
import 'package:medicad/strings.dart';

int currentMoves = 0;
List<String> _board = ['', '', '', '', '', '', '', '', '']; //empty board
String status = '';
String winner = '';
var _gamePageState;
var _turnState;
var _context;
String _turn = 'First Move: X';
bool loading = false;
bool vsBot;

class GamesScreen extends StatefulWidget {
  GamesScreen() {
    _resetGame();
    vsBot = true;
    if (vsBot) _turn = 'First Move: O';
  }

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  @override
  Widget build(BuildContext context) {
    _gamePageState = this;

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.GAMES),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[200]),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_BoxContainer(), Status()],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            awaitfn('Reset?', 'Want to reset the current game?', 'Go Back',
                'Reset');
          });
        },
        tooltip: 'Restart',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class _BoxContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(color: Colors.blue),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue[100],
                  blurRadius: 20.0,
                  spreadRadius: 5.0,
                  offset: Offset(7.0, 7.0))
            ]),
        child: Center(
            child: GridView.count(
          primary: false,
          crossAxisCount: 3,
          children: List.generate(9, (index) {
            return Box(index);
          }),
        )));
  }
}

class Box extends StatefulWidget {
  final int index;
  Box(this.index);
  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  void pressed() {
    print(currentMoves);
    setState(() {
      currentMoves++;
      if (_checkGame()) {
        awaitfnn();
      } else if (currentMoves >= 9) {
        awaitfn('It\'s a Draw', 'Want to try again?', 'Go Back', 'New Game');
      }
      _turnState.setState(() {
        if (currentMoves % 2 == 0)
          _turn = 'Turn: O';
        else
          _turn = 'Turn: X';
        _gamePageState.setState(() {});
      });
    });
  }

  @override
  Widget build(context) {
    return MaterialButton(
        padding: EdgeInsets.all(0),
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: new Border.all(color: Colors.blue)),
            child: Center(
              child: Text(
                _board[widget.index].toUpperCase(),
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        onPressed: () {
          if (_board[widget.index] == '') {
            if (vsBot == false) {
              if (currentMoves % 2 == 0)
                _board[widget.index] = 'x';
              else
                _board[widget.index] = 'o';
            } else if (!loading) {
              loading = true;
              _board[widget.index] = 'o';
              if (currentMoves >= 8) {
              } else
                _bestMove(_board);
            }
            pressed();
          }
        });
  }
}

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    _turnState = this;
    return Card(
        margin: EdgeInsets.all(40),
        child: Container(
          width: 220,
          height: 60,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            _turn,
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ));
  }
}

// ------------------- TicTacToe game functions --------------------------------
bool _checkGame() {
  for (int i = 0; i < 9; i += 3) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 1] &&
        _board[i + 1] == _board[i + 2]) {
      winner = _board[i];
      return true;
    }
  }
  for (int i = 0; i < 3; i++) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 3] &&
        _board[i + 3] == _board[i + 6]) {
      winner = _board[i];
      return true;
    }
  }
  if (_board[0] != '' && (_board[0] == _board[4] && _board[4] == _board[8]) ||
      (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6])) {
    winner = _board[4];
    return true;
  }
  return false;
}

void _resetGame() {
  currentMoves = 0;
  status = '';
  _board = ['', '', '', '', '', '', '', '', ''];
  _turn = 'First Move: X';
  loading = false;
}

//------------------------------ Alerts Dialog --------------------------------------
void awaitfnn() async {
  if ('x' == winner) {
    winner = 'Bot';
  } else if ('0' == winner) {
    winner = 'You';
  }

  bool result = await _showAlertBox(
      _context, '$winner won!', 'Start a new Game?', 'Exit', 'New Game');
  if (result) {
    _gamePageState.setState(() {
      _resetGame();
    });
  } else {
    Navigator.pop(_context);
  }
}

Future<bool> _showAlertBox(BuildContext context, String title, String content,
    String btn1, String btn2) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _context) => AlertDialog(
            title: Text(title.toUpperCase()),
            content: Text(content),
            actions: <Widget>[
              ElevatedButton(
                child: Text(btn1),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ElevatedButton(
                child: Text(btn2),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ));
}

awaitfn(String title, String content, String btn1, String btn2) async {
  bool result = await _showAlertBox(_context, title, content, btn1, btn2);
  if (result) {
    _gamePageState.setState(() {
      _resetGame();
    });
  }
}

//------------------------------ MIN-MAX ------------------------------------------
int max(int a, int b) {
  return a > b ? a : b;
}

int min(int a, int b) {
  return a < b ? a : b;
}

String player = 'x', opponent = 'o';

bool isMovesLeft(List<String> _board) {
  int i;
  for (i = 0; i < 9; i++) {
    if (_board[i] == '') return true;
  }
  return false;
}

int _eval(List<String> _board) {
  for (int i = 0; i < 9; i += 3) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 1] &&
        _board[i + 1] == _board[i + 2]) {
      winner = _board[i];
      return (winner == player) ? 10 : -10;
    }
  }
  for (int i = 0; i < 3; i++) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 3] &&
        _board[i + 3] == _board[i + 6]) {
      winner = _board[i];
      return (winner == player) ? 10 : -10;
    }
  }
  if (_board[0] != '' && (_board[0] == _board[4] && _board[4] == _board[8]) ||
      (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6])) {
    winner = _board[4];
    return (winner == player) ? 10 : -10;
  }
  return 0;
}

int minmax(List<String> _board, int depth, bool isMax) {
  int score = _eval(_board);
  int best = 0, i;

  if (score == 10 || score == -10) return score;
  if (!isMovesLeft(_board)) return 0;
  if (isMax) {
    best = -1000;
    for (i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = player;
        best = max(best, minmax(_board, depth + 1, !isMax));
        _board[i] = '';
      }
    }
    return best;
  } else {
    best = 1000;
    for (i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = opponent;
        best = min(best, minmax(_board, depth + 1, !isMax));
        _board[i] = '';
      }
    }
    return best;
  }
}

int _bestMove(List<String> _board) {
  int bestMove = -1000, moveVal;
  int i, bi;
  for (i = 0; i < 9; i++) {
    if (_board[i] == '') {
      moveVal = -1000;
      _board[i] = player;
      moveVal = minmax(_board, 0, false);
      _board[i] = '';
      if (moveVal > bestMove) {
        bestMove = moveVal;
        bi = i;
      }
    }
  }
  _board[bi] = player;
  _gamePageState.setState(() {});
  loading = false;
  _turnState.setState(() {
    _turn = 'Turn: X';
    currentMoves++;
  });
  return bestMove;
}
