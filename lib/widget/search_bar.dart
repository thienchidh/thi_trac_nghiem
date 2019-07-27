import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

class SearchBar extends StatefulWidget {
  final Function performSearch;
  final Function performOpenDrawer;

  const SearchBar(
      {Key key, @required this.performSearch, @required this.performOpenDrawer})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  String mLocale = "vi_VN";

  final List<String> listSuggestions;
  _SearchAppBarDelegate _searchDelegate;

  _SearchBarState()
  //TODO
//      : listSuggestions = List.from(words.all),
      : listSuggestions = [],
        super();

  SpeechRecognition _speechRecognition;

  bool _isAvailable = false;
  bool _isListening = false;
  String _resultText = "";

  @override
  void initState() {
    super.initState();
    _searchDelegate = _SearchAppBarDelegate(listSuggestions, onVoice);
    _initSpeechRecognizer();
  }

  void _initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setRecognitionStartedHandler(() {
      print('setRecognitionStartedHandler._resultText =  $_resultText');
      setState(() => _isListening = true);
    });

    _speechRecognition.setRecognitionResultHandler(
      (String speech) {
        setState(() => _resultText = speech);
        print('setRecognitionResultHandler._resultText =  $_resultText');
      },
    );

    _speechRecognition.setRecognitionCompleteHandler(() {
      print('setRecognitionCompleteHandler._resultText =  $_resultText');
      setState(() => _isListening = false);
      widget.performSearch(_resultText);
    });

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black54,
              ),
              onPressed: () {
                widget.performOpenDrawer();
              },
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: _resultText,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isAvailable
                    ? !_isListening ? Icons.mic : Icons.cancel
                    : Icons.mic_off,
                color: Colors.black54,
              ),
              onPressed: () {
                onVoice();
              },
            ),
          ],
        ),
      ),
      onTap: () {
        _showSearchPage(context, _searchDelegate);
      },
    );
  }

  void onVoice() {
    print('_SearchBarState.onVoice');
    if (!_isListening) {
      setState(() => _isListening = true);
      _speechRecognition.listen(locale: mLocale);
    } else {
      setState(() => _isListening = false);
      _speechRecognition.stop();
    }
  }

  Future<void> _showSearchPage(
      BuildContext context, _SearchAppBarDelegate searchDelegate) async {
    final String selected = await showSearch<String>(
      context: context,
      delegate: searchDelegate,
      query: _resultText,
    );
    if (selected != null) {
      setState(() => _resultText = selected);
      widget.performSearch(_resultText);
    }
  }
}

class _SearchAppBarDelegate extends SearchDelegate<String> {
  List<String> _words;
  List<String> _history;

  final onVoiceCallback;

  _SearchAppBarDelegate(this._words, this.onVoiceCallback) {
    _history = _words;
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    Future.delayed(
      Duration(
        milliseconds: 1000,
      ),
    ).then((_) {
      _hideSearch(context, query);
    });
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        _hideSearch(context, null);
      },
    );
  }

  // Builds page to populate search results.
  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: const SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  void _hideSearch(BuildContext context, String query) {
    close(context, query);
  }

  // Suggestions list while typing search query - this.query.
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty
        ? _history
        : _words.where((word) => word.startsWith(query));

    return _SuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this._history.insert(0, suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.mic),
              tooltip: 'Voice input',
              onPressed: () {
                _hideSearch(context, null);
                onVoiceCallback();
              },
            ),
    ];
  }
}

// Suggestions list widget displayed in the search page.
class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(Icons.search),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
