// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Matematizé';

  @override
  String get players_title => 'Elegir jugador';

  @override
  String get players_list => 'Jugadores';

  @override
  String get label_language => 'Idioma';

  @override
  String get label_mode => 'Modo';

  @override
  String get mode_multiplication => 'Multiplicación';

  @override
  String difficulty_fmt(int level) {
    return 'Dificultad: nivel $level/10';
  }

  @override
  String get btn_switch => 'Cambiar';

  @override
  String get home_player => 'Jugador';

  @override
  String get home_level => 'Nivel';

  @override
  String get home_hints => 'Pistas';

  @override
  String get home_changeOrAdd => 'Elegir / Agregar';

  @override
  String get home_play => 'Entrenar';

  @override
  String get home_stats => 'Estadísticas';

  @override
  String get home_choose_player_hint => 'Practica un poco cada día.\nEmpieza despacio, prioriza el acierto 🙂';

  @override
  String get play_title => 'Entrenar';

  @override
  String get play_chooseType => 'Elige el tipo de entrenamiento:';

  @override
  String get play_multiplication => 'Tablas de multiplicar (×)';

  @override
  String get mult_select_title => 'Entrenar multiplicación';

  @override
  String get mult_choose_table => 'Elige la tabla que quieres estudiar:';

  @override
  String get mult_errors => 'Errores';

  @override
  String get mult_random => 'Aleatorio';

  @override
  String get mult_random_title => 'Entrenamiento aleatorio';

  @override
  String get mult_random_desc => 'Elige el intervalo de tablas para mezclar. Ej.: de 2 a 10. También puedes usar valores mayores (11..20).';

  @override
  String get tip_footnote1 => '• «Errores» se centra en las cuentas que más fallaste (p. ej., 7×5).';

  @override
  String get tip_footnote2 => '• «Aleatorio» mezcla tablas dentro del intervalo elegido.';

  @override
  String get tip_footnote3 => '• Cada ronda tiene 10 preguntas y guarda todo en el historial.';

  @override
  String mult_session_title(int table, int current, int total) {
    return 'Tabla del $table ($current / $total)';
  }

  @override
  String hits_fmt(Object hits, Object round) {
    return 'Aciertos: $hits/$round';
  }

  @override
  String time_secs_fmt(Object secs) {
    return 'Tiempo: $secs s';
  }

  @override
  String get mult_choose_before_timeout => '¡Elige la respuesta antes de que se acabe el tiempo!';

  @override
  String get howto_title => 'Cómo pensar esta cuenta:';

  @override
  String get howto_repeat_addition => '💡 Piensa como suma repetida:';

  @override
  String get howto_step_by_step => 'Ejemplo paso a paso:';

  @override
  String get howto_doubling_helps => '💡 Doblar ayuda:';

  @override
  String get mult_tips_title => '📚 Consejos de la tabla:';

  @override
  String get summary_label => 'Resumen';

  @override
  String get btn_continue => 'Continuar';

  @override
  String get btn_close => 'Cerrar';

  @override
  String get btn_exit => 'Salir';

  @override
  String get btn_see_hint => 'Ver pista';

  @override
  String get no_hints_left => 'No te quedan pistas.';

  @override
  String hint_tooltip_fmt(int count) {
    return 'Pista ($count)';
  }

  @override
  String get wrong_title => 'Respuesta incorrecta';

  @override
  String wrong_explain_fmt(int a, int b, int correct) {
    return 'La respuesta correcta es $correct porque $a × $b = $correct.\n\n¿Quieres ver cómo llegar a este resultado paso a paso?';
  }

  @override
  String get quit_tooltip => 'Salir';

  @override
  String get quit_title => '¿Terminar el entrenamiento?';

  @override
  String get quit_content => 'Si sales ahora, esta ronda terminará antes de 10 preguntas.';

  @override
  String get quit_keep_playing => 'Seguir jugando';

  @override
  String get result_title => 'Resultado';

  @override
  String get result_performance_title => 'Tu desempeño';

  @override
  String score_fmt(int correct, int total) {
    return '$correct / $total aciertos';
  }

  @override
  String get praise_perfect => '¡Excelente! Acertaste todas 👏';

  @override
  String get praise_good => '¡Muy bien! Sigue practicando 👌';

  @override
  String get praise_try_more => 'Está bien equivocarse 🙂 Practiquemos un poco más.';

  @override
  String get play_again => 'Jugar de nuevo';

  @override
  String get back_home => 'Volver al inicio';

  @override
  String get no_answer => '— (sin respuesta)';

  @override
  String attempt_question_fmt(int number, Object qText) {
    return 'Pregunta $number: $qText';
  }

  @override
  String you_answered_fmt(Object answer) {
    return 'Respondiste: $answer';
  }

  @override
  String correct_fmt(Object answer) {
    return 'Correcto: $answer';
  }

  @override
  String howto_repeat_addition_explain_fmt(int a, int b) {
    return '$a × $b significa sumar $b un total de $a veces (o sumar $a un total de $b veces).';
  }

  @override
  String howto_step_continue_fmt(int result) {
    return '…y así llegamos a $result.';
  }

  @override
  String get howto_nine_trick_title => '💡 Truco de la tabla del 9:';

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
    return '×2: solo duplica. Ej.: 2 × $other = $other + $other.';
  }

  @override
  String get tip_table_3 => '×3: piensa en sumar de 3 en 3: 3, 6, 9, 12, 15, 18…';

  @override
  String get tip_table_4 => '×4: duplica dos veces. Ej.: 4 × n = (2 × n) × 2.';

  @override
  String get tip_table_5 => '×5: termina en 0 o 5 (par → 0, impar → 5).';

  @override
  String tip_table_6_fmt(int other) {
    return '×6: piensa 5 × $other + $other.';
  }

  @override
  String tip_table_7_fmt(int other) {
    return '×7: piensa 5 × $other + 2 × $other.';
  }

  @override
  String tip_table_8_fmt(int other) {
    return '×8: doble del doble. Ej.: 8 × $other = (4 × $other) × 2.';
  }

  @override
  String get tip_table_9_note => '×9: la suma de los dígitos suele dar 9 (ej.: 9×4=36 → 3+6=9).';

  @override
  String tip_table_10_fmt(int other) {
    return '×10: basta con añadir un cero. Ej.: 10 × $other = ${other}0.';
  }

  @override
  String get errors_need_active_player => 'Activa un jugador para entrenar los errores.';

  @override
  String get errors_not_enough => 'Aún no tenemos errores suficientes.\nJuega algunas rondas primero 😉';

  @override
  String get label_from => 'De';

  @override
  String get label_to => 'Hasta';

  @override
  String get word_to => 'hasta';

  @override
  String get btn_cancel => 'Cancelar';

  @override
  String get btn_play => 'Jugar';

  @override
  String get players_add_title => 'Nuevo jugador';

  @override
  String get players_info => 'Cada jugador puede tener su propio idioma, modo preferido y dificultad (1 a 10). Eso ayuda a personalizar la práctica sin mezclar el progreso de las niñas y los niños.';

  @override
  String get players_new => 'Nuevo jugador';

  @override
  String get players_current => 'ACTUAL';

  @override
  String get tooltip_activate => 'Activar';

  @override
  String get tooltip_edit => 'Editar';

  @override
  String get tooltip_delete => 'Eliminar';

  @override
  String get label_name => 'Nombre';

  @override
  String get name_hint => 'Ej.: Ana, Juan...';

  @override
  String get difficulty_hint => 'Dificultad (1 fácil, 10 rápido)';

  @override
  String get save_player => 'Guardar jugador';

  @override
  String get players_edit_title => 'Editar jugador';

  @override
  String get save_changes => 'Guardar cambios';

  @override
  String get players_delete_title => 'Eliminar jugador';

  @override
  String players_delete_confirm_fmt(Object name) {
    return '¿Seguro que quieres eliminar a \'$name\'? Esto no se puede deshacer.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get lang_portuguese => 'Portugués';

  @override
  String get lang_english => 'Inglés';

  @override
  String get lang_spanish => 'Español';

  @override
  String get mode_addition => 'Adición';

  @override
  String get mode_subtraction => 'Sustracción';

  @override
  String get mode_division => 'División';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get settings_body => 'Próximamente:\n• Elegir idioma de la interfaz\n• Configuraciones pedagógicas\n• Dificultad predeterminada\n';

  @override
  String get stats_title => 'Estadísticas';

  @override
  String get refresh => 'Actualizar';

  @override
  String get stats_no_player_hint => 'No hay jugador activo.\nElige o crea un jugador.';

  @override
  String stats_player_fmt(Object name) {
    return 'Jugador: $name';
  }

  @override
  String get stats_overall => 'Resumen general';

  @override
  String stats_total_questions_fmt(int total) {
    return 'Total de preguntas: $total';
  }

  @override
  String hits_only_fmt(int hits) {
    return 'Aciertos: $hits';
  }

  @override
  String get stats_success_rate_na => 'Aprovechamiento: —';

  @override
  String stats_success_rate_fmt(Object percent) {
    return 'Aprovechamiento: $percent';
  }

  @override
  String get stats_by_table => 'Por tabla';

  @override
  String get stats_by_table_empty => 'Aún no tenemos datos por tabla.\n¡Juega una ronda!';

  @override
  String stats_hits_over_total_percent_fmt(int hits, int total, Object percent) {
    return 'Aciertos: $hits/$total ($percent)';
  }

  @override
  String get play_addition => 'Adición (＋)';

  @override
  String get add_select_title => 'Entrenar adición';

  @override
  String get add_parcels_label => 'Sumandos';

  @override
  String get add_level_label => 'Nivel';

  @override
  String get add_decimals_label => 'Incluir decimales';

  @override
  String get add_decimal_places_label => 'Cifras (1–9)';

  @override
  String get add_play => 'Jugar';

  @override
  String get add_fill_all => 'Completa todos los campos.';

  @override
  String get add_correct_title => '¡Todo correcto!';

  @override
  String get add_feedback_ok => '¡Muy bien! Tu suma es correcta.';

  @override
  String get add_new_problem => 'Nuevo ejercicio';

  @override
  String get add_incorrect_title => 'Revisa tu cuenta';

  @override
  String add_feedback_wrong_fmt(int col, int subtotal, int expDigit, int expCarry) {
    return 'En la columna $col, el subtotal fue $subtotal. El dígito esperado es $expDigit y el acarreo es $expCarry.';
  }

  @override
  String get add_game_title => 'Adición';

  @override
  String get add_plus_sign_hint => 'El signo \'+\' indica adición.';

  @override
  String get add_verify => 'Verificar';

  @override
  String add_level_header_fmt(int level, int pow) {
    return 'Nivel $level (10^$pow)';
  }

  @override
  String add_level_item_fmt(int n) {
    return 'Nivel $n';
  }

  @override
  String get add_level_mapping_hint => 'Mapeo: 1→10², 2→10³, 3→10⁴, 4→10⁵, 5→10⁶.';

  @override
  String get add_decimals_hint => 'Al activar, siempre usa 2 cifras decimales.';

  @override
  String get legend_places => 'Leyenda: u=unidad, d=decena, c=centena, m=millar, dm=decenas de millar, cm=centenas de millar, um=unidad de millón, dmm=decenas de millón, cmm=centenas de millón, mil=mil millones.';

  @override
  String legend_decimal_sep_fmt(Object sep) {
    return 'Separador decimal: \"$sep\"';
  }

  @override
  String get settings_theme_title => 'Tema de la app';

  @override
  String get settings_theme_system => 'Seguir el sistema';

  @override
  String get settings_theme_light => 'Claro';

  @override
  String get settings_theme_dark => 'Oscuro';

  @override
  String get go_home => 'Ir al inicio';
}
