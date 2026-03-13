local temper = require('temper-core');
local ChangesetError, Changeset, ChangesetImpl__151, JoinType, InnerJoin, LeftJoin, RightJoin, FullJoin, JoinClause, OrderClause, WhereClause, AndCondition, OrCondition, Query, SafeIdentifier, ValidatedIdentifier__205, FieldType, StringField, IntField, Int64Field, FloatField, BoolField, DateField, FieldDef, TableDef, SqlBuilder, SqlFragment, SqlPart, SqlSource, SqlBoolean, SqlDate, SqlFloat64, SqlInt32, SqlInt64, SqlString, changeset, isIdentStart__444, isIdentPart__445, safeIdentifier, deleteSql, from, col, countAll, countCol, sumCol, avgCol, minCol, maxCol, exports;
ChangesetError = temper.type('ChangesetError');
ChangesetError.constructor = function(this__240, field__451, message__452)
  this__240.field__448 = field__451;
  this__240.message__449 = message__452;
  return nil;
end;
ChangesetError.get.field = function(this__1276)
  return this__1276.field__448;
end;
ChangesetError.get.message = function(this__1279)
  return this__1279.message__449;
end;
Changeset = temper.type('Changeset');
Changeset.get.tableDef = function(this__138)
  temper.virtual();
end;
Changeset.get.changes = function(this__139)
  temper.virtual();
end;
Changeset.get.errors = function(this__140)
  temper.virtual();
end;
Changeset.get.isValid = function(this__141)
  temper.virtual();
end;
Changeset.methods.cast = function(this__142, allowedFields__462)
  temper.virtual();
end;
Changeset.methods.validateRequired = function(this__143, fields__465)
  temper.virtual();
end;
Changeset.methods.validateLength = function(this__144, field__468, min__469, max__470)
  temper.virtual();
end;
Changeset.methods.validateInt = function(this__145, field__473)
  temper.virtual();
end;
Changeset.methods.validateInt64 = function(this__146, field__476)
  temper.virtual();
end;
Changeset.methods.validateFloat = function(this__147, field__479)
  temper.virtual();
end;
Changeset.methods.validateBool = function(this__148, field__482)
  temper.virtual();
end;
Changeset.methods.toInsertSql = function(this__149)
  temper.virtual();
end;
Changeset.methods.toUpdateSql = function(this__150, id__487)
  temper.virtual();
end;
ChangesetImpl__151 = temper.type('ChangesetImpl__151', Changeset);
ChangesetImpl__151.get.tableDef = function(this__152)
  return this__152._tableDef__489;
end;
ChangesetImpl__151.get.changes = function(this__153)
  return this__153._changes__491;
end;
ChangesetImpl__151.get.errors = function(this__154)
  return this__154._errors__492;
end;
ChangesetImpl__151.get.isValid = function(this__155)
  return this__155._isValid__493;
end;
ChangesetImpl__151.methods.cast = function(this__156, allowedFields__503)
  local mb__505, fn__8709;
  mb__505 = temper.mapbuilder_constructor();
  fn__8709 = function(f__506)
    local t_0, t_1, val__507;
    t_1 = f__506.sqlValue;
    val__507 = temper.mapped_getor(this__156._params__490, t_1, '');
    if not temper.string_isempty(val__507) then
      t_0 = f__506.sqlValue;
      temper.mapbuilder_set(mb__505, t_0, val__507);
    end
    return nil;
  end;
  temper.list_foreach(allowedFields__503, fn__8709);
  return ChangesetImpl__151(this__156._tableDef__489, this__156._params__490, temper.mapped_tomap(mb__505), this__156._errors__492, this__156._isValid__493);
end;
ChangesetImpl__151.methods.validateRequired = function(this__157, fields__509)
  local return__273, t_2, t_3, t_4, t_5, eb__511, valid__512, fn__8698;
  ::continue_1::
  if not this__157._isValid__493 then
    return__273 = this__157;
    goto break_0;
  end
  eb__511 = temper.list_tolistbuilder(this__157._errors__492);
  valid__512 = true;
  fn__8698 = function(f__513)
    local t_6, t_7;
    t_7 = f__513.sqlValue;
    if not temper.mapped_has(this__157._changes__491, t_7) then
      t_6 = ChangesetError(f__513.sqlValue, 'is required');
      temper.listbuilder_add(eb__511, t_6);
      valid__512 = false;
    end
    return nil;
  end;
  temper.list_foreach(fields__509, fn__8698);
  t_3 = this__157._tableDef__489;
  t_4 = this__157._params__490;
  t_5 = this__157._changes__491;
  t_2 = temper.listbuilder_tolist(eb__511);
  return__273 = ChangesetImpl__151(t_3, t_4, t_5, t_2, valid__512);
  ::break_0::return return__273;
end;
ChangesetImpl__151.methods.validateLength = function(this__158, field__515, min__516, max__517)
  local return__274, t_8, t_9, t_10, t_11, t_12, t_13, val__519, len__520;
  ::continue_3::
  if not this__158._isValid__493 then
    return__274 = this__158;
    goto break_2;
  end
  t_8 = field__515.sqlValue;
  val__519 = temper.mapped_getor(this__158._changes__491, t_8, '');
  len__520 = temper.string_countbetween(val__519, 1.0, temper.string_end(val__519));
  if (len__520 < min__516) then
    t_10 = true;
  else
    t_10 = (len__520 > max__517);
  end
  if t_10 then
    local msg__521, eb__522;
    msg__521 = temper.concat('must be between ', temper.int32_tostring(min__516), ' and ', temper.int32_tostring(max__517), ' characters');
    eb__522 = temper.list_tolistbuilder(this__158._errors__492);
    temper.listbuilder_add(eb__522, ChangesetError(field__515.sqlValue, msg__521));
    t_11 = this__158._tableDef__489;
    t_12 = this__158._params__490;
    t_13 = this__158._changes__491;
    t_9 = temper.listbuilder_tolist(eb__522);
    return__274 = ChangesetImpl__151(t_11, t_12, t_13, t_9, false);
    goto break_2;
  end
  return__274 = this__158;
  ::break_2::return return__274;
end;
ChangesetImpl__151.methods.validateInt = function(this__159, field__524)
  local return__275, t_14, t_15, t_16, t_17, t_18, val__526, parseOk__527, local_19, local_20, local_21;
  ::continue_5::
  if not this__159._isValid__493 then
    return__275 = this__159;
    goto break_4;
  end
  t_14 = field__524.sqlValue;
  val__526 = temper.mapped_getor(this__159._changes__491, t_14, '');
  if temper.string_isempty(val__526) then
    return__275 = this__159;
    goto break_4;
  end
  local_19, local_20, local_21 = temper.pcall(function()
    temper.string_toint32(val__526);
    parseOk__527 = true;
  end);
  if local_19 then
  else
    parseOk__527 = false;
  end
  if not parseOk__527 then
    local eb__528;
    eb__528 = temper.list_tolistbuilder(this__159._errors__492);
    temper.listbuilder_add(eb__528, ChangesetError(field__524.sqlValue, 'must be an integer'));
    t_16 = this__159._tableDef__489;
    t_17 = this__159._params__490;
    t_18 = this__159._changes__491;
    t_15 = temper.listbuilder_tolist(eb__528);
    return__275 = ChangesetImpl__151(t_16, t_17, t_18, t_15, false);
    goto break_4;
  end
  return__275 = this__159;
  ::break_4::return return__275;
