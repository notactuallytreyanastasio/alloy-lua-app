local temper = require('temper-core');
local ChangesetError, Changeset, ChangesetImpl__129, JoinType, InnerJoin, LeftJoin, RightJoin, FullJoin, JoinClause, OrderClause, WhereClause, AndCondition, OrCondition, Query, SafeIdentifier, ValidatedIdentifier__177, FieldType, StringField, IntField, Int64Field, FloatField, BoolField, DateField, FieldDef, TableDef, SqlBuilder, SqlFragment, SqlPart, SqlSource, SqlBoolean, SqlDate, SqlFloat64, SqlInt32, SqlInt64, SqlString, changeset, isIdentStart__401, isIdentPart__402, safeIdentifier, deleteSql, from, col, exports;
ChangesetError = temper.type('ChangesetError');
ChangesetError.constructor = function(this__212, field__408, message__409)
  this__212.field__405 = field__408;
  this__212.message__406 = message__409;
  return nil;
end;
ChangesetError.get.field = function(this__1134)
  return this__1134.field__405;
end;
ChangesetError.get.message = function(this__1137)
  return this__1137.message__406;
end;
Changeset = temper.type('Changeset');
Changeset.get.tableDef = function(this__116)
  temper.virtual();
end;
Changeset.get.changes = function(this__117)
  temper.virtual();
end;
Changeset.get.errors = function(this__118)
  temper.virtual();
end;
Changeset.get.isValid = function(this__119)
  temper.virtual();
end;
Changeset.methods.cast = function(this__120, allowedFields__419)
  temper.virtual();
end;
Changeset.methods.validateRequired = function(this__121, fields__422)
  temper.virtual();
end;
Changeset.methods.validateLength = function(this__122, field__425, min__426, max__427)
  temper.virtual();
end;
Changeset.methods.validateInt = function(this__123, field__430)
  temper.virtual();
end;
Changeset.methods.validateInt64 = function(this__124, field__433)
  temper.virtual();
end;
Changeset.methods.validateFloat = function(this__125, field__436)
  temper.virtual();
end;
Changeset.methods.validateBool = function(this__126, field__439)
  temper.virtual();
end;
Changeset.methods.toInsertSql = function(this__127)
  temper.virtual();
end;
Changeset.methods.toUpdateSql = function(this__128, id__444)
  temper.virtual();
end;
ChangesetImpl__129 = temper.type('ChangesetImpl__129', Changeset);
ChangesetImpl__129.get.tableDef = function(this__130)
  return this__130._tableDef__446;
end;
ChangesetImpl__129.get.changes = function(this__131)
  return this__131._changes__448;
end;
ChangesetImpl__129.get.errors = function(this__132)
  return this__132._errors__449;
end;
ChangesetImpl__129.get.isValid = function(this__133)
  return this__133._isValid__450;
end;
ChangesetImpl__129.methods.cast = function(this__134, allowedFields__460)
  local mb__462, fn__7132;
  mb__462 = temper.mapbuilder_constructor();
  fn__7132 = function(f__463)
    local t_0, t_1, val__464;
    t_1 = f__463.sqlValue;
    val__464 = temper.mapped_getor(this__134._params__447, t_1, '');
    if not temper.string_isempty(val__464) then
      t_0 = f__463.sqlValue;
      temper.mapbuilder_set(mb__462, t_0, val__464);
    end
    return nil;
  end;
  temper.list_foreach(allowedFields__460, fn__7132);
  return ChangesetImpl__129(this__134._tableDef__446, this__134._params__447, temper.mapped_tomap(mb__462), this__134._errors__449, this__134._isValid__450);
end;
ChangesetImpl__129.methods.validateRequired = function(this__135, fields__466)
  local return__245, t_2, t_3, t_4, t_5, eb__468, valid__469, fn__7121;
  ::continue_1::
  if not this__135._isValid__450 then
    return__245 = this__135;
    goto break_0;
  end
  eb__468 = temper.list_tolistbuilder(this__135._errors__449);
  valid__469 = true;
  fn__7121 = function(f__470)
    local t_6, t_7;
    t_7 = f__470.sqlValue;
    if not temper.mapped_has(this__135._changes__448, t_7) then
      t_6 = ChangesetError(f__470.sqlValue, 'is required');
      temper.listbuilder_add(eb__468, t_6);
      valid__469 = false;
    end
    return nil;
  end;
  temper.list_foreach(fields__466, fn__7121);
  t_3 = this__135._tableDef__446;
  t_4 = this__135._params__447;
  t_5 = this__135._changes__448;
  t_2 = temper.listbuilder_tolist(eb__468);
  return__245 = ChangesetImpl__129(t_3, t_4, t_5, t_2, valid__469);
  ::break_0::return return__245;
end;
ChangesetImpl__129.methods.validateLength = function(this__136, field__472, min__473, max__474)
  local return__246, t_8, t_9, t_10, t_11, t_12, t_13, val__476, len__477;
  ::continue_3::
  if not this__136._isValid__450 then
    return__246 = this__136;
    goto break_2;
  end
  t_8 = field__472.sqlValue;
  val__476 = temper.mapped_getor(this__136._changes__448, t_8, '');
  len__477 = temper.string_countbetween(val__476, 1.0, temper.string_end(val__476));
  if (len__477 < min__473) then
    t_10 = true;
  else
    t_10 = (len__477 > max__474);
  end
  if t_10 then
    local msg__478, eb__479;
    msg__478 = temper.concat('must be between ', temper.int32_tostring(min__473), ' and ', temper.int32_tostring(max__474), ' characters');
    eb__479 = temper.list_tolistbuilder(this__136._errors__449);
    temper.listbuilder_add(eb__479, ChangesetError(field__472.sqlValue, msg__478));
    t_11 = this__136._tableDef__446;
    t_12 = this__136._params__447;
    t_13 = this__136._changes__448;
    t_9 = temper.listbuilder_tolist(eb__479);
    return__246 = ChangesetImpl__129(t_11, t_12, t_13, t_9, false);
    goto break_2;
  end
  return__246 = this__136;
  ::break_2::return return__246;
