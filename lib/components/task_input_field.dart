import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/system_design/tc_text_field.dart';

class TaskInputParsed {
  final String raw;
  final String title;
  final List<String> tags;
  final String? error;

  const TaskInputParsed({
    required this.raw,
    required this.title,
    required this.tags,
    required this.error,
  });
}

final RegExp _tagMatch = RegExp(r'(^|\s)#([^\s#]*)');

final RegExp _allowedTagChars = RegExp(r'^[a-z0-9_/-]+$');

String _normTag(String t) => t.trim().toLowerCase();

TaskInputParsed parseTaskInputAdvanced(String text, AppLocalizations l10n) {
  final tags = <String>[];
  String? error;

  for (final m in _tagMatch.allMatches(text)) {
    final token = (m.group(2) ?? '');

    if (token.isEmpty) {
      error ??= l10n.tagErrorEmpty;
      continue;
    }

    final norm = _normTag(token);
    if (!_allowedTagChars.hasMatch(norm)) {
      error ??= l10n.tagErrorInvalid(token);
      continue;
    }
    tags.add(norm);
  }

  final title = text
      .replaceAllMapped(_tagMatch, (m) {
        final prefix = m.group(1) ?? '';
        return prefix.isEmpty ? ' ' : prefix;
      })
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  final seen = <String>{};
  final unique = <String>[];
  for (final t in tags) {
    if (seen.add(t)) unique.add(t);
  }

  return TaskInputParsed(raw: text, title: title, tags: unique, error: error);
}

class HashtagHighlightController extends TextEditingController {
  HashtagHighlightController({super.text});

  TextStyle baseStyle = const TextStyle(fontSize: 16);

  Color tagColor = const Color(0xFF2563EB);
  Color? tagBackground = const Color(0x332563EB);

  Color invalidColor = const Color(0xFF991B1B);
  Color? invalidBackground = const Color(0x33F87171);

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

      if (start > index) {
        spans.add(TextSpan(text: text.substring(index, start), style: base));
      }

      final prefix = m.group(1) ?? '';
      if (prefix.isNotEmpty) {
        spans.add(TextSpan(text: prefix, style: base));
      }

      final rawToken = (m.group(2) ?? '');
      final norm = _normTag(rawToken);
      final isValid = rawToken.isNotEmpty && _allowedTagChars.hasMatch(norm);

      spans.add(
        TextSpan(
          text: '#$norm',
          style: base.copyWith(
            color: isValid ? tagColor : invalidColor,
            fontWeight: FontWeight.w700,
            backgroundColor: isValid ? tagBackground : invalidBackground,
          ),
        ),
      );

      index = end;
    }

    if (index < text.length) {
      spans.add(TextSpan(text: text.substring(index), style: base));
    }

    return TextSpan(style: base, children: spans);
  }
}

class TaskInputAdvancedField extends StatefulWidget {
  const TaskInputAdvancedField({
    super.key,
    required this.availableTags,
    required this.onChanged,
    this.initialText,
    this.maxSuggestions = 6,
  });

  final List<String> availableTags;

  final void Function(TaskInputParsed parsed) onChanged;

  final String? initialText;
  final int maxSuggestions;

  @override
  State<TaskInputAdvancedField> createState() => _TaskInputAdvancedFieldState();
}

class _TaskInputAdvancedFieldState extends State<TaskInputAdvancedField> {
  late final HashtagHighlightController _controller;
  final FocusNode _focus = FocusNode();

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlay;

  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = HashtagHighlightController(text: widget.initialText ?? '');

    _controller.addListener(_onTextOrSelectionChanged);
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
      AppLocalizations.of(context)!,
    );
    setState(() => _errorText = parsed.error);
    widget.onChanged(parsed);
  }

  void _onTextOrSelectionChanged() {
    _emitParsed();

    if (!_focus.hasFocus) return;

    final query = _extractHashtagQueryAtCursor();
    if (query == null) {
      _hideOverlay();
      return;
    }

    final suggestions = _computeSuggestions(query);

    if (suggestions.isEmpty) {
      _hideOverlay();
    } else {
      _hideOverlay();
      _showOverlay(suggestions);
    }
  }

  String? _extractHashtagQueryAtCursor() {
    final pos = _controller.selection.baseOffset;

    final text = _controller.text;
    final left = text.substring(0, math.min(pos, text.length));

    final lastSpace = left.lastIndexOf(RegExp(r' '));
    final tokenStart = lastSpace + 1;

    final token = left.substring(tokenStart);
    if (!token.startsWith('#')) return null;

    final query = token.substring(1);
    return query;
  }

  List<String> _computeSuggestions(String query) {
    final q = query.toLowerCase();

    final base = widget.availableTags.map((t) => t.toLowerCase()).toList();

    final filtered = base.where((t) => q.isEmpty || t.startsWith(q)).toList();

    filtered.sort((a, b) {
      final da = (a.length - q.length).abs();
      final db = (b.length - q.length).abs();
      final c = da.compareTo(db);
      return c != 0 ? c : a.compareTo(b);
    });

    return filtered.take(widget.maxSuggestions).toList();
  }

  void _showOverlay(List<String> suggestions) {
    if (_overlay != null) {
      return;
    }

    _overlay = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideOverlay,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 56),
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
    final pos = _controller.selection.baseOffset;
    final text = _controller.text;

    final left = text.substring(0, pos);
    final right = text.substring(pos);

    final lastSpace = left.lastIndexOf(RegExp(r' '));
    final tokenStart = lastSpace == -1 ? 0 : lastSpace + 1;

    final beforeToken = left.substring(0, tokenStart);
    final token = left.substring(tokenStart);

    if (!token.startsWith('#')) return;

    final normalized = tag.toLowerCase();
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
    final l10n = AppLocalizations.of(context)!;
    final tagButton = IconButton(
      onPressed: () {
        int cursorPos = _controller.selection.baseOffset;
        if (cursorPos == -1) cursorPos = _controller.text.length;
        final text = _controller.text;
        final newText =
            "${text.substring(0, cursorPos)} #${text.substring(cursorPos)}";
        final newCursorPos = cursorPos + 2;

        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursorPos),
        );

        FocusScope.of(context).requestFocus(_focus);
      },
      icon: const Icon(Icons.tag),
      tooltip: l10n.addTagTooltip,
      color: Theme.of(context).colorScheme.primary,

      //label: const Text('Tag'),
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: TcTextField(
        controller: _controller,
        labelText: l10n.titleLabel,
        leading: const Icon(Icons.task_alt_outlined),
        trailing: tagButton,
        focusNode: _focus,
        errorText: _errorText,
        hintText: l10n.titleHint,
        helperText: l10n.titleHelper,
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
      separatorBuilder: (_, _) => const Divider(height: 1),
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