end;
ChangesetImpl__151.methods.validateInt64 = function(this__160, field__530)
  local return__276, t_23, t_24, t_25, t_26, t_27, val__532, parseOk__533, local_28, local_29, local_30;
  ::continue_7::
  if not this__160._isValid__493 then
    return__276 = this__160;
    goto break_6;
  end
  t_23 = field__530.sqlValue;
  val__532 = temper.mapped_getor(this__160._changes__491, t_23, '');
  if temper.string_isempty(val__532) then
    return__276 = this__160;
    goto break_6;
  end
  local_28, local_29, local_30 = temper.pcall(function()
    temper.string_toint64(val__532);
    parseOk__533 = true;
  end);
  if local_28 then
  else
    parseOk__533 = false;
  end
  if not parseOk__533 then
    local eb__534;
    eb__534 = temper.list_tolistbuilder(this__160._errors__492);
    temper.listbuilder_add(eb__534, ChangesetError(field__530.sqlValue, 'must be a 64-bit integer'));
    t_25 = this__160._tableDef__489;
    t_26 = this__160._params__490;
    t_27 = this__160._changes__491;
    t_24 = temper.listbuilder_tolist(eb__534);
    return__276 = ChangesetImpl__151(t_25, t_26, t_27, t_24, false);
    goto break_6;
  end
  return__276 = this__160;
  ::break_6::return return__276;
end;
ChangesetImpl__151.methods.validateFloat = function(this__161, field__536)
  local return__277, t_32, t_33, t_34, t_35, t_36, val__538, parseOk__539, local_37, local_38, local_39;
  ::continue_9::
  if not this__161._isValid__493 then
    return__277 = this__161;
    goto break_8;
  end
  t_32 = field__536.sqlValue;
  val__538 = temper.mapped_getor(this__161._changes__491, t_32, '');
  if temper.string_isempty(val__538) then
    return__277 = this__161;
    goto break_8;
  end
  local_37, local_38, local_39 = temper.pcall(function()
    temper.string_tofloat64(val__538);
    parseOk__539 = true;
  end);
  if local_37 then
  else
    parseOk__539 = false;
  end
  if not parseOk__539 then
    local eb__540;
    eb__540 = temper.list_tolistbuilder(this__161._errors__492);
    temper.listbuilder_add(eb__540, ChangesetError(field__536.sqlValue, 'must be a number'));
    t_34 = this__161._tableDef__489;
    t_35 = this__161._params__490;
    t_36 = this__161._changes__491;
    t_33 = temper.listbuilder_tolist(eb__540);
    return__277 = ChangesetImpl__151(t_34, t_35, t_36, t_33, false);
    goto break_8;
  end
  return__277 = this__161;
  ::break_8::return return__277;
end;
ChangesetImpl__151.methods.validateBool = function(this__162, field__542)
  local return__278, t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48, t_49, t_50, val__544, isTrue__545, isFalse__546;
  ::continue_11::
  if not this__162._isValid__493 then
    return__278 = this__162;
    goto break_10;
  end
  t_41 = field__542.sqlValue;
  val__544 = temper.mapped_getor(this__162._changes__491, t_41, '');
  if temper.string_isempty(val__544) then
    return__278 = this__162;
    goto break_10;
  end
  if temper.str_eq(val__544, 'true') then
    isTrue__545 = true;
  else
    if temper.str_eq(val__544, '1') then
      t_44 = true;
    else
      if temper.str_eq(val__544, 'yes') then
        t_43 = true;
      else
        t_43 = temper.str_eq(val__544, 'on');
      end
      t_44 = t_43;
    end
    isTrue__545 = t_44;
  end
  if temper.str_eq(val__544, 'false') then
    isFalse__546 = true;
  else
    if temper.str_eq(val__544, '0') then
      t_46 = true;
    else
      if temper.str_eq(val__544, 'no') then
        t_45 = true;
      else
        t_45 = temper.str_eq(val__544, 'off');
      end
      t_46 = t_45;
    end
    isFalse__546 = t_46;
  end
  if not isTrue__545 then
    t_47 = not isFalse__546;
  else
    t_47 = false;
  end
  if t_47 then
    local eb__547;
    eb__547 = temper.list_tolistbuilder(this__162._errors__492);
    temper.listbuilder_add(eb__547, ChangesetError(field__542.sqlValue, 'must be a boolean (true/false/1/0/yes/no/on/off)'));
    t_48 = this__162._tableDef__489;
    t_49 = this__162._params__490;
    t_50 = this__162._changes__491;
    t_42 = temper.listbuilder_tolist(eb__547);
    return__278 = ChangesetImpl__151(t_48, t_49, t_50, t_42, false);
    goto break_10;
  end
  return__278 = this__162;
  ::break_10::return return__278;
end;
ChangesetImpl__151.methods.parseBoolSqlPart = function(this__163, val__549)
  local return__279, t_51, t_52, t_53, t_54, t_55, t_56;
  ::continue_13::
  if temper.str_eq(val__549, 'true') then
    t_53 = true;
  else
    if temper.str_eq(val__549, '1') then
      t_52 = true;
    else
      if temper.str_eq(val__549, 'yes') then
        t_51 = true;
      else
        t_51 = temper.str_eq(val__549, 'on');
      end
      t_52 = t_51;
    end
    t_53 = t_52;
  end
  if t_53 then
    return__279 = SqlBoolean(true);
    goto break_12;
  end
  if temper.str_eq(val__549, 'false') then
    t_56 = true;
  else
    if temper.str_eq(val__549, '0') then
      t_55 = true;
    else
      if temper.str_eq(val__549, 'no') then
        t_54 = true;
      else
        t_54 = temper.str_eq(val__549, 'off');
      end
      t_55 = t_54;
    end
    t_56 = t_55;
  end
  if t_56 then
    return__279 = SqlBoolean(false);
    goto break_12;
  end
  temper.bubble();
  ::break_12::return return__279;
end;
ChangesetImpl__151.methods.valueToSqlPart = function(this__164, fieldDef__552, val__553)
  local return__280, t_57, t_58, t_59, t_60, ft__555;
  ::continue_15::ft__555 = fieldDef__552.fieldType;
  if temper.instance_of(ft__555, StringField) then
    return__280 = SqlString(val__553);
    goto break_14;
  end
  if temper.instance_of(ft__555, IntField) then
    t_57 = temper.string_toint32(val__553);
    return__280 = SqlInt32(t_57);
    goto break_14;
  end
  if temper.instance_of(ft__555, Int64Field) then
    t_58 = temper.string_toint64(val__553);
    return__280 = SqlInt64(t_58);
    goto break_14;
  end
  if temper.instance_of(ft__555, FloatField) then
    t_59 = temper.string_tofloat64(val__553);
    return__280 = SqlFloat64(t_59);
    goto break_14;
  end
  if temper.instance_of(ft__555, BoolField) then
    return__280 = this__164:parseBoolSqlPart(val__553);
    goto break_14;
  end
  if temper.instance_of(ft__555, DateField) then
    t_60 = temper.date_fromisostring(val__553);
    return__280 = SqlDate(t_60);
    goto break_14;
  end
  temper.bubble();
  ::break_14::return return__280;
