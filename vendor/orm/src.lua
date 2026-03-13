local temper = require('temper-core');
local ChangesetError, Changeset, ChangesetImpl__182, JoinType, InnerJoin, LeftJoin, RightJoin, FullJoin, CrossJoin, JoinClause, NullsPosition, NullsFirst, NullsLast, OrderClause, LockMode, ForUpdate, ForShare, WhereClause, AndCondition, OrCondition, Query, SetClause, UpdateQuery, DeleteQuery, SafeIdentifier, ValidatedIdentifier__256, FieldType, StringField, IntField, Int64Field, FloatField, BoolField, DateField, FieldDef, TableDef, SqlBuilder, SqlFragment, SqlPart, SqlSource, SqlBoolean, SqlDate, SqlFloat64, SqlInt32, SqlInt64, SqlString, changeset, isIdentStart__547, isIdentPart__548, safeIdentifier, deleteSql, from, col, countAll, countCol, sumCol, avgCol, minCol, maxCol, unionSql, unionAllSql, intersectSql, exceptSql, subquery, existsSql, update, deleteFrom, exports;
ChangesetError = temper.type('ChangesetError');
ChangesetError.constructor = function(this__291, field__554, message__555)
  this__291.field__551 = field__554;
  this__291.message__552 = message__555;
  return nil;
end;
ChangesetError.get.field = function(this__1601)
  return this__1601.field__551;
end;
ChangesetError.get.message = function(this__1604)
  return this__1604.message__552;
end;
Changeset = temper.type('Changeset');
Changeset.get.tableDef = function(this__169)
  temper.virtual();
end;
Changeset.get.changes = function(this__170)
  temper.virtual();
end;
Changeset.get.errors = function(this__171)
  temper.virtual();
end;
Changeset.get.isValid = function(this__172)
  temper.virtual();
end;
Changeset.methods.cast = function(this__173, allowedFields__565)
  temper.virtual();
end;
Changeset.methods.validateRequired = function(this__174, fields__568)
  temper.virtual();
end;
Changeset.methods.validateLength = function(this__175, field__571, min__572, max__573)
  temper.virtual();
end;
Changeset.methods.validateInt = function(this__176, field__576)
  temper.virtual();
end;
Changeset.methods.validateInt64 = function(this__177, field__579)
  temper.virtual();
end;
Changeset.methods.validateFloat = function(this__178, field__582)
  temper.virtual();
end;
Changeset.methods.validateBool = function(this__179, field__585)
  temper.virtual();
end;
Changeset.methods.toInsertSql = function(this__180)
  temper.virtual();
end;
Changeset.methods.toUpdateSql = function(this__181, id__590)
  temper.virtual();
end;
ChangesetImpl__182 = temper.type('ChangesetImpl__182', Changeset);
ChangesetImpl__182.get.tableDef = function(this__183)
  return this__183._tableDef__592;
end;
ChangesetImpl__182.get.changes = function(this__184)
  return this__184._changes__594;
end;
ChangesetImpl__182.get.errors = function(this__185)
  return this__185._errors__595;
end;
ChangesetImpl__182.get.isValid = function(this__186)
  return this__186._isValid__596;
end;
ChangesetImpl__182.methods.cast = function(this__187, allowedFields__606)
  local mb__608, fn__11363;
  mb__608 = temper.mapbuilder_constructor();
  fn__11363 = function(f__609)
    local t_0, t_1, val__610;
    t_1 = f__609.sqlValue;
    val__610 = temper.mapped_getor(this__187._params__593, t_1, '');
    if not temper.string_isempty(val__610) then
      t_0 = f__609.sqlValue;
      temper.mapbuilder_set(mb__608, t_0, val__610);
    end
    return nil;
  end;
  temper.list_foreach(allowedFields__606, fn__11363);
  return ChangesetImpl__182(this__187._tableDef__592, this__187._params__593, temper.mapped_tomap(mb__608), this__187._errors__595, this__187._isValid__596);
end;
ChangesetImpl__182.methods.validateRequired = function(this__188, fields__612)
  local return__324, t_2, t_3, t_4, t_5, eb__614, valid__615, fn__11352;
  ::continue_1::
  if not this__188._isValid__596 then
    return__324 = this__188;
    goto break_0;
  end
  eb__614 = temper.list_tolistbuilder(this__188._errors__595);
  valid__615 = true;
  fn__11352 = function(f__616)
    local t_6, t_7;
    t_7 = f__616.sqlValue;
    if not temper.mapped_has(this__188._changes__594, t_7) then
      t_6 = ChangesetError(f__616.sqlValue, 'is required');
      temper.listbuilder_add(eb__614, t_6);
      valid__615 = false;
    end
    return nil;
  end;
  temper.list_foreach(fields__612, fn__11352);
  t_3 = this__188._tableDef__592;
  t_4 = this__188._params__593;
  t_5 = this__188._changes__594;
  t_2 = temper.listbuilder_tolist(eb__614);
  return__324 = ChangesetImpl__182(t_3, t_4, t_5, t_2, valid__615);
  ::break_0::return return__324;
end;
ChangesetImpl__182.methods.validateLength = function(this__189, field__618, min__619, max__620)
  local return__325, t_8, t_9, t_10, t_11, t_12, t_13, val__622, len__623;
  ::continue_3::
  if not this__189._isValid__596 then
    return__325 = this__189;
    goto break_2;
  end
  t_8 = field__618.sqlValue;
  val__622 = temper.mapped_getor(this__189._changes__594, t_8, '');
  len__623 = temper.string_countbetween(val__622, 1.0, temper.string_end(val__622));
  if (len__623 < min__619) then
    t_10 = true;
  else
    t_10 = (len__623 > max__620);
  end
  if t_10 then
    local msg__624, eb__625;
    msg__624 = temper.concat('must be between ', temper.int32_tostring(min__619), ' and ', temper.int32_tostring(max__620), ' characters');
    eb__625 = temper.list_tolistbuilder(this__189._errors__595);
    temper.listbuilder_add(eb__625, ChangesetError(field__618.sqlValue, msg__624));
    t_11 = this__189._tableDef__592;
    t_12 = this__189._params__593;
    t_13 = this__189._changes__594;
    t_9 = temper.listbuilder_tolist(eb__625);
    return__325 = ChangesetImpl__182(t_11, t_12, t_13, t_9, false);
    goto break_2;
  end
  return__325 = this__189;
  ::break_2::return return__325;
end;
ChangesetImpl__182.methods.validateInt = function(this__190, field__627)
  local return__326, t_14, t_15, t_16, t_17, t_18, val__629, parseOk__630, local_19, local_20, local_21;
  ::continue_5::
  if not this__190._isValid__596 then
    return__326 = this__190;
    goto break_4;
  end
  t_14 = field__627.sqlValue;
  val__629 = temper.mapped_getor(this__190._changes__594, t_14, '');
  if temper.string_isempty(val__629) then
    return__326 = this__190;
    goto break_4;
  end
  local_19, local_20, local_21 = temper.pcall(function()
    temper.string_toint32(val__629);
    parseOk__630 = true;
  end);
  if local_19 then
  else
    parseOk__630 = false;
  end
  if not parseOk__630 then
    local eb__631;
    eb__631 = temper.list_tolistbuilder(this__190._errors__595);
    temper.listbuilder_add(eb__631, ChangesetError(field__627.sqlValue, 'must be an integer'));
    t_16 = this__190._tableDef__592;
    t_17 = this__190._params__593;
    t_18 = this__190._changes__594;
    t_15 = temper.listbuilder_tolist(eb__631);
    return__326 = ChangesetImpl__182(t_16, t_17, t_18, t_15, false);
    goto break_4;
  end
  return__326 = this__190;
  ::break_4::return return__326;
end;
ChangesetImpl__182.methods.validateInt64 = function(this__191, field__633)
  local return__327, t_23, t_24, t_25, t_26, t_27, val__635, parseOk__636, local_28, local_29, local_30;
  ::continue_7::
  if not this__191._isValid__596 then
    return__327 = this__191;
    goto break_6;
  end
  t_23 = field__633.sqlValue;
  val__635 = temper.mapped_getor(this__191._changes__594, t_23, '');
  if temper.string_isempty(val__635) then
    return__327 = this__191;
    goto break_6;
  end
  local_28, local_29, local_30 = temper.pcall(function()
    temper.string_toint64(val__635);
    parseOk__636 = true;
  end);
  if local_28 then
  else
    parseOk__636 = false;
  end
  if not parseOk__636 then
    local eb__637;
    eb__637 = temper.list_tolistbuilder(this__191._errors__595);
    temper.listbuilder_add(eb__637, ChangesetError(field__633.sqlValue, 'must be a 64-bit integer'));
    t_25 = this__191._tableDef__592;
    t_26 = this__191._params__593;
    t_27 = this__191._changes__594;
    t_24 = temper.listbuilder_tolist(eb__637);
    return__327 = ChangesetImpl__182(t_25, t_26, t_27, t_24, false);
    goto break_6;
  end
  return__327 = this__191;
  ::break_6::return return__327;
