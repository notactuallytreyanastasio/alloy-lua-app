local temper = require('temper-core');
local ChangesetError, Changeset, ChangesetImpl__161, JoinType, InnerJoin, LeftJoin, RightJoin, FullJoin, JoinClause, OrderClause, WhereClause, AndCondition, OrCondition, Query, SafeIdentifier, ValidatedIdentifier__216, FieldType, StringField, IntField, Int64Field, FloatField, BoolField, DateField, FieldDef, TableDef, SqlBuilder, SqlFragment, SqlPart, SqlSource, SqlBoolean, SqlDate, SqlFloat64, SqlInt32, SqlInt64, SqlString, changeset, isIdentStart__462, isIdentPart__463, safeIdentifier, deleteSql, from, col, countAll, countCol, sumCol, avgCol, minCol, maxCol, unionSql, unionAllSql, intersectSql, exceptSql, subquery, existsSql, exports;
ChangesetError = temper.type('ChangesetError');
ChangesetError.constructor = function(this__251, field__469, message__470)
  this__251.field__466 = field__469;
  this__251.message__467 = message__470;
  return nil;
end;
ChangesetError.get.field = function(this__1360)
  return this__1360.field__466;
end;
ChangesetError.get.message = function(this__1363)
  return this__1363.message__467;
end;
Changeset = temper.type('Changeset');
Changeset.get.tableDef = function(this__148)
  temper.virtual();
end;
Changeset.get.changes = function(this__149)
  temper.virtual();
end;
Changeset.get.errors = function(this__150)
  temper.virtual();
end;
Changeset.get.isValid = function(this__151)
  temper.virtual();
end;
Changeset.methods.cast = function(this__152, allowedFields__480)
  temper.virtual();
end;
Changeset.methods.validateRequired = function(this__153, fields__483)
  temper.virtual();
end;
Changeset.methods.validateLength = function(this__154, field__486, min__487, max__488)
  temper.virtual();
end;
Changeset.methods.validateInt = function(this__155, field__491)
  temper.virtual();
end;
Changeset.methods.validateInt64 = function(this__156, field__494)
  temper.virtual();
end;
Changeset.methods.validateFloat = function(this__157, field__497)
  temper.virtual();
end;
Changeset.methods.validateBool = function(this__158, field__500)
  temper.virtual();
end;
Changeset.methods.toInsertSql = function(this__159)
  temper.virtual();
end;
Changeset.methods.toUpdateSql = function(this__160, id__505)
  temper.virtual();
end;
ChangesetImpl__161 = temper.type('ChangesetImpl__161', Changeset);
ChangesetImpl__161.get.tableDef = function(this__162)
  return this__162._tableDef__507;
end;
ChangesetImpl__161.get.changes = function(this__163)
  return this__163._changes__509;
end;
ChangesetImpl__161.get.errors = function(this__164)
  return this__164._errors__510;
end;
ChangesetImpl__161.get.isValid = function(this__165)
  return this__165._isValid__511;
end;
ChangesetImpl__161.methods.cast = function(this__166, allowedFields__521)
  local mb__523, fn__9583;
  mb__523 = temper.mapbuilder_constructor();
  fn__9583 = function(f__524)
    local t_0, t_1, val__525;
    t_1 = f__524.sqlValue;
    val__525 = temper.mapped_getor(this__166._params__508, t_1, '');
    if not temper.string_isempty(val__525) then
      t_0 = f__524.sqlValue;
      temper.mapbuilder_set(mb__523, t_0, val__525);
    end
    return nil;
  end;
  temper.list_foreach(allowedFields__521, fn__9583);
  return ChangesetImpl__161(this__166._tableDef__507, this__166._params__508, temper.mapped_tomap(mb__523), this__166._errors__510, this__166._isValid__511);
end;
ChangesetImpl__161.methods.validateRequired = function(this__167, fields__527)
  local return__284, t_2, t_3, t_4, t_5, eb__529, valid__530, fn__9572;
  ::continue_1::
  if not this__167._isValid__511 then
    return__284 = this__167;
    goto break_0;
  end
  eb__529 = temper.list_tolistbuilder(this__167._errors__510);
  valid__530 = true;
  fn__9572 = function(f__531)
    local t_6, t_7;
    t_7 = f__531.sqlValue;
    if not temper.mapped_has(this__167._changes__509, t_7) then
      t_6 = ChangesetError(f__531.sqlValue, 'is required');
      temper.listbuilder_add(eb__529, t_6);
      valid__530 = false;
    end
    return nil;
  end;
  temper.list_foreach(fields__527, fn__9572);
  t_3 = this__167._tableDef__507;
  t_4 = this__167._params__508;
  t_5 = this__167._changes__509;
  t_2 = temper.listbuilder_tolist(eb__529);
  return__284 = ChangesetImpl__161(t_3, t_4, t_5, t_2, valid__530);
  ::break_0::return return__284;
end;
ChangesetImpl__161.methods.validateLength = function(this__168, field__533, min__534, max__535)
  local return__285, t_8, t_9, t_10, t_11, t_12, t_13, val__537, len__538;
  ::continue_3::
  if not this__168._isValid__511 then
    return__285 = this__168;
    goto break_2;
  end
  t_8 = field__533.sqlValue;
  val__537 = temper.mapped_getor(this__168._changes__509, t_8, '');
  len__538 = temper.string_countbetween(val__537, 1.0, temper.string_end(val__537));
  if (len__538 < min__534) then
    t_10 = true;
  else
    t_10 = (len__538 > max__535);
  end
  if t_10 then
    local msg__539, eb__540;
    msg__539 = temper.concat('must be between ', temper.int32_tostring(min__534), ' and ', temper.int32_tostring(max__535), ' characters');
    eb__540 = temper.list_tolistbuilder(this__168._errors__510);
    temper.listbuilder_add(eb__540, ChangesetError(field__533.sqlValue, msg__539));
    t_11 = this__168._tableDef__507;
    t_12 = this__168._params__508;
    t_13 = this__168._changes__509;
    t_9 = temper.listbuilder_tolist(eb__540);
    return__285 = ChangesetImpl__161(t_11, t_12, t_13, t_9, false);
    goto break_2;
  end
  return__285 = this__168;
  ::break_2::return return__285;
end;
ChangesetImpl__161.methods.validateInt = function(this__169, field__542)
  local return__286, t_14, t_15, t_16, t_17, t_18, val__544, parseOk__545, local_19, local_20, local_21;
  ::continue_5::
  if not this__169._isValid__511 then
    return__286 = this__169;
    goto break_4;
  end
  t_14 = field__542.sqlValue;
  val__544 = temper.mapped_getor(this__169._changes__509, t_14, '');
  if temper.string_isempty(val__544) then
    return__286 = this__169;
    goto break_4;
  end
  local_19, local_20, local_21 = temper.pcall(function()
    temper.string_toint32(val__544);
    parseOk__545 = true;
  end);
  if local_19 then
  else
    parseOk__545 = false;
  end
  if not parseOk__545 then
    local eb__546;
    eb__546 = temper.list_tolistbuilder(this__169._errors__510);
    temper.listbuilder_add(eb__546, ChangesetError(field__542.sqlValue, 'must be an integer'));
    t_16 = this__169._tableDef__507;
    t_17 = this__169._params__508;
    t_18 = this__169._changes__509;
    t_15 = temper.listbuilder_tolist(eb__546);
    return__286 = ChangesetImpl__161(t_16, t_17, t_18, t_15, false);
    goto break_4;
  end
  return__286 = this__169;
  ::break_4::return return__286;