end;
ChangesetImpl__129.methods.validateInt = function(this__137, field__481)
  local return__247, t_14, t_15, t_16, t_17, t_18, val__483, parseOk__484, local_19, local_20, local_21;
  ::continue_5::
  if not this__137._isValid__450 then
    return__247 = this__137;
    goto break_4;
  end
  t_14 = field__481.sqlValue;
  val__483 = temper.mapped_getor(this__137._changes__448, t_14, '');
  if temper.string_isempty(val__483) then
    return__247 = this__137;
    goto break_4;
  end
  local_19, local_20, local_21 = temper.pcall(function()
    temper.string_toint32(val__483);
    parseOk__484 = true;
  end);
  if local_19 then
  else
    parseOk__484 = false;
  end
  if not parseOk__484 then
    local eb__485;
    eb__485 = temper.list_tolistbuilder(this__137._errors__449);
    temper.listbuilder_add(eb__485, ChangesetError(field__481.sqlValue, 'must be an integer'));
    t_16 = this__137._tableDef__446;
    t_17 = this__137._params__447;
    t_18 = this__137._changes__448;
    t_15 = temper.listbuilder_tolist(eb__485);
    return__247 = ChangesetImpl__129(t_16, t_17, t_18, t_15, false);
    goto break_4;
  end
  return__247 = this__137;
  ::break_4::return return__247;
end;
ChangesetImpl__129.methods.validateInt64 = function(this__138, field__487)
  local return__248, t_23, t_24, t_25, t_26, t_27, val__489, parseOk__490, local_28, local_29, local_30;
  ::continue_7::
  if not this__138._isValid__450 then
    return__248 = this__138;
    goto break_6;
  end
  t_23 = field__487.sqlValue;
  val__489 = temper.mapped_getor(this__138._changes__448, t_23, '');
  if temper.string_isempty(val__489) then
    return__248 = this__138;
    goto break_6;
  end
  local_28, local_29, local_30 = temper.pcall(function()
    temper.string_toint64(val__489);
    parseOk__490 = true;
  end);
  if local_28 then
  else
    parseOk__490 = false;
  end
  if not parseOk__490 then
    local eb__491;
    eb__491 = temper.list_tolistbuilder(this__138._errors__449);
    temper.listbuilder_add(eb__491, ChangesetError(field__487.sqlValue, 'must be a 64-bit integer'));
    t_25 = this__138._tableDef__446;
    t_26 = this__138._params__447;
    t_27 = this__138._changes__448;
    t_24 = temper.listbuilder_tolist(eb__491);
    return__248 = ChangesetImpl__129(t_25, t_26, t_27, t_24, false);
    goto break_6;
  end
  return__248 = this__138;
  ::break_6::return return__248;
end;
ChangesetImpl__129.methods.validateFloat = function(this__139, field__493)
  local return__249, t_32, t_33, t_34, t_35, t_36, val__495, parseOk__496, local_37, local_38, local_39;
  ::continue_9::
  if not this__139._isValid__450 then
    return__249 = this__139;
    goto break_8;
  end
  t_32 = field__493.sqlValue;
  val__495 = temper.mapped_getor(this__139._changes__448, t_32, '');
  if temper.string_isempty(val__495) then
    return__249 = this__139;
    goto break_8;
  end
  local_37, local_38, local_39 = temper.pcall(function()
    temper.string_tofloat64(val__495);
    parseOk__496 = true;
  end);
  if local_37 then
  else
    parseOk__496 = false;
  end
  if not parseOk__496 then
    local eb__497;
    eb__497 = temper.list_tolistbuilder(this__139._errors__449);
    temper.listbuilder_add(eb__497, ChangesetError(field__493.sqlValue, 'must be a number'));
    t_34 = this__139._tableDef__446;
    t_35 = this__139._params__447;
    t_36 = this__139._changes__448;
    t_33 = temper.listbuilder_tolist(eb__497);
    return__249 = ChangesetImpl__129(t_34, t_35, t_36, t_33, false);
    goto break_8;
  end
  return__249 = this__139;
  ::break_8::return return__249;
end;
ChangesetImpl__129.methods.validateBool = function(this__140, field__499)
  local return__250, t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48, t_49, t_50, val__501, isTrue__502, isFalse__503;
  ::continue_11::
  if not this__140._isValid__450 then
    return__250 = this__140;
    goto break_10;
  end
  t_41 = field__499.sqlValue;
  val__501 = temper.mapped_getor(this__140._changes__448, t_41, '');
  if temper.string_isempty(val__501) then
    return__250 = this__140;
    goto break_10;
  end
  if temper.str_eq(val__501, 'true') then
    isTrue__502 = true;
  else
    if temper.str_eq(val__501, '1') then
      t_44 = true;
    else
      if temper.str_eq(val__501, 'yes') then
        t_43 = true;
      else
        t_43 = temper.str_eq(val__501, 'on');
      end
      t_44 = t_43;
    end
    isTrue__502 = t_44;
  end
  if temper.str_eq(val__501, 'false') then
    isFalse__503 = true;
  else
    if temper.str_eq(val__501, '0') then
      t_46 = true;
    else
      if temper.str_eq(val__501, 'no') then
        t_45 = true;
      else
        t_45 = temper.str_eq(val__501, 'off');
      end
      t_46 = t_45;
    end
    isFalse__503 = t_46;
  end
  if not isTrue__502 then
    t_47 = not isFalse__503;
  else
    t_47 = false;
  end
  if t_47 then
    local eb__504;
    eb__504 = temper.list_tolistbuilder(this__140._errors__449);
    temper.listbuilder_add(eb__504, ChangesetError(field__499.sqlValue, 'must be a boolean (true/false/1/0/yes/no/on/off)'));
    t_48 = this__140._tableDef__446;
    t_49 = this__140._params__447;
    t_50 = this__140._changes__448;
    t_42 = temper.listbuilder_tolist(eb__504);
    return__250 = ChangesetImpl__129(t_48, t_49, t_50, t_42, false);
    goto break_10;
  end
  return__250 = this__140;
  ::break_10::return return__250;
end;
ChangesetImpl__129.methods.parseBoolSqlPart = function(this__141, val__506)
  local return__251, t_51, t_52, t_53, t_54, t_55, t_56;
  ::continue_13::
  if temper.str_eq(val__506, 'true') then
    t_53 = true;
  else
    if temper.str_eq(val__506, '1') then
      t_52 = true;
    else
      if temper.str_eq(val__506, 'yes') then
        t_51 = true;
      else
        t_51 = temper.str_eq(val__506, 'on');
      end
      t_52 = t_51;
    end
    t_53 = t_52;
  end
  if t_53 then
    return__251 = SqlBoolean(true);
    goto break_12;
  end
  if temper.str_eq(val__506, 'false') then
    t_56 = true;
  else
    if temper.str_eq(val__506, '0') then
      t_55 = true;
    else
      if temper.str_eq(val__506, 'no') then
        t_54 = true;
      else
        t_54 = temper.str_eq(val__506, 'off');
      end
      t_55 = t_54;
    end
    t_56 = t_55;
  end
  if t_56 then
    return__251 = SqlBoolean(false);
    goto break_12;
  end
  temper.bubble();
  ::break_12::return return__251;
