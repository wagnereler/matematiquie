// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Matematiquei';

  @override
  String get players_title => 'Escolher jogador';

  @override
  String get players_list => 'Jogadores';

  @override
  String get label_language => 'Idioma';

  @override
  String get label_mode => 'Modo';

  @override
  String get mode_multiplication => 'Multiplicação';

  @override
  String difficulty_fmt(int level) {
    return 'Dificuldade: nível $level/10';
  }

  @override
  String get btn_switch => 'Trocar';

  @override
  String get home_player => 'Jogador';

  @override
  String get home_level => 'Nível';

  @override
  String get home_hints => 'Dicas';

  @override
  String get home_changeOrAdd => 'Escolher / Cadastrar';

  @override
  String get home_play => 'Treinar';

  @override
  String get home_stats => 'Estatísticas';

  @override
  String get home_choose_player_hint => 'Pratique todos os dias um pouquinho.\nComece devagar, priorize o acerto 🙂';

  @override
  String get play_title => 'Treinar';

  @override
  String get play_chooseType => 'Escolha o tipo de treino:';

  @override
  String get play_multiplication => 'Tabuada (×)';

  @override
  String get mult_select_title => 'Treinar multiplicação';

  @override
  String get mult_choose_table => 'Escolha a tabuada que quer estudar:';

  @override
  String get mult_errors => 'Erros';

  @override
  String get mult_random => 'Aleatório';

  @override
  String get mult_random_title => 'Treino aleatório';

  @override
  String get mult_random_desc => 'Escolha o intervalo de tabuadas que quer misturar. Ex.: 2 até 10. Você também pode usar valores maiores (11..20).';

  @override
  String get tip_footnote1 => '• \'Erros\' foca nas contas que você mais errou (ex: 7×5).';

  @override
  String get tip_footnote2 => '• \'Aleatório\' mistura tabuadas num intervalo que você escolhe.';

  @override
  String get tip_footnote3 => '• Cada rodada tem 10 perguntas e salva tudo no histórico.';

  @override
  String mult_session_title(int table, int current, int total) {
    return 'Tabuada do $table ($current / $total)';
  }

  @override
  String hits_fmt(Object hits, Object round) {
    return 'Acertos: $hits/$round';
  }

  @override
  String time_secs_fmt(Object secs) {
    return 'Tempo: $secs s';
  }

  @override
  String get mult_choose_before_timeout => 'Escolha a resposta antes do tempo acabar!';

  @override
  String get howto_title => 'Como pensar nessa conta:';

  @override
  String get howto_repeat_addition => '💡 Pense como soma repetida:';

  @override
  String get howto_step_by_step => 'Exemplo de construção passo a passo:';

  @override
  String get howto_doubling_helps => '💡 Dobrar ajuda:';

  @override
  String get mult_tips_title => '📚 Dicas da tabuada:';

  @override
  String get summary_label => 'Resumo';

  @override
  String get btn_continue => 'Continuar';

  @override
  String get btn_close => 'Fechar';

  @override
  String get btn_exit => 'Sair';

  @override
  String get btn_see_hint => 'Ver dica';

  @override
  String get no_hints_left => 'Você não tem mais dicas disponíveis.';

  @override
  String hint_tooltip_fmt(int count) {
    return 'Dica ($count)';
  }

  @override
  String get wrong_title => 'Resposta incorreta';

  @override
  String wrong_explain_fmt(int a, int b, int correct) {
    return 'A resposta correta é $correct porque $a × $b = $correct.\n\nQuer ver como chegar nesse resultado passo a passo?';
  }

  @override
  String get quit_tooltip => 'Sair';

  @override
  String get quit_title => 'Encerrar treino?';

  @override
  String get quit_content => 'Se você sair agora, essa rodada vai terminar antes das 10 questões.';

  @override
  String get quit_keep_playing => 'Continuar jogando';

  @override
  String get result_title => 'Resultado';

  @override
  String get result_performance_title => 'Seu desempenho';

  @override
  String score_fmt(int correct, int total) {
    return '$correct / $total acertos';
  }

  @override
  String get praise_perfect => 'Excelente! Você acertou todas 👏';

  @override
  String get praise_good => 'Muito bom! Continue praticando 👌';

  @override
  String get praise_try_more => 'Tudo bem errar 🙂 Vamos treinar mais um pouquinho.';

  @override
  String get play_again => 'Jogar de novo';

  @override
  String get back_home => 'Voltar para início';

  @override
  String get no_answer => '— (sem resposta)';

  @override
  String attempt_question_fmt(int number, Object qText) {
    return 'Pergunta $number: $qText';
  }

  @override
  String you_answered_fmt(Object answer) {
    return 'Você respondeu: $answer';
  }

  @override
  String correct_fmt(Object answer) {
    return 'Correto: $answer';
  }

  @override
  String howto_repeat_addition_explain_fmt(int a, int b) {
    return '$a × $b quer dizer somar $b um total de $a vezes (ou somar $a um total de $b vezes).';
  }

  @override
  String howto_step_continue_fmt(int result) {
    return 'continuando assim chegamos em $result.';
  }

  @override
  String get howto_nine_trick_title => '💡 Truque da tabuada do 9:';

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
    return 'Tabuada do 2: é só dobrar. Ex: 2 × $other = $other + $other.';
  }

  @override
  String get tip_table_3 => 'Tabuada do 3: pense em somar de 3 em 3: 3, 6, 9, 12, 15, 18...';

  @override
  String get tip_table_4 => 'Tabuada do 4: dobre duas vezes. Ex: 4 × n = (2 × n) × 2.';

  @override
  String get tip_table_5 => 'Tabuada do 5: termina em 0 ou 5 (par → 0, ímpar → 5).';

  @override
  String tip_table_6_fmt(int other) {
    return 'Tabuada do 6: pense 5 × $other + $other.';
  }

  @override
  String tip_table_7_fmt(int other) {
    return 'Tabuada do 7: pense 5 × $other + 2 × $other.';
  }

  @override
  String tip_table_8_fmt(int other) {
    return 'Tabuada do 8: dobro do dobro do dobro. Ex: 8 × $other = (4 × $other) × 2.';
  }

  @override
  String get tip_table_9_note => 'Tabuada do 9: a soma dos dígitos do resultado costuma dar 9 (ex.: 9×4=36 → 3+6=9).';

  @override
  String tip_table_10_fmt(int other) {
    return 'Tabuada do 10: basta colocar um zero no final. Ex: 10 × $other = ${other}0.';
  }

  @override
  String get errors_need_active_player => 'Ative um jogador para treinar os erros.';

  @override
  String get errors_not_enough => 'Ainda não temos erros suficientes.\nJogue algumas rodadas primeiro 😉';

  @override
  String get label_from => 'De';

  @override
  String get label_to => 'Até';

  @override
  String get word_to => 'até';

  @override
  String get btn_cancel => 'Cancelar';

  @override
  String get btn_play => 'Jogar';

  @override
  String get players_add_title => 'Novo jogador';

  @override
  String get players_info => 'Cada jogador pode ter idioma, modo preferido e dificuldade própria (1 a 10). Isso ajuda o adulto a personalizar o treino sem misturar progresso das crianças.';

  @override
  String get players_new => 'Novo jogador';

  @override
  String get players_current => 'ATUAL';

  @override
  String get tooltip_activate => 'Ativar';

  @override
  String get tooltip_edit => 'Editar';

  @override
  String get tooltip_delete => 'Excluir';

  @override
  String get label_name => 'Nome';

  @override
  String get name_hint => 'Ex.: Ana, João...';

  @override
  String get difficulty_hint => 'Dificuldade (1 fácil, 10 rápido)';

  @override
  String get save_player => 'Salvar jogador';

  @override
  String get players_edit_title => 'Editar jogador';

  @override
  String get save_changes => 'Salvar alterações';

  @override
  String get players_delete_title => 'Excluir jogador';

  @override
  String players_delete_confirm_fmt(Object name) {
    return 'Tem certeza que deseja excluir \'$name\'? Isso não pode ser desfeito.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get lang_portuguese => 'Português';

  @override
  String get lang_english => 'English';

  @override
  String get lang_spanish => 'Español';

  @override
  String get mode_addition => 'Adição';

  @override
  String get mode_subtraction => 'Subtração';

  @override
  String get mode_division => 'Divisão';

  @override
  String get settings_title => 'Configurações';

  @override
  String get settings_body => 'Aqui futuramente:\n• Escolher idioma da interface\n• Configurações pedagógicas\n• Dificuldade padrão\n';

  @override
  String get stats_title => 'Estatísticas';

  @override
  String get refresh => 'Atualizar';

  @override
  String get stats_no_player_hint => 'Nenhum jogador ativo.\nEscolha ou crie um jogador.';

  @override
  String stats_player_fmt(Object name) {
    return 'Jogador: $name';
  }

  @override
  String get stats_overall => 'Resumo geral';

  @override
  String stats_total_questions_fmt(int total) {
    return 'Total de perguntas: $total';
  }

  @override
  String hits_only_fmt(int hits) {
    return 'Acertos: $hits';
  }

  @override
  String get stats_success_rate_na => 'Aproveitamento: —';

  @override
  String stats_success_rate_fmt(Object percent) {
    return 'Aproveitamento: $percent';
  }

  @override
  String get stats_by_table => 'Por tabuada';

  @override
  String get stats_by_table_empty => 'Ainda não temos dados por tabuada.\nJogue uma rodada!';

  @override
  String stats_hits_over_total_percent_fmt(int hits, int total, Object percent) {
    return 'Acertos: $hits/$total ($percent)';
  }

  @override
  String get play_addition => 'Adição (＋)';

  @override
  String get add_select_title => 'Treinar adição';

  @override
  String get add_parcels_label => 'Parcelas';

  @override
  String get add_level_label => 'Nível';

  @override
  String get add_decimals_label => 'Incluir casas decimais';

  @override
  String get add_decimal_places_label => 'Quantidade (1–9)';

  @override
  String get add_play => 'Jogar';

  @override
  String get add_fill_all => 'Preencha todos os campos.';

  @override
  String get add_correct_title => 'Tudo certo!';

  @override
  String get add_feedback_ok => 'Parabéns! Sua soma está correta.';

  @override
  String get add_new_problem => 'Novo desafio';

  @override
  String get add_incorrect_title => 'Confira sua conta';

  @override
  String add_feedback_wrong_fmt(int col, int subtotal, int expDigit, int expCarry) {
    return 'Na coluna $col, o subtotal foi $subtotal. O dígito esperado é $expDigit e o vai-um (excedente) é $expCarry.';
  }

  @override
  String get add_game_title => 'Adição';

  @override
  String get add_plus_sign_hint => 'O sinal \'+\' identifica que é uma adição.';

  @override
  String get add_verify => 'Verificar';

  @override
  String add_level_header_fmt(int level, int pow) {
    return 'Nível $level (10^$pow)';
  }

  @override
  String add_level_item_fmt(int n) {
    return 'Nível $n';
  }

  @override
  String get add_level_mapping_hint => 'Mapeamento: 1→10², 2→10³, 3→10⁴, 4→10⁵, 5→10⁶.';

  @override
  String get add_decimals_hint => 'Ao ativar, sempre usa 2 casas decimais.';

  @override
  String get legend_places => 'Legenda: u=unidade, d=dezena, c=centena, m=milhar, dm=dezenas de milhar, cm=centenas de milhar, um=unidade de milhão, dmi=dezenas de milhão, cmi=centenas de milhão, bi=bilhão.';

  @override
  String legend_decimal_sep_fmt(Object sep) {
    return 'Separador decimal: \"$sep\"';
  }
}