end;
ChangesetImpl__161.methods.validateInt64 = function(this__170, field__548)
  local return__287, t_23, t_24, t_25, t_26, t_27, val__550, parseOk__551, local_28, local_29, local_30;
  ::continue_7::
  if not this__170._isValid__511 then
    return__287 = this__170;
    goto break_6;
  end
  t_23 = field__548.sqlValue;
  val__550 = temper.mapped_getor(this__170._changes__509, t_23, '');
  if temper.string_isempty(val__550) then
    return__287 = this__170;
    goto break_6;
  end
  local_28, local_29, local_30 = temper.pcall(function()
    temper.string_toint64(val__550);
    parseOk__551 = true;
  end);
  if local_28 then
  else
    parseOk__551 = false;
  end
  if not parseOk__551 then
    local eb__552;
    eb__552 = temper.list_tolistbuilder(this__170._errors__510);
    temper.listbuilder_add(eb__552, ChangesetError(field__548.sqlValue, 'must be a 64-bit integer'));
    t_25 = this__170._tableDef__507;
    t_26 = this__170._params__508;
    t_27 = this__170._changes__509;
    t_24 = temper.listbuilder_tolist(eb__552);
    return__287 = ChangesetImpl__161(t_25, t_26, t_27, t_24, false);
    goto break_6;
  end
  return__287 = this__170;
  ::break_6::return return__287;
end;
ChangesetImpl__161.methods.validateFloat = function(this__171, field__554)
  local return__288, t_32, t_33, t_34, t_35, t_36, val__556, parseOk__557, local_37, local_38, local_39;
  ::continue_9::
  if not this__171._isValid__511 then
    return__288 = this__171;
    goto break_8;
  end
  t_32 = field__554.sqlValue;
  val__556 = temper.mapped_getor(this__171._changes__509, t_32, '');
  if temper.string_isempty(val__556) then
    return__288 = this__171;
    goto break_8;
  end
  local_37, local_38, local_39 = temper.pcall(function()
    temper.string_tofloat64(val__556);
    parseOk__557 = true;
  end);
  if local_37 then
  else
    parseOk__557 = false;
  end
  if not parseOk__557 then
    local eb__558;
    eb__558 = temper.list_tolistbuilder(this__171._errors__510);
    temper.listbuilder_add(eb__558, ChangesetError(field__554.sqlValue, 'must be a number'));
    t_34 = this__171._tableDef__507;
    t_35 = this__171._params__508;
    t_36 = this__171._changes__509;
    t_33 = temper.listbuilder_tolist(eb__558);
    return__288 = ChangesetImpl__161(t_34, t_35, t_36, t_33, false);
    goto break_8;
  end
  return__288 = this__171;
  ::break_8::return return__288;
end;
ChangesetImpl__161.methods.validateBool = function(this__172, field__560)
  local return__289, t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48, t_49, t_50, val__562, isTrue__563, isFalse__564;
  ::continue_11::
  if not this__172._isValid__511 then
    return__289 = this__172;
    goto break_10;
  end
  t_41 = field__560.sqlValue;
  val__562 = temper.mapped_getor(this__172._changes__509, t_41, '');
  if temper.string_isempty(val__562) then
    return__289 = this__172;
    goto break_10;
  end
  if temper.str_eq(val__562, 'true') then
    isTrue__563 = true;
  else
    if temper.str_eq(val__562, '1') then
      t_44 = true;
    else
      if temper.str_eq(val__562, 'yes') then
        t_43 = true;
      else
        t_43 = temper.str_eq(val__562, 'on');
      end
      t_44 = t_43;
    end
    isTrue__563 = t_44;
  end
  if temper.str_eq(val__562, 'false') then
    isFalse__564 = true;
  else
    if temper.str_eq(val__562, '0') then
      t_46 = true;
    else
      if temper.str_eq(val__562, 'no') then
        t_45 = true;
      else
        t_45 = temper.str_eq(val__562, 'off');
      end
      t_46 = t_45;
    end
    isFalse__564 = t_46;
  end
  if not isTrue__563 then
    t_47 = not isFalse__564;
  else
    t_47 = false;
  end
  if t_47 then
    local eb__565;
    eb__565 = temper.list_tolistbuilder(this__172._errors__510);
    temper.listbuilder_add(eb__565, ChangesetError(field__560.sqlValue, 'must be a boolean (true/false/1/0/yes/no/on/off)'));
    t_48 = this__172._tableDef__507;
    t_49 = this__172._params__508;
    t_50 = this__172._changes__509;
    t_42 = temper.listbuilder_tolist(eb__565);
    return__289 = ChangesetImpl__161(t_48, t_49, t_50, t_42, false);
    goto break_10;
  end
  return__289 = this__172;
  ::break_10::return return__289;
end;
ChangesetImpl__161.methods.parseBoolSqlPart = function(this__173, val__567)
  local return__290, t_51, t_52, t_53, t_54, t_55, t_56;
  ::continue_13::
  if temper.str_eq(val__567, 'true') then
    t_53 = true;
  else
    if temper.str_eq(val__567, '1') then
      t_52 = true;
    else
      if temper.str_eq(val__567, 'yes') then
        t_51 = true;
      else
        t_51 = temper.str_eq(val__567, 'on');
      end
      t_52 = t_51;
    end
    t_53 = t_52;
  end
  if t_53 then
    return__290 = SqlBoolean(true);
    goto break_12;
  end
  if temper.str_eq(val__567, 'false') then
    t_56 = true;
  else
    if temper.str_eq(val__567, '0') then
      t_55 = true;
    else
      if temper.str_eq(val__567, 'no') then
        t_54 = true;
      else
        t_54 = temper.str_eq(val__567, 'off');
      end
      t_55 = t_54;
    end
    t_56 = t_55;
  end
  if t_56 then
    return__290 = SqlBoolean(false);
    goto break_12;
  end
  temper.bubble();
  ::break_12::return return__290;
end;
ChangesetImpl__161.methods.valueToSqlPart = function(this__174, fieldDef__570, val__571)
  local return__291, t_57, t_58, t_59, t_60, ft__573;
  ::continue_15::ft__573 = fieldDef__570.fieldType;
  if temper.instance_of(ft__573, StringField) then
    return__291 = SqlString(val__571);
    goto break_14;
  end
  if temper.instance_of(ft__573, IntField) then
    t_57 = temper.string_toint32(val__571);
    return__291 = SqlInt32(t_57);
    goto break_14;
  end
  if temper.instance_of(ft__573, Int64Field) then
    t_58 = temper.string_toint64(val__571);
    return__291 = SqlInt64(t_58);
    goto break_14;
  end
  if temper.instance_of(ft__573, FloatField) then
    t_59 = temper.string_tofloat64(val__571);
    return__291 = SqlFloat64(t_59);
    goto break_14;
  end
  if temper.instance_of(ft__573, BoolField) then
    return__291 = this__174:parseBoolSqlPart(val__571);
    goto break_14;
  end
  if temper.instance_of(ft__573, DateField) then
    t_60 = temper.date_fromisostring(val__571);
    return__291 = SqlDate(t_60);
    goto break_14;
  end
  temper.bubble();
  ::break_14::return return__291;
