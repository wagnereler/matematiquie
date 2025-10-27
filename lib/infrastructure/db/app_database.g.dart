// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayersTableTable extends PlayersTable
    with TableInfo<$PlayersTableTable, PlayersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageCodeMeta =
      const VerificationMeta('languageCode');
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
      'language_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMaxMeta =
      const VerificationMeta('difficultyMax');
  @override
  late final GeneratedColumn<int> difficultyMax = GeneratedColumn<int>(
      'difficulty_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hintsAvailableMeta =
      const VerificationMeta('hintsAvailable');
  @override
  late final GeneratedColumn<int> hintsAvailable = GeneratedColumn<int>(
      'hints_available', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _roundsPlayedMeta =
      const VerificationMeta('roundsPlayed');
  @override
  late final GeneratedColumn<int> roundsPlayed = GeneratedColumn<int>(
      'rounds_played', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        languageCode,
        mode,
        difficultyMax,
        hintsAvailable,
        roundsPlayed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players_table';
  @override
  VerificationContext validateIntegrity(Insertable<PlayersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
          _languageCodeMeta,
          languageCode.isAcceptableOrUnknown(
              data['language_code']!, _languageCodeMeta));
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('difficulty_max')) {
      context.handle(
          _difficultyMaxMeta,
          difficultyMax.isAcceptableOrUnknown(
              data['difficulty_max']!, _difficultyMaxMeta));
    } else if (isInserting) {
      context.missing(_difficultyMaxMeta);
    }
    if (data.containsKey('hints_available')) {
      context.handle(
          _hintsAvailableMeta,
          hintsAvailable.isAcceptableOrUnknown(
              data['hints_available']!, _hintsAvailableMeta));
    }
    if (data.containsKey('rounds_played')) {
      context.handle(
          _roundsPlayedMeta,
          roundsPlayed.isAcceptableOrUnknown(
              data['rounds_played']!, _roundsPlayedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      languageCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_code'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      difficultyMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}difficulty_max'])!,
      hintsAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hints_available'])!,
      roundsPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rounds_played'])!,
    );
  }

  @override
  $PlayersTableTable createAlias(String alias) {
    return $PlayersTableTable(attachedDatabase, alias);
  }
}

