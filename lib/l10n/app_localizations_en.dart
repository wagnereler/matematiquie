// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MathShow';

  @override
  String get players_title => 'Choose player';

  @override
  String get players_list => 'Players';

  @override
  String get label_language => 'Language';

  @override
  String get label_mode => 'Mode';

  @override
  String get mode_multiplication => 'Multiplication';

  @override
  String difficulty_fmt(int level) {
    return 'Difficulty: level $level/10';
  }

  @override
  String get btn_switch => 'Switch';

  @override
  String get home_player => 'Player';

  @override
  String get home_level => 'Level';

  @override
  String get home_hints => 'Hints';

  @override
  String get home_changeOrAdd => 'Choose / Add';

  @override
  String get home_play => 'Train';

  @override
  String get home_stats => 'Statistics';

  @override
  String get home_choose_player_hint => 'Practice a little every day.\nStart slowly, prioritize accuracy 🙂';

  @override
  String get play_title => 'Train';

  @override
  String get play_chooseType => 'Choose a training type:';

  @override
  String get play_multiplication => 'Times Table (×)';

  @override
  String get mult_select_title => 'Train multiplication';

  @override
  String get mult_choose_table => 'Pick the table you want to study:';

  @override
  String get mult_errors => 'Missed';

  @override
  String get mult_random => 'Random';

  @override
  String get mult_random_title => 'Random training';

  @override
  String get mult_random_desc => 'Choose the range of tables to shuffle. E.g., 2 to 10. You can also use bigger ranges (11..20).';

  @override
  String get tip_footnote1 => '• “Missed” focuses on the pairs you missed most (e.g., 7×5).';

  @override
  String get tip_footnote2 => '• “Random” shuffles tables within your chosen range.';

  @override
  String get tip_footnote3 => '• Each round has 10 questions and records your history.';

  @override
  String mult_session_title(int table, int current, int total) {
    return 'Table of $table ($current / $total)';
  }

  @override
  String hits_fmt(Object hits, Object round) {
    return 'Hits: $hits/$round';
  }

  @override
  String time_secs_fmt(Object secs) {
    return 'Time: $secs s';
  }

  @override
  String get mult_choose_before_timeout => 'Choose the answer before time runs out!';

  @override
  String get howto_title => 'How to think about this:';

  @override
  String get howto_repeat_addition => '💡 Think as repeated addition:';

  @override
  String get howto_step_by_step => 'Step-by-step example:';

  @override
  String get howto_doubling_helps => '💡 Doubling helps:';

  @override
  String get mult_tips_title => '📚 Times table tips:';

  @override
  String get summary_label => 'Summary';

  @override
  String get btn_continue => 'Continue';

  @override
  String get btn_close => 'Close';

  @override
  String get btn_exit => 'Exit';

  @override
  String get btn_see_hint => 'See hint';

  @override
  String get no_hints_left => 'You have no hints left.';

  @override
  String hint_tooltip_fmt(int count) {
    return 'Hint ($count)';
  }

  @override
  String get wrong_title => 'Incorrect answer';

  @override
  String wrong_explain_fmt(int a, int b, int correct) {
    return 'The correct answer is $correct because $a × $b = $correct.\n\nDo you want to see how to get this result step by step?';
  }

  @override
  String get quit_tooltip => 'Quit';

  @override
  String get quit_title => 'End training?';

  @override
  String get quit_content => 'If you exit now, this round will end before 10 questions.';

  @override
  String get quit_keep_playing => 'Keep playing';

  @override
  String get result_title => 'Results';

  @override
  String get result_performance_title => 'Your performance';

  @override
  String score_fmt(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get praise_perfect => 'Excellent! You got them all 👏';

  @override
  String get praise_good => 'Great job! Keep practicing 👌';

  @override
  String get praise_try_more => 'It\'s okay to miss 🙂 Let\'s practice a bit more.';

  @override
  String get play_again => 'Play again';

  @override
  String get back_home => 'Back to home';

  @override
  String get no_answer => '— (no answer)';

  @override
  String attempt_question_fmt(int number, Object qText) {
    return 'Question $number: $qText';
  }

  @override
  String you_answered_fmt(Object answer) {
    return 'You answered: $answer';
  }

  @override
  String correct_fmt(Object answer) {
    return 'Correct: $answer';
  }

  @override
  String howto_repeat_addition_explain_fmt(int a, int b) {
    return '$a × $b means add $b a total of $a times (or add $a a total of $b times).';
  }

  @override
  String howto_step_continue_fmt(int result) {
    return '…and we reach $result.';
  }

  @override
  String get howto_nine_trick_title => '💡 9-times table trick:';

  @override
  String howto_nine_trick_explain_fmt(int n, int tenTimes, int minusOther) {
    return '9 × $n = (10 × $n) − $n = $tenTimes − $n = $minusOther';
  }

  @override
  String get tip_zero_property => '0×N = 0; N×0 = 0.';

  @override
  String get tip_one_property => '1×N = N; N×1 = N.';

  @override
  String tip_table_2_fmt(int other) {
    return '×2: just double it. E.g., 2 × $other = $other + $other.';
  }

  @override
  String get tip_table_3 => '×3: think of adding 3 each time: 3, 6, 9, 12, 15, 18…';

  @override
  String get tip_table_4 => '×4: double twice. E.g., 4 × n = (2 × n) × 2.';

  @override
  String get tip_table_5 => '×5: ends with 0 or 5 (even → 0, odd → 5).';

  @override
  String tip_table_6_fmt(int other) {
    return '×6: think 5 × $other + $other.';
  }

  @override
  String tip_table_7_fmt(int other) {
    return '×7: think 5 × $other + 2 × $other.';
  }

  @override
  String tip_table_8_fmt(int other) {
    return '×8: double the double. E.g., 8 × $other = (4 × $other) × 2.';
  }

  @override
  String get tip_table_9_note => '×9: the sum of the digits often equals 9 (e.g., 9×4=36 → 3+6=9).';

  @override
  String tip_table_10_fmt(int other) {
    return '×10: just append a zero. E.g., 10 × $other = ${other}0.';
  }

  @override
  String get errors_need_active_player => 'Activate a player to train your mistakes.';

  @override
  String get errors_not_enough => 'We don’t have enough mistakes yet.\nPlay a few rounds first 😉';

  @override
  String get label_from => 'From';

  @override
  String get label_to => 'To';

  @override
  String get word_to => 'to';

  @override
  String get btn_cancel => 'Cancel';

  @override
  String get btn_play => 'Play';

  @override
  String get players_add_title => 'New player';

  @override
  String get players_info => 'Each player can have their own language, preferred mode, and difficulty (1 to 10). This helps adults tailor practice without mixing kids\' progress.';

  @override
  String get players_new => 'New player';

  @override
  String get players_current => 'CURRENT';

  @override
  String get tooltip_activate => 'Activate';

  @override
  String get tooltip_edit => 'Edit';

  @override
  String get tooltip_delete => 'Delete';

  @override
  String get label_name => 'Name';

  @override
  String get name_hint => 'E.g., Ana, John...';

  @override
  String get difficulty_hint => 'Difficulty (1 easy, 10 fast)';

  @override
  String get save_player => 'Save player';

  @override
  String get players_edit_title => 'Edit player';

  @override
  String get save_changes => 'Save changes';

  @override
  String get players_delete_title => 'Delete player';

  @override
  String players_delete_confirm_fmt(Object name) {
    return 'Are you sure you want to delete \'$name\'? This cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get lang_portuguese => 'Portuguese';

  @override
  String get lang_english => 'English';

  @override
  String get lang_spanish => 'Spanish';

  @override
  String get mode_addition => 'Addition';

  @override
  String get mode_subtraction => 'Subtraction';

  @override
  String get mode_division => 'Division';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_body => 'Coming soon:\n• Choose interface language\n• Pedagogical settings\n• Default difficulty\n';

  @override
  String get stats_title => 'Statistics';

  @override
  String get refresh => 'Refresh';

  @override
  String get stats_no_player_hint => 'No active player.\nChoose or create a player.';

  @override
  String stats_player_fmt(Object name) {
    return 'Player: $name';
  }

  @override
  String get stats_overall => 'Overall summary';

  @override
  String stats_total_questions_fmt(int total) {
    return 'Total questions: $total';
  }

  @override
  String hits_only_fmt(int hits) {
    return 'Hits: $hits';
  }

  @override
  String get stats_success_rate_na => 'Success rate: —';

  @override
  String stats_success_rate_fmt(Object percent) {
    return 'Success rate: $percent';
  }

  @override
  String get stats_by_table => 'By table';

  @override
  String get stats_by_table_empty => 'We don’t have per-table data yet.\nPlay a round!';

  @override
  String stats_hits_over_total_percent_fmt(int hits, int total, Object percent) {
    return 'Hits: $hits/$total ($percent)';
  }

  @override
  String get play_addition => 'Addition (＋)';

  @override
  String get add_select_title => 'Train addition';

  @override
  String get add_parcels_label => 'Addends';

  @override
  String get add_level_label => 'Level';

  @override
  String get add_decimals_label => 'Include decimals';

  @override
  String get add_decimal_places_label => 'Places (1–9)';

  @override
  String get add_play => 'Play';

  @override
  String get add_fill_all => 'Please fill all fields.';

  @override
  String get add_correct_title => 'All correct!';

  @override
  String get add_feedback_ok => 'Nice job! Your sum is correct.';

  @override
  String get add_new_problem => 'New problem';

  @override
  String get add_incorrect_title => 'Check your work';

  @override
  String add_feedback_wrong_fmt(int col, int subtotal, int expDigit, int expCarry) {
    return 'At column $col, the subtotal was $subtotal. Expected digit is $expDigit and carry is $expCarry.';
  }

  @override
  String get add_game_title => 'Addition';

  @override
  String get add_plus_sign_hint => 'The \'+\' sign marks addition.';

  @override
  String get add_verify => 'Verify';

  @override
  String add_level_header_fmt(int level, int pow) {
    return 'Level $level (10^$pow)';
  }

  @override
  String add_level_item_fmt(int n) {
    return 'Level $n';
  }

  @override
  String get add_level_mapping_hint => 'Mapping: 1→10², 2→10³, 3→10⁴, 4→10⁵, 5→10⁶.';

  @override
  String get add_decimals_hint => 'When enabled, it always uses 2 decimal places.';

  @override
  String get legend_places => 'Legend: u=unit, d=ten, c=hundred, k=thousand, 10k=ten-thousand, 100k=hundred-thousand, m=million, 10m=ten-million, 100m=hundred-million, b=billion.';

  @override
  String legend_decimal_sep_fmt(Object sep) {
    return 'Decimal separator: \"$sep\"';
  }

  @override
  String get settings_theme_title => 'App theme';

  @override
  String get settings_theme_system => 'Follow system';

  @override
  String get settings_theme_light => 'Light';

  @override
  String get settings_theme_dark => 'Dark';

  @override
  String get go_home => 'Go to Home';
}