end;
ChangesetImpl__161.methods.toInsertSql = function(this__175)
  local t_61, t_62, t_63, t_64, t_65, t_66, t_67, t_68, t_69, t_70, i__576, pairs__578, colNames__579, valParts__580, i__581, b__584, t_71, fn__9464, j__586;
  if not this__175._isValid__511 then
    temper.bubble();
  end
  i__576 = 0;
  while true do
    local f__577;
    t_61 = temper.list_length(this__175._tableDef__507.fields);
    if not (i__576 < t_61) then
      break;
    end
    f__577 = temper.list_get(this__175._tableDef__507.fields, i__576);
    if not f__577.nullable then
      t_62 = f__577.name.sqlValue;
      t_63 = temper.mapped_has(this__175._changes__509, t_62);
      t_68 = not t_63;
    else
      t_68 = false;
    end
    if t_68 then
      temper.bubble();
    end
    i__576 = temper.int32_add(i__576, 1);
  end
  pairs__578 = temper.mapped_tolist(this__175._changes__509);
  if (temper.list_length(pairs__578) == 0) then
    temper.bubble();
  end
  colNames__579 = temper.listbuilder_constructor();
  valParts__580 = temper.listbuilder_constructor();
  i__581 = 0;
  while true do
    local pair__582, fd__583;
    t_64 = temper.list_length(pairs__578);
    if not (i__581 < t_64) then
      break;
    end
    pair__582 = temper.list_get(pairs__578, i__581);
    t_65 = pair__582.key;
    t_69 = this__175._tableDef__507:field(t_65);
    fd__583 = t_69;
    temper.listbuilder_add(colNames__579, fd__583.name.sqlValue);
    t_66 = pair__582.value;
    t_70 = this__175:valueToSqlPart(fd__583, t_66);
    temper.listbuilder_add(valParts__580, t_70);
    i__581 = temper.int32_add(i__581, 1);
  end
  b__584 = SqlBuilder();
  b__584:appendSafe('INSERT INTO ');
  b__584:appendSafe(this__175._tableDef__507.tableName.sqlValue);
  b__584:appendSafe(' (');
  t_71 = temper.listbuilder_tolist(colNames__579);
  fn__9464 = function(c__585)
    return c__585;
  end;
  b__584:appendSafe(temper.listed_join(t_71, ', ', fn__9464));
  b__584:appendSafe(') VALUES (');
  b__584:appendPart(temper.listed_get(valParts__580, 0));
  j__586 = 1;
  while true do
    t_67 = temper.listbuilder_length(valParts__580);
    if not (j__586 < t_67) then
      break;
    end
    b__584:appendSafe(', ');
    b__584:appendPart(temper.listed_get(valParts__580, j__586));
    j__586 = temper.int32_add(j__586, 1);
  end
  b__584:appendSafe(')');
  return b__584.accumulated;
end;
ChangesetImpl__161.methods.toUpdateSql = function(this__176, id__588)
  local t_72, t_73, t_74, t_75, t_76, pairs__590, b__591, i__592;
  if not this__176._isValid__511 then
    temper.bubble();
  end
  pairs__590 = temper.mapped_tolist(this__176._changes__509);
  if (temper.list_length(pairs__590) == 0) then
    temper.bubble();
  end
  b__591 = SqlBuilder();
  b__591:appendSafe('UPDATE ');
  b__591:appendSafe(this__176._tableDef__507.tableName.sqlValue);
  b__591:appendSafe(' SET ');
  i__592 = 0;
  while true do
    local pair__593, fd__594;
    t_72 = temper.list_length(pairs__590);
    if not (i__592 < t_72) then
      break;
    end
    if (i__592 > 0) then
      b__591:appendSafe(', ');
    end
    pair__593 = temper.list_get(pairs__590, i__592);
    t_73 = pair__593.key;
    t_75 = this__176._tableDef__507:field(t_73);
    fd__594 = t_75;
    b__591:appendSafe(fd__594.name.sqlValue);
    b__591:appendSafe(' = ');
    t_74 = pair__593.value;
    t_76 = this__176:valueToSqlPart(fd__594, t_74);
    b__591:appendPart(t_76);
    i__592 = temper.int32_add(i__592, 1);
  end
  b__591:appendSafe(' WHERE id = ');
  b__591:appendInt32(id__588);
  return b__591.accumulated;
end;
ChangesetImpl__161.constructor = function(this__274, _tableDef__596, _params__597, _changes__598, _errors__599, _isValid__600)
  this__274._tableDef__507 = _tableDef__596;
  this__274._params__508 = _params__597;
  this__274._changes__509 = _changes__598;
  this__274._errors__510 = _errors__599;
  this__274._isValid__511 = _isValid__600;
  return nil;
end;
JoinType = temper.type('JoinType');
JoinType.methods.keyword = function(this__177)
  temper.virtual();
end;
InnerJoin = temper.type('InnerJoin', JoinType);
InnerJoin.methods.keyword = function(this__178)
  return 'INNER JOIN';
end;
InnerJoin.constructor = function(this__299)
  return nil;
end;
LeftJoin = temper.type('LeftJoin', JoinType);
LeftJoin.methods.keyword = function(this__179)
  return 'LEFT JOIN';
end;
LeftJoin.constructor = function(this__302)
  return nil;
end;
RightJoin = temper.type('RightJoin', JoinType);
RightJoin.methods.keyword = function(this__180)
  return 'RIGHT JOIN';
end;
RightJoin.constructor = function(this__305)
  return nil;
end;
FullJoin = temper.type('FullJoin', JoinType);
FullJoin.methods.keyword = function(this__181)
  return 'FULL OUTER JOIN';
end;
FullJoin.constructor = function(this__308)
  return nil;
end;
JoinClause = temper.type('JoinClause');
JoinClause.constructor = function(this__311, joinType__713, table__714, onCondition__715)
  this__311.joinType__709 = joinType__713;
  this__311.table__710 = table__714;
  this__311.onCondition__711 = onCondition__715;
  return nil;
end;
JoinClause.get.joinType = function(this__1428)
  return this__1428.joinType__709;
end;
JoinClause.get.table = function(this__1431)
  return this__1431.table__710;
end;
JoinClause.get.onCondition = function(this__1434)
  return this__1434.onCondition__711;
end;
OrderClause = temper.type('OrderClause');
OrderClause.constructor = function(this__313, field__719, ascending__720)
  this__313.field__716 = field__719;
  this__313.ascending__717 = ascending__720;
  return nil;
end;
OrderClause.get.field = function(this__1437)
  return this__1437.field__716;
end;
OrderClause.get.ascending = function(this__1440)
  return this__1440.ascending__717;
end;
WhereClause = temper.type('WhereClause');
WhereClause.get.condition = function(this__182)
  temper.virtual();
end;
WhereClause.methods.keyword = function(this__183)
  temper.virtual();
end;
AndCondition = temper.type('AndCondition', WhereClause);
AndCondition.get.condition = function(this__184)
  return this__184._condition__725;
end;
AndCondition.methods.keyword = function(this__185)
  return 'AND';
end;
AndCondition.constructor = function(this__319, _condition__731)
  this__319._condition__725 = _condition__731;
  return nil;
end;
OrCondition = temper.type('OrCondition', WhereClause);
OrCondition.get.condition = function(this__186)
  return this__186._condition__732;
end;
OrCondition.methods.keyword = function(this__187)
  return 'OR';
end;
OrCondition.constructor = function(this__324, _condition__738)
  this__324._condition__732 = _condition__738;
  return nil;
end;
Query = temper.type('Query');
Query.methods.where = function(this__188, condition__751)
  local nb__753;
  nb__753 = temper.list_tolistbuilder(this__188.conditions__740);
  temper.listbuilder_add(nb__753, AndCondition(condition__751));
  return Query(this__188.tableName__739, temper.listbuilder_tolist(nb__753), this__188.selectedFields__741, this__188.orderClauses__742, this__188.limitVal__743, this__188.offsetVal__744, this__188.joinClauses__745, this__188.groupByFields__746, this__188.havingConditions__747, this__188.isDistinct__748, this__188.selectExprs__749);
end;
Query.methods.orWhere = function(this__189, condition__755)
  local nb__757;
  nb__757 = temper.list_tolistbuilder(this__189.conditions__740);
  temper.listbuilder_add(nb__757, OrCondition(condition__755));
  return Query(this__189.tableName__739, temper.listbuilder_tolist(nb__757), this__189.selectedFields__741, this__189.orderClauses__742, this__189.limitVal__743, this__189.offsetVal__744, this__189.joinClauses__745, this__189.groupByFields__746, this__189.havingConditions__747, this__189.isDistinct__748, this__189.selectExprs__749);