end;
ChangesetImpl__151.methods.toInsertSql = function(this__165)
  local t_61, t_62, t_63, t_64, t_65, t_66, t_67, t_68, t_69, t_70, i__558, pairs__560, colNames__561, valParts__562, i__563, b__566, t_71, fn__8590, j__568;
  if not this__165._isValid__493 then
    temper.bubble();
  end
  i__558 = 0;
  while true do
    local f__559;
    t_61 = temper.list_length(this__165._tableDef__489.fields);
    if not (i__558 < t_61) then
      break;
    end
    f__559 = temper.list_get(this__165._tableDef__489.fields, i__558);
    if not f__559.nullable then
      t_62 = f__559.name.sqlValue;
      t_63 = temper.mapped_has(this__165._changes__491, t_62);
      t_68 = not t_63;
    else
      t_68 = false;
    end
    if t_68 then
      temper.bubble();
    end
    i__558 = temper.int32_add(i__558, 1);
  end
  pairs__560 = temper.mapped_tolist(this__165._changes__491);
  if (temper.list_length(pairs__560) == 0) then
    temper.bubble();
  end
  colNames__561 = temper.listbuilder_constructor();
  valParts__562 = temper.listbuilder_constructor();
  i__563 = 0;
  while true do
    local pair__564, fd__565;
    t_64 = temper.list_length(pairs__560);
    if not (i__563 < t_64) then
      break;
    end
    pair__564 = temper.list_get(pairs__560, i__563);
    t_65 = pair__564.key;
    t_69 = this__165._tableDef__489:field(t_65);
    fd__565 = t_69;
    temper.listbuilder_add(colNames__561, fd__565.name.sqlValue);
    t_66 = pair__564.value;
    t_70 = this__165:valueToSqlPart(fd__565, t_66);
    temper.listbuilder_add(valParts__562, t_70);
    i__563 = temper.int32_add(i__563, 1);
  end
  b__566 = SqlBuilder();
  b__566:appendSafe('INSERT INTO ');
  b__566:appendSafe(this__165._tableDef__489.tableName.sqlValue);
  b__566:appendSafe(' (');
  t_71 = temper.listbuilder_tolist(colNames__561);
  fn__8590 = function(c__567)
    return c__567;
  end;
  b__566:appendSafe(temper.listed_join(t_71, ', ', fn__8590));
  b__566:appendSafe(') VALUES (');
  b__566:appendPart(temper.listed_get(valParts__562, 0));
  j__568 = 1;
  while true do
    t_67 = temper.listbuilder_length(valParts__562);
    if not (j__568 < t_67) then
      break;
    end
    b__566:appendSafe(', ');
    b__566:appendPart(temper.listed_get(valParts__562, j__568));
    j__568 = temper.int32_add(j__568, 1);
  end
  b__566:appendSafe(')');
  return b__566.accumulated;
end;
ChangesetImpl__151.methods.toUpdateSql = function(this__166, id__570)
  local t_72, t_73, t_74, t_75, t_76, pairs__572, b__573, i__574;
  if not this__166._isValid__493 then
    temper.bubble();
  end
  pairs__572 = temper.mapped_tolist(this__166._changes__491);
  if (temper.list_length(pairs__572) == 0) then
    temper.bubble();
  end
  b__573 = SqlBuilder();
  b__573:appendSafe('UPDATE ');
  b__573:appendSafe(this__166._tableDef__489.tableName.sqlValue);
  b__573:appendSafe(' SET ');
  i__574 = 0;
  while true do
    local pair__575, fd__576;
    t_72 = temper.list_length(pairs__572);
    if not (i__574 < t_72) then
      break;
    end
    if (i__574 > 0) then
      b__573:appendSafe(', ');
    end
    pair__575 = temper.list_get(pairs__572, i__574);
    t_73 = pair__575.key;
    t_75 = this__166._tableDef__489:field(t_73);
    fd__576 = t_75;
    b__573:appendSafe(fd__576.name.sqlValue);
    b__573:appendSafe(' = ');
    t_74 = pair__575.value;
    t_76 = this__166:valueToSqlPart(fd__576, t_74);
    b__573:appendPart(t_76);
    i__574 = temper.int32_add(i__574, 1);
  end
  b__573:appendSafe(' WHERE id = ');
  b__573:appendInt32(id__570);
  return b__573.accumulated;
end;
ChangesetImpl__151.constructor = function(this__263, _tableDef__578, _params__579, _changes__580, _errors__581, _isValid__582)
  this__263._tableDef__489 = _tableDef__578;
  this__263._params__490 = _params__579;
  this__263._changes__491 = _changes__580;
  this__263._errors__492 = _errors__581;
  this__263._isValid__493 = _isValid__582;
  return nil;
end;
JoinType = temper.type('JoinType');
JoinType.methods.keyword = function(this__167)
  temper.virtual();
end;
InnerJoin = temper.type('InnerJoin', JoinType);
InnerJoin.methods.keyword = function(this__168)
  return 'INNER JOIN';
end;
InnerJoin.constructor = function(this__288)
  return nil;
end;
LeftJoin = temper.type('LeftJoin', JoinType);
LeftJoin.methods.keyword = function(this__169)
  return 'LEFT JOIN';
end;
LeftJoin.constructor = function(this__291)
  return nil;
end;
RightJoin = temper.type('RightJoin', JoinType);
RightJoin.methods.keyword = function(this__170)
  return 'RIGHT JOIN';
end;
RightJoin.constructor = function(this__294)
  return nil;
end;
FullJoin = temper.type('FullJoin', JoinType);
FullJoin.methods.keyword = function(this__171)
  return 'FULL OUTER JOIN';
end;
FullJoin.constructor = function(this__297)
  return nil;
end;
JoinClause = temper.type('JoinClause');
JoinClause.constructor = function(this__300, joinType__695, table__696, onCondition__697)
  this__300.joinType__691 = joinType__695;
  this__300.table__692 = table__696;
  this__300.onCondition__693 = onCondition__697;
  return nil;
end;
JoinClause.get.joinType = function(this__1344)
  return this__1344.joinType__691;
end;
JoinClause.get.table = function(this__1347)
  return this__1347.table__692;
end;
JoinClause.get.onCondition = function(this__1350)
  return this__1350.onCondition__693;
end;
OrderClause = temper.type('OrderClause');
OrderClause.constructor = function(this__302, field__701, ascending__702)
  this__302.field__698 = field__701;
  this__302.ascending__699 = ascending__702;
  return nil;
end;
OrderClause.get.field = function(this__1353)
  return this__1353.field__698;
end;
OrderClause.get.ascending = function(this__1356)
  return this__1356.ascending__699;
end;
WhereClause = temper.type('WhereClause');
WhereClause.get.condition = function(this__172)
  temper.virtual();
end;
WhereClause.methods.keyword = function(this__173)
  temper.virtual();
end;
AndCondition = temper.type('AndCondition', WhereClause);
AndCondition.get.condition = function(this__174)
  return this__174._condition__707;
end;
AndCondition.methods.keyword = function(this__175)
  return 'AND';
end;
AndCondition.constructor = function(this__308, _condition__713)
  this__308._condition__707 = _condition__713;
  return nil;
end;
OrCondition = temper.type('OrCondition', WhereClause);
OrCondition.get.condition = function(this__176)
  return this__176._condition__714;
end;
OrCondition.methods.keyword = function(this__177)
  return 'OR';
end;
OrCondition.constructor = function(this__313, _condition__720)
  this__313._condition__714 = _condition__720;
  return nil;