class PlayersTableData extends DataClass
    implements Insertable<PlayersTableData> {
  final int id;
  final String name;
  final String languageCode;
  final String mode;
  final int difficultyMax;

  /// Quantas dicas pedagógicas o jogador ainda tem (0..5)
  final int hintsAvailable;

  /// Quantas rodadas completas (10 questões) já jogou
  final int roundsPlayed;
  const PlayersTableData(
      {required this.id,
      required this.name,
      required this.languageCode,
      required this.mode,
      required this.difficultyMax,
      required this.hintsAvailable,
      required this.roundsPlayed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['language_code'] = Variable<String>(languageCode);
    map['mode'] = Variable<String>(mode);
    map['difficulty_max'] = Variable<int>(difficultyMax);
    map['hints_available'] = Variable<int>(hintsAvailable);
    map['rounds_played'] = Variable<int>(roundsPlayed);
    return map;
  }

  PlayersTableCompanion toCompanion(bool nullToAbsent) {
    return PlayersTableCompanion(
      id: Value(id),
      name: Value(name),
      languageCode: Value(languageCode),
      mode: Value(mode),
      difficultyMax: Value(difficultyMax),
      hintsAvailable: Value(hintsAvailable),
      roundsPlayed: Value(roundsPlayed),
    );
  }

  factory PlayersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayersTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      mode: serializer.fromJson<String>(json['mode']),
      difficultyMax: serializer.fromJson<int>(json['difficultyMax']),
      hintsAvailable: serializer.fromJson<int>(json['hintsAvailable']),
      roundsPlayed: serializer.fromJson<int>(json['roundsPlayed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'languageCode': serializer.toJson<String>(languageCode),
      'mode': serializer.toJson<String>(mode),
      'difficultyMax': serializer.toJson<int>(difficultyMax),
      'hintsAvailable': serializer.toJson<int>(hintsAvailable),
      'roundsPlayed': serializer.toJson<int>(roundsPlayed),
    };
  }

  PlayersTableData copyWith(
          {int? id,
          String? name,
          String? languageCode,
          String? mode,
          int? difficultyMax,
          int? hintsAvailable,
          int? roundsPlayed}) =>
      PlayersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        languageCode: languageCode ?? this.languageCode,
        mode: mode ?? this.mode,
        difficultyMax: difficultyMax ?? this.difficultyMax,
        hintsAvailable: hintsAvailable ?? this.hintsAvailable,
        roundsPlayed: roundsPlayed ?? this.roundsPlayed,
      );
  PlayersTableData copyWithCompanion(PlayersTableCompanion data) {
    return PlayersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      mode: data.mode.present ? data.mode.value : this.mode,
      difficultyMax: data.difficultyMax.present
          ? data.difficultyMax.value
          : this.difficultyMax,
      hintsAvailable: data.hintsAvailable.present
          ? data.hintsAvailable.value
          : this.hintsAvailable,
      roundsPlayed: data.roundsPlayed.present
          ? data.roundsPlayed.value
          : this.roundsPlayed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('languageCode: $languageCode, ')
          ..write('mode: $mode, ')
          ..write('difficultyMax: $difficultyMax, ')
          ..write('hintsAvailable: $hintsAvailable, ')
          ..write('roundsPlayed: $roundsPlayed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, languageCode, mode, difficultyMax,
      hintsAvailable, roundsPlayed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.languageCode == this.languageCode &&
          other.mode == this.mode &&
          other.difficultyMax == this.difficultyMax &&
          other.hintsAvailable == this.hintsAvailable &&
          other.roundsPlayed == this.roundsPlayed);
}

class PlayersTableCompanion extends UpdateCompanion<PlayersTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> languageCode;
  final Value<String> mode;
  final Value<int> difficultyMax;
  final Value<int> hintsAvailable;
  final Value<int> roundsPlayed;
  const PlayersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.mode = const Value.absent(),
    this.difficultyMax = const Value.absent(),
    this.hintsAvailable = const Value.absent(),
    this.roundsPlayed = const Value.absent(),
  });
  PlayersTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String languageCode,
    required String mode,
    required int difficultyMax,
    this.hintsAvailable = const Value.absent(),
    this.roundsPlayed = const Value.absent(),
  })  : name = Value(name),
        languageCode = Value(languageCode),
        mode = Value(mode),
        difficultyMax = Value(difficultyMax);
  static Insertable<PlayersTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? languageCode,
    Expression<String>? mode,
    Expression<int>? difficultyMax,
    Expression<int>? hintsAvailable,
    Expression<int>? roundsPlayed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (languageCode != null) 'language_code': languageCode,
      if (mode != null) 'mode': mode,
      if (difficultyMax != null) 'difficulty_max': difficultyMax,
      if (hintsAvailable != null) 'hints_available': hintsAvailable,
      if (roundsPlayed != null) 'rounds_played': roundsPlayed,
    });
  }

  PlayersTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? languageCode,
      Value<String>? mode,
      Value<int>? difficultyMax,
      Value<int>? hintsAvailable,
      Value<int>? roundsPlayed}) {
    return PlayersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      languageCode: languageCode ?? this.languageCode,
      mode: mode ?? this.mode,
      difficultyMax: difficultyMax ?? this.difficultyMax,
      hintsAvailable: hintsAvailable ?? this.hintsAvailable,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (difficultyMax.present) {
      map['difficulty_max'] = Variable<int>(difficultyMax.value);
    }
    if (hintsAvailable.present) {
      map['hints_available'] = Variable<int>(hintsAvailable.value);
    }
    if (roundsPlayed.present) {
      map['rounds_played'] = Variable<int>(roundsPlayed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('languageCode: $languageCode, ')
          ..write('mode: $mode, ')
          ..write('difficultyMax: $difficultyMax, ')
          ..write('hintsAvailable: $hintsAvailable, ')
          ..write('roundsPlayed: $roundsPlayed')
          ..write(')'))
        .toString();
  }
}