end;
Query.methods.whereNull = function(this__190, field__759)
  local b__761, t_77;
  b__761 = SqlBuilder();
  b__761:appendSafe(field__759.sqlValue);
  b__761:appendSafe(' IS NULL');
  t_77 = b__761.accumulated;
  return this__190:where(t_77);
end;
Query.methods.whereNotNull = function(this__191, field__763)
  local b__765, t_78;
  b__765 = SqlBuilder();
  b__765:appendSafe(field__763.sqlValue);
  b__765:appendSafe(' IS NOT NULL');
  t_78 = b__765.accumulated;
  return this__191:where(t_78);
end;
Query.methods.whereIn = function(this__192, field__767, values__768)
  local return__343, t_79, t_80, t_81, b__771, i__772;
  ::continue_17::
  if temper.listed_isempty(values__768) then
    local b__770;
    b__770 = SqlBuilder();
    b__770:appendSafe('1 = 0');
    t_79 = b__770.accumulated;
    return__343 = this__192:where(t_79);
    goto break_16;
  end
  b__771 = SqlBuilder();
  b__771:appendSafe(field__767.sqlValue);
  b__771:appendSafe(' IN (');
  b__771:appendPart(temper.list_get(values__768, 0));
  i__772 = 1;
  while true do
    t_80 = temper.list_length(values__768);
    if not (i__772 < t_80) then
      break;
    end
    b__771:appendSafe(', ');
    b__771:appendPart(temper.list_get(values__768, i__772));
    i__772 = temper.int32_add(i__772, 1);
  end
  b__771:appendSafe(')');
  t_81 = b__771.accumulated;
  return__343 = this__192:where(t_81);
  ::break_16::return return__343;
end;
Query.methods.whereInSubquery = function(this__193, field__774, sub__775)
  local b__777, t_82;
  b__777 = SqlBuilder();
  b__777:appendSafe(field__774.sqlValue);
  b__777:appendSafe(' IN (');
  b__777:appendFragment(sub__775:toSql());
  b__777:appendSafe(')');
  t_82 = b__777.accumulated;
  return this__193:where(t_82);
end;
Query.methods.whereNot = function(this__194, condition__779)
  local b__781, t_83;
  b__781 = SqlBuilder();
  b__781:appendSafe('NOT (');
  b__781:appendFragment(condition__779);
  b__781:appendSafe(')');
  t_83 = b__781.accumulated;
  return this__194:where(t_83);
end;
Query.methods.whereBetween = function(this__195, field__783, low__784, high__785)
  local b__787, t_84;
  b__787 = SqlBuilder();
  b__787:appendSafe(field__783.sqlValue);
  b__787:appendSafe(' BETWEEN ');
  b__787:appendPart(low__784);
  b__787:appendSafe(' AND ');
  b__787:appendPart(high__785);
  t_84 = b__787.accumulated;
  return this__195:where(t_84);
end;
Query.methods.whereLike = function(this__196, field__789, pattern__790)
  local b__792, t_85;
  b__792 = SqlBuilder();
  b__792:appendSafe(field__789.sqlValue);
  b__792:appendSafe(' LIKE ');
  b__792:appendString(pattern__790);
  t_85 = b__792.accumulated;
  return this__196:where(t_85);
end;
Query.methods.whereILike = function(this__197, field__794, pattern__795)
  local b__797, t_86;
  b__797 = SqlBuilder();
  b__797:appendSafe(field__794.sqlValue);
  b__797:appendSafe(' ILIKE ');
  b__797:appendString(pattern__795);
  t_86 = b__797.accumulated;
  return this__197:where(t_86);
end;
Query.methods.select = function(this__198, fields__799)
  return Query(this__198.tableName__739, this__198.conditions__740, fields__799, this__198.orderClauses__742, this__198.limitVal__743, this__198.offsetVal__744, this__198.joinClauses__745, this__198.groupByFields__746, this__198.havingConditions__747, this__198.isDistinct__748, this__198.selectExprs__749);
end;
Query.methods.selectExpr = function(this__199, exprs__802)
  return Query(this__199.tableName__739, this__199.conditions__740, this__199.selectedFields__741, this__199.orderClauses__742, this__199.limitVal__743, this__199.offsetVal__744, this__199.joinClauses__745, this__199.groupByFields__746, this__199.havingConditions__747, this__199.isDistinct__748, exprs__802);
end;
Query.methods.orderBy = function(this__200, field__805, ascending__806)
  local nb__808;
  nb__808 = temper.list_tolistbuilder(this__200.orderClauses__742);
  temper.listbuilder_add(nb__808, OrderClause(field__805, ascending__806));
  return Query(this__200.tableName__739, this__200.conditions__740, this__200.selectedFields__741, temper.listbuilder_tolist(nb__808), this__200.limitVal__743, this__200.offsetVal__744, this__200.joinClauses__745, this__200.groupByFields__746, this__200.havingConditions__747, this__200.isDistinct__748, this__200.selectExprs__749);
end;
Query.methods.limit = function(this__201, n__810)
  if (n__810 < 0) then
    temper.bubble();
  end
  return Query(this__201.tableName__739, this__201.conditions__740, this__201.selectedFields__741, this__201.orderClauses__742, n__810, this__201.offsetVal__744, this__201.joinClauses__745, this__201.groupByFields__746, this__201.havingConditions__747, this__201.isDistinct__748, this__201.selectExprs__749);
end;
Query.methods.offset = function(this__202, n__813)
  if (n__813 < 0) then
    temper.bubble();
  end
  return Query(this__202.tableName__739, this__202.conditions__740, this__202.selectedFields__741, this__202.orderClauses__742, this__202.limitVal__743, n__813, this__202.joinClauses__745, this__202.groupByFields__746, this__202.havingConditions__747, this__202.isDistinct__748, this__202.selectExprs__749);
end;
Query.methods.join = function(this__203, joinType__816, table__817, onCondition__818)
  local nb__820;
  nb__820 = temper.list_tolistbuilder(this__203.joinClauses__745);
  temper.listbuilder_add(nb__820, JoinClause(joinType__816, table__817, onCondition__818));
  return Query(this__203.tableName__739, this__203.conditions__740, this__203.selectedFields__741, this__203.orderClauses__742, this__203.limitVal__743, this__203.offsetVal__744, temper.listbuilder_tolist(nb__820), this__203.groupByFields__746, this__203.havingConditions__747, this__203.isDistinct__748, this__203.selectExprs__749);
end;
Query.methods.innerJoin = function(this__204, table__822, onCondition__823)
  local t_87;
  t_87 = InnerJoin();
  return this__204:join(t_87, table__822, onCondition__823);
end;
Query.methods.leftJoin = function(this__205, table__826, onCondition__827)
  local t_88;
  t_88 = LeftJoin();
  return this__205:join(t_88, table__826, onCondition__827);
end;
Query.methods.rightJoin = function(this__206, table__830, onCondition__831)
  local t_89;
  t_89 = RightJoin();
  return this__206:join(t_89, table__830, onCondition__831);
end;
Query.methods.fullJoin = function(this__207, table__834, onCondition__835)
  local t_90;
  t_90 = FullJoin();
  return this__207:join(t_90, table__834, onCondition__835);
end;
Query.methods.groupBy = function(this__208, field__838)
  local nb__840;
  nb__840 = temper.list_tolistbuilder(this__208.groupByFields__746);
  temper.listbuilder_add(nb__840, field__838);
  return Query(this__208.tableName__739, this__208.conditions__740, this__208.selectedFields__741, this__208.orderClauses__742, this__208.limitVal__743, this__208.offsetVal__744, this__208.joinClauses__745, temper.listbuilder_tolist(nb__840), this__208.havingConditions__747, this__208.isDistinct__748, this__208.selectExprs__749);