end;
Query = temper.type('Query');
Query.methods.where = function(this__178, condition__733)
  local nb__735;
  nb__735 = temper.list_tolistbuilder(this__178.conditions__722);
  temper.listbuilder_add(nb__735, AndCondition(condition__733));
  return Query(this__178.tableName__721, temper.listbuilder_tolist(nb__735), this__178.selectedFields__723, this__178.orderClauses__724, this__178.limitVal__725, this__178.offsetVal__726, this__178.joinClauses__727, this__178.groupByFields__728, this__178.havingConditions__729, this__178.isDistinct__730, this__178.selectExprs__731);
end;
Query.methods.orWhere = function(this__179, condition__737)
  local nb__739;
  nb__739 = temper.list_tolistbuilder(this__179.conditions__722);
  temper.listbuilder_add(nb__739, OrCondition(condition__737));
  return Query(this__179.tableName__721, temper.listbuilder_tolist(nb__739), this__179.selectedFields__723, this__179.orderClauses__724, this__179.limitVal__725, this__179.offsetVal__726, this__179.joinClauses__727, this__179.groupByFields__728, this__179.havingConditions__729, this__179.isDistinct__730, this__179.selectExprs__731);
end;
Query.methods.whereNull = function(this__180, field__741)
  local b__743, t_77;
  b__743 = SqlBuilder();
  b__743:appendSafe(field__741.sqlValue);
  b__743:appendSafe(' IS NULL');
  t_77 = b__743.accumulated;
  return this__180:where(t_77);
end;
Query.methods.whereNotNull = function(this__181, field__745)
  local b__747, t_78;
  b__747 = SqlBuilder();
  b__747:appendSafe(field__745.sqlValue);
  b__747:appendSafe(' IS NOT NULL');
  t_78 = b__747.accumulated;
  return this__181:where(t_78);
end;
Query.methods.whereIn = function(this__182, field__749, values__750)
  local return__332, t_79, t_80, t_81, b__753, i__754;
  ::continue_17::
  if temper.listed_isempty(values__750) then
    local b__752;
    b__752 = SqlBuilder();
    b__752:appendSafe('1 = 0');
    t_79 = b__752.accumulated;
    return__332 = this__182:where(t_79);
    goto break_16;
  end
  b__753 = SqlBuilder();
  b__753:appendSafe(field__749.sqlValue);
  b__753:appendSafe(' IN (');
  b__753:appendPart(temper.list_get(values__750, 0));
  i__754 = 1;
  while true do
    t_80 = temper.list_length(values__750);
    if not (i__754 < t_80) then
      break;
    end
    b__753:appendSafe(', ');
    b__753:appendPart(temper.list_get(values__750, i__754));
    i__754 = temper.int32_add(i__754, 1);
  end
  b__753:appendSafe(')');
  t_81 = b__753.accumulated;
  return__332 = this__182:where(t_81);
  ::break_16::return return__332;
end;
Query.methods.whereNot = function(this__183, condition__756)
  local b__758, t_82;
  b__758 = SqlBuilder();
  b__758:appendSafe('NOT (');
  b__758:appendFragment(condition__756);
  b__758:appendSafe(')');
  t_82 = b__758.accumulated;
  return this__183:where(t_82);
end;
Query.methods.whereBetween = function(this__184, field__760, low__761, high__762)
  local b__764, t_83;
  b__764 = SqlBuilder();
  b__764:appendSafe(field__760.sqlValue);
  b__764:appendSafe(' BETWEEN ');
  b__764:appendPart(low__761);
  b__764:appendSafe(' AND ');
  b__764:appendPart(high__762);
  t_83 = b__764.accumulated;
  return this__184:where(t_83);
end;
Query.methods.whereLike = function(this__185, field__766, pattern__767)
  local b__769, t_84;
  b__769 = SqlBuilder();
  b__769:appendSafe(field__766.sqlValue);
  b__769:appendSafe(' LIKE ');
  b__769:appendString(pattern__767);
  t_84 = b__769.accumulated;
  return this__185:where(t_84);
end;
Query.methods.whereILike = function(this__186, field__771, pattern__772)
  local b__774, t_85;
  b__774 = SqlBuilder();
  b__774:appendSafe(field__771.sqlValue);
  b__774:appendSafe(' ILIKE ');
  b__774:appendString(pattern__772);
  t_85 = b__774.accumulated;
  return this__186:where(t_85);
end;
Query.methods.select = function(this__187, fields__776)
  return Query(this__187.tableName__721, this__187.conditions__722, fields__776, this__187.orderClauses__724, this__187.limitVal__725, this__187.offsetVal__726, this__187.joinClauses__727, this__187.groupByFields__728, this__187.havingConditions__729, this__187.isDistinct__730, this__187.selectExprs__731);
end;
Query.methods.selectExpr = function(this__188, exprs__779)
  return Query(this__188.tableName__721, this__188.conditions__722, this__188.selectedFields__723, this__188.orderClauses__724, this__188.limitVal__725, this__188.offsetVal__726, this__188.joinClauses__727, this__188.groupByFields__728, this__188.havingConditions__729, this__188.isDistinct__730, exprs__779);
end;
Query.methods.orderBy = function(this__189, field__782, ascending__783)
  local nb__785;
  nb__785 = temper.list_tolistbuilder(this__189.orderClauses__724);
  temper.listbuilder_add(nb__785, OrderClause(field__782, ascending__783));
  return Query(this__189.tableName__721, this__189.conditions__722, this__189.selectedFields__723, temper.listbuilder_tolist(nb__785), this__189.limitVal__725, this__189.offsetVal__726, this__189.joinClauses__727, this__189.groupByFields__728, this__189.havingConditions__729, this__189.isDistinct__730, this__189.selectExprs__731);
end;
Query.methods.limit = function(this__190, n__787)
  if (n__787 < 0) then
    temper.bubble();
  end
  return Query(this__190.tableName__721, this__190.conditions__722, this__190.selectedFields__723, this__190.orderClauses__724, n__787, this__190.offsetVal__726, this__190.joinClauses__727, this__190.groupByFields__728, this__190.havingConditions__729, this__190.isDistinct__730, this__190.selectExprs__731);
end;
Query.methods.offset = function(this__191, n__790)
  if (n__790 < 0) then
    temper.bubble();
  end
  return Query(this__191.tableName__721, this__191.conditions__722, this__191.selectedFields__723, this__191.orderClauses__724, this__191.limitVal__725, n__790, this__191.joinClauses__727, this__191.groupByFields__728, this__191.havingConditions__729, this__191.isDistinct__730, this__191.selectExprs__731);
end;
Query.methods.join = function(this__192, joinType__793, table__794, onCondition__795)
  local nb__797;
  nb__797 = temper.list_tolistbuilder(this__192.joinClauses__727);
  temper.listbuilder_add(nb__797, JoinClause(joinType__793, table__794, onCondition__795));
  return Query(this__192.tableName__721, this__192.conditions__722, this__192.selectedFields__723, this__192.orderClauses__724, this__192.limitVal__725, this__192.offsetVal__726, temper.listbuilder_tolist(nb__797), this__192.groupByFields__728, this__192.havingConditions__729, this__192.isDistinct__730, this__192.selectExprs__731);
end;
Query.methods.innerJoin = function(this__193, table__799, onCondition__800)
  local t_86;
  t_86 = InnerJoin();
  return this__193:join(t_86, table__799, onCondition__800);
end;
Query.methods.leftJoin = function(this__194, table__803, onCondition__804)
  local t_87;
  t_87 = LeftJoin();
  return this__194:join(t_87, table__803, onCondition__804);
end;
Query.methods.rightJoin = function(this__195, table__807, onCondition__808)
  local t_88;
  t_88 = RightJoin();
  return this__195:join(t_88, table__807, onCondition__808);