end;
ChangesetImpl__182.methods.validateFloat = function(this__192, field__639)
  local return__328, t_32, t_33, t_34, t_35, t_36, val__641, parseOk__642, local_37, local_38, local_39;
  ::continue_9::
  if not this__192._isValid__596 then
    return__328 = this__192;
    goto break_8;
  end
  t_32 = field__639.sqlValue;
  val__641 = temper.mapped_getor(this__192._changes__594, t_32, '');
  if temper.string_isempty(val__641) then
    return__328 = this__192;
    goto break_8;
  end
  local_37, local_38, local_39 = temper.pcall(function()
    temper.string_tofloat64(val__641);
    parseOk__642 = true;
  end);
  if local_37 then
  else
    parseOk__642 = false;
  end
  if not parseOk__642 then
    local eb__643;
    eb__643 = temper.list_tolistbuilder(this__192._errors__595);
    temper.listbuilder_add(eb__643, ChangesetError(field__639.sqlValue, 'must be a number'));
    t_34 = this__192._tableDef__592;
    t_35 = this__192._params__593;
    t_36 = this__192._changes__594;
    t_33 = temper.listbuilder_tolist(eb__643);
    return__328 = ChangesetImpl__182(t_34, t_35, t_36, t_33, false);
    goto break_8;
  end
  return__328 = this__192;
  ::break_8::return return__328;
end;
ChangesetImpl__182.methods.validateBool = function(this__193, field__645)
  local return__329, t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48, t_49, t_50, val__647, isTrue__648, isFalse__649;
  ::continue_11::
  if not this__193._isValid__596 then
    return__329 = this__193;
    goto break_10;
  end
  t_41 = field__645.sqlValue;
  val__647 = temper.mapped_getor(this__193._changes__594, t_41, '');
  if temper.string_isempty(val__647) then
    return__329 = this__193;
    goto break_10;
  end
  if temper.str_eq(val__647, 'true') then
    isTrue__648 = true;
  else
    if temper.str_eq(val__647, '1') then
      t_44 = true;
    else
      if temper.str_eq(val__647, 'yes') then
        t_43 = true;
      else
        t_43 = temper.str_eq(val__647, 'on');
      end
      t_44 = t_43;
    end
    isTrue__648 = t_44;
  end
  if temper.str_eq(val__647, 'false') then
    isFalse__649 = true;
  else
    if temper.str_eq(val__647, '0') then
      t_46 = true;
    else
      if temper.str_eq(val__647, 'no') then
        t_45 = true;
      else
        t_45 = temper.str_eq(val__647, 'off');
      end
      t_46 = t_45;
    end
    isFalse__649 = t_46;
  end
  if not isTrue__648 then
    t_47 = not isFalse__649;
  else
    t_47 = false;
  end
  if t_47 then
    local eb__650;
    eb__650 = temper.list_tolistbuilder(this__193._errors__595);
    temper.listbuilder_add(eb__650, ChangesetError(field__645.sqlValue, 'must be a boolean (true/false/1/0/yes/no/on/off)'));
    t_48 = this__193._tableDef__592;
    t_49 = this__193._params__593;
    t_50 = this__193._changes__594;
    t_42 = temper.listbuilder_tolist(eb__650);
    return__329 = ChangesetImpl__182(t_48, t_49, t_50, t_42, false);
    goto break_10;
  end
  return__329 = this__193;
  ::break_10::return return__329;
end;
ChangesetImpl__182.methods.parseBoolSqlPart = function(this__194, val__652)
  local return__330, t_51, t_52, t_53, t_54, t_55, t_56;
  ::continue_13::
  if temper.str_eq(val__652, 'true') then
    t_53 = true;
  else
    if temper.str_eq(val__652, '1') then
      t_52 = true;
    else
      if temper.str_eq(val__652, 'yes') then
        t_51 = true;
      else
        t_51 = temper.str_eq(val__652, 'on');
      end
      t_52 = t_51;
    end
    t_53 = t_52;
  end
  if t_53 then
    return__330 = SqlBoolean(true);
    goto break_12;
  end
  if temper.str_eq(val__652, 'false') then
    t_56 = true;
  else
    if temper.str_eq(val__652, '0') then
      t_55 = true;
    else
      if temper.str_eq(val__652, 'no') then
        t_54 = true;
      else
        t_54 = temper.str_eq(val__652, 'off');
      end
      t_55 = t_54;
    end
    t_56 = t_55;
  end
  if t_56 then
    return__330 = SqlBoolean(false);
    goto break_12;
  end
  temper.bubble();
  ::break_12::return return__330;
end;
ChangesetImpl__182.methods.valueToSqlPart = function(this__195, fieldDef__655, val__656)
  local return__331, t_57, t_58, t_59, t_60, ft__658;
  ::continue_15::ft__658 = fieldDef__655.fieldType;
  if temper.instance_of(ft__658, StringField) then
    return__331 = SqlString(val__656);
    goto break_14;
  end
  if temper.instance_of(ft__658, IntField) then
    t_57 = temper.string_toint32(val__656);
    return__331 = SqlInt32(t_57);
    goto break_14;
  end
  if temper.instance_of(ft__658, Int64Field) then
    t_58 = temper.string_toint64(val__656);
    return__331 = SqlInt64(t_58);
    goto break_14;
  end
  if temper.instance_of(ft__658, FloatField) then
    t_59 = temper.string_tofloat64(val__656);
    return__331 = SqlFloat64(t_59);
    goto break_14;
  end
  if temper.instance_of(ft__658, BoolField) then
    return__331 = this__195:parseBoolSqlPart(val__656);
    goto break_14;
  end
  if temper.instance_of(ft__658, DateField) then
    t_60 = temper.date_fromisostring(val__656);
    return__331 = SqlDate(t_60);
    goto break_14;
  end
  temper.bubble();
  ::break_14::return return__331;
end;
ChangesetImpl__182.methods.toInsertSql = function(this__196)
  local t_61, t_62, t_63, t_64, t_65, t_66, t_67, t_68, t_69, t_70, i__661, pairs__663, colNames__664, valParts__665, i__666, b__669, t_71, fn__11244, j__671;
  if not this__196._isValid__596 then
    temper.bubble();
  end
  i__661 = 0;
  while true do
    local f__662;
    t_61 = temper.list_length(this__196._tableDef__592.fields);
    if not (i__661 < t_61) then
      break;
    end
    f__662 = temper.list_get(this__196._tableDef__592.fields, i__661);
    if not f__662.nullable then
      t_62 = f__662.name.sqlValue;
      t_63 = temper.mapped_has(this__196._changes__594, t_62);
      t_68 = not t_63;
    else
      t_68 = false;
    end
    if t_68 then
      temper.bubble();
    end
    i__661 = temper.int32_add(i__661, 1);
  end
  pairs__663 = temper.mapped_tolist(this__196._changes__594);
  if (temper.list_length(pairs__663) == 0) then
    temper.bubble();
  end
  colNames__664 = temper.listbuilder_constructor();
  valParts__665 = temper.listbuilder_constructor();
  i__666 = 0;
  while true do
    local pair__667, fd__668;
    t_64 = temper.list_length(pairs__663);
    if not (i__666 < t_64) then
      break;
    end
    pair__667 = temper.list_get(pairs__663, i__666);
    t_65 = pair__667.key;
    t_69 = this__196._tableDef__592:field(t_65);
    fd__668 = t_69;
    temper.listbuilder_add(colNames__664, fd__668.name.sqlValue);
    t_66 = pair__667.value;
    t_70 = this__196:valueToSqlPart(fd__668, t_66);
    temper.listbuilder_add(valParts__665, t_70);
    i__666 = temper.int32_add(i__666, 1);
  end
  b__669 = SqlBuilder();
  b__669:appendSafe('INSERT INTO ');
  b__669:appendSafe(this__196._tableDef__592.tableName.sqlValue);
  b__669:appendSafe(' (');
  t_71 = temper.listbuilder_tolist(colNames__664);
  fn__11244 = function(c__670)
    return c__670;
  end;
  b__669:appendSafe(temper.listed_join(t_71, ', ', fn__11244));
  b__669:appendSafe(') VALUES (');
  b__669:appendPart(temper.listed_get(valParts__665, 0));
  j__671 = 1;
  while true do
    t_67 = temper.listbuilder_length(valParts__665);
    if not (j__671 < t_67) then
      break;
    end
    b__669:appendSafe(', ');
    b__669:appendPart(temper.listed_get(valParts__665, j__671));
    j__671 = temper.int32_add(j__671, 1);
  end
  b__669:appendSafe(')');
  return b__669.accumulated;
end;
ChangesetImpl__182.methods.toUpdateSql = function(this__197, id__673)
  local t_72, t_73, t_74, t_75, t_76, pairs__675, b__676, i__677;
  if not this__197._isValid__596 then
    temper.bubble();
  end
  pairs__675 = temper.mapped_tolist(this__197._changes__594);
  if (temper.list_length(pairs__675) == 0) then
    temper.bubble();
  end
  b__676 = SqlBuilder();
  b__676:appendSafe('UPDATE ');
  b__676:appendSafe(this__197._tableDef__592.tableName.sqlValue);
  b__676:appendSafe(' SET ');
  i__677 = 0;
  while true do
    local pair__678, fd__679;
    t_72 = temper.list_length(pairs__675);
    if not (i__677 < t_72) then
      break;
    end
    if (i__677 > 0) then
      b__676:appendSafe(', ');
    end
    pair__678 = temper.list_get(pairs__675, i__677);
    t_73 = pair__678.key;
    t_75 = this__197._tableDef__592:field(t_73);
    fd__679 = t_75;
    b__676:appendSafe(fd__679.name.sqlValue);
    b__676:appendSafe(' = ');
    t_74 = pair__678.value;
    t_76 = this__197:valueToSqlPart(fd__679, t_74);
    b__676:appendPart(t_76);
    i__677 = temper.int32_add(i__677, 1);
  end
  b__676:appendSafe(' WHERE id = ');
  b__676:appendInt32(id__673);
  return b__676.accumulated;