end;
ChangesetImpl__129.methods.valueToSqlPart = function(this__142, fieldDef__509, val__510)
  local return__252, t_57, t_58, t_59, t_60, ft__512;
  ::continue_15::ft__512 = fieldDef__509.fieldType;
  if temper.instance_of(ft__512, StringField) then
    return__252 = SqlString(val__510);
    goto break_14;
  end
  if temper.instance_of(ft__512, IntField) then
    t_57 = temper.string_toint32(val__510);
    return__252 = SqlInt32(t_57);
    goto break_14;
  end
  if temper.instance_of(ft__512, Int64Field) then
    t_58 = temper.string_toint64(val__510);
    return__252 = SqlInt64(t_58);
    goto break_14;
  end
  if temper.instance_of(ft__512, FloatField) then
    t_59 = temper.string_tofloat64(val__510);
    return__252 = SqlFloat64(t_59);
    goto break_14;
  end
  if temper.instance_of(ft__512, BoolField) then
    return__252 = this__142:parseBoolSqlPart(val__510);
    goto break_14;
  end
  if temper.instance_of(ft__512, DateField) then
    t_60 = temper.date_fromisostring(val__510);
    return__252 = SqlDate(t_60);
    goto break_14;
  end
  temper.bubble();
  ::break_14::return return__252;
end;
ChangesetImpl__129.methods.toInsertSql = function(this__143)
  local t_61, t_62, t_63, t_64, t_65, t_66, t_67, t_68, t_69, t_70, i__515, pairs__517, colNames__518, valParts__519, i__520, b__523, t_71, fn__7013, j__525;
  if not this__143._isValid__450 then
    temper.bubble();
  end
  i__515 = 0;
  while true do
    local f__516;
    t_61 = temper.list_length(this__143._tableDef__446.fields);
    if not (i__515 < t_61) then
      break;
    end
    f__516 = temper.list_get(this__143._tableDef__446.fields, i__515);
    if not f__516.nullable then
      t_62 = f__516.name.sqlValue;
      t_63 = temper.mapped_has(this__143._changes__448, t_62);
      t_68 = not t_63;
    else
      t_68 = false;
    end
    if t_68 then
      temper.bubble();
    end
    i__515 = temper.int32_add(i__515, 1);
  end
  pairs__517 = temper.mapped_tolist(this__143._changes__448);
  if (temper.list_length(pairs__517) == 0) then
    temper.bubble();
  end
  colNames__518 = temper.listbuilder_constructor();
  valParts__519 = temper.listbuilder_constructor();
  i__520 = 0;
  while true do
    local pair__521, fd__522;
    t_64 = temper.list_length(pairs__517);
    if not (i__520 < t_64) then
      break;
    end
    pair__521 = temper.list_get(pairs__517, i__520);
    t_65 = pair__521.key;
    t_69 = this__143._tableDef__446:field(t_65);
    fd__522 = t_69;
    temper.listbuilder_add(colNames__518, fd__522.name.sqlValue);
    t_66 = pair__521.value;
    t_70 = this__143:valueToSqlPart(fd__522, t_66);
    temper.listbuilder_add(valParts__519, t_70);
    i__520 = temper.int32_add(i__520, 1);
  end
  b__523 = SqlBuilder();
  b__523:appendSafe('INSERT INTO ');
  b__523:appendSafe(this__143._tableDef__446.tableName.sqlValue);
  b__523:appendSafe(' (');
  t_71 = temper.listbuilder_tolist(colNames__518);
  fn__7013 = function(c__524)
    return c__524;
  end;
  b__523:appendSafe(temper.listed_join(t_71, ', ', fn__7013));
  b__523:appendSafe(') VALUES (');
  b__523:appendPart(temper.listed_get(valParts__519, 0));
  j__525 = 1;
  while true do
    t_67 = temper.listbuilder_length(valParts__519);
    if not (j__525 < t_67) then
      break;
    end
    b__523:appendSafe(', ');
    b__523:appendPart(temper.listed_get(valParts__519, j__525));
    j__525 = temper.int32_add(j__525, 1);
  end
  b__523:appendSafe(')');
  return b__523.accumulated;
end;
ChangesetImpl__129.methods.toUpdateSql = function(this__144, id__527)
  local t_72, t_73, t_74, t_75, t_76, pairs__529, b__530, i__531;
  if not this__144._isValid__450 then
    temper.bubble();
  end
  pairs__529 = temper.mapped_tolist(this__144._changes__448);
  if (temper.list_length(pairs__529) == 0) then
    temper.bubble();
  end
  b__530 = SqlBuilder();
  b__530:appendSafe('UPDATE ');
  b__530:appendSafe(this__144._tableDef__446.tableName.sqlValue);
  b__530:appendSafe(' SET ');
  i__531 = 0;
  while true do
    local pair__532, fd__533;
    t_72 = temper.list_length(pairs__529);
    if not (i__531 < t_72) then
      break;
    end
    if (i__531 > 0) then
      b__530:appendSafe(', ');
    end
    pair__532 = temper.list_get(pairs__529, i__531);
    t_73 = pair__532.key;
    t_75 = this__144._tableDef__446:field(t_73);
    fd__533 = t_75;
    b__530:appendSafe(fd__533.name.sqlValue);
    b__530:appendSafe(' = ');
    t_74 = pair__532.value;
    t_76 = this__144:valueToSqlPart(fd__533, t_74);
    b__530:appendPart(t_76);
    i__531 = temper.int32_add(i__531, 1);
  end
  b__530:appendSafe(' WHERE id = ');
  b__530:appendInt32(id__527);
  return b__530.accumulated;
end;
ChangesetImpl__129.constructor = function(this__235, _tableDef__535, _params__536, _changes__537, _errors__538, _isValid__539)
  this__235._tableDef__446 = _tableDef__535;
  this__235._params__447 = _params__536;
  this__235._changes__448 = _changes__537;
  this__235._errors__449 = _errors__538;
  this__235._isValid__450 = _isValid__539;
  return nil;
