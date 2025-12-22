import 'dart:math' as math;
import 'package:flutter/material.dart';

class TaskInputParsed {
  final String raw;
  final String title; // tekst bez hashtagów
  final List<String> tags; // bez '#', unikalne, znormalizowane
  final String? error; // null jeśli ok

  const TaskInputParsed({
    required this.raw,
    required this.title,
    required this.tags,
    required this.error,
  });
}

/// Tag = # + token bez spacji i bez '#'
/// Łapiemy również poprzedzający whitespace (żeby zachować go w spanie)
final RegExp _tagMatch = RegExp(
  r'(^|\s)#([^\s#]*)',
); // drugi group może być pusty (do walidacji)

/// Dozwolone znaki w nazwie taga (po '#').
/// Zmień jeśli chcesz np. kropki.
final RegExp _allowedTagChars = RegExp(r'^[a-z0-9_/-]+$');

String _normTag(String t) => t.trim().toLowerCase();

TaskInputParsed parseTaskInputAdvanced(
  String text, {
  bool normalizeLowercase = true,
}) {
  final tags = <String>[];
  String? error;

  // wykryj tagi i waliduj
  for (final m in _tagMatch.allMatches(text)) {
    final token = (m.group(2) ?? '');

    // token pusty => "#"
    if (token.isEmpty) {
      // Jeśli user dopiero wpisuje, nie musisz od razu krzyczeć.
      // Ale wymóg: "blokuj # bez nazwy" => zwracamy błąd.
      error ??= 'Hashtag "#" must have a name (e.g. #work).';
      continue;
    }

    final norm = normalizeLowercase ? _normTag(token) : token.trim();
    if (!_allowedTagChars.hasMatch(norm)) {
      error ??=
          'Tag "#$token" contains invalid characters. Allowed: a-z 0-9 _ / -';
      continue;
    }
    tags.add(norm);
  }

  // title = tekst bez hashtagów, normalizacja spacji
  final title = text
      .replaceAllMapped(_tagMatch, (m) {
        // usuń cały match, ale zostaw pojedynczą spację jeśli była
        final prefix = m.group(1) ?? '';
        return prefix.isEmpty ? ' ' : prefix; // prefix jest whitespace
      })
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  // unikalne tagi w kolejności
  final seen = <String>{};
  final unique = <String>[];
  for (final t in tags) {
    if (seen.add(t)) unique.add(t);
  }

  return TaskInputParsed(raw: text, title: title, tags: unique, error: error);
}

class HashtagHighlightController extends TextEditingController {
  HashtagHighlightController({String? text}) : super(text: text);

  TextStyle baseStyle = const TextStyle(fontSize: 16);

  // wygląd taga (łatwy do edycji)
  Color tagColor = const Color(0xFF2563EB);
  Color? tagBackground = const Color(
    0x332563EB,
  ); // delikatne tło (możesz dać null)

  // błędny tag
  Color invalidColor = const Color(0xFF991B1B);
  Color? invalidBackground = const Color(0x33F87171);

  bool normalizeLowercase = true;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final base = (style ?? baseStyle);
    final text = value.text;
    if (text.isEmpty) return TextSpan(text: '', style: base);

    final spans = <InlineSpan>[];
    int index = 0;

    for (final m in _tagMatch.allMatches(text)) {
      final start = m.start;
      final end = m.end;

      // przed tagiem
      if (start > index) {
        spans.add(TextSpan(text: text.substring(index, start), style: base));
      }

      final prefix = m.group(1) ?? '';
      if (prefix.isNotEmpty) {
        spans.add(TextSpan(text: prefix, style: base));
      }

      final rawToken = (m.group(2) ?? '');
      final norm = normalizeLowercase ? _normTag(rawToken) : rawToken.trim();
      final isValid = rawToken.isNotEmpty && _allowedTagChars.hasMatch(norm);

      final shown = '#${normalizeLowercase ? norm : rawToken}';

      spans.add(
        TextSpan(
          text: shown,
          style: base.copyWith(
            color: isValid ? tagColor : invalidColor,
            fontWeight: FontWeight.w700,
            backgroundColor: isValid ? tagBackground : invalidBackground,
          ),
        ),
      );

      index = end;
    }

    // końcówka
    if (index < text.length) {
      spans.add(TextSpan(text: text.substring(index), style: base));
    }

    return TextSpan(style: base, children: spans);
  }
}

/// Główny widget: input + autocomplete + walidacja + parsing
class TaskInputAdvancedField extends StatefulWidget {
  const TaskInputAdvancedField({
    super.key,
    required this.availableTags,
    required this.onChanged,
    this.initialText,
    this.hintText = 'Np. Zrobić raport #work #pilne',
    this.normalizeLowercase = true,
    this.maxSuggestions = 6,
  });

  /// Lista znanych tagów do podpowiedzi (bez '#')
  final List<String> availableTags;

  /// Callback: dostajesz (raw, title, tags, error)
  final void Function(TaskInputParsed parsed) onChanged;

  final String? initialText;
  final String hintText;
  final bool normalizeLowercase;
  final int maxSuggestions;