end;
ChangesetImpl__182.constructor = function(this__314, _tableDef__681, _params__682, _changes__683, _errors__684, _isValid__685)
  this__314._tableDef__592 = _tableDef__681;
  this__314._params__593 = _params__682;
  this__314._changes__594 = _changes__683;
  this__314._errors__595 = _errors__684;
  this__314._isValid__596 = _isValid__685;
  return nil;
end;
JoinType = temper.type('JoinType');
JoinType.methods.keyword = function(this__198)
  temper.virtual();
end;
InnerJoin = temper.type('InnerJoin', JoinType);
InnerJoin.methods.keyword = function(this__199)
  return 'INNER JOIN';
end;
InnerJoin.constructor = function(this__339)
  return nil;
end;
LeftJoin = temper.type('LeftJoin', JoinType);
LeftJoin.methods.keyword = function(this__200)
  return 'LEFT JOIN';
end;
LeftJoin.constructor = function(this__342)
  return nil;
end;
RightJoin = temper.type('RightJoin', JoinType);
RightJoin.methods.keyword = function(this__201)
  return 'RIGHT JOIN';
end;
RightJoin.constructor = function(this__345)
  return nil;
end;
FullJoin = temper.type('FullJoin', JoinType);
FullJoin.methods.keyword = function(this__202)
  return 'FULL OUTER JOIN';
end;
FullJoin.constructor = function(this__348)
  return nil;
end;
CrossJoin = temper.type('CrossJoin', JoinType);
CrossJoin.methods.keyword = function(this__203)
  return 'CROSS JOIN';
end;
CrossJoin.constructor = function(this__351)
  return nil;
end;
JoinClause = temper.type('JoinClause');
JoinClause.constructor = function(this__354, joinType__801, table__802, onCondition__803)
  if (onCondition__803 == nil) then
    onCondition__803 = temper.null;
  end
  this__354.joinType__797 = joinType__801;
  this__354.table__798 = table__802;
  this__354.onCondition__799 = onCondition__803;
  return nil;
end;
JoinClause.get.joinType = function(this__1669)
  return this__1669.joinType__797;
end;
JoinClause.get.table = function(this__1672)
  return this__1672.table__798;
end;
JoinClause.get.onCondition = function(this__1675)
  return this__1675.onCondition__799;
end;
NullsPosition = temper.type('NullsPosition');
NullsPosition.methods.keyword = function(this__204)
  temper.virtual();
end;
NullsFirst = temper.type('NullsFirst', NullsPosition);
NullsFirst.methods.keyword = function(this__205)
  return ' NULLS FIRST';
end;
NullsFirst.constructor = function(this__358)
  return nil;
end;
NullsLast = temper.type('NullsLast', NullsPosition);
NullsLast.methods.keyword = function(this__206)
  return ' NULLS LAST';
end;
NullsLast.constructor = function(this__361)
  return nil;
end;
OrderClause = temper.type('OrderClause');
OrderClause.constructor = function(this__364, field__816, ascending__817, nullsPos__818)
  if (nullsPos__818 == nil) then
    nullsPos__818 = temper.null;
  end
  this__364.field__812 = field__816;
  this__364.ascending__813 = ascending__817;
  this__364.nullsPos__814 = nullsPos__818;
  return nil;
end;
OrderClause.get.field = function(this__1678)
  return this__1678.field__812;
end;
OrderClause.get.ascending = function(this__1681)
  return this__1681.ascending__813;
end;
OrderClause.get.nullsPos = function(this__1684)
  return this__1684.nullsPos__814;
end;
LockMode = temper.type('LockMode');
LockMode.methods.keyword = function(this__207)
  temper.virtual();
end;
ForUpdate = temper.type('ForUpdate', LockMode);
ForUpdate.methods.keyword = function(this__208)
  return ' FOR UPDATE';
end;
ForUpdate.constructor = function(this__368)
  return nil;
end;
ForShare = temper.type('ForShare', LockMode);
ForShare.methods.keyword = function(this__209)
  return ' FOR SHARE';
end;
ForShare.constructor = function(this__371)
  return nil;
end;
WhereClause = temper.type('WhereClause');
WhereClause.get.condition = function(this__210)
  temper.virtual();
end;
WhereClause.methods.keyword = function(this__211)
  temper.virtual();
end;
AndCondition = temper.type('AndCondition', WhereClause);
AndCondition.get.condition = function(this__212)
  return this__212._condition__831;
end;
AndCondition.methods.keyword = function(this__213)
  return 'AND';
end;
AndCondition.constructor = function(this__378, _condition__837)
  this__378._condition__831 = _condition__837;
  return nil;
end;
OrCondition = temper.type('OrCondition', WhereClause);
OrCondition.get.condition = function(this__214)
  return this__214._condition__838;
end;
OrCondition.methods.keyword = function(this__215)
  return 'OR';
end;
OrCondition.constructor = function(this__383, _condition__844)
  this__383._condition__838 = _condition__844;
  return nil;
end;
Query = temper.type('Query');
Query.methods.where = function(this__216, condition__858)
  local nb__860;
  nb__860 = temper.list_tolistbuilder(this__216.conditions__846);
  temper.listbuilder_add(nb__860, AndCondition(condition__858));
  return Query(this__216.tableName__845, temper.listbuilder_tolist(nb__860), this__216.selectedFields__847, this__216.orderClauses__848, this__216.limitVal__849, this__216.offsetVal__850, this__216.joinClauses__851, this__216.groupByFields__852, this__216.havingConditions__853, this__216.isDistinct__854, this__216.selectExprs__855, this__216.lockMode__856);
end;
Query.methods.orWhere = function(this__217, condition__862)
  local nb__864;
  nb__864 = temper.list_tolistbuilder(this__217.conditions__846);
  temper.listbuilder_add(nb__864, OrCondition(condition__862));
  return Query(this__217.tableName__845, temper.listbuilder_tolist(nb__864), this__217.selectedFields__847, this__217.orderClauses__848, this__217.limitVal__849, this__217.offsetVal__850, this__217.joinClauses__851, this__217.groupByFields__852, this__217.havingConditions__853, this__217.isDistinct__854, this__217.selectExprs__855, this__217.lockMode__856);
end;
Query.methods.whereNull = function(this__218, field__866)
  local b__868, t_77;
  b__868 = SqlBuilder();
  b__868:appendSafe(field__866.sqlValue);
  b__868:appendSafe(' IS NULL');
  t_77 = b__868.accumulated;
  return this__218:where(t_77);
end;
Query.methods.whereNotNull = function(this__219, field__870)
  local b__872, t_78;
  b__872 = SqlBuilder();
  b__872:appendSafe(field__870.sqlValue);
  b__872:appendSafe(' IS NOT NULL');
  t_78 = b__872.accumulated;
  return this__219:where(t_78);
end;
Query.methods.whereIn = function(this__220, field__874, values__875)
  local return__403, t_79, t_80, t_81, b__878, i__879;
  ::continue_17::
  if temper.listed_isempty(values__875) then
    local b__877;
    b__877 = SqlBuilder();
    b__877:appendSafe('1 = 0');
    t_79 = b__877.accumulated;
    return__403 = this__220:where(t_79);
    goto break_16;
  end
  b__878 = SqlBuilder();
  b__878:appendSafe(field__874.sqlValue);
  b__878:appendSafe(' IN (');
  b__878:appendPart(temper.list_get(values__875, 0));
  i__879 = 1;
  while true do
    t_80 = temper.list_length(values__875);
    if not (i__879 < t_80) then
      break;
    end
    b__878:appendSafe(', ');
    b__878:appendPart(temper.list_get(values__875, i__879));
    i__879 = temper.int32_add(i__879, 1);
  end
  b__878:appendSafe(')');
  t_81 = b__878.accumulated;
  return__403 = this__220:where(t_81);
  ::break_16::return return__403;
end;
Query.methods.whereInSubquery = function(this__221, field__881, sub__882)
  local b__884, t_82;
  b__884 = SqlBuilder();
  b__884:appendSafe(field__881.sqlValue);
  b__884:appendSafe(' IN (');
  b__884:appendFragment(sub__882:toSql());
  b__884:appendSafe(')');
  t_82 = b__884.accumulated;
  return this__221:where(t_82);
end;
Query.methods.whereNot = function(this__222, condition__886)
  local b__888, t_83;
  b__888 = SqlBuilder();
  b__888:appendSafe('NOT (');
  b__888:appendFragment(condition__886);
  b__888:appendSafe(')');
  t_83 = b__888.accumulated;
  return this__222:where(t_83);
end;
Query.methods.whereBetween = function(this__223, field__890, low__891, high__892)
  local b__894, t_84;
  b__894 = SqlBuilder();
  b__894:appendSafe(field__890.sqlValue);
  b__894:appendSafe(' BETWEEN ');
  b__894:appendPart(low__891);
  b__894:appendSafe(' AND ');
  b__894:appendPart(high__892);
  t_84 = b__894.accumulated;
  return this__223:where(t_84);
end;
Query.methods.whereLike = function(this__224, field__896, pattern__897)
  local b__899, t_85;
  b__899 = SqlBuilder();
  b__899:appendSafe(field__896.sqlValue);
  b__899:appendSafe(' LIKE ');
  b__899:appendString(pattern__897);
  t_85 = b__899.accumulated;
  return this__224:where(t_85);
