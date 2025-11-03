import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MathShow'**
  String get appTitle;

  /// No description provided for @players_title.
  ///
  /// In en, this message translates to:
  /// **'Choose player'**
  String get players_title;

  /// No description provided for @players_list.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players_list;

  /// No description provided for @label_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get label_language;

  /// No description provided for @label_mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get label_mode;

  /// No description provided for @mode_multiplication.
  ///
  /// In en, this message translates to:
  /// **'Multiplication'**
  String get mode_multiplication;

  /// No description provided for @difficulty_fmt.
  ///
  /// In en, this message translates to:
  /// **'Difficulty: level {level}/10'**
  String difficulty_fmt(int level);

  /// No description provided for @btn_switch.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get btn_switch;

  /// No description provided for @home_player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get home_player;

  /// No description provided for @home_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get home_level;

  /// No description provided for @home_hints.
  ///
  /// In en, this message translates to:
  /// **'Hints'**
  String get home_hints;

  /// No description provided for @home_changeOrAdd.
  ///
  /// In en, this message translates to:
  /// **'Choose / Add'**
  String get home_changeOrAdd;

  /// No description provided for @home_play.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get home_play;

  /// No description provided for @home_stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get home_stats;

  /// No description provided for @home_choose_player_hint.
  ///
  /// In en, this message translates to:
  /// **'Practice a little every day.\nStart slowly, prioritize accuracy 🙂'**
  String get home_choose_player_hint;

  /// No description provided for @play_title.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get play_title;

  /// No description provided for @play_chooseType.
  ///
  /// In en, this message translates to:
  /// **'Choose a training type:'**
  String get play_chooseType;

  /// No description provided for @play_multiplication.
  ///
  /// In en, this message translates to:
  /// **'Times Table (×)'**
  String get play_multiplication;

  /// No description provided for @mult_select_title.
  ///
  /// In en, this message translates to:
  /// **'Train multiplication'**
  String get mult_select_title;

  /// No description provided for @mult_choose_table.
  ///
  /// In en, this message translates to:
  /// **'Pick the table you want to study:'**
  String get mult_choose_table;

  /// No description provided for @mult_errors.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get mult_errors;

  /// No description provided for @mult_random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get mult_random;

  /// No description provided for @mult_random_title.
  ///
  /// In en, this message translates to:
  /// **'Random training'**
  String get mult_random_title;

  /// No description provided for @mult_random_desc.
  ///
  /// In en, this message translates to:
  /// **'Choose the range of tables to shuffle. E.g., 2 to 10. You can also use bigger ranges (11..20).'**
  String get mult_random_desc;

  /// No description provided for @tip_footnote1.
  ///
  /// In en, this message translates to:
  /// **'• “Missed” focuses on the pairs you missed most (e.g., 7×5).'**
  String get tip_footnote1;

  /// No description provided for @tip_footnote2.
  ///
  /// In en, this message translates to:
  /// **'• “Random” shuffles tables within your chosen range.'**
  String get tip_footnote2;

  /// No description provided for @tip_footnote3.
  ///
  /// In en, this message translates to:
  /// **'• Each round has 10 questions and records your history.'**
  String get tip_footnote3;

  /// No description provided for @mult_session_title.
  ///
  /// In en, this message translates to:
  /// **'Table of {table} ({current} / {total})'**
  String mult_session_title(int table, int current, int total);

  /// No description provided for @hits_fmt.
  ///
  /// In en, this message translates to:
  /// **'Hits: {hits}/{round}'**
  String hits_fmt(Object hits, Object round);

  /// No description provided for @time_secs_fmt.
  ///
  /// In en, this message translates to:
  /// **'Time: {secs} s'**
  String time_secs_fmt(Object secs);

  /// No description provided for @mult_choose_before_timeout.
  ///
  /// In en, this message translates to:
  /// **'Choose the answer before time runs out!'**
  String get mult_choose_before_timeout;

  /// No description provided for @howto_title.
  ///
  /// In en, this message translates to:
  /// **'How to think about this:'**
  String get howto_title;

  /// No description provided for @howto_repeat_addition.
  ///
  /// In en, this message translates to:
  /// **'💡 Think as repeated addition:'**
  String get howto_repeat_addition;

  /// No description provided for @howto_step_by_step.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step example:'**
  String get howto_step_by_step;

  /// No description provided for @howto_doubling_helps.
  ///
  /// In en, this message translates to:
  /// **'💡 Doubling helps:'**
  String get howto_doubling_helps;

  /// No description provided for @mult_tips_title.
  ///
  /// In en, this message translates to:
  /// **'📚 Times table tips:'**
  String get mult_tips_title;

  /// No description provided for @summary_label.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary_label;

  /// No description provided for @btnContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get btnContinue;

  /// No description provided for @btnClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btnClose;

  /// No description provided for @btnExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get btnExit;

  /// No description provided for @btn_see_hint.
  ///
  /// In en, this message translates to:
  /// **'See hint'**
  String get btn_see_hint;

  /// No description provided for @no_hints_left.
  ///
  /// In en, this message translates to:
  /// **'You have no hints left.'**
  String get no_hints_left;

  /// No description provided for @hint_tooltip_fmt.
  ///
  /// In en, this message translates to:
  /// **'Hint ({count})'**
  String hint_tooltip_fmt(int count);

  /// No description provided for @wrong_title.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer'**
  String get wrong_title;

  /// No description provided for @wrong_explain_fmt.
  ///
  /// In en, this message translates to:
  /// **'The correct answer is {correct} because {a} × {b} = {correct}.\n\nDo you want to see how to get this result step by step?'**
  String wrong_explain_fmt(int a, int b, int correct);

  /// No description provided for @quit_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit_tooltip;

  /// No description provided for @quit_title.
  ///
  /// In en, this message translates to:
  /// **'End training?'**
  String get quit_title;

  /// No description provided for @quit_content.
  ///
  /// In en, this message translates to:
  /// **'If you exit now, this round will end before 10 questions.'**
  String get quit_content;

  /// No description provided for @quit_keep_playing.
  ///
  /// In en, this message translates to:
  /// **'Keep playing'**
  String get quit_keep_playing;

  /// No description provided for @result_title.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get result_title;

  /// No description provided for @result_performance_title.
  ///
  /// In en, this message translates to:
  /// **'Your performance'**
  String get result_performance_title;

  /// No description provided for @score_fmt.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total} correct'**
  String score_fmt(int correct, int total);

  /// No description provided for @praise_perfect.
  ///
  /// In en, this message translates to:
  /// **'Excellent! You got them all 👏'**
  String get praise_perfect;

  /// No description provided for @praise_good.
  ///
  /// In en, this message translates to:
  /// **'Great job! Keep practicing 👌'**
  String get praise_good;

  /// No description provided for @praise_try_more.
  ///
  /// In en, this message translates to:
  /// **'It\'s okay to miss 🙂 Let\'s practice a bit more.'**
  String get praise_try_more;

  /// No description provided for @play_again.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get play_again;

  /// No description provided for @back_home.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get back_home;

  /// No description provided for @no_answer.
  ///
  /// In en, this message translates to:
  /// **'— (no answer)'**
  String get no_answer;

  /// No description provided for @attempt_question_fmt.
  ///
  /// In en, this message translates to:
  /// **'Question {number}: {qText}'**
  String attempt_question_fmt(int number, Object qText);

  /// No description provided for @you_answered_fmt.
  ///
  /// In en, this message translates to:
  /// **'You answered: {answer}'**
  String you_answered_fmt(Object answer);

  /// No description provided for @correct_fmt.
  ///
  /// In en, this message translates to:
  /// **'Correct: {answer}'**
  String correct_fmt(Object answer);

  /// No description provided for @howto_repeat_addition_explain_fmt.
  ///
  /// In en, this message translates to:
  /// **'{a} × {b} means add {b} a total of {a} times (or add {a} a total of {b} times).'**
  String howto_repeat_addition_explain_fmt(int a, int b);

  /// No description provided for @howto_step_continue_fmt.
  ///
  /// In en, this message translates to:
  /// **'…and we reach {result}.'**
  String howto_step_continue_fmt(int result);

  /// No description provided for @howto_nine_trick_title.
  ///
  /// In en, this message translates to:
  /// **'💡 9-times table trick:'**
  String get howto_nine_trick_title;

  /// No description provided for @howto_nine_trick_explain_fmt.
  ///
  /// In en, this message translates to:
  /// **'9 × {n} = (10 × {n}) − {n} = {tenTimes} − {n} = {minusOther}'**
  String howto_nine_trick_explain_fmt(int n, int tenTimes, int minusOther);

  /// No description provided for @tip_zero_property.
  ///
  /// In en, this message translates to:
  /// **'0×N = 0; N×0 = 0.'**
  String get tip_zero_property;

  /// No description provided for @tip_one_property.
  ///
  /// In en, this message translates to:
  /// **'1×N = N; N×1 = N.'**
  String get tip_one_property;

  /// No description provided for @tip_table_2_fmt.
  ///
  /// In en, this message translates to:
  /// **'×2: just double it. E.g., 2 × {other} = {other} + {other}.'**
  String tip_table_2_fmt(int other);

  /// No description provided for @tip_table_3.
  ///
  /// In en, this message translates to:
  /// **'×3: think of adding 3 each time: 3, 6, 9, 12, 15, 18…'**
  String get tip_table_3;

  /// No description provided for @tip_table_4.
  ///
  /// In en, this message translates to:
  /// **'×4: double twice. E.g., 4 × n = (2 × n) × 2.'**
  String get tip_table_4;

  /// No description provided for @tip_table_5.
  ///
  /// In en, this message translates to:
  /// **'×5: ends with 0 or 5 (even → 0, odd → 5).'**
  String get tip_table_5;

  /// No description provided for @tip_table_6_fmt.
  ///
  /// In en, this message translates to:
  /// **'×6: think 5 × {other} + {other}.'**
  String tip_table_6_fmt(int other);

  /// No description provided for @tip_table_7_fmt.
  ///
  /// In en, this message translates to:
  /// **'×7: think 5 × {other} + 2 × {other}.'**
  String tip_table_7_fmt(int other);

  /// No description provided for @tip_table_8_fmt.
  ///
  /// In en, this message translates to:
  /// **'×8: double the double. E.g., 8 × {other} = (4 × {other}) × 2.'**
  String tip_table_8_fmt(int other);

  /// No description provided for @tip_table_9_note.
  ///
  /// In en, this message translates to:
  /// **'×9: the sum of the digits often equals 9 (e.g., 9×4=36 → 3+6=9).'**
  String get tip_table_9_note;

  /// No description provided for @tip_table_10_fmt.
  ///
  /// In en, this message translates to:
  /// **'×10: just append a zero. E.g., 10 × {other} = {other}0.'**
  String tip_table_10_fmt(int other);

  /// No description provided for @errors_need_active_player.
  ///
  /// In en, this message translates to:
  /// **'Activate a player to train your mistakes.'**
  String get errors_need_active_player;

  /// No description provided for @errors_not_enough.
  ///
  /// In en, this message translates to:
  /// **'We don’t have enough mistakes yet.\nPlay a few rounds first 😉'**
  String get errors_not_enough;

  /// No description provided for @label_from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get label_from;

  /// No description provided for @label_to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get label_to;

  /// No description provided for @word_to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get word_to;

  /// No description provided for @btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btn_cancel;

  /// No description provided for @btn_play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get btn_play;

  /// No description provided for @players_add_title.
  ///
  /// In en, this message translates to:
  /// **'New player'**
  String get players_add_title;

  /// No description provided for @players_info.
  ///
  /// In en, this message translates to:
  /// **'Each player can have their own language, preferred mode, and difficulty (1 to 10). This helps adults tailor practice without mixing kids\' progress.'**
  String get players_info;

  /// No description provided for @players_new.
  ///
  /// In en, this message translates to:
  /// **'New player'**
  String get players_new;

  /// No description provided for @players_current.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get players_current;

  /// No description provided for @tooltip_activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get tooltip_activate;

  /// No description provided for @tooltip_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get tooltip_edit;

  /// No description provided for @tooltip_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tooltip_delete;

  /// No description provided for @label_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get label_name;

  /// No description provided for @name_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Ana, John...'**
  String get name_hint;

  /// No description provided for @difficulty_hint.
  ///
  /// In en, this message translates to:
  /// **'Difficulty (1 easy, 10 fast)'**
  String get difficulty_hint;

  /// No description provided for @save_player.
  ///
  /// In en, this message translates to:
  /// **'Save player'**
  String get save_player;

  /// No description provided for @players_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit player'**
  String get players_edit_title;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save_changes;

  /// No description provided for @players_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete player'**
  String get players_delete_title;

  /// No description provided for @players_delete_confirm_fmt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \'{name}\'? This cannot be undone.'**
  String players_delete_confirm_fmt(Object name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @lang_portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get lang_portuguese;

  /// No description provided for @lang_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get lang_english;

  /// No description provided for @lang_spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get lang_spanish;

  /// No description provided for @mode_addition.
  ///
  /// In en, this message translates to:
  /// **'Addition'**
  String get mode_addition;

  /// No description provided for @mode_subtraction.
  ///
  /// In en, this message translates to:
  /// **'Subtraction'**
  String get mode_subtraction;

  /// No description provided for @mode_division.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get mode_division;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_body.
  ///
  /// In en, this message translates to:
  /// **'Coming soon:\n• Choose interface language\n• Pedagogical settings\n• Default difficulty\n'**
  String get settings_body;

  /// No description provided for @stats_title.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats_title;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @stats_no_player_hint.
  ///
  /// In en, this message translates to:
  /// **'No active player.\nChoose or create a player.'**
  String get stats_no_player_hint;

  /// No description provided for @stats_player_fmt.
  ///
  /// In en, this message translates to:
  /// **'Player: {name}'**
  String stats_player_fmt(Object name);

  /// No description provided for @stats_overall.
  ///
  /// In en, this message translates to:
  /// **'Overall summary'**
  String get stats_overall;

  /// No description provided for @stats_total_questions_fmt.
  ///
  /// In en, this message translates to:
  /// **'Total questions: {total}'**
  String stats_total_questions_fmt(int total);

  /// No description provided for @hits_only_fmt.
  ///
  /// In en, this message translates to:
  /// **'Hits: {hits}'**
  String hits_only_fmt(int hits);

  /// No description provided for @stats_success_rate_na.
  ///
  /// In en, this message translates to:
  /// **'Success rate: —'**
  String get stats_success_rate_na;

  /// No description provided for @stats_success_rate_fmt.
  ///
  /// In en, this message translates to:
  /// **'Success rate: {percent}'**
  String stats_success_rate_fmt(Object percent);

  /// No description provided for @stats_by_table.
  ///
  /// In en, this message translates to:
  /// **'By table'**
  String get stats_by_table;

  /// No description provided for @stats_by_table_empty.
  ///
  /// In en, this message translates to:
  /// **'We don’t have per-table data yet.\nPlay a round!'**
  String get stats_by_table_empty;

  /// No description provided for @stats_hits_over_total_percent_fmt.
  ///
  /// In en, this message translates to:
  /// **'Hits: {hits}/{total} ({percent})'**
  String stats_hits_over_total_percent_fmt(int hits, int total, Object percent);

  /// No description provided for @play_addition.
  ///
  /// In en, this message translates to:
  /// **'Addition (＋)'**
  String get play_addition;

  /// No description provided for @add_select_title.
  ///
  /// In en, this message translates to:
  /// **'Train addition'**
  String get add_select_title;

  /// No description provided for @add_parcels_label.
  ///
  /// In en, this message translates to:
  /// **'Addends'**
  String get add_parcels_label;

  /// No description provided for @add_level_label.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get add_level_label;

  /// No description provided for @add_decimals_label.
  ///
  /// In en, this message translates to:
  /// **'Include decimals'**
  String get add_decimals_label;

  /// No description provided for @add_decimal_places_label.
  ///
  /// In en, this message translates to:
  /// **'Places (1–9)'**
  String get add_decimal_places_label;

  /// No description provided for @add_play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get add_play;

  /// No description provided for @addFillAll.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get addFillAll;

  /// No description provided for @addCorrectTitle.
  ///
  /// In en, this message translates to:
  /// **'All correct!'**
  String get addCorrectTitle;

  /// No description provided for @addFeedbackOk.
  ///
  /// In en, this message translates to:
  /// **'Nice job! Your sum is correct.'**
  String get addFeedbackOk;

  /// No description provided for @add_new_problem.
  ///
  /// In en, this message translates to:
  /// **'New problem'**
  String get add_new_problem;

  /// No description provided for @addIncorrectTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your work'**
  String get addIncorrectTitle;

  /// No description provided for @addFeedbackWrongFmt.
  ///
  /// In en, this message translates to:
  /// **'At column {col}, the subtotal was {subtotal}. Expected digit is {expDigit} and carry is {expCarry}.'**
  String addFeedbackWrongFmt(int col, int subtotal, int expDigit, int expCarry);

  /// No description provided for @addGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Addition'**
  String get addGameTitle;

  /// No description provided for @addPlusSignHint.
  ///
  /// In en, this message translates to:
  /// **'The \'+\' sign marks addition.'**
  String get addPlusSignHint;

  /// No description provided for @addVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get addVerify;

  /// No description provided for @add_level_header_fmt.
  ///
  /// In en, this message translates to:
  /// **'Level {level} (10^{pow})'**
  String add_level_header_fmt(int level, int pow);

  /// No description provided for @addLevelItemFmt.
  ///
  /// In en, this message translates to:
  /// **'Level {n}'**
  String addLevelItemFmt(int n);

  /// No description provided for @add_level_mapping_hint.
  ///
  /// In en, this message translates to:
  /// **'Mapping: 1→10², 2→10³, 3→10⁴, 4→10⁵, 5→10⁶.'**
  String get add_level_mapping_hint;

  /// No description provided for @add_decimals_hint.
  ///
  /// In en, this message translates to:
  /// **'When enabled, it always uses 2 decimal places.'**
  String get add_decimals_hint;

  /// No description provided for @legendPlaces.
  ///
  /// In en, this message translates to:
  /// **'Legend: u=unit, t=ten, h=hundred, th=thousand, t.th=ten-thousand, h.th=hundred-thousand, m=million, t.m=ten-million, h.m=hundred-million, b=billion.'**
  String get legendPlaces;

  /// No description provided for @legendDecimalSepFmt.
  ///
  /// In en, this message translates to:
  /// **'Decimal separator: \"{sep}\"'**
  String legendDecimalSepFmt(Object sep);

  /// No description provided for @settings_theme_title.
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get settings_theme_title;

  /// No description provided for @settings_theme_system.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settings_theme_system;

  /// No description provided for @settings_theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_theme_light;

  /// No description provided for @settings_theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_theme_dark;

  /// No description provided for @go_home.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get go_home;

  /// No description provided for @placeAbbrevSeries.
  ///
  /// In en, this message translates to:
  /// **'u,t,h,th,t.th,h.th,m,t.m,h.m,b'**
  String get placeAbbrevSeries;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