end;
Query.methods.having = function(this__209, condition__842)
  local nb__844;
  nb__844 = temper.list_tolistbuilder(this__209.havingConditions__747);
  temper.listbuilder_add(nb__844, AndCondition(condition__842));
  return Query(this__209.tableName__739, this__209.conditions__740, this__209.selectedFields__741, this__209.orderClauses__742, this__209.limitVal__743, this__209.offsetVal__744, this__209.joinClauses__745, this__209.groupByFields__746, temper.listbuilder_tolist(nb__844), this__209.isDistinct__748, this__209.selectExprs__749);
end;
Query.methods.orHaving = function(this__210, condition__846)
  local nb__848;
  nb__848 = temper.list_tolistbuilder(this__210.havingConditions__747);
  temper.listbuilder_add(nb__848, OrCondition(condition__846));
  return Query(this__210.tableName__739, this__210.conditions__740, this__210.selectedFields__741, this__210.orderClauses__742, this__210.limitVal__743, this__210.offsetVal__744, this__210.joinClauses__745, this__210.groupByFields__746, temper.listbuilder_tolist(nb__848), this__210.isDistinct__748, this__210.selectExprs__749);
end;
Query.methods.distinct = function(this__211)
  return Query(this__211.tableName__739, this__211.conditions__740, this__211.selectedFields__741, this__211.orderClauses__742, this__211.limitVal__743, this__211.offsetVal__744, this__211.joinClauses__745, this__211.groupByFields__746, this__211.havingConditions__747, true, this__211.selectExprs__749);
end;
Query.methods.toSql = function(this__212)
  local t_91, t_92, t_93, b__853, fn__8851, lv__862, ov__863;
  b__853 = SqlBuilder();
  if this__212.isDistinct__748 then
    b__853:appendSafe('SELECT DISTINCT ');
  else
    b__853:appendSafe('SELECT ');
  end
  if not temper.listed_isempty(this__212.selectExprs__749) then
    local i__854;
    b__853:appendFragment(temper.list_get(this__212.selectExprs__749, 0));
    i__854 = 1;
    while true do
      t_91 = temper.list_length(this__212.selectExprs__749);
      if not (i__854 < t_91) then
        break;
      end
      b__853:appendSafe(', ');
      b__853:appendFragment(temper.list_get(this__212.selectExprs__749, i__854));
      i__854 = temper.int32_add(i__854, 1);
    end
  elseif temper.listed_isempty(this__212.selectedFields__741) then
    b__853:appendSafe('*');
  else
    local fn__8852;
    fn__8852 = function(f__855)
      return f__855.sqlValue;
    end;
    b__853:appendSafe(temper.listed_join(this__212.selectedFields__741, ', ', fn__8852));
  end
  b__853:appendSafe(' FROM ');
  b__853:appendSafe(this__212.tableName__739.sqlValue);
  fn__8851 = function(jc__856)
    local t_94, t_95, t_96;
    b__853:appendSafe(' ');
    t_94 = jc__856.joinType:keyword();
    b__853:appendSafe(t_94);
    b__853:appendSafe(' ');
    t_95 = jc__856.table.sqlValue;
    b__853:appendSafe(t_95);
    b__853:appendSafe(' ON ');
    t_96 = jc__856.onCondition;
    b__853:appendFragment(t_96);
    return nil;
  end;
  temper.list_foreach(this__212.joinClauses__745, fn__8851);
  if not temper.listed_isempty(this__212.conditions__740) then
    local i__857;
    b__853:appendSafe(' WHERE ');
    b__853:appendFragment((temper.list_get(this__212.conditions__740, 0)).condition);
    i__857 = 1;
    while true do
      t_92 = temper.list_length(this__212.conditions__740);
      if not (i__857 < t_92) then
        break;
      end
      b__853:appendSafe(' ');
      b__853:appendSafe(temper.list_get(this__212.conditions__740, i__857):keyword());
      b__853:appendSafe(' ');
      b__853:appendFragment((temper.list_get(this__212.conditions__740, i__857)).condition);
      i__857 = temper.int32_add(i__857, 1);
    end
  end
  if not temper.listed_isempty(this__212.groupByFields__746) then
    local fn__8850;
    b__853:appendSafe(' GROUP BY ');
    fn__8850 = function(f__858)
      return f__858.sqlValue;
    end;
    b__853:appendSafe(temper.listed_join(this__212.groupByFields__746, ', ', fn__8850));
  end
  if not temper.listed_isempty(this__212.havingConditions__747) then
    local i__859;
    b__853:appendSafe(' HAVING ');
    b__853:appendFragment((temper.list_get(this__212.havingConditions__747, 0)).condition);
    i__859 = 1;
    while true do
      t_93 = temper.list_length(this__212.havingConditions__747);
      if not (i__859 < t_93) then
        break;
      end
      b__853:appendSafe(' ');
      b__853:appendSafe(temper.list_get(this__212.havingConditions__747, i__859):keyword());
      b__853:appendSafe(' ');
      b__853:appendFragment((temper.list_get(this__212.havingConditions__747, i__859)).condition);
      i__859 = temper.int32_add(i__859, 1);
    end
  end
  if not temper.listed_isempty(this__212.orderClauses__742) then
    local first__860, fn__8849;
    b__853:appendSafe(' ORDER BY ');
    first__860 = true;
    fn__8849 = function(oc__861)
      local t_97, t_98;
      if not first__860 then
        b__853:appendSafe(', ');
      end
      first__860 = false;
      t_98 = oc__861.field.sqlValue;
      b__853:appendSafe(t_98);
      if oc__861.ascending then
        t_97 = ' ASC';
      else
        t_97 = ' DESC';
      end
      b__853:appendSafe(t_97);
      return nil;
    end;
    temper.list_foreach(this__212.orderClauses__742, fn__8849);
  end
  lv__862 = this__212.limitVal__743;
  if not temper.is_null(lv__862) then
    local lv_99;
    lv_99 = lv__862;
    b__853:appendSafe(' LIMIT ');
    b__853:appendInt32(lv_99);
  end
  ov__863 = this__212.offsetVal__744;
  if not temper.is_null(ov__863) then
    local ov_100;
    ov_100 = ov__863;
    b__853:appendSafe(' OFFSET ');
    b__853:appendInt32(ov_100);
  end
  return b__853.accumulated;
end;
Query.methods.countSql = function(this__213)
  local t_101, t_102, b__866, fn__8789;
  b__866 = SqlBuilder();
  b__866:appendSafe('SELECT COUNT(*) FROM ');
  b__866:appendSafe(this__213.tableName__739.sqlValue);
  fn__8789 = function(jc__867)
    local t_103, t_104, t_105;
    b__866:appendSafe(' ');
    t_103 = jc__867.joinType:keyword();
    b__866:appendSafe(t_103);
    b__866:appendSafe(' ');
    t_104 = jc__867.table.sqlValue;
    b__866:appendSafe(t_104);
    b__866:appendSafe(' ON ');
    t_105 = jc__867.onCondition;
    b__866:appendFragment(t_105);
    return nil;
  end;
  temper.list_foreach(this__213.joinClauses__745, fn__8789);
  if not temper.listed_isempty(this__213.conditions__740) then
    local i__868;
    b__866:appendSafe(' WHERE ');
    b__866:appendFragment((temper.list_get(this__213.conditions__740, 0)).condition);
    i__868 = 1;
    while true do
      t_101 = temper.list_length(this__213.conditions__740);
      if not (i__868 < t_101) then
        break;
      end
      b__866:appendSafe(' ');
      b__866:appendSafe(temper.list_get(this__213.conditions__740, i__868):keyword());
      b__866:appendSafe(' ');
      b__866:appendFragment((temper.list_get(this__213.conditions__740, i__868)).condition);
      i__868 = temper.int32_add(i__868, 1);
    end
  end
  if not temper.listed_isempty(this__213.groupByFields__746) then
    local fn__8788;
    b__866:appendSafe(' GROUP BY ');
    fn__8788 = function(f__869)
      return f__869.sqlValue;
    end;
    b__866:appendSafe(temper.listed_join(this__213.groupByFields__746, ', ', fn__8788));
  end
  if not temper.listed_isempty(this__213.havingConditions__747) then
    local i__870;
    b__866:appendSafe(' HAVING ');
    b__866:appendFragment((temper.list_get(this__213.havingConditions__747, 0)).condition);
    i__870 = 1;
    while true do
      t_102 = temper.list_length(this__213.havingConditions__747);
      if not (i__870 < t_102) then
        break;
      end
      b__866:appendSafe(' ');
      b__866:appendSafe(temper.list_get(this__213.havingConditions__747, i__870):keyword());
      b__866:appendSafe(' ');
      b__866:appendFragment((temper.list_get(this__213.havingConditions__747, i__870)).condition);
      i__870 = temper.int32_add(i__870, 1);
    end
  end
  return b__866.accumulated;