end;
Query.methods.whereILike = function(this__225, field__901, pattern__902)
  local b__904, t_86;
  b__904 = SqlBuilder();
  b__904:appendSafe(field__901.sqlValue);
  b__904:appendSafe(' ILIKE ');
  b__904:appendString(pattern__902);
  t_86 = b__904.accumulated;
  return this__225:where(t_86);
end;
Query.methods.select = function(this__226, fields__906)
  return Query(this__226.tableName__845, this__226.conditions__846, fields__906, this__226.orderClauses__848, this__226.limitVal__849, this__226.offsetVal__850, this__226.joinClauses__851, this__226.groupByFields__852, this__226.havingConditions__853, this__226.isDistinct__854, this__226.selectExprs__855, this__226.lockMode__856);
end;
Query.methods.selectExpr = function(this__227, exprs__909)
  return Query(this__227.tableName__845, this__227.conditions__846, this__227.selectedFields__847, this__227.orderClauses__848, this__227.limitVal__849, this__227.offsetVal__850, this__227.joinClauses__851, this__227.groupByFields__852, this__227.havingConditions__853, this__227.isDistinct__854, exprs__909, this__227.lockMode__856);
end;
Query.methods.orderBy = function(this__228, field__912, ascending__913)
  local nb__915;
  nb__915 = temper.list_tolistbuilder(this__228.orderClauses__848);
  temper.listbuilder_add(nb__915, OrderClause(field__912, ascending__913, temper.null));
  return Query(this__228.tableName__845, this__228.conditions__846, this__228.selectedFields__847, temper.listbuilder_tolist(nb__915), this__228.limitVal__849, this__228.offsetVal__850, this__228.joinClauses__851, this__228.groupByFields__852, this__228.havingConditions__853, this__228.isDistinct__854, this__228.selectExprs__855, this__228.lockMode__856);
end;
Query.methods.orderByNulls = function(this__229, field__917, ascending__918, nulls__919)
  local nb__921;
  nb__921 = temper.list_tolistbuilder(this__229.orderClauses__848);
  temper.listbuilder_add(nb__921, OrderClause(field__917, ascending__918, nulls__919));
  return Query(this__229.tableName__845, this__229.conditions__846, this__229.selectedFields__847, temper.listbuilder_tolist(nb__921), this__229.limitVal__849, this__229.offsetVal__850, this__229.joinClauses__851, this__229.groupByFields__852, this__229.havingConditions__853, this__229.isDistinct__854, this__229.selectExprs__855, this__229.lockMode__856);
end;
Query.methods.limit = function(this__230, n__923)
  if (n__923 < 0) then
    temper.bubble();
  end
  return Query(this__230.tableName__845, this__230.conditions__846, this__230.selectedFields__847, this__230.orderClauses__848, n__923, this__230.offsetVal__850, this__230.joinClauses__851, this__230.groupByFields__852, this__230.havingConditions__853, this__230.isDistinct__854, this__230.selectExprs__855, this__230.lockMode__856);
end;
Query.methods.offset = function(this__231, n__926)
  if (n__926 < 0) then
    temper.bubble();
  end
  return Query(this__231.tableName__845, this__231.conditions__846, this__231.selectedFields__847, this__231.orderClauses__848, this__231.limitVal__849, n__926, this__231.joinClauses__851, this__231.groupByFields__852, this__231.havingConditions__853, this__231.isDistinct__854, this__231.selectExprs__855, this__231.lockMode__856);
end;
Query.methods.join = function(this__232, joinType__929, table__930, onCondition__931)
  local nb__933;
  nb__933 = temper.list_tolistbuilder(this__232.joinClauses__851);
  temper.listbuilder_add(nb__933, JoinClause(joinType__929, table__930, onCondition__931));
  return Query(this__232.tableName__845, this__232.conditions__846, this__232.selectedFields__847, this__232.orderClauses__848, this__232.limitVal__849, this__232.offsetVal__850, temper.listbuilder_tolist(nb__933), this__232.groupByFields__852, this__232.havingConditions__853, this__232.isDistinct__854, this__232.selectExprs__855, this__232.lockMode__856);
end;
Query.methods.innerJoin = function(this__233, table__935, onCondition__936)
  local t_87;
  t_87 = InnerJoin();
  return this__233:join(t_87, table__935, onCondition__936);
end;
Query.methods.leftJoin = function(this__234, table__939, onCondition__940)
  local t_88;
  t_88 = LeftJoin();
  return this__234:join(t_88, table__939, onCondition__940);
end;
Query.methods.rightJoin = function(this__235, table__943, onCondition__944)
  local t_89;
  t_89 = RightJoin();
  return this__235:join(t_89, table__943, onCondition__944);
end;
Query.methods.fullJoin = function(this__236, table__947, onCondition__948)
  local t_90;
  t_90 = FullJoin();
  return this__236:join(t_90, table__947, onCondition__948);
end;
Query.methods.crossJoin = function(this__237, table__951)
  local nb__953;
  nb__953 = temper.list_tolistbuilder(this__237.joinClauses__851);
  temper.listbuilder_add(nb__953, JoinClause(CrossJoin(), table__951, temper.null));
  return Query(this__237.tableName__845, this__237.conditions__846, this__237.selectedFields__847, this__237.orderClauses__848, this__237.limitVal__849, this__237.offsetVal__850, temper.listbuilder_tolist(nb__953), this__237.groupByFields__852, this__237.havingConditions__853, this__237.isDistinct__854, this__237.selectExprs__855, this__237.lockMode__856);
end;
Query.methods.groupBy = function(this__238, field__955)
  local nb__957;
  nb__957 = temper.list_tolistbuilder(this__238.groupByFields__852);
  temper.listbuilder_add(nb__957, field__955);
  return Query(this__238.tableName__845, this__238.conditions__846, this__238.selectedFields__847, this__238.orderClauses__848, this__238.limitVal__849, this__238.offsetVal__850, this__238.joinClauses__851, temper.listbuilder_tolist(nb__957), this__238.havingConditions__853, this__238.isDistinct__854, this__238.selectExprs__855, this__238.lockMode__856);
end;
Query.methods.having = function(this__239, condition__959)
  local nb__961;
  nb__961 = temper.list_tolistbuilder(this__239.havingConditions__853);
  temper.listbuilder_add(nb__961, AndCondition(condition__959));
  return Query(this__239.tableName__845, this__239.conditions__846, this__239.selectedFields__847, this__239.orderClauses__848, this__239.limitVal__849, this__239.offsetVal__850, this__239.joinClauses__851, this__239.groupByFields__852, temper.listbuilder_tolist(nb__961), this__239.isDistinct__854, this__239.selectExprs__855, this__239.lockMode__856);
end;
Query.methods.orHaving = function(this__240, condition__963)
  local nb__965;
  nb__965 = temper.list_tolistbuilder(this__240.havingConditions__853);
  temper.listbuilder_add(nb__965, OrCondition(condition__963));
  return Query(this__240.tableName__845, this__240.conditions__846, this__240.selectedFields__847, this__240.orderClauses__848, this__240.limitVal__849, this__240.offsetVal__850, this__240.joinClauses__851, this__240.groupByFields__852, temper.listbuilder_tolist(nb__965), this__240.isDistinct__854, this__240.selectExprs__855, this__240.lockMode__856);
end;
Query.methods.distinct = function(this__241)
  return Query(this__241.tableName__845, this__241.conditions__846, this__241.selectedFields__847, this__241.orderClauses__848, this__241.limitVal__849, this__241.offsetVal__850, this__241.joinClauses__851, this__241.groupByFields__852, this__241.havingConditions__853, true, this__241.selectExprs__855, this__241.lockMode__856);
end;
Query.methods.lock = function(this__242, mode__969)
  return Query(this__242.tableName__845, this__242.conditions__846, this__242.selectedFields__847, this__242.orderClauses__848, this__242.limitVal__849, this__242.offsetVal__850, this__242.joinClauses__851, this__242.groupByFields__852, this__242.havingConditions__853, this__242.isDistinct__854, this__242.selectExprs__855, mode__969);