end;
JoinType = temper.type('JoinType');
JoinType.methods.keyword = function(this__145)
  temper.virtual();
end;
InnerJoin = temper.type('InnerJoin', JoinType);
InnerJoin.methods.keyword = function(this__146)
  return 'INNER JOIN';
end;
InnerJoin.constructor = function(this__260)
  return nil;
end;
LeftJoin = temper.type('LeftJoin', JoinType);
LeftJoin.methods.keyword = function(this__147)
  return 'LEFT JOIN';
end;
LeftJoin.constructor = function(this__263)
  return nil;
end;
RightJoin = temper.type('RightJoin', JoinType);
RightJoin.methods.keyword = function(this__148)
  return 'RIGHT JOIN';
end;
RightJoin.constructor = function(this__266)
  return nil;
end;
FullJoin = temper.type('FullJoin', JoinType);
FullJoin.methods.keyword = function(this__149)
  return 'FULL OUTER JOIN';
end;
FullJoin.constructor = function(this__269)
  return nil;
end;
JoinClause = temper.type('JoinClause');
JoinClause.constructor = function(this__272, joinType__652, table__653, onCondition__654)
  this__272.joinType__648 = joinType__652;
  this__272.table__649 = table__653;
  this__272.onCondition__650 = onCondition__654;
  return nil;
end;
JoinClause.get.joinType = function(this__1202)
  return this__1202.joinType__648;
end;
JoinClause.get.table = function(this__1205)
  return this__1205.table__649;
end;
JoinClause.get.onCondition = function(this__1208)
  return this__1208.onCondition__650;
end;
OrderClause = temper.type('OrderClause');
OrderClause.constructor = function(this__274, field__658, ascending__659)
  this__274.field__655 = field__658;
  this__274.ascending__656 = ascending__659;
  return nil;
end;
OrderClause.get.field = function(this__1211)
  return this__1211.field__655;
end;
OrderClause.get.ascending = function(this__1214)
  return this__1214.ascending__656;
end;
WhereClause = temper.type('WhereClause');
WhereClause.get.condition = function(this__150)
  temper.virtual();
end;
WhereClause.methods.keyword = function(this__151)
  temper.virtual();
end;
AndCondition = temper.type('AndCondition', WhereClause);
AndCondition.get.condition = function(this__152)
  return this__152._condition__664;
end;
AndCondition.methods.keyword = function(this__153)
  return 'AND';
end;
AndCondition.constructor = function(this__280, _condition__670)
  this__280._condition__664 = _condition__670;
  return nil;
end;
OrCondition = temper.type('OrCondition', WhereClause);
OrCondition.get.condition = function(this__154)
  return this__154._condition__671;
end;
OrCondition.methods.keyword = function(this__155)
  return 'OR';
end;
OrCondition.constructor = function(this__285, _condition__677)
  this__285._condition__671 = _condition__677;
  return nil;
end;
Query = temper.type('Query');
Query.methods.where = function(this__156, condition__686)
  local nb__688;
  nb__688 = temper.list_tolistbuilder(this__156.conditions__679);
  temper.listbuilder_add(nb__688, AndCondition(condition__686));
  return Query(this__156.tableName__678, temper.listbuilder_tolist(nb__688), this__156.selectedFields__680, this__156.orderClauses__681, this__156.limitVal__682, this__156.offsetVal__683, this__156.joinClauses__684);
end;
Query.methods.orWhere = function(this__157, condition__690)
  local nb__692;
  nb__692 = temper.list_tolistbuilder(this__157.conditions__679);
  temper.listbuilder_add(nb__692, OrCondition(condition__690));
  return Query(this__157.tableName__678, temper.listbuilder_tolist(nb__692), this__157.selectedFields__680, this__157.orderClauses__681, this__157.limitVal__682, this__157.offsetVal__683, this__157.joinClauses__684);
end;
Query.methods.whereNull = function(this__158, field__694)
  local b__696, t_77;
  b__696 = SqlBuilder();
  b__696:appendSafe(field__694.sqlValue);
  b__696:appendSafe(' IS NULL');
  t_77 = b__696.accumulated;
  return this__158:where(t_77);
end;
Query.methods.whereNotNull = function(this__159, field__698)
  local b__700, t_78;
  b__700 = SqlBuilder();
  b__700:appendSafe(field__698.sqlValue);
  b__700:appendSafe(' IS NOT NULL');
  t_78 = b__700.accumulated;
  return this__159:where(t_78);
end;
Query.methods.whereIn = function(this__160, field__702, values__703)
  local return__301, t_79, t_80, t_81, b__706, i__707;
  ::continue_17::
  if temper.listed_isempty(values__703) then
    local b__705;
    b__705 = SqlBuilder();
    b__705:appendSafe('1 = 0');
    t_79 = b__705.accumulated;
    return__301 = this__160:where(t_79);
    goto break_16;
  end
  b__706 = SqlBuilder();
  b__706:appendSafe(field__702.sqlValue);
  b__706:appendSafe(' IN (');
  b__706:appendPart(temper.list_get(values__703, 0));
  i__707 = 1;
  while true do
    t_80 = temper.list_length(values__703);
    if not (i__707 < t_80) then
      break;
    end
    b__706:appendSafe(', ');
    b__706:appendPart(temper.list_get(values__703, i__707));
    i__707 = temper.int32_add(i__707, 1);
  end
  b__706:appendSafe(')');
  t_81 = b__706.accumulated;
  return__301 = this__160:where(t_81);
  ::break_16::return return__301;
end;
Query.methods.whereNot = function(this__161, condition__709)
  local b__711, t_82;
  b__711 = SqlBuilder();
  b__711:appendSafe('NOT (');
  b__711:appendFragment(condition__709);
  b__711:appendSafe(')');
  t_82 = b__711.accumulated;
  return this__161:where(t_82);
end;
Query.methods.whereBetween = function(this__162, field__713, low__714, high__715)
  local b__717, t_83;
  b__717 = SqlBuilder();
  b__717:appendSafe(field__713.sqlValue);
  b__717:appendSafe(' BETWEEN ');
  b__717:appendPart(low__714);
  b__717:appendSafe(' AND ');
  b__717:appendPart(high__715);
  t_83 = b__717.accumulated;
  return this__162:where(t_83);
