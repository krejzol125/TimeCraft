// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TimeCraft';

  @override
  String get appTitle => 'WeekCraft';

  @override
  String get languageToggle => 'Language';

  @override
  String get accountSettings => 'Account settings';

  @override
  String get signOut => 'Sign out';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePolish => 'Polish';

  @override
  String get undatedTasks => 'Undated tasks';

  @override
  String get noUndatedTasks => 'No undated tasks';

  @override
  String get newTask => 'New Task';

  @override
  String get createTask => 'Create Task';

  @override
  String get cancel => 'Cancel';

  @override
  String get back => 'Back';

  @override
  String get create => 'Create';

  @override
  String get next => 'Next';

  @override
  String get basics => 'Basics';

  @override
  String get schedule => 'Schedule';

  @override
  String get completion => 'Completion';

  @override
  String get description => 'Description';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get yesNo => 'Yes/No';

  @override
  String get quantity => 'Quantity';

  @override
  String get target => 'Target';

  @override
  String get unit => 'Unit';

  @override
  String get defaultUnit => 'pages';

  @override
  String get validationTitleRequired => 'Please enter a title.';

  @override
  String get validationEndAfterStart => 'End must be after start.';

  @override
  String get repeat => 'Repeat';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get interval => 'Interval';

  @override
  String get every => 'Every';

  @override
  String get limit => 'Limit';

  @override
  String get endDate => 'End date';

  @override
  String get occurrences => 'Occurrences';

  @override
  String get ends => 'Ends';

  @override
  String get never => 'Never';

  @override
  String get until => 'Until';

  @override
  String get count => 'Count';

  @override
  String intervalDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String intervalWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'weeks',
      one: 'week',
    );
    return '$_temp0';
  }

  @override
  String intervalMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'months',
      one: 'month',
    );
    return '$_temp0';
  }

  @override
  String intervalYears(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'years',
      one: 'year',
    );
    return '$_temp0';
  }

  @override
  String get weekdayMonShort => 'Mon';

  @override
  String get weekdayTueShort => 'Tue';

  @override
  String get weekdayWedShort => 'Wed';

  @override
  String get weekdayThuShort => 'Thu';

  @override
  String get weekdayFriShort => 'Fri';

  @override
  String get weekdaySatShort => 'Sat';

  @override
  String get weekdaySunShort => 'Sun';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get calendarMonth => 'Month';

  @override
  String get calendarWeek => 'Week';

  @override
  String get monthHint => 'Tap a day to see details.';

  @override
  String get ghostMove => 'Moving';

  @override
  String get ghostResize => 'Resizing';

  @override
  String get unscheduled => 'Unscheduled';

  @override
  String get completed => 'Completed';

  @override
  String get subtasks => 'Subtasks';

  @override
  String get details => 'Details';

  @override
  String get priority => 'Priority';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityUrgent => 'Urgent';

  @override
  String get reminders => 'Reminders';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get moveRecurringTask => 'Move recurring task';

  @override
  String get moveWhat => 'What do you want to move?';

  @override
  String get scopeOnlyThis => 'Only this occurrence';

  @override
  String get scopeOnlyThisSubtitle => 'Move just the one you dragged.';

  @override
  String get scopeThisAndFuture => 'This and future';

  @override
  String get scopeThisAndFutureSubtitle =>
      'Move this occurrence and all after it.';

  @override
  String get scopeEntireSeries => 'Entire series';

  @override
  String get scopeEntireSeriesSubtitle =>
      'Shift every occurrence in this series.';

  @override
  String get addSubtasksLabel => 'Subtasks';

  @override
  String get addSubtaskHint => 'Add subtask...';

  @override
  String get addSubtaskTooltip => 'Add subtask';

  @override
  String get addTagTooltip => 'Add a tag';

  @override
  String get titleLabel => 'Title';

  @override
  String get titleHint => 'e.g. Write report #work #urgent';

  @override
  String get titleHelper => 'You can add hashtags like #work or #urgent.';

  @override
  String get tagErrorEmpty => 'Hashtag \"#\" must have a name (e.g. #work).';

  @override
  String tagErrorInvalid(Object token) {
    return 'Tag \"#$token\" contains invalid characters. Allowed: a-z 0-9 _ / -';
  }

  @override
  String get dateTimeNotSet => 'Not set';
}