end;
Query.methods.toSql = function(this__243)
  local t_91, t_92, t_93, b__973, fn__10608, lv__984, ov__985, lm__986;
  b__973 = SqlBuilder();
  if this__243.isDistinct__854 then
    b__973:appendSafe('SELECT DISTINCT ');
  else
    b__973:appendSafe('SELECT ');
  end
  if not temper.listed_isempty(this__243.selectExprs__855) then
    local i__974;
    b__973:appendFragment(temper.list_get(this__243.selectExprs__855, 0));
    i__974 = 1;
    while true do
      t_91 = temper.list_length(this__243.selectExprs__855);
      if not (i__974 < t_91) then
        break;
      end
      b__973:appendSafe(', ');
      b__973:appendFragment(temper.list_get(this__243.selectExprs__855, i__974));
      i__974 = temper.int32_add(i__974, 1);
    end
  elseif temper.listed_isempty(this__243.selectedFields__847) then
    b__973:appendSafe('*');
  else
    local fn__10609;
    fn__10609 = function(f__975)
      return f__975.sqlValue;
    end;
    b__973:appendSafe(temper.listed_join(this__243.selectedFields__847, ', ', fn__10609));
  end
  b__973:appendSafe(' FROM ');
  b__973:appendSafe(this__243.tableName__845.sqlValue);
  fn__10608 = function(jc__976)
    local t_94, t_95, oc__977;
    b__973:appendSafe(' ');
    t_94 = jc__976.joinType:keyword();
    b__973:appendSafe(t_94);
    b__973:appendSafe(' ');
    t_95 = jc__976.table.sqlValue;
    b__973:appendSafe(t_95);
    oc__977 = jc__976.onCondition;
    if not temper.is_null(oc__977) then
      local oc_96;
      oc_96 = oc__977;
      b__973:appendSafe(' ON ');
      b__973:appendFragment(oc_96);
    end
    return nil;
  end;
  temper.list_foreach(this__243.joinClauses__851, fn__10608);
  if not temper.listed_isempty(this__243.conditions__846) then
    local i__978;
    b__973:appendSafe(' WHERE ');
    b__973:appendFragment((temper.list_get(this__243.conditions__846, 0)).condition);
    i__978 = 1;
    while true do
      t_92 = temper.list_length(this__243.conditions__846);
      if not (i__978 < t_92) then
        break;
      end
      b__973:appendSafe(' ');
      b__973:appendSafe(temper.list_get(this__243.conditions__846, i__978):keyword());
      b__973:appendSafe(' ');
      b__973:appendFragment((temper.list_get(this__243.conditions__846, i__978)).condition);
      i__978 = temper.int32_add(i__978, 1);
    end
  end
  if not temper.listed_isempty(this__243.groupByFields__852) then
    local fn__10607;
    b__973:appendSafe(' GROUP BY ');
    fn__10607 = function(f__979)
      return f__979.sqlValue;
    end;
    b__973:appendSafe(temper.listed_join(this__243.groupByFields__852, ', ', fn__10607));
  end
  if not temper.listed_isempty(this__243.havingConditions__853) then
    local i__980;
    b__973:appendSafe(' HAVING ');
    b__973:appendFragment((temper.list_get(this__243.havingConditions__853, 0)).condition);
    i__980 = 1;
    while true do
      t_93 = temper.list_length(this__243.havingConditions__853);
      if not (i__980 < t_93) then
        break;
      end
      b__973:appendSafe(' ');
      b__973:appendSafe(temper.list_get(this__243.havingConditions__853, i__980):keyword());
      b__973:appendSafe(' ');
      b__973:appendFragment((temper.list_get(this__243.havingConditions__853, i__980)).condition);
      i__980 = temper.int32_add(i__980, 1);
    end
  end
  if not temper.listed_isempty(this__243.orderClauses__848) then
    local first__981, fn__10606;
    b__973:appendSafe(' ORDER BY ');
    first__981 = true;
    fn__10606 = function(orc__982)
      local t_97, t_98, t_99, np__983;
      if not first__981 then
        b__973:appendSafe(', ');
      end
      first__981 = false;
      t_99 = orc__982.field.sqlValue;
      b__973:appendSafe(t_99);
      if orc__982.ascending then
        t_98 = ' ASC';
      else
        t_98 = ' DESC';
      end
      b__973:appendSafe(t_98);
      np__983 = orc__982.nullsPos;
      if not temper.is_null(np__983) then
        t_97 = np__983:keyword();
        b__973:appendSafe(t_97);
      end
      return nil;
    end;
    temper.list_foreach(this__243.orderClauses__848, fn__10606);
  end
  lv__984 = this__243.limitVal__849;
  if not temper.is_null(lv__984) then
    local lv_100;
    lv_100 = lv__984;
    b__973:appendSafe(' LIMIT ');
    b__973:appendInt32(lv_100);
  end
  ov__985 = this__243.offsetVal__850;
  if not temper.is_null(ov__985) then
    local ov_101;
    ov_101 = ov__985;
    b__973:appendSafe(' OFFSET ');
    b__973:appendInt32(ov_101);
  end
  lm__986 = this__243.lockMode__856;
  if not temper.is_null(lm__986) then
    b__973:appendSafe(lm__986:keyword());
  end
  return b__973.accumulated;
end;
Query.methods.countSql = function(this__244)
  local t_102, t_103, b__989, fn__10543;
  b__989 = SqlBuilder();
  b__989:appendSafe('SELECT COUNT(*) FROM ');
  b__989:appendSafe(this__244.tableName__845.sqlValue);
  fn__10543 = function(jc__990)
    local t_104, t_105, oc2__991;
    b__989:appendSafe(' ');
    t_104 = jc__990.joinType:keyword();
    b__989:appendSafe(t_104);
    b__989:appendSafe(' ');
    t_105 = jc__990.table.sqlValue;
    b__989:appendSafe(t_105);
    oc2__991 = jc__990.onCondition;
    if not temper.is_null(oc2__991) then
      local oc2_106;
      oc2_106 = oc2__991;
      b__989:appendSafe(' ON ');
      b__989:appendFragment(oc2_106);
    end
    return nil;
  end;
  temper.list_foreach(this__244.joinClauses__851, fn__10543);
  if not temper.listed_isempty(this__244.conditions__846) then
    local i__992;
    b__989:appendSafe(' WHERE ');
    b__989:appendFragment((temper.list_get(this__244.conditions__846, 0)).condition);
    i__992 = 1;
    while true do
      t_102 = temper.list_length(this__244.conditions__846);
      if not (i__992 < t_102) then
        break;
      end
      b__989:appendSafe(' ');
      b__989:appendSafe(temper.list_get(this__244.conditions__846, i__992):keyword());
      b__989:appendSafe(' ');
      b__989:appendFragment((temper.list_get(this__244.conditions__846, i__992)).condition);
      i__992 = temper.int32_add(i__992, 1);
    end
  end
  if not temper.listed_isempty(this__244.groupByFields__852) then
    local fn__10542;
    b__989:appendSafe(' GROUP BY ');
    fn__10542 = function(f__993)
      return f__993.sqlValue;
    end;
    b__989:appendSafe(temper.listed_join(this__244.groupByFields__852, ', ', fn__10542));
  end
  if not temper.listed_isempty(this__244.havingConditions__853) then
    local i__994;
    b__989:appendSafe(' HAVING ');
    b__989:appendFragment((temper.list_get(this__244.havingConditions__853, 0)).condition);
    i__994 = 1;
    while true do
      t_103 = temper.list_length(this__244.havingConditions__853);
      if not (i__994 < t_103) then
        break;
      end
      b__989:appendSafe(' ');
      b__989:appendSafe(temper.list_get(this__244.havingConditions__853, i__994):keyword());
      b__989:appendSafe(' ');
      b__989:appendFragment((temper.list_get(this__244.havingConditions__853, i__994)).condition);
      i__994 = temper.int32_add(i__994, 1);
    end
  end
  return b__989.accumulated;
end;
Query.methods.safeToSql = function(this__245, defaultLimit__996)
  local return__428, t_107;
  if (defaultLimit__996 < 0) then
    temper.bubble();
  end
  if not temper.is_null(this__245.limitVal__849) then
    return__428 = this__245:toSql();
  else
    t_107 = this__245:limit(defaultLimit__996);
    return__428 = t_107:toSql();
  end
  return return__428;
end;
Query.constructor = function(this__387, tableName__999, conditions__1000, selectedFields__1001, orderClauses__1002, limitVal__1003, offsetVal__1004, joinClauses__1005, groupByFields__1006, havingConditions__1007, isDistinct__1008, selectExprs__1009, lockMode__1010)
  if (limitVal__1003 == nil) then
    limitVal__1003 = temper.null;
  end
  if (offsetVal__1004 == nil) then
    offsetVal__1004 = temper.null;
  end
  if (lockMode__1010 == nil) then
    lockMode__1010 = temper.null;
  end
  this__387.tableName__845 = tableName__999;
  this__387.conditions__846 = conditions__1000;
  this__387.selectedFields__847 = selectedFields__1001;
  this__387.orderClauses__848 = orderClauses__1002;
  this__387.limitVal__849 = limitVal__1003;
  this__387.offsetVal__850 = offsetVal__1004;
  this__387.joinClauses__851 = joinClauses__1005;
  this__387.groupByFields__852 = groupByFields__1006;
  this__387.havingConditions__853 = havingConditions__1007;
  this__387.isDistinct__854 = isDistinct__1008;
  this__387.selectExprs__855 = selectExprs__1009;
  this__387.lockMode__856 = lockMode__1010;
  return nil;
end;
Query.get.tableName = function(this__1687)
  return this__1687.tableName__845;
end;
Query.get.conditions = function(this__1690)
  return this__1690.conditions__846;
end;
Query.get.selectedFields = function(this__1693)
  return this__1693.selectedFields__847;
end;
Query.get.orderClauses = function(this__1696)
  return this__1696.orderClauses__848;
end;
Query.get.limitVal = function(this__1699)
  return this__1699.limitVal__849;
end;
Query.get.offsetVal = function(this__1702)
  return this__1702.offsetVal__850;
end;
Query.get.joinClauses = function(this__1705)
  return this__1705.joinClauses__851;
end;
Query.get.groupByFields = function(this__1708)
  return this__1708.groupByFields__852;
end;
Query.get.havingConditions = function(this__1711)
  return this__1711.havingConditions__853;
end;
Query.get.isDistinct = function(this__1714)
  return this__1714.isDistinct__854;
end;
Query.get.selectExprs = function(this__1717)
  return this__1717.selectExprs__855;
end;
Query.get.lockMode = function(this__1720)
  return this__1720.lockMode__856;
end;
SetClause = temper.type('SetClause');
SetClause.constructor = function(this__443, field__1060, value__1061)
  this__443.field__1057 = field__1060;
  this__443.value__1058 = value__1061;
  return nil;
end;
SetClause.get.field = function(this__1723)
  return this__1723.field__1057;
end;
SetClause.get.value = function(this__1726)
  return this__1726.value__1058;