end;
Query.methods.whereLike = function(this__163, field__719, pattern__720)
  local b__722, t_84;
  b__722 = SqlBuilder();
  b__722:appendSafe(field__719.sqlValue);
  b__722:appendSafe(' LIKE ');
  b__722:appendString(pattern__720);
  t_84 = b__722.accumulated;
  return this__163:where(t_84);
end;
Query.methods.whereILike = function(this__164, field__724, pattern__725)
  local b__727, t_85;
  b__727 = SqlBuilder();
  b__727:appendSafe(field__724.sqlValue);
  b__727:appendSafe(' ILIKE ');
  b__727:appendString(pattern__725);
  t_85 = b__727.accumulated;
  return this__164:where(t_85);
end;
Query.methods.select = function(this__165, fields__729)
  return Query(this__165.tableName__678, this__165.conditions__679, fields__729, this__165.orderClauses__681, this__165.limitVal__682, this__165.offsetVal__683, this__165.joinClauses__684);
end;
Query.methods.orderBy = function(this__166, field__732, ascending__733)
  local nb__735;
  nb__735 = temper.list_tolistbuilder(this__166.orderClauses__681);
  temper.listbuilder_add(nb__735, OrderClause(field__732, ascending__733));
  return Query(this__166.tableName__678, this__166.conditions__679, this__166.selectedFields__680, temper.listbuilder_tolist(nb__735), this__166.limitVal__682, this__166.offsetVal__683, this__166.joinClauses__684);
end;
Query.methods.limit = function(this__167, n__737)
  if (n__737 < 0) then
    temper.bubble();
  end
  return Query(this__167.tableName__678, this__167.conditions__679, this__167.selectedFields__680, this__167.orderClauses__681, n__737, this__167.offsetVal__683, this__167.joinClauses__684);
end;
Query.methods.offset = function(this__168, n__740)
  if (n__740 < 0) then
    temper.bubble();
  end
  return Query(this__168.tableName__678, this__168.conditions__679, this__168.selectedFields__680, this__168.orderClauses__681, this__168.limitVal__682, n__740, this__168.joinClauses__684);
end;
Query.methods.join = function(this__169, joinType__743, table__744, onCondition__745)
  local nb__747;
  nb__747 = temper.list_tolistbuilder(this__169.joinClauses__684);
  temper.listbuilder_add(nb__747, JoinClause(joinType__743, table__744, onCondition__745));
  return Query(this__169.tableName__678, this__169.conditions__679, this__169.selectedFields__680, this__169.orderClauses__681, this__169.limitVal__682, this__169.offsetVal__683, temper.listbuilder_tolist(nb__747));
end;
Query.methods.innerJoin = function(this__170, table__749, onCondition__750)
  local t_86;
  t_86 = InnerJoin();
  return this__170:join(t_86, table__749, onCondition__750);
end;
Query.methods.leftJoin = function(this__171, table__753, onCondition__754)
  local t_87;
  t_87 = LeftJoin();
  return this__171:join(t_87, table__753, onCondition__754);
end;
Query.methods.rightJoin = function(this__172, table__757, onCondition__758)
  local t_88;
  t_88 = RightJoin();
  return this__172:join(t_88, table__757, onCondition__758);
end;
Query.methods.fullJoin = function(this__173, table__761, onCondition__762)
  local t_89;
  t_89 = FullJoin();
  return this__173:join(t_89, table__761, onCondition__762);
end;
Query.methods.toSql = function(this__174)
  local t_90, b__766, fn__6475, lv__772, ov__773;
  b__766 = SqlBuilder();
  b__766:appendSafe('SELECT ');
  if temper.listed_isempty(this__174.selectedFields__680) then
    b__766:appendSafe('*');
  else
    local fn__6476;
    fn__6476 = function(f__767)
      return f__767.sqlValue;
    end;
    b__766:appendSafe(temper.listed_join(this__174.selectedFields__680, ', ', fn__6476));
  end
  b__766:appendSafe(' FROM ');
  b__766:appendSafe(this__174.tableName__678.sqlValue);
  fn__6475 = function(jc__768)
    local t_91, t_92, t_93;
    b__766:appendSafe(' ');
    t_91 = jc__768.joinType:keyword();
    b__766:appendSafe(t_91);
    b__766:appendSafe(' ');
    t_92 = jc__768.table.sqlValue;
    b__766:appendSafe(t_92);
    b__766:appendSafe(' ON ');
    t_93 = jc__768.onCondition;
    b__766:appendFragment(t_93);
    return nil;
  end;
  temper.list_foreach(this__174.joinClauses__684, fn__6475);
  if not temper.listed_isempty(this__174.conditions__679) then
    local i__769;
    b__766:appendSafe(' WHERE ');
    b__766:appendFragment((temper.list_get(this__174.conditions__679, 0)).condition);
    i__769 = 1;
    while true do
      t_90 = temper.list_length(this__174.conditions__679);
      if not (i__769 < t_90) then
        break;
      end
      b__766:appendSafe(' ');
      b__766:appendSafe(temper.list_get(this__174.conditions__679, i__769):keyword());
      b__766:appendSafe(' ');
      b__766:appendFragment((temper.list_get(this__174.conditions__679, i__769)).condition);
      i__769 = temper.int32_add(i__769, 1);
    end
  end
  if not temper.listed_isempty(this__174.orderClauses__681) then
    local first__770, fn__6474;
    b__766:appendSafe(' ORDER BY ');
    first__770 = true;
    fn__6474 = function(oc__771)
      local t_94, t_95;
      if not first__770 then
        b__766:appendSafe(', ');
      end
      first__770 = false;
      t_95 = oc__771.field.sqlValue;
      b__766:appendSafe(t_95);
      if oc__771.ascending then
        t_94 = ' ASC';
      else
        t_94 = ' DESC';
      end
      b__766:appendSafe(t_94);
      return nil;
    end;
    temper.list_foreach(this__174.orderClauses__681, fn__6474);
  end
  lv__772 = this__174.limitVal__682;
  if not temper.is_null(lv__772) then
    local lv_96;
    lv_96 = lv__772;
    b__766:appendSafe(' LIMIT ');
    b__766:appendInt32(lv_96);
  end
  ov__773 = this__174.offsetVal__683;
  if not temper.is_null(ov__773) then
    local ov_97;
    ov_97 = ov__773;
    b__766:appendSafe(' OFFSET ');
    b__766:appendInt32(ov_97);
  end
  return b__766.accumulated;