end;
Query.methods.safeToSql = function(this__214, defaultLimit__872)
  local return__365, t_106;
  if (defaultLimit__872 < 0) then
    temper.bubble();
  end
  if not temper.is_null(this__214.limitVal__743) then
    return__365 = this__214:toSql();
  else
    t_106 = this__214:limit(defaultLimit__872);
    return__365 = t_106:toSql();
  end
  return return__365;
end;
Query.constructor = function(this__328, tableName__875, conditions__876, selectedFields__877, orderClauses__878, limitVal__879, offsetVal__880, joinClauses__881, groupByFields__882, havingConditions__883, isDistinct__884, selectExprs__885)
  if (limitVal__879 == nil) then
    limitVal__879 = temper.null;
  end
  if (offsetVal__880 == nil) then
    offsetVal__880 = temper.null;
  end
  this__328.tableName__739 = tableName__875;
  this__328.conditions__740 = conditions__876;
  this__328.selectedFields__741 = selectedFields__877;
  this__328.orderClauses__742 = orderClauses__878;
  this__328.limitVal__743 = limitVal__879;
  this__328.offsetVal__744 = offsetVal__880;
  this__328.joinClauses__745 = joinClauses__881;
  this__328.groupByFields__746 = groupByFields__882;
  this__328.havingConditions__747 = havingConditions__883;
  this__328.isDistinct__748 = isDistinct__884;
  this__328.selectExprs__749 = selectExprs__885;
  return nil;
end;
Query.get.tableName = function(this__1443)
  return this__1443.tableName__739;
end;
Query.get.conditions = function(this__1446)
  return this__1446.conditions__740;
end;
Query.get.selectedFields = function(this__1449)
  return this__1449.selectedFields__741;
end;
Query.get.orderClauses = function(this__1452)
  return this__1452.orderClauses__742;
end;
Query.get.limitVal = function(this__1455)
  return this__1455.limitVal__743;
end;
Query.get.offsetVal = function(this__1458)
  return this__1458.offsetVal__744;
end;
Query.get.joinClauses = function(this__1461)
  return this__1461.joinClauses__745;
end;
Query.get.groupByFields = function(this__1464)
  return this__1464.groupByFields__746;
end;
Query.get.havingConditions = function(this__1467)
  return this__1467.havingConditions__747;
end;
Query.get.isDistinct = function(this__1470)
  return this__1470.isDistinct__748;
end;
Query.get.selectExprs = function(this__1473)
  return this__1473.selectExprs__749;
end;
SafeIdentifier = temper.type('SafeIdentifier');
SafeIdentifier.get.sqlValue = function(this__215)
  temper.virtual();
end;
ValidatedIdentifier__216 = temper.type('ValidatedIdentifier__216', SafeIdentifier);
ValidatedIdentifier__216.get.sqlValue = function(this__217)
  return this__217._value__1116;
end;
ValidatedIdentifier__216.constructor = function(this__384, _value__1120)
  this__384._value__1116 = _value__1120;
  return nil;
end;
FieldType = temper.type('FieldType');
StringField = temper.type('StringField', FieldType);
StringField.constructor = function(this__390)
  return nil;
end;
IntField = temper.type('IntField', FieldType);
IntField.constructor = function(this__392)
  return nil;
end;
Int64Field = temper.type('Int64Field', FieldType);
Int64Field.constructor = function(this__394)
  return nil;
end;
FloatField = temper.type('FloatField', FieldType);
FloatField.constructor = function(this__396)
  return nil;
end;
BoolField = temper.type('BoolField', FieldType);
BoolField.constructor = function(this__398)
  return nil;
end;
DateField = temper.type('DateField', FieldType);
DateField.constructor = function(this__400)
  return nil;
end;
FieldDef = temper.type('FieldDef');
FieldDef.constructor = function(this__402, name__1138, fieldType__1139, nullable__1140)
  this__402.name__1134 = name__1138;
  this__402.fieldType__1135 = fieldType__1139;
  this__402.nullable__1136 = nullable__1140;
  return nil;
end;
FieldDef.get.name = function(this__1366)
  return this__1366.name__1134;
end;
FieldDef.get.fieldType = function(this__1369)
  return this__1369.fieldType__1135;
end;
FieldDef.get.nullable = function(this__1372)
  return this__1372.nullable__1136;
end;
TableDef = temper.type('TableDef');
TableDef.methods.field = function(this__218, name__1144)
  local return__407, this__5723, n__5724, i__5725;
  ::continue_19::this__5723 = this__218.fields__1142;
  n__5724 = temper.list_length(this__5723);
  i__5725 = 0;
  while (i__5725 < n__5724) do
    local el__5726, f__1146;
    el__5726 = temper.list_get(this__5723, i__5725);
    i__5725 = temper.int32_add(i__5725, 1);
    f__1146 = el__5726;
    if temper.str_eq(f__1146.name.sqlValue, name__1144) then
      return__407 = f__1146;
      goto break_18;
    end
  end
  temper.bubble();
  ::break_18::return return__407;
end;
TableDef.constructor = function(this__404, tableName__1148, fields__1149)
  this__404.tableName__1141 = tableName__1148;
  this__404.fields__1142 = fields__1149;
  return nil;
end;
TableDef.get.tableName = function(this__1375)
  return this__1375.tableName__1141;
end;
TableDef.get.fields = function(this__1378)
  return this__1378.fields__1142;
end;
SqlBuilder = temper.type('SqlBuilder');
SqlBuilder.methods.appendSafe = function(this__219, sqlSource__1171)
  local t_107;
  t_107 = SqlSource(sqlSource__1171);
  temper.listbuilder_add(this__219.buffer__1169, t_107);
  return nil;
end;
SqlBuilder.methods.appendFragment = function(this__220, fragment__1174)
  local t_108;
  t_108 = fragment__1174.parts;
  temper.listbuilder_addall(this__220.buffer__1169, t_108);
  return nil;
end;
SqlBuilder.methods.appendPart = function(this__221, part__1177)
  temper.listbuilder_add(this__221.buffer__1169, part__1177);
  return nil;
end;
SqlBuilder.methods.appendPartList = function(this__222, values__1180)
  local fn__9635;
  fn__9635 = function(x__1182)
    this__222:appendPart(x__1182);
    return nil;
  end;
  this__222:appendList(values__1180, fn__9635);
  return nil;
end;
SqlBuilder.methods.appendBoolean = function(this__223, value__1184)
  local t_109;
  t_109 = SqlBoolean(value__1184);
  temper.listbuilder_add(this__223.buffer__1169, t_109);
  return nil;