  @override
  State<TaskInputAdvancedField> createState() => _TaskInputAdvancedFieldState();
}

class _TaskInputAdvancedFieldState extends State<TaskInputAdvancedField> {
  late final HashtagHighlightController _controller;
  final FocusNode _focus = FocusNode();

  // Overlay do autocomplete
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlay;

  //String? _activeQuery; // aktualnie wpisywane po '#'
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = HashtagHighlightController(text: widget.initialText ?? '')
      ..normalizeLowercase = widget.normalizeLowercase;

    _controller.addListener(_onTextOrSelectionChanged);
    // _focus.addListener(() {
    //   if (!_focus.hasFocus) _hideOverlay();
    //   _emitParsed(); // walidacja też przy blur
    // });

    //WidgetsBinding.instance.addPostFrameCallback((_) => _emitParsed());
  }

  @override
  void dispose() {
    _hideOverlay();
    _controller.removeListener(_onTextOrSelectionChanged);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _emitParsed() {
    final parsed = parseTaskInputAdvanced(
      _controller.text,
      normalizeLowercase: widget.normalizeLowercase,
    );
    setState(() => _errorText = parsed.error);
    widget.onChanged(parsed);
  }

  void _onTextOrSelectionChanged() {
    _emitParsed();

    if (!_focus.hasFocus) return;

    final query = _extractHashtagQueryAtCursor();
    if (query == null) {
      //_activeQuery = null;
      _hideOverlay();
      return;
    }

    //_activeQuery = query;
    final suggestions = _computeSuggestions(query);

    if (suggestions.isEmpty) {
      _hideOverlay();
    } else {
      _hideOverlay();
      _showOverlay(suggestions);
    }
  }

  /// Zwraca token po # w miejscu kursora, np. "wo" dla "#wo|"
  String? _extractHashtagQueryAtCursor() {
    final sel = _controller.selection;
    if (!sel.isValid) return null;
    final pos = sel.baseOffset;
    if (pos < 0) return null;

    final text = _controller.text;
    final left = text.substring(0, math.min(pos, text.length));

    // znajdź ostatni separator (whitespace)
    final lastWs = left.lastIndexOf(RegExp(r'\s'));
    final tokenStart = lastWs + 1;

    final token = left.substring(tokenStart); // od ostatniej spacji do kursora
    if (!token.startsWith('#')) return null;

    final query = token.substring(1); // po '#'
    // jeśli user ma samo "#", też pokaż podpowiedzi (query pusty)
    // ale walidacja i tak pokaże błąd jeśli zostawi to samo
    return query;
  }

  List<String> _computeSuggestions(String query) {
    final q = widget.normalizeLowercase ? query.toLowerCase() : query;

    final base = widget.availableTags
        .map((t) => widget.normalizeLowercase ? t.toLowerCase() : t)
        .toList();

    final filtered = base
        .where(
          (t) => _allowedTagChars.hasMatch(t) && (q.isEmpty || t.startsWith(q)),
        )
        .toList();

    filtered.sort((a, b) {
      // krótsze i bliższe prefiksowi wyżej
      final da = (a.length - q.length).abs();
      final db = (b.length - q.length).abs();
      final c = da.compareTo(db);
      return c != 0 ? c : a.compareTo(b);
    });

    return filtered.take(widget.maxSuggestions).toList();
  }

  void _showOverlay(List<String> suggestions) {
    if (_overlay != null) {
      _overlay!.markNeedsBuild();
      return;
    }

    _overlay = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Stack(
            children: [
              // klik poza -> zamknij
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideOverlay,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 56), // pod polem
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: _SuggestionsList(
                      suggestions: suggestions,
                      onPick: (tag) {
                        _applySuggestion(tag);
                        _hideOverlay();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
  }

  void _hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _applySuggestion(String tag) {
    // Zamień aktualny "#query" (od ostatniej spacji do kursora) na "#tag "
    final pos = _controller.selection.baseOffset;
    final text = _controller.text;

    final left = text.substring(0, pos);
    final right = text.substring(pos);

    final lastWs = left.lastIndexOf(RegExp(r' '));
    final tokenStart = lastWs == -1 ? 0 : lastWs + 1;

    final beforeToken = left.substring(0, tokenStart);
    final token = left.substring(tokenStart);

    if (!token.startsWith('#')) return;

    final normalized = widget.normalizeLowercase ? tag.toLowerCase() : tag;
    final replacement = '#$normalized ';

    final newText = '$beforeToken$replacement$right';
    final newCursor = (beforeToken.length + replacement.length);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        decoration: InputDecoration(
          hintText: widget.hintText,
          helperText: 'You can add hashtags like #work or #urgent.',
          errorText: _errorText,
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  const _SuggestionsList({required this.suggestions, required this.onPick});

  final List<String> suggestions;
  final void Function(String tag) onPick;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: suggestions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final t = suggestions[i];
        return ListTile(
          dense: true,
          leading: const Icon(Icons.tag, size: 18),
          title: Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
          onTap: () {
            onPick(t);
          },
        );
      },
    );
  }
}