end;
Query.methods.fullJoin = function(this__196, table__811, onCondition__812)
  local t_89;
  t_89 = FullJoin();
  return this__196:join(t_89, table__811, onCondition__812);
end;
Query.methods.groupBy = function(this__197, field__815)
  local nb__817;
  nb__817 = temper.list_tolistbuilder(this__197.groupByFields__728);
  temper.listbuilder_add(nb__817, field__815);
  return Query(this__197.tableName__721, this__197.conditions__722, this__197.selectedFields__723, this__197.orderClauses__724, this__197.limitVal__725, this__197.offsetVal__726, this__197.joinClauses__727, temper.listbuilder_tolist(nb__817), this__197.havingConditions__729, this__197.isDistinct__730, this__197.selectExprs__731);
end;
Query.methods.having = function(this__198, condition__819)
  local nb__821;
  nb__821 = temper.list_tolistbuilder(this__198.havingConditions__729);
  temper.listbuilder_add(nb__821, AndCondition(condition__819));
  return Query(this__198.tableName__721, this__198.conditions__722, this__198.selectedFields__723, this__198.orderClauses__724, this__198.limitVal__725, this__198.offsetVal__726, this__198.joinClauses__727, this__198.groupByFields__728, temper.listbuilder_tolist(nb__821), this__198.isDistinct__730, this__198.selectExprs__731);
end;
Query.methods.orHaving = function(this__199, condition__823)
  local nb__825;
  nb__825 = temper.list_tolistbuilder(this__199.havingConditions__729);
  temper.listbuilder_add(nb__825, OrCondition(condition__823));
  return Query(this__199.tableName__721, this__199.conditions__722, this__199.selectedFields__723, this__199.orderClauses__724, this__199.limitVal__725, this__199.offsetVal__726, this__199.joinClauses__727, this__199.groupByFields__728, temper.listbuilder_tolist(nb__825), this__199.isDistinct__730, this__199.selectExprs__731);
end;
Query.methods.distinct = function(this__200)
  return Query(this__200.tableName__721, this__200.conditions__722, this__200.selectedFields__723, this__200.orderClauses__724, this__200.limitVal__725, this__200.offsetVal__726, this__200.joinClauses__727, this__200.groupByFields__728, this__200.havingConditions__729, true, this__200.selectExprs__731);
end;
Query.methods.toSql = function(this__201)
  local t_90, t_91, t_92, b__830, fn__7986, lv__839, ov__840;
  b__830 = SqlBuilder();
  if this__201.isDistinct__730 then
    b__830:appendSafe('SELECT DISTINCT ');
  else
    b__830:appendSafe('SELECT ');
  end
  if not temper.listed_isempty(this__201.selectExprs__731) then
    local i__831;
    b__830:appendFragment(temper.list_get(this__201.selectExprs__731, 0));
    i__831 = 1;
    while true do
      t_90 = temper.list_length(this__201.selectExprs__731);
      if not (i__831 < t_90) then
        break;
      end
      b__830:appendSafe(', ');
      b__830:appendFragment(temper.list_get(this__201.selectExprs__731, i__831));
      i__831 = temper.int32_add(i__831, 1);
    end
  elseif temper.listed_isempty(this__201.selectedFields__723) then
    b__830:appendSafe('*');
  else
    local fn__7987;
    fn__7987 = function(f__832)
      return f__832.sqlValue;
    end;
    b__830:appendSafe(temper.listed_join(this__201.selectedFields__723, ', ', fn__7987));
  end
  b__830:appendSafe(' FROM ');
  b__830:appendSafe(this__201.tableName__721.sqlValue);
  fn__7986 = function(jc__833)
    local t_93, t_94, t_95;
    b__830:appendSafe(' ');
    t_93 = jc__833.joinType:keyword();
    b__830:appendSafe(t_93);
    b__830:appendSafe(' ');
    t_94 = jc__833.table.sqlValue;
    b__830:appendSafe(t_94);
    b__830:appendSafe(' ON ');
    t_95 = jc__833.onCondition;
    b__830:appendFragment(t_95);
    return nil;
  end;
  temper.list_foreach(this__201.joinClauses__727, fn__7986);
  if not temper.listed_isempty(this__201.conditions__722) then
    local i__834;
    b__830:appendSafe(' WHERE ');
    b__830:appendFragment((temper.list_get(this__201.conditions__722, 0)).condition);
    i__834 = 1;
    while true do
      t_91 = temper.list_length(this__201.conditions__722);
      if not (i__834 < t_91) then
        break;
      end
      b__830:appendSafe(' ');
      b__830:appendSafe(temper.list_get(this__201.conditions__722, i__834):keyword());
      b__830:appendSafe(' ');
      b__830:appendFragment((temper.list_get(this__201.conditions__722, i__834)).condition);
      i__834 = temper.int32_add(i__834, 1);
    end
  end
  if not temper.listed_isempty(this__201.groupByFields__728) then
    local fn__7985;
    b__830:appendSafe(' GROUP BY ');
    fn__7985 = function(f__835)
      return f__835.sqlValue;
    end;
    b__830:appendSafe(temper.listed_join(this__201.groupByFields__728, ', ', fn__7985));
  end
  if not temper.listed_isempty(this__201.havingConditions__729) then
    local i__836;
    b__830:appendSafe(' HAVING ');
    b__830:appendFragment((temper.list_get(this__201.havingConditions__729, 0)).condition);
    i__836 = 1;
    while true do
      t_92 = temper.list_length(this__201.havingConditions__729);
      if not (i__836 < t_92) then
        break;
      end
      b__830:appendSafe(' ');
      b__830:appendSafe(temper.list_get(this__201.havingConditions__729, i__836):keyword());
      b__830:appendSafe(' ');
      b__830:appendFragment((temper.list_get(this__201.havingConditions__729, i__836)).condition);
      i__836 = temper.int32_add(i__836, 1);
    end
  end
  if not temper.listed_isempty(this__201.orderClauses__724) then
    local first__837, fn__7984;
    b__830:appendSafe(' ORDER BY ');
    first__837 = true;
    fn__7984 = function(oc__838)
      local t_96, t_97;
      if not first__837 then
        b__830:appendSafe(', ');
      end
      first__837 = false;
      t_97 = oc__838.field.sqlValue;
      b__830:appendSafe(t_97);
      if oc__838.ascending then
        t_96 = ' ASC';
      else
        t_96 = ' DESC';
      end
      b__830:appendSafe(t_96);
      return nil;
    end;
    temper.list_foreach(this__201.orderClauses__724, fn__7984);
  end
  lv__839 = this__201.limitVal__725;
  if not temper.is_null(lv__839) then
    local lv_98;
    lv_98 = lv__839;
    b__830:appendSafe(' LIMIT ');
    b__830:appendInt32(lv_98);
  end
  ov__840 = this__201.offsetVal__726;
  if not temper.is_null(ov__840) then
    local ov_99;
    ov_99 = ov__840;
    b__830:appendSafe(' OFFSET ');
    b__830:appendInt32(ov_99);
  end
  return b__830.accumulated;