end;
Query.methods.safeToSql = function(this__175, defaultLimit__775)
  local return__316, t_98;
  if (defaultLimit__775 < 0) then
    temper.bubble();
  end
  if not temper.is_null(this__175.limitVal__682) then
    return__316 = this__175:toSql();
  else
    t_98 = this__175:limit(defaultLimit__775);
    return__316 = t_98:toSql();
  end
  return return__316;
end;
Query.constructor = function(this__289, tableName__778, conditions__779, selectedFields__780, orderClauses__781, limitVal__782, offsetVal__783, joinClauses__784)
  if (limitVal__782 == nil) then
    limitVal__782 = temper.null;
  end
  if (offsetVal__783 == nil) then
    offsetVal__783 = temper.null;
  end
  this__289.tableName__678 = tableName__778;
  this__289.conditions__679 = conditions__779;
  this__289.selectedFields__680 = selectedFields__780;
  this__289.orderClauses__681 = orderClauses__781;
  this__289.limitVal__682 = limitVal__782;
  this__289.offsetVal__683 = offsetVal__783;
  this__289.joinClauses__684 = joinClauses__784;
  return nil;
end;
Query.get.tableName = function(this__1217)
  return this__1217.tableName__678;
end;
Query.get.conditions = function(this__1220)
  return this__1220.conditions__679;
end;
Query.get.selectedFields = function(this__1223)
  return this__1223.selectedFields__680;
end;
Query.get.orderClauses = function(this__1226)
  return this__1226.orderClauses__681;
end;
Query.get.limitVal = function(this__1229)
  return this__1229.limitVal__682;
end;
Query.get.offsetVal = function(this__1232)
  return this__1232.offsetVal__683;
end;
Query.get.joinClauses = function(this__1235)
  return this__1235.joinClauses__684;
end;
SafeIdentifier = temper.type('SafeIdentifier');
SafeIdentifier.get.sqlValue = function(this__176)
  temper.virtual();
end;
ValidatedIdentifier__177 = temper.type('ValidatedIdentifier__177', SafeIdentifier);
ValidatedIdentifier__177.get.sqlValue = function(this__178)
  return this__178._value__894;
end;
ValidatedIdentifier__177.constructor = function(this__323, _value__898)
  this__323._value__894 = _value__898;
  return nil;
end;
FieldType = temper.type('FieldType');
StringField = temper.type('StringField', FieldType);
StringField.constructor = function(this__329)
  return nil;
end;
IntField = temper.type('IntField', FieldType);
IntField.constructor = function(this__331)
  return nil;
end;
Int64Field = temper.type('Int64Field', FieldType);
Int64Field.constructor = function(this__333)
  return nil;
end;
FloatField = temper.type('FloatField', FieldType);
FloatField.constructor = function(this__335)
  return nil;
end;
BoolField = temper.type('BoolField', FieldType);
BoolField.constructor = function(this__337)
  return nil;
end;
DateField = temper.type('DateField', FieldType);
DateField.constructor = function(this__339)
  return nil;
end;
FieldDef = temper.type('FieldDef');
FieldDef.constructor = function(this__341, name__916, fieldType__917, nullable__918)
  this__341.name__912 = name__916;
  this__341.fieldType__913 = fieldType__917;
  this__341.nullable__914 = nullable__918;
  return nil;
end;
FieldDef.get.name = function(this__1140)
  return this__1140.name__912;
end;
FieldDef.get.fieldType = function(this__1143)
  return this__1143.fieldType__913;
end;
FieldDef.get.nullable = function(this__1146)
  return this__1146.nullable__914;
end;
TableDef = temper.type('TableDef');
TableDef.methods.field = function(this__179, name__922)
  local return__346, this__4373, n__4374, i__4375;
  ::continue_19::this__4373 = this__179.fields__920;
  n__4374 = temper.list_length(this__4373);
  i__4375 = 0;
  while (i__4375 < n__4374) do
    local el__4376, f__924;
    el__4376 = temper.list_get(this__4373, i__4375);
    i__4375 = temper.int32_add(i__4375, 1);
    f__924 = el__4376;
    if temper.str_eq(f__924.name.sqlValue, name__922) then
      return__346 = f__924;
      goto break_18;
    end
  end
  temper.bubble();
  ::break_18::return return__346;
end;
TableDef.constructor = function(this__343, tableName__926, fields__927)
  this__343.tableName__919 = tableName__926;
  this__343.fields__920 = fields__927;
  return nil;
end;
TableDef.get.tableName = function(this__1149)
  return this__1149.tableName__919;
end;
TableDef.get.fields = function(this__1152)
  return this__1152.fields__920;
end;
SqlBuilder = temper.type('SqlBuilder');
SqlBuilder.methods.appendSafe = function(this__180, sqlSource__949)
  local t_99;
  t_99 = SqlSource(sqlSource__949);
  temper.listbuilder_add(this__180.buffer__947, t_99);
  return nil;
end;
SqlBuilder.methods.appendFragment = function(this__181, fragment__952)
  local t_100;
  t_100 = fragment__952.parts;
  temper.listbuilder_addall(this__181.buffer__947, t_100);
  return nil;
end;
SqlBuilder.methods.appendPart = function(this__182, part__955)
  temper.listbuilder_add(this__182.buffer__947, part__955);
  return nil;
end;
SqlBuilder.methods.appendPartList = function(this__183, values__958)
  local fn__7184;
  fn__7184 = function(x__960)
    this__183:appendPart(x__960);
    return nil;
  end;
  this__183:appendList(values__958, fn__7184);
  return nil;
end;
SqlBuilder.methods.appendBoolean = function(this__184, value__962)
  local t_101;
  t_101 = SqlBoolean(value__962);
  temper.listbuilder_add(this__184.buffer__947, t_101);
  return nil;
end;
SqlBuilder.methods.appendBooleanList = function(this__185, values__965)
  local fn__7178;
  fn__7178 = function(x__967)
    this__185:appendBoolean(x__967);
    return nil;
  end;
  this__185:appendList(values__965, fn__7178);
  return nil;
end;
SqlBuilder.methods.appendDate = function(this__186, value__969)
  local t_102;
  t_102 = SqlDate(value__969);
  temper.listbuilder_add(this__186.buffer__947, t_102);
  return nil;