class $AttemptsTableTable extends AttemptsTable
    with TableInfo<$AttemptsTableTable, AttemptsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _playerIdMeta =
      const VerificationMeta('playerId');
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
      'player_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _factorAMeta =
      const VerificationMeta('factorA');
  @override
  late final GeneratedColumn<int> factorA = GeneratedColumn<int>(
      'factor_a', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _factorBMeta =
      const VerificationMeta('factorB');
  @override
  late final GeneratedColumn<int> factorB = GeneratedColumn<int>(
      'factor_b', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tableBaseMeta =
      const VerificationMeta('tableBase');
  @override
  late final GeneratedColumn<int> tableBase = GeneratedColumn<int>(
      'table_base', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswerMeta =
      const VerificationMeta('correctAnswer');
  @override
  late final GeneratedColumn<int> correctAnswer = GeneratedColumn<int>(
      'correct_answer', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _selectedAnswerMeta =
      const VerificationMeta('selectedAnswer');
  @override
  late final GeneratedColumn<int> selectedAnswer = GeneratedColumn<int>(
      'selected_answer', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isCorrectMeta =
      const VerificationMeta('isCorrect');
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
      'is_correct', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_correct" IN (0, 1))'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        playerId,
        mode,
        factorA,
        factorB,
        tableBase,
        correctAnswer,
        selectedAnswer,
        isCorrect,
        timestamp
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempts_table';
  @override
  VerificationContext validateIntegrity(Insertable<AttemptsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('player_id')) {
      context.handle(_playerIdMeta,
          playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta));
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('factor_a')) {
      context.handle(_factorAMeta,
          factorA.isAcceptableOrUnknown(data['factor_a']!, _factorAMeta));
    } else if (isInserting) {
      context.missing(_factorAMeta);
    }
    if (data.containsKey('factor_b')) {
      context.handle(_factorBMeta,
          factorB.isAcceptableOrUnknown(data['factor_b']!, _factorBMeta));
    } else if (isInserting) {
      context.missing(_factorBMeta);
    }
    if (data.containsKey('table_base')) {
      context.handle(_tableBaseMeta,
          tableBase.isAcceptableOrUnknown(data['table_base']!, _tableBaseMeta));
    } else if (isInserting) {
      context.missing(_tableBaseMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
          _correctAnswerMeta,
          correctAnswer.isAcceptableOrUnknown(
              data['correct_answer']!, _correctAnswerMeta));
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('selected_answer')) {
      context.handle(
          _selectedAnswerMeta,
          selectedAnswer.isAcceptableOrUnknown(
              data['selected_answer']!, _selectedAnswerMeta));
    }
    if (data.containsKey('is_correct')) {
      context.handle(_isCorrectMeta,
          isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta));
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttemptsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttemptsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      playerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}player_id'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      factorA: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}factor_a'])!,
      factorB: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}factor_b'])!,
      tableBase: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}table_base'])!,
      correctAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_answer'])!,
      selectedAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}selected_answer']),
      isCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_correct'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $AttemptsTableTable createAlias(String alias) {
    return $AttemptsTableTable(attachedDatabase, alias);
  }
}