end;
SqlBuilder.methods.appendBooleanList = function(this__224, values__1187)
  local fn__9629;
  fn__9629 = function(x__1189)
    this__224:appendBoolean(x__1189);
    return nil;
  end;
  this__224:appendList(values__1187, fn__9629);
  return nil;
end;
SqlBuilder.methods.appendDate = function(this__225, value__1191)
  local t_110;
  t_110 = SqlDate(value__1191);
  temper.listbuilder_add(this__225.buffer__1169, t_110);
  return nil;
end;
SqlBuilder.methods.appendDateList = function(this__226, values__1194)
  local fn__9623;
  fn__9623 = function(x__1196)
    this__226:appendDate(x__1196);
    return nil;
  end;
  this__226:appendList(values__1194, fn__9623);
  return nil;
end;
SqlBuilder.methods.appendFloat64 = function(this__227, value__1198)
  local t_111;
  t_111 = SqlFloat64(value__1198);
  temper.listbuilder_add(this__227.buffer__1169, t_111);
  return nil;
end;
SqlBuilder.methods.appendFloat64List = function(this__228, values__1201)
  local fn__9617;
  fn__9617 = function(x__1203)
    this__228:appendFloat64(x__1203);
    return nil;
  end;
  this__228:appendList(values__1201, fn__9617);
  return nil;
end;
SqlBuilder.methods.appendInt32 = function(this__229, value__1205)
  local t_112;
  t_112 = SqlInt32(value__1205);
  temper.listbuilder_add(this__229.buffer__1169, t_112);
  return nil;
end;
SqlBuilder.methods.appendInt32List = function(this__230, values__1208)
  local fn__9611;
  fn__9611 = function(x__1210)
    this__230:appendInt32(x__1210);
    return nil;
  end;
  this__230:appendList(values__1208, fn__9611);
  return nil;
end;
SqlBuilder.methods.appendInt64 = function(this__231, value__1212)
  local t_113;
  t_113 = SqlInt64(value__1212);
  temper.listbuilder_add(this__231.buffer__1169, t_113);
  return nil;
end;
SqlBuilder.methods.appendInt64List = function(this__232, values__1215)
  local fn__9605;
  fn__9605 = function(x__1217)
    this__232:appendInt64(x__1217);
    return nil;
  end;
  this__232:appendList(values__1215, fn__9605);
  return nil;
end;
SqlBuilder.methods.appendString = function(this__233, value__1219)
  local t_114;
  t_114 = SqlString(value__1219);
  temper.listbuilder_add(this__233.buffer__1169, t_114);
  return nil;
end;
SqlBuilder.methods.appendStringList = function(this__234, values__1222)
  local fn__9599;
  fn__9599 = function(x__1224)
    this__234:appendString(x__1224);
    return nil;
  end;
  this__234:appendList(values__1222, fn__9599);
  return nil;
end;
SqlBuilder.methods.appendList = function(this__235, values__1226, appendValue__1227)
  local t_115, t_116, i__1229;
  i__1229 = 0;
  while true do
    t_115 = temper.listed_length(values__1226);
    if not (i__1229 < t_115) then
      break;
    end
    if (i__1229 > 0) then
      this__235:appendSafe(', ');
    end
    t_116 = temper.listed_get(values__1226, i__1229);
    appendValue__1227(t_116);
    i__1229 = temper.int32_add(i__1229, 1);
  end
  return nil;
end;
SqlBuilder.get.accumulated = function(this__236)
  return SqlFragment(temper.listbuilder_tolist(this__236.buffer__1169));
end;
SqlBuilder.constructor = function(this__409)
  local t_117;
  t_117 = temper.listbuilder_constructor();
  this__409.buffer__1169 = t_117;
  return nil;
end;
SqlFragment = temper.type('SqlFragment');
SqlFragment.methods.toSource = function(this__241)
  return SqlSource(this__241:toString());
end;
SqlFragment.methods.toString = function(this__242)
  local t_118, builder__1241, i__1242;
  builder__1241 = temper.stringbuilder_constructor();
  i__1242 = 0;
  while true do
    t_118 = temper.list_length(this__242.parts__1236);
    if not (i__1242 < t_118) then
      break;
    end
    temper.list_get(this__242.parts__1236, i__1242):formatTo(builder__1241);
    i__1242 = temper.int32_add(i__1242, 1);
  end
  return temper.stringbuilder_tostring(builder__1241);
end;
SqlFragment.constructor = function(this__430, parts__1244)
  this__430.parts__1236 = parts__1244;
  return nil;
end;
SqlFragment.get.parts = function(this__1384)
  return this__1384.parts__1236;
end;
SqlPart = temper.type('SqlPart');
SqlPart.methods.formatTo = function(this__243, builder__1246)
  temper.virtual();
end;
SqlSource = temper.type('SqlSource', SqlPart);
SqlSource.methods.formatTo = function(this__244, builder__1250)
  temper.stringbuilder_append(builder__1250, this__244.source__1248);
  return nil;
end;
SqlSource.constructor = function(this__436, source__1253)
  this__436.source__1248 = source__1253;
  return nil;
end;
SqlSource.get.source = function(this__1381)
  return this__1381.source__1248;
end;
SqlBoolean = temper.type('SqlBoolean', SqlPart);
SqlBoolean.methods.formatTo = function(this__245, builder__1256)
  local t_119;
  if this__245.value__1254 then
    t_119 = 'TRUE';
  else
    t_119 = 'FALSE';
  end
  temper.stringbuilder_append(builder__1256, t_119);
  return nil;
end;
SqlBoolean.constructor = function(this__439, value__1259)
  this__439.value__1254 = value__1259;
  return nil;
end;
SqlBoolean.get.value = function(this__1387)
  return this__1387.value__1254;
end;
SqlDate = temper.type('SqlDate', SqlPart);
SqlDate.methods.formatTo = function(this__246, builder__1262)
  local t_120, fn__9644;
  temper.stringbuilder_append(builder__1262, "'");
  t_120 = temper.date_tostring(this__246.value__1260);
  fn__9644 = function(c__1264)
    if (c__1264 == 39) then
      temper.stringbuilder_append(builder__1262, "''");
    else
      local local_121, local_122, local_123;
      local_121, local_122, local_123 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__1262, c__1264);
      end);
      if local_121 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(t_120, fn__9644);
  temper.stringbuilder_append(builder__1262, "'");
  return nil;
end;
SqlDate.constructor = function(this__442, value__1266)
  this__442.value__1260 = value__1266;
  return nil;
end;
SqlDate.get.value = function(this__1402)
  return this__1402.value__1260;
end;
SqlFloat64 = temper.type('SqlFloat64', SqlPart);
SqlFloat64.methods.formatTo = function(this__247, builder__1269)
  local t_125, t_126, s__1271;
  s__1271 = temper.float64_tostring(this__247.value__1267);
  if temper.str_eq(s__1271, 'NaN') then
    t_126 = true;
  else
    if temper.str_eq(s__1271, 'Infinity') then
      t_125 = true;
    else
      t_125 = temper.str_eq(s__1271, '-Infinity');
    end
    t_126 = t_125;
  end
  if t_126 then
    temper.stringbuilder_append(builder__1269, 'NULL');
  else
    temper.stringbuilder_append(builder__1269, s__1271);
  end
  return nil;
end;
SqlFloat64.constructor = function(this__445, value__1273)
  this__445.value__1267 = value__1273;
  return nil;
end;
SqlFloat64.get.value = function(this__1399)
  return this__1399.value__1267;
end;
SqlInt32 = temper.type('SqlInt32', SqlPart);
SqlInt32.methods.formatTo = function(this__248, builder__1276)
  local t_127;
  t_127 = temper.int32_tostring(this__248.value__1274);
  temper.stringbuilder_append(builder__1276, t_127);
  return nil;