end;
UpdateQuery = temper.type('UpdateQuery');
UpdateQuery.methods.set = function(this__246, field__1067, value__1068)
  local nb__1070;
  nb__1070 = temper.list_tolistbuilder(this__246.setClauses__1063);
  temper.listbuilder_add(nb__1070, SetClause(field__1067, value__1068));
  return UpdateQuery(this__246.tableName__1062, temper.listbuilder_tolist(nb__1070), this__246.conditions__1064, this__246.limitVal__1065);
end;
UpdateQuery.methods.where = function(this__247, condition__1072)
  local nb__1074;
  nb__1074 = temper.list_tolistbuilder(this__247.conditions__1064);
  temper.listbuilder_add(nb__1074, AndCondition(condition__1072));
  return UpdateQuery(this__247.tableName__1062, this__247.setClauses__1063, temper.listbuilder_tolist(nb__1074), this__247.limitVal__1065);
end;
UpdateQuery.methods.orWhere = function(this__248, condition__1076)
  local nb__1078;
  nb__1078 = temper.list_tolistbuilder(this__248.conditions__1064);
  temper.listbuilder_add(nb__1078, OrCondition(condition__1076));
  return UpdateQuery(this__248.tableName__1062, this__248.setClauses__1063, temper.listbuilder_tolist(nb__1078), this__248.limitVal__1065);
end;
UpdateQuery.methods.limit = function(this__249, n__1080)
  if (n__1080 < 0) then
    temper.bubble();
  end
  return UpdateQuery(this__249.tableName__1062, this__249.setClauses__1063, this__249.conditions__1064, n__1080);
end;
UpdateQuery.methods.toSql = function(this__250)
  local t_108, t_109, b__1084, i__1085, i__1086, lv__1087;
  if temper.listed_isempty(this__250.conditions__1064) then
    temper.bubble();
  end
  if temper.listed_isempty(this__250.setClauses__1063) then
    temper.bubble();
  end
  b__1084 = SqlBuilder();
  b__1084:appendSafe('UPDATE ');
  b__1084:appendSafe(this__250.tableName__1062.sqlValue);
  b__1084:appendSafe(' SET ');
  b__1084:appendSafe((temper.list_get(this__250.setClauses__1063, 0)).field.sqlValue);
  b__1084:appendSafe(' = ');
  b__1084:appendPart((temper.list_get(this__250.setClauses__1063, 0)).value);
  i__1085 = 1;
  while true do
    t_108 = temper.list_length(this__250.setClauses__1063);
    if not (i__1085 < t_108) then
      break;
    end
    b__1084:appendSafe(', ');
    b__1084:appendSafe((temper.list_get(this__250.setClauses__1063, i__1085)).field.sqlValue);
    b__1084:appendSafe(' = ');
    b__1084:appendPart((temper.list_get(this__250.setClauses__1063, i__1085)).value);
    i__1085 = temper.int32_add(i__1085, 1);
  end
  b__1084:appendSafe(' WHERE ');
  b__1084:appendFragment((temper.list_get(this__250.conditions__1064, 0)).condition);
  i__1086 = 1;
  while true do
    t_109 = temper.list_length(this__250.conditions__1064);
    if not (i__1086 < t_109) then
      break;
    end
    b__1084:appendSafe(' ');
    b__1084:appendSafe(temper.list_get(this__250.conditions__1064, i__1086):keyword());
    b__1084:appendSafe(' ');
    b__1084:appendFragment((temper.list_get(this__250.conditions__1064, i__1086)).condition);
    i__1086 = temper.int32_add(i__1086, 1);
  end
  lv__1087 = this__250.limitVal__1065;
  if not temper.is_null(lv__1087) then
    local lv_110;
    lv_110 = lv__1087;
    b__1084:appendSafe(' LIMIT ');
    b__1084:appendInt32(lv_110);
  end
  return b__1084.accumulated;
end;
UpdateQuery.constructor = function(this__445, tableName__1089, setClauses__1090, conditions__1091, limitVal__1092)
  if (limitVal__1092 == nil) then
    limitVal__1092 = temper.null;
  end
  this__445.tableName__1062 = tableName__1089;
  this__445.setClauses__1063 = setClauses__1090;
  this__445.conditions__1064 = conditions__1091;
  this__445.limitVal__1065 = limitVal__1092;
  return nil;
end;
UpdateQuery.get.tableName = function(this__1729)
  return this__1729.tableName__1062;
end;
UpdateQuery.get.setClauses = function(this__1732)
  return this__1732.setClauses__1063;
end;
UpdateQuery.get.conditions = function(this__1735)
  return this__1735.conditions__1064;
end;
UpdateQuery.get.limitVal = function(this__1738)
  return this__1738.limitVal__1065;
end;
DeleteQuery = temper.type('DeleteQuery');
DeleteQuery.methods.where = function(this__251, condition__1097)
  local nb__1099;
  nb__1099 = temper.list_tolistbuilder(this__251.conditions__1094);
  temper.listbuilder_add(nb__1099, AndCondition(condition__1097));
  return DeleteQuery(this__251.tableName__1093, temper.listbuilder_tolist(nb__1099), this__251.limitVal__1095);
end;
DeleteQuery.methods.orWhere = function(this__252, condition__1101)
  local nb__1103;
  nb__1103 = temper.list_tolistbuilder(this__252.conditions__1094);
  temper.listbuilder_add(nb__1103, OrCondition(condition__1101));
  return DeleteQuery(this__252.tableName__1093, temper.listbuilder_tolist(nb__1103), this__252.limitVal__1095);
end;
DeleteQuery.methods.limit = function(this__253, n__1105)
  if (n__1105 < 0) then
    temper.bubble();
  end
  return DeleteQuery(this__253.tableName__1093, this__253.conditions__1094, n__1105);
end;
DeleteQuery.methods.toSql = function(this__254)
  local t_111, b__1109, i__1110, lv__1111;
  if temper.listed_isempty(this__254.conditions__1094) then
    temper.bubble();
  end
  b__1109 = SqlBuilder();
  b__1109:appendSafe('DELETE FROM ');
  b__1109:appendSafe(this__254.tableName__1093.sqlValue);
  b__1109:appendSafe(' WHERE ');
  b__1109:appendFragment((temper.list_get(this__254.conditions__1094, 0)).condition);
  i__1110 = 1;
  while true do
    t_111 = temper.list_length(this__254.conditions__1094);
    if not (i__1110 < t_111) then
      break;
    end
    b__1109:appendSafe(' ');
    b__1109:appendSafe(temper.list_get(this__254.conditions__1094, i__1110):keyword());
    b__1109:appendSafe(' ');
    b__1109:appendFragment((temper.list_get(this__254.conditions__1094, i__1110)).condition);
    i__1110 = temper.int32_add(i__1110, 1);
  end
  lv__1111 = this__254.limitVal__1095;
  if not temper.is_null(lv__1111) then
    local lv_112;
    lv_112 = lv__1111;
    b__1109:appendSafe(' LIMIT ');
    b__1109:appendInt32(lv_112);
  end
  return b__1109.accumulated;
end;
DeleteQuery.constructor = function(this__455, tableName__1113, conditions__1114, limitVal__1115)
  if (limitVal__1115 == nil) then
    limitVal__1115 = temper.null;
  end
  this__455.tableName__1093 = tableName__1113;
  this__455.conditions__1094 = conditions__1114;
  this__455.limitVal__1095 = limitVal__1115;
  return nil;
end;
DeleteQuery.get.tableName = function(this__1741)
  return this__1741.tableName__1093;
end;
DeleteQuery.get.conditions = function(this__1744)
  return this__1744.conditions__1094;
end;
DeleteQuery.get.limitVal = function(this__1747)
  return this__1747.limitVal__1095;
end;
SafeIdentifier = temper.type('SafeIdentifier');
SafeIdentifier.get.sqlValue = function(this__255)
  temper.virtual();
end;
ValidatedIdentifier__256 = temper.type('ValidatedIdentifier__256', SafeIdentifier);
ValidatedIdentifier__256.get.sqlValue = function(this__257)
  return this__257._value__1346;
end;
ValidatedIdentifier__256.constructor = function(this__469, _value__1350)
  this__469._value__1346 = _value__1350;
  return nil;
end;
FieldType = temper.type('FieldType');
StringField = temper.type('StringField', FieldType);
StringField.constructor = function(this__475)
  return nil;
end;
IntField = temper.type('IntField', FieldType);
IntField.constructor = function(this__477)
  return nil;
end;
Int64Field = temper.type('Int64Field', FieldType);
Int64Field.constructor = function(this__479)
  return nil;
end;
FloatField = temper.type('FloatField', FieldType);
FloatField.constructor = function(this__481)
  return nil;
end;
BoolField = temper.type('BoolField', FieldType);
BoolField.constructor = function(this__483)
  return nil;
end;
DateField = temper.type('DateField', FieldType);
DateField.constructor = function(this__485)
  return nil;
end;
FieldDef = temper.type('FieldDef');
FieldDef.constructor = function(this__487, name__1368, fieldType__1369, nullable__1370)
  this__487.name__1364 = name__1368;
  this__487.fieldType__1365 = fieldType__1369;
  this__487.nullable__1366 = nullable__1370;
  return nil;
end;
FieldDef.get.name = function(this__1607)
  return this__1607.name__1364;
end;
FieldDef.get.fieldType = function(this__1610)
  return this__1610.fieldType__1365;
end;
FieldDef.get.nullable = function(this__1613)
  return this__1613.nullable__1366;