end;
Query.methods.countSql = function(this__202)
  local t_100, t_101, b__843, fn__7924;
  b__843 = SqlBuilder();
  b__843:appendSafe('SELECT COUNT(*) FROM ');
  b__843:appendSafe(this__202.tableName__721.sqlValue);
  fn__7924 = function(jc__844)
    local t_102, t_103, t_104;
    b__843:appendSafe(' ');
    t_102 = jc__844.joinType:keyword();
    b__843:appendSafe(t_102);
    b__843:appendSafe(' ');
    t_103 = jc__844.table.sqlValue;
    b__843:appendSafe(t_103);
    b__843:appendSafe(' ON ');
    t_104 = jc__844.onCondition;
    b__843:appendFragment(t_104);
    return nil;
  end;
  temper.list_foreach(this__202.joinClauses__727, fn__7924);
  if not temper.listed_isempty(this__202.conditions__722) then
    local i__845;
    b__843:appendSafe(' WHERE ');
    b__843:appendFragment((temper.list_get(this__202.conditions__722, 0)).condition);
    i__845 = 1;
    while true do
      t_100 = temper.list_length(this__202.conditions__722);
      if not (i__845 < t_100) then
        break;
      end
      b__843:appendSafe(' ');
      b__843:appendSafe(temper.list_get(this__202.conditions__722, i__845):keyword());
      b__843:appendSafe(' ');
      b__843:appendFragment((temper.list_get(this__202.conditions__722, i__845)).condition);
      i__845 = temper.int32_add(i__845, 1);
    end
  end
  if not temper.listed_isempty(this__202.groupByFields__728) then
    local fn__7923;
    b__843:appendSafe(' GROUP BY ');
    fn__7923 = function(f__846)
      return f__846.sqlValue;
    end;
    b__843:appendSafe(temper.listed_join(this__202.groupByFields__728, ', ', fn__7923));
  end
  if not temper.listed_isempty(this__202.havingConditions__729) then
    local i__847;
    b__843:appendSafe(' HAVING ');
    b__843:appendFragment((temper.list_get(this__202.havingConditions__729, 0)).condition);
    i__847 = 1;
    while true do
      t_101 = temper.list_length(this__202.havingConditions__729);
      if not (i__847 < t_101) then
        break;
      end
      b__843:appendSafe(' ');
      b__843:appendSafe(temper.list_get(this__202.havingConditions__729, i__847):keyword());
      b__843:appendSafe(' ');
      b__843:appendFragment((temper.list_get(this__202.havingConditions__729, i__847)).condition);
      i__847 = temper.int32_add(i__847, 1);
    end
  end
  return b__843.accumulated;
end;
Query.methods.safeToSql = function(this__203, defaultLimit__849)
  local return__353, t_105;
  if (defaultLimit__849 < 0) then
    temper.bubble();
  end
  if not temper.is_null(this__203.limitVal__725) then
    return__353 = this__203:toSql();
  else
    t_105 = this__203:limit(defaultLimit__849);
    return__353 = t_105:toSql();
  end
  return return__353;
end;
Query.constructor = function(this__317, tableName__852, conditions__853, selectedFields__854, orderClauses__855, limitVal__856, offsetVal__857, joinClauses__858, groupByFields__859, havingConditions__860, isDistinct__861, selectExprs__862)
  if (limitVal__856 == nil) then
    limitVal__856 = temper.null;
  end
  if (offsetVal__857 == nil) then
    offsetVal__857 = temper.null;
  end
  this__317.tableName__721 = tableName__852;
  this__317.conditions__722 = conditions__853;
  this__317.selectedFields__723 = selectedFields__854;
  this__317.orderClauses__724 = orderClauses__855;
  this__317.limitVal__725 = limitVal__856;
  this__317.offsetVal__726 = offsetVal__857;
  this__317.joinClauses__727 = joinClauses__858;
  this__317.groupByFields__728 = groupByFields__859;
  this__317.havingConditions__729 = havingConditions__860;
  this__317.isDistinct__730 = isDistinct__861;
  this__317.selectExprs__731 = selectExprs__862;
  return nil;
end;
Query.get.tableName = function(this__1359)
  return this__1359.tableName__721;
end;
Query.get.conditions = function(this__1362)
  return this__1362.conditions__722;
end;
Query.get.selectedFields = function(this__1365)
  return this__1365.selectedFields__723;
end;
Query.get.orderClauses = function(this__1368)
  return this__1368.orderClauses__724;
end;
Query.get.limitVal = function(this__1371)
  return this__1371.limitVal__725;
end;
Query.get.offsetVal = function(this__1374)
  return this__1374.offsetVal__726;
end;
Query.get.joinClauses = function(this__1377)
  return this__1377.joinClauses__727;
end;
Query.get.groupByFields = function(this__1380)
  return this__1380.groupByFields__728;
end;
Query.get.havingConditions = function(this__1383)
  return this__1383.havingConditions__729;
end;
Query.get.isDistinct = function(this__1386)
  return this__1386.isDistinct__730;
end;
Query.get.selectExprs = function(this__1389)
  return this__1389.selectExprs__731;
end;
SafeIdentifier = temper.type('SafeIdentifier');
SafeIdentifier.get.sqlValue = function(this__204)
  temper.virtual();
end;
ValidatedIdentifier__205 = temper.type('ValidatedIdentifier__205', SafeIdentifier);
ValidatedIdentifier__205.get.sqlValue = function(this__206)
  return this__206._value__1032;
end;
ValidatedIdentifier__205.constructor = function(this__366, _value__1036)
  this__366._value__1032 = _value__1036;
  return nil;
end;
FieldType = temper.type('FieldType');
StringField = temper.type('StringField', FieldType);
StringField.constructor = function(this__372)
  return nil;
end;
IntField = temper.type('IntField', FieldType);
IntField.constructor = function(this__374)
  return nil;
end;
Int64Field = temper.type('Int64Field', FieldType);
Int64Field.constructor = function(this__376)
  return nil;
end;
FloatField = temper.type('FloatField', FieldType);
FloatField.constructor = function(this__378)
  return nil;
end;
BoolField = temper.type('BoolField', FieldType);
BoolField.constructor = function(this__380)
  return nil;
end;
DateField = temper.type('DateField', FieldType);
DateField.constructor = function(this__382)
  return nil;
end;
FieldDef = temper.type('FieldDef');
FieldDef.constructor = function(this__384, name__1054, fieldType__1055, nullable__1056)
  this__384.name__1050 = name__1054;
  this__384.fieldType__1051 = fieldType__1055;
  this__384.nullable__1052 = nullable__1056;
  return nil;
end;
FieldDef.get.name = function(this__1282)
  return this__1282.name__1050;
end;
FieldDef.get.fieldType = function(this__1285)
  return this__1285.fieldType__1051;
end;
FieldDef.get.nullable = function(this__1288)
  return this__1288.nullable__1052;
end;
TableDef = temper.type('TableDef');
TableDef.methods.field = function(this__207, name__1060)
  local return__389, this__5239, n__5240, i__5241;
  ::continue_19::this__5239 = this__207.fields__1058;
  n__5240 = temper.list_length(this__5239);
  i__5241 = 0;
  while (i__5241 < n__5240) do
    local el__5242, f__1062;
    el__5242 = temper.list_get(this__5239, i__5241);
    i__5241 = temper.int32_add(i__5241, 1);
    f__1062 = el__5242;
    if temper.str_eq(f__1062.name.sqlValue, name__1060) then
      return__389 = f__1062;
      goto break_18;
    end
  end
  temper.bubble();
  ::break_18::return return__389;
end;
TableDef.constructor = function(this__386, tableName__1064, fields__1065)
  this__386.tableName__1057 = tableName__1064;
  this__386.fields__1058 = fields__1065;
  return nil;