end;
SqlInt32.constructor = function(this__448, value__1279)
  this__448.value__1274 = value__1279;
  return nil;
end;
SqlInt32.get.value = function(this__1393)
  return this__1393.value__1274;
end;
SqlInt64 = temper.type('SqlInt64', SqlPart);
SqlInt64.methods.formatTo = function(this__249, builder__1282)
  local t_128;
  t_128 = temper.int64_tostring(this__249.value__1280);
  temper.stringbuilder_append(builder__1282, t_128);
  return nil;
end;
SqlInt64.constructor = function(this__451, value__1285)
  this__451.value__1280 = value__1285;
  return nil;
end;
SqlInt64.get.value = function(this__1396)
  return this__1396.value__1280;
end;
SqlString = temper.type('SqlString', SqlPart);
SqlString.methods.formatTo = function(this__250, builder__1288)
  local fn__9658;
  temper.stringbuilder_append(builder__1288, "'");
  fn__9658 = function(c__1290)
    if (c__1290 == 39) then
      temper.stringbuilder_append(builder__1288, "''");
    else
      local local_129, local_130, local_131;
      local_129, local_130, local_131 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__1288, c__1290);
      end);
      if local_129 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(this__250.value__1286, fn__9658);
  temper.stringbuilder_append(builder__1288, "'");
  return nil;
end;
SqlString.constructor = function(this__454, value__1292)
  this__454.value__1286 = value__1292;
  return nil;
end;
SqlString.get.value = function(this__1390)
  return this__1390.value__1286;
end;
changeset = function(tableDef__601, params__602)
  local t_133;
  t_133 = temper.map_constructor(temper.listof());
  return ChangesetImpl__161(tableDef__601, params__602, t_133, temper.listof(), true);
end;
isIdentStart__462 = function(c__1121)
  local return__387, t_134, t_135;
  if (c__1121 >= 97) then
    t_134 = (c__1121 <= 122);
  else
    t_134 = false;
  end
  if t_134 then
    return__387 = true;
  else
    if (c__1121 >= 65) then
      t_135 = (c__1121 <= 90);
    else
      t_135 = false;
    end
    if t_135 then
      return__387 = true;
    else
      return__387 = (c__1121 == 95);
    end
  end
  return return__387;
end;
isIdentPart__463 = function(c__1123)
  local return__388;
  if isIdentStart__462(c__1123) then
    return__388 = true;
  elseif (c__1123 >= 48) then
    return__388 = (c__1123 <= 57);
  else
    return__388 = false;
  end
  return return__388;
end;
safeIdentifier = function(name__1125)
  local t_136, idx__1127, t_137;
  if temper.string_isempty(name__1125) then
    temper.bubble();
  end
  idx__1127 = 1.0;
  if not isIdentStart__462(temper.string_get(name__1125, idx__1127)) then
    temper.bubble();
  end
  t_137 = temper.string_next(name__1125, idx__1127);
  idx__1127 = t_137;
  while true do
    if not temper.string_hasindex(name__1125, idx__1127) then
      break;
    end
    if not isIdentPart__463(temper.string_get(name__1125, idx__1127)) then
      temper.bubble();
    end
    t_136 = temper.string_next(name__1125, idx__1127);
    idx__1127 = t_136;
  end
  return ValidatedIdentifier__216(name__1125);
end;
deleteSql = function(tableDef__691, id__692)
  local b__694;
  b__694 = SqlBuilder();
  b__694:appendSafe('DELETE FROM ');
  b__694:appendSafe(tableDef__691.tableName.sqlValue);
  b__694:appendSafe(' WHERE id = ');
  b__694:appendInt32(id__692);
  return b__694.accumulated;
end;
from = function(tableName__886)
  return Query(tableName__886, temper.listof(), temper.listof(), temper.listof(), temper.null, temper.null, temper.listof(), temper.listof(), temper.listof(), false, temper.listof());
end;
col = function(table__888, column__889)
  local b__891;
  b__891 = SqlBuilder();
  b__891:appendSafe(table__888.sqlValue);
  b__891:appendSafe('.');
  b__891:appendSafe(column__889.sqlValue);
  return b__891.accumulated;
end;
countAll = function()
  local b__893;
  b__893 = SqlBuilder();
  b__893:appendSafe('COUNT(*)');
  return b__893.accumulated;
end;
countCol = function(field__894)
  local b__896;
  b__896 = SqlBuilder();
  b__896:appendSafe('COUNT(');
  b__896:appendSafe(field__894.sqlValue);
  b__896:appendSafe(')');
  return b__896.accumulated;
end;
sumCol = function(field__897)
  local b__899;
  b__899 = SqlBuilder();
  b__899:appendSafe('SUM(');
  b__899:appendSafe(field__897.sqlValue);
  b__899:appendSafe(')');
  return b__899.accumulated;
end;
avgCol = function(field__900)
  local b__902;
  b__902 = SqlBuilder();
  b__902:appendSafe('AVG(');
  b__902:appendSafe(field__900.sqlValue);
  b__902:appendSafe(')');
  return b__902.accumulated;
end;
minCol = function(field__903)
  local b__905;
  b__905 = SqlBuilder();
  b__905:appendSafe('MIN(');
  b__905:appendSafe(field__903.sqlValue);
  b__905:appendSafe(')');
  return b__905.accumulated;
end;
maxCol = function(field__906)
  local b__908;
  b__908 = SqlBuilder();
  b__908:appendSafe('MAX(');
  b__908:appendSafe(field__906.sqlValue);
  b__908:appendSafe(')');
  return b__908.accumulated;
end;
unionSql = function(a__909, b__910)
  local sb__912;
  sb__912 = SqlBuilder();
  sb__912:appendSafe('(');
  sb__912:appendFragment(a__909:toSql());
  sb__912:appendSafe(') UNION (');
  sb__912:appendFragment(b__910:toSql());
  sb__912:appendSafe(')');
  return sb__912.accumulated;
end;
unionAllSql = function(a__913, b__914)
  local sb__916;
  sb__916 = SqlBuilder();
  sb__916:appendSafe('(');
  sb__916:appendFragment(a__913:toSql());
  sb__916:appendSafe(') UNION ALL (');
  sb__916:appendFragment(b__914:toSql());
  sb__916:appendSafe(')');
  return sb__916.accumulated;
end;
intersectSql = function(a__917, b__918)
  local sb__920;
  sb__920 = SqlBuilder();
  sb__920:appendSafe('(');
  sb__920:appendFragment(a__917:toSql());
  sb__920:appendSafe(') INTERSECT (');
  sb__920:appendFragment(b__918:toSql());
  sb__920:appendSafe(')');
  return sb__920.accumulated;
end;
exceptSql = function(a__921, b__922)
  local sb__924;
  sb__924 = SqlBuilder();
  sb__924:appendSafe('(');
  sb__924:appendFragment(a__921:toSql());
  sb__924:appendSafe(') EXCEPT (');
  sb__924:appendFragment(b__922:toSql());
  sb__924:appendSafe(')');
  return sb__924.accumulated;
end;
subquery = function(q__925, alias__926)
  local b__928;
  b__928 = SqlBuilder();
  b__928:appendSafe('(');
  b__928:appendFragment(q__925:toSql());
  b__928:appendSafe(') AS ');
  b__928:appendSafe(alias__926.sqlValue);
  return b__928.accumulated;
end;
existsSql = function(q__929)
  local b__931;
  b__931 = SqlBuilder();
  b__931:appendSafe('EXISTS (');
  b__931:appendFragment(q__929:toSql());
  b__931:appendSafe(')');
  return b__931.accumulated;
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
exports.unionSql = unionSql;
exports.unionAllSql = unionAllSql;
exports.intersectSql = intersectSql;
exports.exceptSql = exceptSql;
exports.subquery = subquery;
exports.existsSql = existsSql;
return exports;