end;
TableDef = temper.type('TableDef');
TableDef.methods.field = function(this__258, name__1374)
  local return__492, this__6801, n__6802, i__6803;
  ::continue_19::this__6801 = this__258.fields__1372;
  n__6802 = temper.list_length(this__6801);
  i__6803 = 0;
  while (i__6803 < n__6802) do
    local el__6804, f__1376;
    el__6804 = temper.list_get(this__6801, i__6803);
    i__6803 = temper.int32_add(i__6803, 1);
    f__1376 = el__6804;
    if temper.str_eq(f__1376.name.sqlValue, name__1374) then
      return__492 = f__1376;
      goto break_18;
    end
  end
  temper.bubble();
  ::break_18::return return__492;
end;
TableDef.constructor = function(this__489, tableName__1378, fields__1379)
  this__489.tableName__1371 = tableName__1378;
  this__489.fields__1372 = fields__1379;
  return nil;
end;
TableDef.get.tableName = function(this__1616)
  return this__1616.tableName__1371;
end;
TableDef.get.fields = function(this__1619)
  return this__1619.fields__1372;
end;
SqlBuilder = temper.type('SqlBuilder');
SqlBuilder.methods.appendSafe = function(this__259, sqlSource__1401)
  local t_113;
  t_113 = SqlSource(sqlSource__1401);
  temper.listbuilder_add(this__259.buffer__1399, t_113);
  return nil;
end;
SqlBuilder.methods.appendFragment = function(this__260, fragment__1404)
  local t_114;
  t_114 = fragment__1404.parts;
  temper.listbuilder_addall(this__260.buffer__1399, t_114);
  return nil;
end;
SqlBuilder.methods.appendPart = function(this__261, part__1407)
  temper.listbuilder_add(this__261.buffer__1399, part__1407);
  return nil;
end;
SqlBuilder.methods.appendPartList = function(this__262, values__1410)
  local fn__11415;
  fn__11415 = function(x__1412)
    this__262:appendPart(x__1412);
    return nil;
  end;
  this__262:appendList(values__1410, fn__11415);
  return nil;
end;
SqlBuilder.methods.appendBoolean = function(this__263, value__1414)
  local t_115;
  t_115 = SqlBoolean(value__1414);
  temper.listbuilder_add(this__263.buffer__1399, t_115);
  return nil;
end;
SqlBuilder.methods.appendBooleanList = function(this__264, values__1417)
  local fn__11409;
  fn__11409 = function(x__1419)
    this__264:appendBoolean(x__1419);
    return nil;
  end;
  this__264:appendList(values__1417, fn__11409);
  return nil;
end;
SqlBuilder.methods.appendDate = function(this__265, value__1421)
  local t_116;
  t_116 = SqlDate(value__1421);
  temper.listbuilder_add(this__265.buffer__1399, t_116);
  return nil;
end;
SqlBuilder.methods.appendDateList = function(this__266, values__1424)
  local fn__11403;
  fn__11403 = function(x__1426)
    this__266:appendDate(x__1426);
    return nil;
  end;
  this__266:appendList(values__1424, fn__11403);
  return nil;
end;
SqlBuilder.methods.appendFloat64 = function(this__267, value__1428)
  local t_117;
  t_117 = SqlFloat64(value__1428);
  temper.listbuilder_add(this__267.buffer__1399, t_117);
  return nil;
end;
SqlBuilder.methods.appendFloat64List = function(this__268, values__1431)
  local fn__11397;
  fn__11397 = function(x__1433)
    this__268:appendFloat64(x__1433);
    return nil;
  end;
  this__268:appendList(values__1431, fn__11397);
  return nil;
end;
SqlBuilder.methods.appendInt32 = function(this__269, value__1435)
  local t_118;
  t_118 = SqlInt32(value__1435);
  temper.listbuilder_add(this__269.buffer__1399, t_118);
  return nil;
end;
SqlBuilder.methods.appendInt32List = function(this__270, values__1438)
  local fn__11391;
  fn__11391 = function(x__1440)
    this__270:appendInt32(x__1440);
    return nil;
  end;
  this__270:appendList(values__1438, fn__11391);
  return nil;
end;
SqlBuilder.methods.appendInt64 = function(this__271, value__1442)
  local t_119;
  t_119 = SqlInt64(value__1442);
  temper.listbuilder_add(this__271.buffer__1399, t_119);
  return nil;
end;
SqlBuilder.methods.appendInt64List = function(this__272, values__1445)
  local fn__11385;
  fn__11385 = function(x__1447)
    this__272:appendInt64(x__1447);
    return nil;
  end;
  this__272:appendList(values__1445, fn__11385);
  return nil;
end;
SqlBuilder.methods.appendString = function(this__273, value__1449)
  local t_120;
  t_120 = SqlString(value__1449);
  temper.listbuilder_add(this__273.buffer__1399, t_120);
  return nil;
end;
SqlBuilder.methods.appendStringList = function(this__274, values__1452)
  local fn__11379;
  fn__11379 = function(x__1454)
    this__274:appendString(x__1454);
    return nil;
  end;
  this__274:appendList(values__1452, fn__11379);
  return nil;
end;
SqlBuilder.methods.appendList = function(this__275, values__1456, appendValue__1457)
  local t_121, t_122, i__1459;
  i__1459 = 0;
  while true do
    t_121 = temper.listed_length(values__1456);
    if not (i__1459 < t_121) then
      break;
    end
    if (i__1459 > 0) then
      this__275:appendSafe(', ');
    end
    t_122 = temper.listed_get(values__1456, i__1459);
    appendValue__1457(t_122);
    i__1459 = temper.int32_add(i__1459, 1);
  end
  return nil;
end;
SqlBuilder.get.accumulated = function(this__276)
  return SqlFragment(temper.listbuilder_tolist(this__276.buffer__1399));
end;
SqlBuilder.constructor = function(this__494)
  local t_123;
  t_123 = temper.listbuilder_constructor();
  this__494.buffer__1399 = t_123;
  return nil;
end;
SqlFragment = temper.type('SqlFragment');
SqlFragment.methods.toSource = function(this__281)
  return SqlSource(this__281:toString());
end;
SqlFragment.methods.toString = function(this__282)
  local t_124, builder__1471, i__1472;
  builder__1471 = temper.stringbuilder_constructor();
  i__1472 = 0;
  while true do
    t_124 = temper.list_length(this__282.parts__1466);
    if not (i__1472 < t_124) then
      break;
    end
    temper.list_get(this__282.parts__1466, i__1472):formatTo(builder__1471);
    i__1472 = temper.int32_add(i__1472, 1);
  end
  return temper.stringbuilder_tostring(builder__1471);
end;
SqlFragment.constructor = function(this__515, parts__1474)
  this__515.parts__1466 = parts__1474;
  return nil;
end;
SqlFragment.get.parts = function(this__1625)
  return this__1625.parts__1466;
end;
SqlPart = temper.type('SqlPart');
SqlPart.methods.formatTo = function(this__283, builder__1476)
  temper.virtual();
end;
SqlSource = temper.type('SqlSource', SqlPart);
SqlSource.methods.formatTo = function(this__284, builder__1480)
  temper.stringbuilder_append(builder__1480, this__284.source__1478);
  return nil;
end;
SqlSource.constructor = function(this__521, source__1483)
  this__521.source__1478 = source__1483;
  return nil;
end;
SqlSource.get.source = function(this__1622)
  return this__1622.source__1478;
end;
SqlBoolean = temper.type('SqlBoolean', SqlPart);
SqlBoolean.methods.formatTo = function(this__285, builder__1486)
  local t_125;
  if this__285.value__1484 then
    t_125 = 'TRUE';
  else
    t_125 = 'FALSE';
  end
  temper.stringbuilder_append(builder__1486, t_125);
  return nil;
end;
SqlBoolean.constructor = function(this__524, value__1489)
  this__524.value__1484 = value__1489;
  return nil;
end;
SqlBoolean.get.value = function(this__1628)
  return this__1628.value__1484;
end;
SqlDate = temper.type('SqlDate', SqlPart);
SqlDate.methods.formatTo = function(this__286, builder__1492)
  local t_126, fn__11424;
  temper.stringbuilder_append(builder__1492, "'");
  t_126 = temper.date_tostring(this__286.value__1490);
  fn__11424 = function(c__1494)
    if (c__1494 == 39) then
      temper.stringbuilder_append(builder__1492, "''");
    else
      local local_127, local_128, local_129;
      local_127, local_128, local_129 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__1492, c__1494);
      end);
      if local_127 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(t_126, fn__11424);
  temper.stringbuilder_append(builder__1492, "'");
  return nil;
end;
SqlDate.constructor = function(this__527, value__1496)
  this__527.value__1490 = value__1496;
  return nil;
end;
SqlDate.get.value = function(this__1643)
  return this__1643.value__1490;
end;
SqlFloat64 = temper.type('SqlFloat64', SqlPart);
SqlFloat64.methods.formatTo = function(this__287, builder__1499)
  local t_131, t_132, s__1501;
  s__1501 = temper.float64_tostring(this__287.value__1497);
  if temper.str_eq(s__1501, 'NaN') then
    t_132 = true;
  else
    if temper.str_eq(s__1501, 'Infinity') then
      t_131 = true;
    else
      t_131 = temper.str_eq(s__1501, '-Infinity');
    end
    t_132 = t_131;
  end
  if t_132 then
    temper.stringbuilder_append(builder__1499, 'NULL');
  else
    temper.stringbuilder_append(builder__1499, s__1501);
  end
  return nil;
end;
SqlFloat64.constructor = function(this__530, value__1503)
  this__530.value__1497 = value__1503;
  return nil;