end;
TableDef.get.tableName = function(this__1291)
  return this__1291.tableName__1057;
end;
TableDef.get.fields = function(this__1294)
  return this__1294.fields__1058;
end;
SqlBuilder = temper.type('SqlBuilder');
SqlBuilder.methods.appendSafe = function(this__208, sqlSource__1087)
  local t_106;
  t_106 = SqlSource(sqlSource__1087);
  temper.listbuilder_add(this__208.buffer__1085, t_106);
  return nil;
end;
SqlBuilder.methods.appendFragment = function(this__209, fragment__1090)
  local t_107;
  t_107 = fragment__1090.parts;
  temper.listbuilder_addall(this__209.buffer__1085, t_107);
  return nil;
end;
SqlBuilder.methods.appendPart = function(this__210, part__1093)
  temper.listbuilder_add(this__210.buffer__1085, part__1093);
  return nil;
end;
SqlBuilder.methods.appendPartList = function(this__211, values__1096)
  local fn__8761;
  fn__8761 = function(x__1098)
    this__211:appendPart(x__1098);
    return nil;
  end;
  this__211:appendList(values__1096, fn__8761);
  return nil;
end;
SqlBuilder.methods.appendBoolean = function(this__212, value__1100)
  local t_108;
  t_108 = SqlBoolean(value__1100);
  temper.listbuilder_add(this__212.buffer__1085, t_108);
  return nil;
end;
SqlBuilder.methods.appendBooleanList = function(this__213, values__1103)
  local fn__8755;
  fn__8755 = function(x__1105)
    this__213:appendBoolean(x__1105);
    return nil;
  end;
  this__213:appendList(values__1103, fn__8755);
  return nil;
end;
SqlBuilder.methods.appendDate = function(this__214, value__1107)
  local t_109;
  t_109 = SqlDate(value__1107);
  temper.listbuilder_add(this__214.buffer__1085, t_109);
  return nil;
end;
SqlBuilder.methods.appendDateList = function(this__215, values__1110)
  local fn__8749;
  fn__8749 = function(x__1112)
    this__215:appendDate(x__1112);
    return nil;
  end;
  this__215:appendList(values__1110, fn__8749);
  return nil;
end;
SqlBuilder.methods.appendFloat64 = function(this__216, value__1114)
  local t_110;
  t_110 = SqlFloat64(value__1114);
  temper.listbuilder_add(this__216.buffer__1085, t_110);
  return nil;
end;
SqlBuilder.methods.appendFloat64List = function(this__217, values__1117)
  local fn__8743;
  fn__8743 = function(x__1119)
    this__217:appendFloat64(x__1119);
    return nil;
  end;
  this__217:appendList(values__1117, fn__8743);
  return nil;
end;
SqlBuilder.methods.appendInt32 = function(this__218, value__1121)
  local t_111;
  t_111 = SqlInt32(value__1121);
  temper.listbuilder_add(this__218.buffer__1085, t_111);
  return nil;
end;
SqlBuilder.methods.appendInt32List = function(this__219, values__1124)
  local fn__8737;
  fn__8737 = function(x__1126)
    this__219:appendInt32(x__1126);
    return nil;
  end;
  this__219:appendList(values__1124, fn__8737);
  return nil;
end;
SqlBuilder.methods.appendInt64 = function(this__220, value__1128)
  local t_112;
  t_112 = SqlInt64(value__1128);
  temper.listbuilder_add(this__220.buffer__1085, t_112);
  return nil;
end;
SqlBuilder.methods.appendInt64List = function(this__221, values__1131)
  local fn__8731;
  fn__8731 = function(x__1133)
    this__221:appendInt64(x__1133);
    return nil;
  end;
  this__221:appendList(values__1131, fn__8731);
  return nil;
end;
SqlBuilder.methods.appendString = function(this__222, value__1135)
  local t_113;
  t_113 = SqlString(value__1135);
  temper.listbuilder_add(this__222.buffer__1085, t_113);
  return nil;
end;
SqlBuilder.methods.appendStringList = function(this__223, values__1138)
  local fn__8725;
  fn__8725 = function(x__1140)
    this__223:appendString(x__1140);
    return nil;
  end;
  this__223:appendList(values__1138, fn__8725);
  return nil;
end;
SqlBuilder.methods.appendList = function(this__224, values__1142, appendValue__1143)
  local t_114, t_115, i__1145;
  i__1145 = 0;
  while true do
    t_114 = temper.listed_length(values__1142);
    if not (i__1145 < t_114) then
      break;
    end
    if (i__1145 > 0) then
      this__224:appendSafe(', ');
    end
    t_115 = temper.listed_get(values__1142, i__1145);
    appendValue__1143(t_115);
    i__1145 = temper.int32_add(i__1145, 1);
  end
  return nil;
end;
SqlBuilder.get.accumulated = function(this__225)
  return SqlFragment(temper.listbuilder_tolist(this__225.buffer__1085));
end;
SqlBuilder.constructor = function(this__391)
  local t_116;
  t_116 = temper.listbuilder_constructor();
  this__391.buffer__1085 = t_116;
  return nil;
end;
SqlFragment = temper.type('SqlFragment');
SqlFragment.methods.toSource = function(this__230)
  return SqlSource(this__230:toString());
end;
SqlFragment.methods.toString = function(this__231)
  local t_117, builder__1157, i__1158;
  builder__1157 = temper.stringbuilder_constructor();
  i__1158 = 0;
  while true do
    t_117 = temper.list_length(this__231.parts__1152);
    if not (i__1158 < t_117) then
      break;
    end
    temper.list_get(this__231.parts__1152, i__1158):formatTo(builder__1157);
    i__1158 = temper.int32_add(i__1158, 1);
  end
  return temper.stringbuilder_tostring(builder__1157);
end;
SqlFragment.constructor = function(this__412, parts__1160)
  this__412.parts__1152 = parts__1160;
  return nil;
end;
SqlFragment.get.parts = function(this__1300)
  return this__1300.parts__1152;
end;
SqlPart = temper.type('SqlPart');
SqlPart.methods.formatTo = function(this__232, builder__1162)
  temper.virtual();
end;
SqlSource = temper.type('SqlSource', SqlPart);
SqlSource.methods.formatTo = function(this__233, builder__1166)
  temper.stringbuilder_append(builder__1166, this__233.source__1164);
  return nil;
end;
SqlSource.constructor = function(this__418, source__1169)
  this__418.source__1164 = source__1169;
  return nil;
end;
SqlSource.get.source = function(this__1297)
  return this__1297.source__1164;
end;
SqlBoolean = temper.type('SqlBoolean', SqlPart);
SqlBoolean.methods.formatTo = function(this__234, builder__1172)
  local t_118;
  if this__234.value__1170 then
    t_118 = 'TRUE';
  else
    t_118 = 'FALSE';
  end
  temper.stringbuilder_append(builder__1172, t_118);
  return nil;
end;
SqlBoolean.constructor = function(this__421, value__1175)
  this__421.value__1170 = value__1175;
  return nil;
end;
SqlBoolean.get.value = function(this__1303)
  return this__1303.value__1170;
end;
SqlDate = temper.type('SqlDate', SqlPart);
SqlDate.methods.formatTo = function(this__235, builder__1178)
  local t_119, fn__8770;
  temper.stringbuilder_append(builder__1178, "'");
  t_119 = temper.date_tostring(this__235.value__1176);
  fn__8770 = function(c__1180)
    if (c__1180 == 39) then
      temper.stringbuilder_append(builder__1178, "''");
    else
      local local_120, local_121, local_122;
      local_120, local_121, local_122 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__1178, c__1180);
      end);
      if local_120 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(t_119, fn__8770);
  temper.stringbuilder_append(builder__1178, "'");
  return nil;
