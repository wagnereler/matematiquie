# scripts/fix_arbs_to_camel.sh
#!/usr/bin/env bash
set -e

FILES="lib/l10n/app_pt.arb lib/l10n/app_en.arb lib/l10n/app_es.arb"

RENAMES=(
  'add_fill_all:addFillAll' '@add_fill_all:@addFillAll'
  'add_correct_title:addCorrectTitle' '@add_correct_title:@addCorrectTitle'
  'add_feedback_ok:addFeedbackOk' '@add_feedback_ok:@addFeedbackOk'
  'btn_continue:btnContinue' '@btn_continue:@btnContinue'
  'add_incorrect_title:addIncorrectTitle' '@add_incorrect_title:@addIncorrectTitle'
  'add_feedback_wrong_fmt:addFeedbackWrongFmt' '@add_feedback_wrong_fmt:@addFeedbackWrongFmt'
  'place_abbrev_series:placeAbbrevSeries'
  'add_game_title:addGameTitle' '@add_game_title:@addGameTitle'
  'add_level_item_fmt:addLevelItemFmt' '@add_level_item_fmt:@addLevelItemFmt'
  'legend_places:legendPlaces' '@legend_places:@legendPlaces'
  'legend_decimal_sep_fmt:legendDecimalSepFmt' '@legend_decimal_sep_fmt:@legendDecimalSepFmt'
  'btn_close:btnClose' '@btn_close:@btnClose'
  'btn_exit:btnExit' '@btn_exit:@btnExit'
  'add_plus_sign_hint:addPlusSignHint' '@add_plus_sign_hint:@addPlusSignHint'
  'add_verify:addVerify' '@add_verify:@addVerify'
)

for f in $FILES; do
  echo "Atualizando $f"
  for pair in "${RENAMES[@]}"; do
    from="${pair%%:*}"; to="${pair##*:}"
    sed -i "s/\"$from\"/\"$to\"/g" "$f"
  done
done

echo "OK. Agora gere novamente as localizações."