end;
SqlFloat64.get.value = function(this__1640)
  return this__1640.value__1497;
end;
SqlInt32 = temper.type('SqlInt32', SqlPart);
SqlInt32.methods.formatTo = function(this__288, builder__1506)
  local t_133;
  t_133 = temper.int32_tostring(this__288.value__1504);
  temper.stringbuilder_append(builder__1506, t_133);
  return nil;
end;
SqlInt32.constructor = function(this__533, value__1509)
  this__533.value__1504 = value__1509;
  return nil;
end;
SqlInt32.get.value = function(this__1634)
  return this__1634.value__1504;
end;
SqlInt64 = temper.type('SqlInt64', SqlPart);
SqlInt64.methods.formatTo = function(this__289, builder__1512)
  local t_134;
  t_134 = temper.int64_tostring(this__289.value__1510);
  temper.stringbuilder_append(builder__1512, t_134);
  return nil;
end;
SqlInt64.constructor = function(this__536, value__1515)
  this__536.value__1510 = value__1515;
  return nil;
end;
SqlInt64.get.value = function(this__1637)
  return this__1637.value__1510;
end;
SqlString = temper.type('SqlString', SqlPart);
SqlString.methods.formatTo = function(this__290, builder__1518)
  local fn__11438;
  temper.stringbuilder_append(builder__1518, "'");
  fn__11438 = function(c__1520)
    if (c__1520 == 39) then
      temper.stringbuilder_append(builder__1518, "''");
    else
      local local_135, local_136, local_137;
      local_135, local_136, local_137 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__1518, c__1520);
      end);
      if local_135 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(this__290.value__1516, fn__11438);
  temper.stringbuilder_append(builder__1518, "'");
  return nil;
end;
SqlString.constructor = function(this__539, value__1522)
  this__539.value__1516 = value__1522;
  return nil;
end;
SqlString.get.value = function(this__1631)
  return this__1631.value__1516;
end;
changeset = function(tableDef__686, params__687)
  local t_139;
  t_139 = temper.map_constructor(temper.listof());
  return ChangesetImpl__182(tableDef__686, params__687, t_139, temper.listof(), true);
end;
isIdentStart__547 = function(c__1351)
  local return__472, t_140, t_141;
  if (c__1351 >= 97) then
    t_140 = (c__1351 <= 122);
  else
    t_140 = false;
  end
  if t_140 then
    return__472 = true;
  else
    if (c__1351 >= 65) then
      t_141 = (c__1351 <= 90);
    else
      t_141 = false;
    end
    if t_141 then
      return__472 = true;
    else
      return__472 = (c__1351 == 95);
    end
  end
  return return__472;
end;
isIdentPart__548 = function(c__1353)
  local return__473;
  if isIdentStart__547(c__1353) then
    return__473 = true;
  elseif (c__1353 >= 48) then
    return__473 = (c__1353 <= 57);
  else
    return__473 = false;
  end
  return return__473;
end;
safeIdentifier = function(name__1355)
  local t_142, idx__1357, t_143;
  if temper.string_isempty(name__1355) then
    temper.bubble();
  end
  idx__1357 = 1.0;
  if not isIdentStart__547(temper.string_get(name__1355, idx__1357)) then
    temper.bubble();
  end
  t_143 = temper.string_next(name__1355, idx__1357);
  idx__1357 = t_143;
  while true do
    if not temper.string_hasindex(name__1355, idx__1357) then
      break;
    end
    if not isIdentPart__548(temper.string_get(name__1355, idx__1357)) then
      temper.bubble();
    end
    t_142 = temper.string_next(name__1355, idx__1357);
    idx__1357 = t_142;
  end
  return ValidatedIdentifier__256(name__1355);
end;
deleteSql = function(tableDef__776, id__777)
  local b__779;
  b__779 = SqlBuilder();
  b__779:appendSafe('DELETE FROM ');
  b__779:appendSafe(tableDef__776.tableName.sqlValue);
  b__779:appendSafe(' WHERE id = ');
  b__779:appendInt32(id__777);
  return b__779.accumulated;
end;
from = function(tableName__1011)
  return Query(tableName__1011, temper.listof(), temper.listof(), temper.listof(), temper.null, temper.null, temper.listof(), temper.listof(), temper.listof(), false, temper.listof(), temper.null);
end;
col = function(table__1013, column__1014)
  local b__1016;
  b__1016 = SqlBuilder();
  b__1016:appendSafe(table__1013.sqlValue);
  b__1016:appendSafe('.');
  b__1016:appendSafe(column__1014.sqlValue);
  return b__1016.accumulated;
end;
countAll = function()
  local b__1018;
  b__1018 = SqlBuilder();
  b__1018:appendSafe('COUNT(*)');
  return b__1018.accumulated;
end;
countCol = function(field__1019)
  local b__1021;
  b__1021 = SqlBuilder();
  b__1021:appendSafe('COUNT(');
  b__1021:appendSafe(field__1019.sqlValue);
  b__1021:appendSafe(')');
  return b__1021.accumulated;
end;
sumCol = function(field__1022)
  local b__1024;
  b__1024 = SqlBuilder();
  b__1024:appendSafe('SUM(');
  b__1024:appendSafe(field__1022.sqlValue);
  b__1024:appendSafe(')');
  return b__1024.accumulated;
end;
avgCol = function(field__1025)
  local b__1027;
  b__1027 = SqlBuilder();
  b__1027:appendSafe('AVG(');
  b__1027:appendSafe(field__1025.sqlValue);
  b__1027:appendSafe(')');
  return b__1027.accumulated;
end;
minCol = function(field__1028)
  local b__1030;
  b__1030 = SqlBuilder();
  b__1030:appendSafe('MIN(');
  b__1030:appendSafe(field__1028.sqlValue);
  b__1030:appendSafe(')');
  return b__1030.accumulated;
end;
maxCol = function(field__1031)
  local b__1033;
  b__1033 = SqlBuilder();
  b__1033:appendSafe('MAX(');
  b__1033:appendSafe(field__1031.sqlValue);
  b__1033:appendSafe(')');
  return b__1033.accumulated;
end;
unionSql = function(a__1034, b__1035)
  local sb__1037;
  sb__1037 = SqlBuilder();
  sb__1037:appendSafe('(');
  sb__1037:appendFragment(a__1034:toSql());
  sb__1037:appendSafe(') UNION (');
  sb__1037:appendFragment(b__1035:toSql());
  sb__1037:appendSafe(')');
  return sb__1037.accumulated;
end;
unionAllSql = function(a__1038, b__1039)
  local sb__1041;
  sb__1041 = SqlBuilder();
  sb__1041:appendSafe('(');
  sb__1041:appendFragment(a__1038:toSql());
  sb__1041:appendSafe(') UNION ALL (');
  sb__1041:appendFragment(b__1039:toSql());
  sb__1041:appendSafe(')');
  return sb__1041.accumulated;
end;
intersectSql = function(a__1042, b__1043)
  local sb__1045;
  sb__1045 = SqlBuilder();
  sb__1045:appendSafe('(');
  sb__1045:appendFragment(a__1042:toSql());
  sb__1045:appendSafe(') INTERSECT (');
  sb__1045:appendFragment(b__1043:toSql());
  sb__1045:appendSafe(')');
  return sb__1045.accumulated;
end;
exceptSql = function(a__1046, b__1047)
  local sb__1049;
  sb__1049 = SqlBuilder();
  sb__1049:appendSafe('(');
  sb__1049:appendFragment(a__1046:toSql());
  sb__1049:appendSafe(') EXCEPT (');
  sb__1049:appendFragment(b__1047:toSql());
  sb__1049:appendSafe(')');
  return sb__1049.accumulated;
end;
subquery = function(q__1050, alias__1051)
  local b__1053;
  b__1053 = SqlBuilder();
  b__1053:appendSafe('(');
  b__1053:appendFragment(q__1050:toSql());
  b__1053:appendSafe(') AS ');
  b__1053:appendSafe(alias__1051.sqlValue);
  return b__1053.accumulated;
end;
existsSql = function(q__1054)
  local b__1056;
  b__1056 = SqlBuilder();
  b__1056:appendSafe('EXISTS (');
  b__1056:appendFragment(q__1054:toSql());
  b__1056:appendSafe(')');
  return b__1056.accumulated;
end;
update = function(tableName__1116)
  return UpdateQuery(tableName__1116, temper.listof(), temper.listof(), temper.null);
end;
deleteFrom = function(tableName__1118)
  return DeleteQuery(tableName__1118, temper.listof(), temper.null);
end;
exports = {};
exports.ChangesetError = ChangesetError;
exports.Changeset = Changeset;
exports.JoinType = JoinType;
exports.InnerJoin = InnerJoin;
exports.LeftJoin = LeftJoin;
exports.RightJoin = RightJoin;
exports.FullJoin = FullJoin;
exports.CrossJoin = CrossJoin;
exports.JoinClause = JoinClause;
exports.NullsPosition = NullsPosition;
exports.NullsFirst = NullsFirst;
exports.NullsLast = NullsLast;
exports.OrderClause = OrderClause;
exports.LockMode = LockMode;
exports.ForUpdate = ForUpdate;
exports.ForShare = ForShare;
exports.WhereClause = WhereClause;
exports.AndCondition = AndCondition;
exports.OrCondition = OrCondition;
exports.Query = Query;
exports.SetClause = SetClause;
exports.UpdateQuery = UpdateQuery;
exports.DeleteQuery = DeleteQuery;
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
exports.update = update;
exports.deleteFrom = deleteFrom;
return exports;