end;
SqlBuilder.methods.appendDateList = function(this__187, values__972)
  local fn__7172;
  fn__7172 = function(x__974)
    this__187:appendDate(x__974);
    return nil;
  end;
  this__187:appendList(values__972, fn__7172);
  return nil;
end;
SqlBuilder.methods.appendFloat64 = function(this__188, value__976)
  local t_103;
  t_103 = SqlFloat64(value__976);
  temper.listbuilder_add(this__188.buffer__947, t_103);
  return nil;
end;
SqlBuilder.methods.appendFloat64List = function(this__189, values__979)
  local fn__7166;
  fn__7166 = function(x__981)
    this__189:appendFloat64(x__981);
    return nil;
  end;
  this__189:appendList(values__979, fn__7166);
  return nil;
end;
SqlBuilder.methods.appendInt32 = function(this__190, value__983)
  local t_104;
  t_104 = SqlInt32(value__983);
  temper.listbuilder_add(this__190.buffer__947, t_104);
  return nil;
end;
SqlBuilder.methods.appendInt32List = function(this__191, values__986)
  local fn__7160;
  fn__7160 = function(x__988)
    this__191:appendInt32(x__988);
    return nil;
  end;
  this__191:appendList(values__986, fn__7160);
  return nil;
end;
SqlBuilder.methods.appendInt64 = function(this__192, value__990)
  local t_105;
  t_105 = SqlInt64(value__990);
  temper.listbuilder_add(this__192.buffer__947, t_105);
  return nil;
end;
SqlBuilder.methods.appendInt64List = function(this__193, values__993)
  local fn__7154;
  fn__7154 = function(x__995)
    this__193:appendInt64(x__995);
    return nil;
  end;
  this__193:appendList(values__993, fn__7154);
  return nil;
end;
SqlBuilder.methods.appendString = function(this__194, value__997)
  local t_106;
  t_106 = SqlString(value__997);
  temper.listbuilder_add(this__194.buffer__947, t_106);
  return nil;
end;
SqlBuilder.methods.appendStringList = function(this__195, values__1000)
  local fn__7148;
  fn__7148 = function(x__1002)
    this__195:appendString(x__1002);
    return nil;
  end;
  this__195:appendList(values__1000, fn__7148);
  return nil;
end;
SqlBuilder.methods.appendList = function(this__196, values__1004, appendValue__1005)
  local t_107, t_108, i__1007;
  i__1007 = 0;
  while true do
    t_107 = temper.listed_length(values__1004);
    if not (i__1007 < t_107) then
      break;
    end
    if (i__1007 > 0) then
      this__196:appendSafe(', ');
    end
    t_108 = temper.listed_get(values__1004, i__1007);
    appendValue__1005(t_108);
    i__1007 = temper.int32_add(i__1007, 1);
  end
  return nil;
end;
SqlBuilder.get.accumulated = function(this__197)
  return SqlFragment(temper.listbuilder_tolist(this__197.buffer__947));
end;
SqlBuilder.constructor = function(this__348)
  local t_109;
  t_109 = temper.listbuilder_constructor();
  this__348.buffer__947 = t_109;
  return nil;
end;
SqlFragment = temper.type('SqlFragment');
SqlFragment.methods.toSource = function(this__202)
  return SqlSource(this__202:toString());
end;
SqlFragment.methods.toString = function(this__203)
  local t_110, builder__1019, i__1020;
  builder__1019 = temper.stringbuilder_constructor();
  i__1020 = 0;
  while true do
    t_110 = temper.list_length(this__203.parts__1014);
    if not (i__1020 < t_110) then
      break;
    end
    temper.list_get(this__203.parts__1014, i__1020):formatTo(builder__1019);
    i__1020 = temper.int32_add(i__1020, 1);
  end
  return temper.stringbuilder_tostring(builder__1019);
end;
SqlFragment.constructor = function(this__369, parts__1022)
  this__369.parts__1014 = parts__1022;
  return nil;
end;
SqlFragment.get.parts = function(this__1158)
  return this__1158.parts__1014;
end;
SqlPart = temper.type('SqlPart');
SqlPart.methods.formatTo = function(this__204, builder__1024)
  temper.virtual();
end;
SqlSource = temper.type('SqlSource', SqlPart);
SqlSource.methods.formatTo = function(this__205, builder__1028)
  temper.stringbuilder_append(builder__1028, this__205.source__1026);
  return nil;
end;
SqlSource.constructor = function(this__375, source__1031)
  this__375.source__1026 = source__1031;
  return nil;
end;
SqlSource.get.source = function(this__1155)
  return this__1155.source__1026;
end;
SqlBoolean = temper.type('SqlBoolean', SqlPart);
SqlBoolean.methods.formatTo = function(this__206, builder__1034)
  local t_111;
  if this__206.value__1032 then
    t_111 = 'TRUE';
  else
    t_111 = 'FALSE';
  end
  temper.stringbuilder_append(builder__1034, t_111);
  return nil;
end;
SqlBoolean.constructor = function(this__378, value__1037)
  this__378.value__1032 = value__1037;
  return nil;
end;
SqlBoolean.get.value = function(this__1161)
  return this__1161.value__1032;
end;
SqlDate = temper.type('SqlDate', SqlPart);
SqlDate.methods.formatTo = function(this__207, builder__1040)
  local t_112, fn__7193;
  temper.stringbuilder_append(builder__1040, "'");
  t_112 = temper.date_tostring(this__207.value__1038);
  fn__7193 = function(c__1042)
    if (c__1042 == 39) then
      temper.stringbuilder_append(builder__1040, "''");
    else
      local local_113, local_114, local_115;
      local_113, local_114, local_115 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__1040, c__1042);
      end);
      if local_113 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(t_112, fn__7193);
  temper.stringbuilder_append(builder__1040, "'");
  return nil;
end;
SqlDate.constructor = function(this__381, value__1044)
  this__381.value__1038 = value__1044;
  return nil;
end;
SqlDate.get.value = function(this__1176)
  return this__1176.value__1038;
end;
SqlFloat64 = temper.type('SqlFloat64', SqlPart);
SqlFloat64.methods.formatTo = function(this__208, builder__1047)
  local t_117, t_118, s__1049;
  s__1049 = temper.float64_tostring(this__208.value__1045);
  if temper.str_eq(s__1049, 'NaN') then
    t_118 = true;
  else
    if temper.str_eq(s__1049, 'Infinity') then
      t_117 = true;
    else
      t_117 = temper.str_eq(s__1049, '-Infinity');
    end
    t_118 = t_117;
  end
  if t_118 then
    temper.stringbuilder_append(builder__1047, 'NULL');
  else
    temper.stringbuilder_append(builder__1047, s__1049);
  end
  return nil;