class AttemptsTableData extends DataClass
    implements Insertable<AttemptsTableData> {
  final int id;
  final int playerId;
  final String mode;
  final int factorA;
  final int factorB;
  final int tableBase;
  final int correctAnswer;
  final int? selectedAnswer;
  final bool isCorrect;
  final DateTime timestamp;
  const AttemptsTableData(
      {required this.id,
      required this.playerId,
      required this.mode,
      required this.factorA,
      required this.factorB,
      required this.tableBase,
      required this.correctAnswer,
      this.selectedAnswer,
      required this.isCorrect,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['player_id'] = Variable<int>(playerId);
    map['mode'] = Variable<String>(mode);
    map['factor_a'] = Variable<int>(factorA);
    map['factor_b'] = Variable<int>(factorB);
    map['table_base'] = Variable<int>(tableBase);
    map['correct_answer'] = Variable<int>(correctAnswer);
    if (!nullToAbsent || selectedAnswer != null) {
      map['selected_answer'] = Variable<int>(selectedAnswer);
    }
    map['is_correct'] = Variable<bool>(isCorrect);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  AttemptsTableCompanion toCompanion(bool nullToAbsent) {
    return AttemptsTableCompanion(
      id: Value(id),
      playerId: Value(playerId),
      mode: Value(mode),
      factorA: Value(factorA),
      factorB: Value(factorB),
      tableBase: Value(tableBase),
      correctAnswer: Value(correctAnswer),
      selectedAnswer: selectedAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedAnswer),
      isCorrect: Value(isCorrect),
      timestamp: Value(timestamp),
    );
  }

  factory AttemptsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttemptsTableData(
      id: serializer.fromJson<int>(json['id']),
      playerId: serializer.fromJson<int>(json['playerId']),
      mode: serializer.fromJson<String>(json['mode']),
      factorA: serializer.fromJson<int>(json['factorA']),
      factorB: serializer.fromJson<int>(json['factorB']),
      tableBase: serializer.fromJson<int>(json['tableBase']),
      correctAnswer: serializer.fromJson<int>(json['correctAnswer']),
      selectedAnswer: serializer.fromJson<int?>(json['selectedAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playerId': serializer.toJson<int>(playerId),
      'mode': serializer.toJson<String>(mode),
      'factorA': serializer.toJson<int>(factorA),
      'factorB': serializer.toJson<int>(factorB),
      'tableBase': serializer.toJson<int>(tableBase),
      'correctAnswer': serializer.toJson<int>(correctAnswer),
      'selectedAnswer': serializer.toJson<int?>(selectedAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  AttemptsTableData copyWith(
          {int? id,
          int? playerId,
          String? mode,
          int? factorA,
          int? factorB,
          int? tableBase,
          int? correctAnswer,
          Value<int?> selectedAnswer = const Value.absent(),
          bool? isCorrect,
          DateTime? timestamp}) =>
      AttemptsTableData(
        id: id ?? this.id,
        playerId: playerId ?? this.playerId,
        mode: mode ?? this.mode,
        factorA: factorA ?? this.factorA,
        factorB: factorB ?? this.factorB,
        tableBase: tableBase ?? this.tableBase,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        selectedAnswer:
            selectedAnswer.present ? selectedAnswer.value : this.selectedAnswer,
        isCorrect: isCorrect ?? this.isCorrect,
        timestamp: timestamp ?? this.timestamp,
      );
  AttemptsTableData copyWithCompanion(AttemptsTableCompanion data) {
    return AttemptsTableData(
      id: data.id.present ? data.id.value : this.id,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      mode: data.mode.present ? data.mode.value : this.mode,
      factorA: data.factorA.present ? data.factorA.value : this.factorA,
      factorB: data.factorB.present ? data.factorB.value : this.factorB,
      tableBase: data.tableBase.present ? data.tableBase.value : this.tableBase,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      selectedAnswer: data.selectedAnswer.present
          ? data.selectedAnswer.value
          : this.selectedAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsTableData(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('mode: $mode, ')
          ..write('factorA: $factorA, ')
          ..write('factorB: $factorB, ')
          ..write('tableBase: $tableBase, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playerId, mode, factorA, factorB,
      tableBase, correctAnswer, selectedAnswer, isCorrect, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttemptsTableData &&
          other.id == this.id &&
          other.playerId == this.playerId &&
          other.mode == this.mode &&
          other.factorA == this.factorA &&
          other.factorB == this.factorB &&
          other.tableBase == this.tableBase &&
          other.correctAnswer == this.correctAnswer &&
          other.selectedAnswer == this.selectedAnswer &&
          other.isCorrect == this.isCorrect &&
          other.timestamp == this.timestamp);
}

class AttemptsTableCompanion extends UpdateCompanion<AttemptsTableData> {
  final Value<int> id;
  final Value<int> playerId;
  final Value<String> mode;
  final Value<int> factorA;
  final Value<int> factorB;
  final Value<int> tableBase;
  final Value<int> correctAnswer;
  final Value<int?> selectedAnswer;
  final Value<bool> isCorrect;
  final Value<DateTime> timestamp;
  const AttemptsTableCompanion({
    this.id = const Value.absent(),
    this.playerId = const Value.absent(),
    this.mode = const Value.absent(),
    this.factorA = const Value.absent(),
    this.factorB = const Value.absent(),
    this.tableBase = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.selectedAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  AttemptsTableCompanion.insert({
    this.id = const Value.absent(),
    required int playerId,
    required String mode,
    required int factorA,
    required int factorB,
    required int tableBase,
    required int correctAnswer,
    this.selectedAnswer = const Value.absent(),
    required bool isCorrect,
    required DateTime timestamp,
  })  : playerId = Value(playerId),
        mode = Value(mode),
        factorA = Value(factorA),
        factorB = Value(factorB),
        tableBase = Value(tableBase),
        correctAnswer = Value(correctAnswer),
        isCorrect = Value(isCorrect),
        timestamp = Value(timestamp);
  static Insertable<AttemptsTableData> custom({
    Expression<int>? id,
    Expression<int>? playerId,
    Expression<String>? mode,
    Expression<int>? factorA,
    Expression<int>? factorB,
    Expression<int>? tableBase,
    Expression<int>? correctAnswer,
    Expression<int>? selectedAnswer,
    Expression<bool>? isCorrect,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playerId != null) 'player_id': playerId,
      if (mode != null) 'mode': mode,
      if (factorA != null) 'factor_a': factorA,
      if (factorB != null) 'factor_b': factorB,
      if (tableBase != null) 'table_base': tableBase,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (selectedAnswer != null) 'selected_answer': selectedAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  AttemptsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? playerId,
      Value<String>? mode,
      Value<int>? factorA,
      Value<int>? factorB,
      Value<int>? tableBase,
      Value<int>? correctAnswer,
      Value<int?>? selectedAnswer,
      Value<bool>? isCorrect,
      Value<DateTime>? timestamp}) {
    return AttemptsTableCompanion(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      mode: mode ?? this.mode,
      factorA: factorA ?? this.factorA,
      factorB: factorB ?? this.factorB,
      tableBase: tableBase ?? this.tableBase,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (factorA.present) {
      map['factor_a'] = Variable<int>(factorA.value);
    }
    if (factorB.present) {
      map['factor_b'] = Variable<int>(factorB.value);
    }
    if (tableBase.present) {
      map['table_base'] = Variable<int>(tableBase.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<int>(correctAnswer.value);
    }
    if (selectedAnswer.present) {
      map['selected_answer'] = Variable<int>(selectedAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsTableCompanion(')
          ..write('id: $id, ')
          ..write('playerId: $playerId, ')
          ..write('mode: $mode, ')
          ..write('factorA: $factorA, ')
          ..write('factorB: $factorB, ')
          ..write('tableBase: $tableBase, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('selectedAnswer: $selectedAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayersTableTable playersTable = $PlayersTableTable(this);
  late final $AttemptsTableTable attemptsTable = $AttemptsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [playersTable, attemptsTable];
}

typedef $$PlayersTableTableCreateCompanionBuilder = PlayersTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String languageCode,
  required String mode,
  required int difficultyMax,
  Value<int> hintsAvailable,
  Value<int> roundsPlayed,
});
typedef $$PlayersTableTableUpdateCompanionBuilder = PlayersTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> languageCode,
  Value<String> mode,
  Value<int> difficultyMax,
  Value<int> hintsAvailable,
  Value<int> roundsPlayed,
});

class $$PlayersTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTableTable> {
  $$PlayersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get difficultyMax => $composableBuilder(
      column: $table.difficultyMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hintsAvailable => $composableBuilder(
      column: $table.hintsAvailable,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get roundsPlayed => $composableBuilder(
      column: $table.roundsPlayed, builder: (column) => ColumnFilters(column));
}

class $$PlayersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTableTable> {
  $$PlayersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageCode => $composableBuilder(
      column: $table.languageCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get difficultyMax => $composableBuilder(
      column: $table.difficultyMax,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hintsAvailable => $composableBuilder(
      column: $table.hintsAvailable,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get roundsPlayed => $composableBuilder(
      column: $table.roundsPlayed,
      builder: (column) => ColumnOrderings(column));
}

class $$PlayersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTableTable> {
  $$PlayersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get difficultyMax => $composableBuilder(
      column: $table.difficultyMax, builder: (column) => column);

  GeneratedColumn<int> get hintsAvailable => $composableBuilder(
      column: $table.hintsAvailable, builder: (column) => column);

  GeneratedColumn<int> get roundsPlayed => $composableBuilder(
      column: $table.roundsPlayed, builder: (column) => column);
}

class $$PlayersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlayersTableTable,
    PlayersTableData,
    $$PlayersTableTableFilterComposer,
    $$PlayersTableTableOrderingComposer,
    $$PlayersTableTableAnnotationComposer,
    $$PlayersTableTableCreateCompanionBuilder,
    $$PlayersTableTableUpdateCompanionBuilder,
    (
      PlayersTableData,
      BaseReferences<_$AppDatabase, $PlayersTableTable, PlayersTableData>
    ),
    PlayersTableData,
    PrefetchHooks Function()> {
  $$PlayersTableTableTableManager(_$AppDatabase db, $PlayersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> languageCode = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<int> difficultyMax = const Value.absent(),
            Value<int> hintsAvailable = const Value.absent(),
            Value<int> roundsPlayed = const Value.absent(),
          }) =>
              PlayersTableCompanion(
            id: id,
            name: name,
            languageCode: languageCode,
            mode: mode,
            difficultyMax: difficultyMax,
            hintsAvailable: hintsAvailable,
            roundsPlayed: roundsPlayed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String languageCode,
            required String mode,
            required int difficultyMax,
            Value<int> hintsAvailable = const Value.absent(),
            Value<int> roundsPlayed = const Value.absent(),
          }) =>
              PlayersTableCompanion.insert(
            id: id,
            name: name,
            languageCode: languageCode,
            mode: mode,
            difficultyMax: difficultyMax,
            hintsAvailable: hintsAvailable,
            roundsPlayed: roundsPlayed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlayersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlayersTableTable,
    PlayersTableData,
    $$PlayersTableTableFilterComposer,
    $$PlayersTableTableOrderingComposer,
    $$PlayersTableTableAnnotationComposer,
    $$PlayersTableTableCreateCompanionBuilder,
    $$PlayersTableTableUpdateCompanionBuilder,
    (
      PlayersTableData,
      BaseReferences<_$AppDatabase, $PlayersTableTable, PlayersTableData>
    ),
    PlayersTableData,
    PrefetchHooks Function()>;
typedef $$AttemptsTableTableCreateCompanionBuilder = AttemptsTableCompanion
    Function({
  Value<int> id,
  required int playerId,
  required String mode,
  required int factorA,
  required int factorB,
  required int tableBase,
  required int correctAnswer,
  Value<int?> selectedAnswer,
  required bool isCorrect,
  required DateTime timestamp,
});
typedef $$AttemptsTableTableUpdateCompanionBuilder = AttemptsTableCompanion
    Function({
  Value<int> id,
  Value<int> playerId,
  Value<String> mode,
  Value<int> factorA,
  Value<int> factorB,
  Value<int> tableBase,
  Value<int> correctAnswer,
  Value<int?> selectedAnswer,
  Value<bool> isCorrect,
  Value<DateTime> timestamp,
});

class $$AttemptsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptsTableTable> {
  $$AttemptsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playerId => $composableBuilder(
      column: $table.playerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get factorA => $composableBuilder(
      column: $table.factorA, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get factorB => $composableBuilder(
      column: $table.factorB, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tableBase => $composableBuilder(
      column: $table.tableBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get selectedAnswer => $composableBuilder(
      column: $table.selectedAnswer,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$AttemptsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptsTableTable> {
  $$AttemptsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playerId => $composableBuilder(
      column: $table.playerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get factorA => $composableBuilder(
      column: $table.factorA, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get factorB => $composableBuilder(
      column: $table.factorB, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tableBase => $composableBuilder(
      column: $table.tableBase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get selectedAnswer => $composableBuilder(
      column: $table.selectedAnswer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
      column: $table.isCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$AttemptsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptsTableTable> {
  $$AttemptsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get factorA =>
      $composableBuilder(column: $table.factorA, builder: (column) => column);

  GeneratedColumn<int> get factorB =>
      $composableBuilder(column: $table.factorB, builder: (column) => column);

  GeneratedColumn<int> get tableBase =>
      $composableBuilder(column: $table.tableBase, builder: (column) => column);

  GeneratedColumn<int> get correctAnswer => $composableBuilder(
      column: $table.correctAnswer, builder: (column) => column);

  GeneratedColumn<int> get selectedAnswer => $composableBuilder(
      column: $table.selectedAnswer, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$AttemptsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttemptsTableTable,
    AttemptsTableData,
    $$AttemptsTableTableFilterComposer,
    $$AttemptsTableTableOrderingComposer,
    $$AttemptsTableTableAnnotationComposer,
    $$AttemptsTableTableCreateCompanionBuilder,
    $$AttemptsTableTableUpdateCompanionBuilder,
    (
      AttemptsTableData,
      BaseReferences<_$AppDatabase, $AttemptsTableTable, AttemptsTableData>
    ),
    AttemptsTableData,
    PrefetchHooks Function()> {
  $$AttemptsTableTableTableManager(_$AppDatabase db, $AttemptsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> playerId = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<int> factorA = const Value.absent(),
            Value<int> factorB = const Value.absent(),
            Value<int> tableBase = const Value.absent(),
            Value<int> correctAnswer = const Value.absent(),
            Value<int?> selectedAnswer = const Value.absent(),
            Value<bool> isCorrect = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              AttemptsTableCompanion(
            id: id,
            playerId: playerId,
            mode: mode,
            factorA: factorA,
            factorB: factorB,
            tableBase: tableBase,
            correctAnswer: correctAnswer,
            selectedAnswer: selectedAnswer,
            isCorrect: isCorrect,
            timestamp: timestamp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int playerId,
            required String mode,
            required int factorA,
            required int factorB,
            required int tableBase,
            required int correctAnswer,
            Value<int?> selectedAnswer = const Value.absent(),
            required bool isCorrect,
            required DateTime timestamp,
          }) =>
              AttemptsTableCompanion.insert(
            id: id,
            playerId: playerId,
            mode: mode,
            factorA: factorA,
            factorB: factorB,
            tableBase: tableBase,
            correctAnswer: correctAnswer,
            selectedAnswer: selectedAnswer,
            isCorrect: isCorrect,
            timestamp: timestamp,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttemptsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttemptsTableTable,
    AttemptsTableData,
    $$AttemptsTableTableFilterComposer,
    $$AttemptsTableTableOrderingComposer,
    $$AttemptsTableTableAnnotationComposer,
    $$AttemptsTableTableCreateCompanionBuilder,
    $$AttemptsTableTableUpdateCompanionBuilder,
    (
      AttemptsTableData,
      BaseReferences<_$AppDatabase, $AttemptsTableTable, AttemptsTableData>
    ),
    AttemptsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayersTableTableTableManager get playersTable =>
      $$PlayersTableTableTableManager(_db, _db.playersTable);
  $$AttemptsTableTableTableManager get attemptsTable =>
      $$AttemptsTableTableTableManager(_db, _db.attemptsTable);
}