end;
SqlDate.constructor = function(this__424, value__1182)
  this__424.value__1176 = value__1182;
  return nil;
end;
SqlDate.get.value = function(this__1318)
  return this__1318.value__1176;
end;
SqlFloat64 = temper.type('SqlFloat64', SqlPart);
SqlFloat64.methods.formatTo = function(this__236, builder__1185)
  local t_124, t_125, s__1187;
  s__1187 = temper.float64_tostring(this__236.value__1183);
  if temper.str_eq(s__1187, 'NaN') then
    t_125 = true;
  else
    if temper.str_eq(s__1187, 'Infinity') then
      t_124 = true;
    else
      t_124 = temper.str_eq(s__1187, '-Infinity');
    end
    t_125 = t_124;
  end
  if t_125 then
    temper.stringbuilder_append(builder__1185, 'NULL');
  else
    temper.stringbuilder_append(builder__1185, s__1187);
  end
  return nil;
end;
SqlFloat64.constructor = function(this__427, value__1189)
  this__427.value__1183 = value__1189;
  return nil;
end;
SqlFloat64.get.value = function(this__1315)
  return this__1315.value__1183;
end;
SqlInt32 = temper.type('SqlInt32', SqlPart);
SqlInt32.methods.formatTo = function(this__237, builder__1192)
  local t_126;
  t_126 = temper.int32_tostring(this__237.value__1190);
  temper.stringbuilder_append(builder__1192, t_126);
  return nil;
end;
SqlInt32.constructor = function(this__430, value__1195)
  this__430.value__1190 = value__1195;
  return nil;
end;
SqlInt32.get.value = function(this__1309)
  return this__1309.value__1190;
end;
SqlInt64 = temper.type('SqlInt64', SqlPart);
SqlInt64.methods.formatTo = function(this__238, builder__1198)
  local t_127;
  t_127 = temper.int64_tostring(this__238.value__1196);
  temper.stringbuilder_append(builder__1198, t_127);
  return nil;
end;
SqlInt64.constructor = function(this__433, value__1201)
  this__433.value__1196 = value__1201;
  return nil;
end;
SqlInt64.get.value = function(this__1312)
  return this__1312.value__1196;
end;
SqlString = temper.type('SqlString', SqlPart);
SqlString.methods.formatTo = function(this__239, builder__1204)
  local fn__8784;
  temper.stringbuilder_append(builder__1204, "'");
  fn__8784 = function(c__1206)
    if (c__1206 == 39) then
      temper.stringbuilder_append(builder__1204, "''");
    else
      local local_128, local_129, local_130;
      local_128, local_129, local_130 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__1204, c__1206);
      end);
      if local_128 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(this__239.value__1202, fn__8784);
  temper.stringbuilder_append(builder__1204, "'");
  return nil;
end;
SqlString.constructor = function(this__436, value__1208)
  this__436.value__1202 = value__1208;
  return nil;
end;
SqlString.get.value = function(this__1306)
  return this__1306.value__1202;
end;
changeset = function(tableDef__583, params__584)
  local t_132;
  t_132 = temper.map_constructor(temper.listof());
  return ChangesetImpl__151(tableDef__583, params__584, t_132, temper.listof(), true);
end;
isIdentStart__444 = function(c__1037)
  local return__369, t_133, t_134;
  if (c__1037 >= 97) then
    t_133 = (c__1037 <= 122);
  else
    t_133 = false;
  end
  if t_133 then
    return__369 = true;
  else
    if (c__1037 >= 65) then
      t_134 = (c__1037 <= 90);
    else
      t_134 = false;
    end
    if t_134 then
      return__369 = true;
    else
      return__369 = (c__1037 == 95);
    end
  end
  return return__369;
end;
isIdentPart__445 = function(c__1039)
  local return__370;
  if isIdentStart__444(c__1039) then
    return__370 = true;
  elseif (c__1039 >= 48) then
    return__370 = (c__1039 <= 57);
  else
    return__370 = false;
  end
  return return__370;
end;
safeIdentifier = function(name__1041)
  local t_135, idx__1043, t_136;
  if temper.string_isempty(name__1041) then
    temper.bubble();
  end
  idx__1043 = 1.0;
  if not isIdentStart__444(temper.string_get(name__1041, idx__1043)) then
    temper.bubble();
  end
  t_136 = temper.string_next(name__1041, idx__1043);
  idx__1043 = t_136;
  while true do
    if not temper.string_hasindex(name__1041, idx__1043) then
      break;
    end
    if not isIdentPart__445(temper.string_get(name__1041, idx__1043)) then
      temper.bubble();
    end
    t_135 = temper.string_next(name__1041, idx__1043);
    idx__1043 = t_135;
  end
  return ValidatedIdentifier__205(name__1041);
end;
deleteSql = function(tableDef__673, id__674)
  local b__676;
  b__676 = SqlBuilder();
  b__676:appendSafe('DELETE FROM ');
  b__676:appendSafe(tableDef__673.tableName.sqlValue);
  b__676:appendSafe(' WHERE id = ');
  b__676:appendInt32(id__674);
  return b__676.accumulated;
end;
from = function(tableName__863)
  return Query(tableName__863, temper.listof(), temper.listof(), temper.listof(), temper.null, temper.null, temper.listof(), temper.listof(), temper.listof(), false, temper.listof());
end;
col = function(table__865, column__866)
  local b__868;
  b__868 = SqlBuilder();
  b__868:appendSafe(table__865.sqlValue);
  b__868:appendSafe('.');
  b__868:appendSafe(column__866.sqlValue);
  return b__868.accumulated;
end;
countAll = function()
  local b__870;
  b__870 = SqlBuilder();
  b__870:appendSafe('COUNT(*)');
  return b__870.accumulated;
end;
countCol = function(field__871)
  local b__873;
  b__873 = SqlBuilder();
  b__873:appendSafe('COUNT(');
  b__873:appendSafe(field__871.sqlValue);
  b__873:appendSafe(')');
  return b__873.accumulated;
end;
sumCol = function(field__874)
  local b__876;
  b__876 = SqlBuilder();
  b__876:appendSafe('SUM(');
  b__876:appendSafe(field__874.sqlValue);
  b__876:appendSafe(')');
  return b__876.accumulated;
end;
avgCol = function(field__877)
  local b__879;
  b__879 = SqlBuilder();
  b__879:appendSafe('AVG(');
  b__879:appendSafe(field__877.sqlValue);
  b__879:appendSafe(')');
  return b__879.accumulated;
end;
minCol = function(field__880)
  local b__882;
  b__882 = SqlBuilder();
  b__882:appendSafe('MIN(');
  b__882:appendSafe(field__880.sqlValue);
  b__882:appendSafe(')');
  return b__882.accumulated;
end;
maxCol = function(field__883)
  local b__885;
  b__885 = SqlBuilder();
  b__885:appendSafe('MAX(');
  b__885:appendSafe(field__883.sqlValue);
  b__885:appendSafe(')');
  return b__885.accumulated;
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
exports.countAll = countAll;
exports.countCol = countCol;
exports.sumCol = sumCol;
exports.avgCol = avgCol;
exports.minCol = minCol;
exports.maxCol = maxCol;
return exports;