end;
SqlFloat64.constructor = function(this__384, value__1051)
  this__384.value__1045 = value__1051;
  return nil;
end;
SqlFloat64.get.value = function(this__1173)
  return this__1173.value__1045;
end;
SqlInt32 = temper.type('SqlInt32', SqlPart);
SqlInt32.methods.formatTo = function(this__209, builder__1054)
  local t_119;
  t_119 = temper.int32_tostring(this__209.value__1052);
  temper.stringbuilder_append(builder__1054, t_119);
  return nil;
end;
SqlInt32.constructor = function(this__387, value__1057)
  this__387.value__1052 = value__1057;
  return nil;
end;
SqlInt32.get.value = function(this__1167)
  return this__1167.value__1052;
end;
SqlInt64 = temper.type('SqlInt64', SqlPart);
SqlInt64.methods.formatTo = function(this__210, builder__1060)
  local t_120;
  t_120 = temper.int64_tostring(this__210.value__1058);
  temper.stringbuilder_append(builder__1060, t_120);
  return nil;
end;
SqlInt64.constructor = function(this__390, value__1063)
  this__390.value__1058 = value__1063;
  return nil;
end;
SqlInt64.get.value = function(this__1170)
  return this__1170.value__1058;
end;
SqlString = temper.type('SqlString', SqlPart);
SqlString.methods.formatTo = function(this__211, builder__1066)
  local fn__7207;
  temper.stringbuilder_append(builder__1066, "'");
  fn__7207 = function(c__1068)
    if (c__1068 == 39) then
      temper.stringbuilder_append(builder__1066, "''");
    else
      local local_121, local_122, local_123;
      local_121, local_122, local_123 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__1066, c__1068);
      end);
      if local_121 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(this__211.value__1064, fn__7207);
  temper.stringbuilder_append(builder__1066, "'");
  return nil;
end;
SqlString.constructor = function(this__393, value__1070)
  this__393.value__1064 = value__1070;
  return nil;
end;
SqlString.get.value = function(this__1164)
  return this__1164.value__1064;
end;
changeset = function(tableDef__540, params__541)
  local t_125;
  t_125 = temper.map_constructor(temper.listof());
  return ChangesetImpl__129(tableDef__540, params__541, t_125, temper.listof(), true);
end;
isIdentStart__401 = function(c__899)
  local return__326, t_126, t_127;
  if (c__899 >= 97) then
    t_126 = (c__899 <= 122);
  else
    t_126 = false;
  end
  if t_126 then
    return__326 = true;
  else
    if (c__899 >= 65) then
      t_127 = (c__899 <= 90);
    else
      t_127 = false;
    end
    if t_127 then
      return__326 = true;
    else
      return__326 = (c__899 == 95);
    end
  end
  return return__326;
end;
isIdentPart__402 = function(c__901)
  local return__327;
  if isIdentStart__401(c__901) then
    return__327 = true;
  elseif (c__901 >= 48) then
    return__327 = (c__901 <= 57);
  else
    return__327 = false;
  end
  return return__327;
end;
safeIdentifier = function(name__903)
  local t_128, idx__905, t_129;
  if temper.string_isempty(name__903) then
    temper.bubble();
  end
  idx__905 = 1.0;
  if not isIdentStart__401(temper.string_get(name__903, idx__905)) then
    temper.bubble();
  end
  t_129 = temper.string_next(name__903, idx__905);
  idx__905 = t_129;
  while true do
    if not temper.string_hasindex(name__903, idx__905) then
      break;
    end
    if not isIdentPart__402(temper.string_get(name__903, idx__905)) then
      temper.bubble();
    end
    t_128 = temper.string_next(name__903, idx__905);
    idx__905 = t_128;
  end
  return ValidatedIdentifier__177(name__903);
end;
deleteSql = function(tableDef__630, id__631)
  local b__633;
  b__633 = SqlBuilder();
  b__633:appendSafe('DELETE FROM ');
  b__633:appendSafe(tableDef__630.tableName.sqlValue);
  b__633:appendSafe(' WHERE id = ');
  b__633:appendInt32(id__631);
  return b__633.accumulated;
end;
from = function(tableName__785)
  return Query(tableName__785, temper.listof(), temper.listof(), temper.listof(), temper.null, temper.null, temper.listof());
end;
col = function(table__787, column__788)
  local b__790;
  b__790 = SqlBuilder();
  b__790:appendSafe(table__787.sqlValue);
  b__790:appendSafe('.');
  b__790:appendSafe(column__788.sqlValue);
  return b__790.accumulated;
end;
exports = {};
exports.ChangesetError = ChangesetError;
exports.Changeset = Changeset;
exports.JoinType = JoinType;
exports.InnerJoin = InnerJoin;
exports.LeftJoin = LeftJoin;
exports.RightJoin = RightJoin;
exports.FullJoin = FullJoin;
exports.JoinClause = JoinClause;
exports.OrderClause = OrderClause;
exports.WhereClause = WhereClause;
exports.AndCondition = AndCondition;
exports.OrCondition = OrCondition;
exports.Query = Query;
exports.SafeIdentifier = SafeIdentifier;
exports.FieldType = FieldType;
exports.StringField = StringField;
exports.IntField = IntField;
exports.Int64Field = Int64Field;
exports.FloatField = FloatField;
exports.BoolField = BoolField;
exports.DateField = DateField;
exports.FieldDef = FieldDef;
exports.TableDef = TableDef;
exports.SqlBuilder = SqlBuilder;
exports.SqlFragment = SqlFragment;
exports.SqlPart = SqlPart;
exports.SqlSource = SqlSource;
exports.SqlBoolean = SqlBoolean;
exports.SqlDate = SqlDate;
exports.SqlFloat64 = SqlFloat64;
exports.SqlInt32 = SqlInt32;
exports.SqlInt64 = SqlInt64;
exports.SqlString = SqlString;
exports.changeset = changeset;
exports.safeIdentifier = safeIdentifier;
exports.deleteSql = deleteSql;
exports.from = from;
exports.col = col;
return exports;
