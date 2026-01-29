// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'TimeCraft';

  @override
  String get appTitle => 'WeekCraft';

  @override
  String get languageToggle => 'Język';

  @override
  String get undatedTasks => 'Zadania bez daty';

  @override
  String get noUndatedTasks => 'Brak zadań bez daty';

  @override
  String get newTask => 'Nowe zadanie';

  @override
  String get createTask => 'Utwórz zadanie';

  @override
  String get cancel => 'Anuluj';

  @override
  String get back => 'Wstecz';

  @override
  String get create => 'Utwórz';

  @override
  String get next => 'Dalej';

  @override
  String get basics => 'Podstawy';

  @override
  String get schedule => 'Harmonogram';

  @override
  String get completion => 'Wykonanie';

  @override
  String get description => 'Opis';

  @override
  String get start => 'Początek';

  @override
  String get end => 'Koniec';

  @override
  String get yesNo => 'Tak/Nie';

  @override
  String get quantity => 'Ilość';

  @override
  String get target => 'Cel';

  @override
  String get unit => 'Jednostka';

  @override
  String get defaultUnit => 'strony';

  @override
  String get validationTitleRequired => 'Podaj tytuł.';

  @override
  String get validationEndAfterStart => 'Koniec musi być po początku.';

  @override
  String get repeat => 'Powtarzanie';

  @override
  String get daily => 'Codziennie';

  @override
  String get weekly => 'Co tydzień';

  @override
  String get monthly => 'Co miesiąc';

  @override
  String get yearly => 'Co rok';

  @override
  String get interval => 'Interwał';

  @override
  String get every => 'Co';

  @override
  String get limit => 'Limit';

  @override
  String get endDate => 'Data zakończenia';

  @override
  String get occurrences => 'Wystąpienia';

  @override
  String get ends => 'Kończy się';

  @override
  String get never => 'Nigdy';

  @override
  String get until => 'Do';

  @override
  String get count => 'Ilość';

  @override
  String intervalDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dnia',
      many: 'dni',
      few: 'dni',
      one: 'dzień',
    );
    return '$_temp0';
  }

  @override
  String intervalWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tygodnia',
      many: 'tygodni',
      few: 'tygodnie',
      one: 'tydzień',
    );
    return '$_temp0';
  }

  @override
  String intervalMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miesiąca',
      many: 'miesięcy',
      few: 'miesiące',
      one: 'miesiąc',
    );
    return '$_temp0';
  }

  @override
  String intervalYears(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'roku',
      many: 'lat',
      few: 'lata',
      one: 'rok',
    );
    return '$_temp0';
  }

  @override
  String get weekdayMonShort => 'Pn';

  @override
  String get weekdayTueShort => 'Wt';

  @override
  String get weekdayWedShort => 'Śr';

  @override
  String get weekdayThuShort => 'Czw';

  @override
  String get weekdayFriShort => 'Pt';

  @override
  String get weekdaySatShort => 'Sob';

  @override
  String get weekdaySunShort => 'Nd';

  @override
  String get monthJanuary => 'Styczeń';

  @override
  String get monthFebruary => 'Luty';

  @override
  String get monthMarch => 'Marzec';

  @override
  String get monthApril => 'Kwiecień';

  @override
  String get monthMay => 'Maj';

  @override
  String get monthJune => 'Czerwiec';

  @override
  String get monthJuly => 'Lipiec';

  @override
  String get monthAugust => 'Sierpień';

  @override
  String get monthSeptember => 'Wrzesień';

  @override
  String get monthOctober => 'Październik';

  @override
  String get monthNovember => 'Listopad';

  @override
  String get monthDecember => 'Grudzień';

  @override
  String get calendarMonth => 'Miesiąc';

  @override
  String get calendarWeek => 'Tydzień';

  @override
  String get monthHint => 'Kliknij dzień, żeby zobaczyć szczegóły.';

  @override
  String get ghostMove => 'Przenoszenie';

  @override
  String get ghostResize => 'Rozciąganie';

  @override
  String get unscheduled => 'Bez terminu';

  @override
  String get completed => 'Ukończone';

  @override
  String get subtasks => 'Podzadania';

  @override
  String get details => 'Szczegóły';

  @override
  String get priority => 'Priorytet';

  @override
  String get priorityLow => 'Niski';

  @override
  String get priorityMedium => 'Średni';

  @override
  String get priorityHigh => 'Wysoki';

  @override
  String get priorityUrgent => 'Pilny';

  @override
  String get reminders => 'Przypomnienia';

  @override
  String get edit => 'Edytuj';

  @override
  String get close => 'Zamknij';

  @override
  String get moveRecurringTask => 'Przenieś zadanie cykliczne';

  @override
  String get moveWhat => 'Co chcesz przenieść?';

  @override
  String get scopeOnlyThis => 'Tylko to wystąpienie';

  @override
  String get scopeOnlyThisSubtitle => 'Przenieś tylko to, które przeciągnąłeś.';

  @override
  String get scopeThisAndFuture => 'To i przyszłe';

  @override
  String get scopeThisAndFutureSubtitle =>
      'Przenieś to wystąpienie i wszystkie późniejsze.';

  @override
  String get scopeEntireSeries => 'Cała seria';

  @override
  String get scopeEntireSeriesSubtitle =>
      'Przesuń wszystkie wystąpienia w tej serii.';

  @override
  String get addSubtasksLabel => 'Podzadania';

  @override
  String get addSubtaskHint => 'Dodaj podzadanie...';

  @override
  String get addSubtaskTooltip => 'Dodaj podzadanie';

  @override
  String get addTagTooltip => 'Dodaj tag';

  @override
  String get titleLabel => 'Tytuł';

  @override
  String get titleHint => 'Np. Zrobić raport #work #pilne';

  @override
  String get titleHelper => 'Możesz dodać hashtagi np. #work lub #pilne.';

  @override
  String get tagErrorEmpty => 'Hashtag \"#\" musi mieć nazwę (np. #work).';

  @override
  String tagErrorInvalid(Object token) {
    return 'Tag \"#$token\" zawiera nieprawidłowe znaki. Dozwolone: a-z 0-9 _ / -';
  }

  @override
  String get dateTimeNotSet => 'Nie ustawiono';
}
