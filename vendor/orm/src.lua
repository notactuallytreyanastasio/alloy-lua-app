local temper = require('temper-core');
local ChangesetError, Changeset, ChangesetImpl__100, OrderClause, Query, SafeIdentifier, ValidatedIdentifier__124, FieldType, StringField, IntField, Int64Field, FloatField, BoolField, DateField, FieldDef, TableDef, SqlBuilder, SqlFragment, SqlPart, SqlSource, SqlBoolean, SqlDate, SqlFloat64, SqlInt32, SqlInt64, SqlString, changeset, isIdentStart__305, isIdentPart__306, safeIdentifier, deleteSql, from, exports;
ChangesetError = temper.type('ChangesetError');
ChangesetError.constructor = function(this__159, field__312, message__313)
  this__159.field__309 = field__312;
  this__159.message__310 = message__313;
  return nil;
end;
ChangesetError.get.field = function(this__864)
  return this__864.field__309;
end;
ChangesetError.get.message = function(this__867)
  return this__867.message__310;
end;
Changeset = temper.type('Changeset');
Changeset.get.tableDef = function(this__87)
  temper.virtual();
end;
Changeset.get.changes = function(this__88)
  temper.virtual();
end;
Changeset.get.errors = function(this__89)
  temper.virtual();
end;
Changeset.get.isValid = function(this__90)
  temper.virtual();
end;
Changeset.methods.cast = function(this__91, allowedFields__323)
  temper.virtual();
end;
Changeset.methods.validateRequired = function(this__92, fields__326)
  temper.virtual();
end;
Changeset.methods.validateLength = function(this__93, field__329, min__330, max__331)
  temper.virtual();
end;
Changeset.methods.validateInt = function(this__94, field__334)
  temper.virtual();
end;
Changeset.methods.validateInt64 = function(this__95, field__337)
  temper.virtual();
end;
Changeset.methods.validateFloat = function(this__96, field__340)
  temper.virtual();
end;
Changeset.methods.validateBool = function(this__97, field__343)
  temper.virtual();
end;
Changeset.methods.toInsertSql = function(this__98)
  temper.virtual();
end;
Changeset.methods.toUpdateSql = function(this__99, id__348)
  temper.virtual();
end;
ChangesetImpl__100 = temper.type('ChangesetImpl__100', Changeset);
ChangesetImpl__100.get.tableDef = function(this__101)
  return this__101._tableDef__350;
end;
ChangesetImpl__100.get.changes = function(this__102)
  return this__102._changes__352;
end;
ChangesetImpl__100.get.errors = function(this__103)
  return this__103._errors__353;
end;
ChangesetImpl__100.get.isValid = function(this__104)
  return this__104._isValid__354;
end;
ChangesetImpl__100.methods.cast = function(this__105, allowedFields__364)
  local mb__366, fn__5014;
  mb__366 = temper.mapbuilder_constructor();
  fn__5014 = function(f__367)
    local t_0, t_1, val__368;
    t_1 = f__367.sqlValue;
    val__368 = temper.mapped_getor(this__105._params__351, t_1, '');
    if not temper.string_isempty(val__368) then
      t_0 = f__367.sqlValue;
      temper.mapbuilder_set(mb__366, t_0, val__368);
    end
    return nil;
  end;
  temper.list_foreach(allowedFields__364, fn__5014);
  return ChangesetImpl__100(this__105._tableDef__350, this__105._params__351, temper.mapped_tomap(mb__366), this__105._errors__353, this__105._isValid__354);
end;
ChangesetImpl__100.methods.validateRequired = function(this__106, fields__370)
  local return__192, t_2, t_3, t_4, t_5, eb__372, valid__373, fn__5003;
  ::continue_1::
  if not this__106._isValid__354 then
    return__192 = this__106;
    goto break_0;
  end
  eb__372 = temper.list_tolistbuilder(this__106._errors__353);
  valid__373 = true;
  fn__5003 = function(f__374)
    local t_6, t_7;
    t_7 = f__374.sqlValue;
    if not temper.mapped_has(this__106._changes__352, t_7) then
      t_6 = ChangesetError(f__374.sqlValue, 'is required');
      temper.listbuilder_add(eb__372, t_6);
      valid__373 = false;
    end
    return nil;
  end;
  temper.list_foreach(fields__370, fn__5003);
  t_3 = this__106._tableDef__350;
  t_4 = this__106._params__351;
  t_5 = this__106._changes__352;
  t_2 = temper.listbuilder_tolist(eb__372);
  return__192 = ChangesetImpl__100(t_3, t_4, t_5, t_2, valid__373);
  ::break_0::return return__192;
end;
ChangesetImpl__100.methods.validateLength = function(this__107, field__376, min__377, max__378)
  local return__193, t_8, t_9, t_10, t_11, t_12, t_13, val__380, len__381;
  ::continue_3::
  if not this__107._isValid__354 then
    return__193 = this__107;
    goto break_2;
  end
  t_8 = field__376.sqlValue;
  val__380 = temper.mapped_getor(this__107._changes__352, t_8, '');
  len__381 = temper.string_countbetween(val__380, 1.0, temper.string_end(val__380));
  if (len__381 < min__377) then
    t_10 = true;
  else
    t_10 = (len__381 > max__378);
  end
  if t_10 then
    local msg__382, eb__383;
    msg__382 = temper.concat('must be between ', temper.int32_tostring(min__377), ' and ', temper.int32_tostring(max__378), ' characters');
    eb__383 = temper.list_tolistbuilder(this__107._errors__353);
    temper.listbuilder_add(eb__383, ChangesetError(field__376.sqlValue, msg__382));
    t_11 = this__107._tableDef__350;
    t_12 = this__107._params__351;
    t_13 = this__107._changes__352;
    t_9 = temper.listbuilder_tolist(eb__383);
    return__193 = ChangesetImpl__100(t_11, t_12, t_13, t_9, false);
    goto break_2;
  end
  return__193 = this__107;
  ::break_2::return return__193;
end;
ChangesetImpl__100.methods.validateInt = function(this__108, field__385)
  local return__194, t_14, t_15, t_16, t_17, t_18, val__387, parseOk__388, local_19, local_20, local_21;
  ::continue_5::
  if not this__108._isValid__354 then
    return__194 = this__108;
    goto break_4;
  end
  t_14 = field__385.sqlValue;
  val__387 = temper.mapped_getor(this__108._changes__352, t_14, '');
  if temper.string_isempty(val__387) then
    return__194 = this__108;
    goto break_4;
  end
  local_19, local_20, local_21 = temper.pcall(function()
    temper.string_toint32(val__387);
    parseOk__388 = true;
  end);
  if local_19 then
  else
    parseOk__388 = false;
  end
  if not parseOk__388 then
    local eb__389;
    eb__389 = temper.list_tolistbuilder(this__108._errors__353);
    temper.listbuilder_add(eb__389, ChangesetError(field__385.sqlValue, 'must be an integer'));
    t_16 = this__108._tableDef__350;
    t_17 = this__108._params__351;
    t_18 = this__108._changes__352;
    t_15 = temper.listbuilder_tolist(eb__389);
    return__194 = ChangesetImpl__100(t_16, t_17, t_18, t_15, false);
    goto break_4;
  end
  return__194 = this__108;
  ::break_4::return return__194;
end;
ChangesetImpl__100.methods.validateInt64 = function(this__109, field__391)
  local return__195, t_23, t_24, t_25, t_26, t_27, val__393, parseOk__394, local_28, local_29, local_30;
  ::continue_7::
  if not this__109._isValid__354 then
    return__195 = this__109;
    goto break_6;
  end
  t_23 = field__391.sqlValue;
  val__393 = temper.mapped_getor(this__109._changes__352, t_23, '');
  if temper.string_isempty(val__393) then
    return__195 = this__109;
    goto break_6;
  end
  local_28, local_29, local_30 = temper.pcall(function()
    temper.string_toint64(val__393);
    parseOk__394 = true;
  end);
  if local_28 then
  else
    parseOk__394 = false;
  end
  if not parseOk__394 then
    local eb__395;
    eb__395 = temper.list_tolistbuilder(this__109._errors__353);
    temper.listbuilder_add(eb__395, ChangesetError(field__391.sqlValue, 'must be a 64-bit integer'));
    t_25 = this__109._tableDef__350;
    t_26 = this__109._params__351;
    t_27 = this__109._changes__352;
    t_24 = temper.listbuilder_tolist(eb__395);
    return__195 = ChangesetImpl__100(t_25, t_26, t_27, t_24, false);
    goto break_6;
  end
  return__195 = this__109;
  ::break_6::return return__195;
end;
ChangesetImpl__100.methods.validateFloat = function(this__110, field__397)
  local return__196, t_32, t_33, t_34, t_35, t_36, val__399, parseOk__400, local_37, local_38, local_39;
  ::continue_9::
  if not this__110._isValid__354 then
    return__196 = this__110;
    goto break_8;
  end
  t_32 = field__397.sqlValue;
  val__399 = temper.mapped_getor(this__110._changes__352, t_32, '');
  if temper.string_isempty(val__399) then
    return__196 = this__110;
    goto break_8;
  end
  local_37, local_38, local_39 = temper.pcall(function()
    temper.string_tofloat64(val__399);
    parseOk__400 = true;
  end);
  if local_37 then
  else
    parseOk__400 = false;
  end
  if not parseOk__400 then
    local eb__401;
    eb__401 = temper.list_tolistbuilder(this__110._errors__353);
    temper.listbuilder_add(eb__401, ChangesetError(field__397.sqlValue, 'must be a number'));
    t_34 = this__110._tableDef__350;
    t_35 = this__110._params__351;
    t_36 = this__110._changes__352;
    t_33 = temper.listbuilder_tolist(eb__401);
    return__196 = ChangesetImpl__100(t_34, t_35, t_36, t_33, false);
    goto break_8;
  end
  return__196 = this__110;
  ::break_8::return return__196;
end;
ChangesetImpl__100.methods.validateBool = function(this__111, field__403)
  local return__197, t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48, t_49, t_50, val__405, isTrue__406, isFalse__407;
  ::continue_11::
  if not this__111._isValid__354 then
    return__197 = this__111;
    goto break_10;
  end
  t_41 = field__403.sqlValue;
  val__405 = temper.mapped_getor(this__111._changes__352, t_41, '');
  if temper.string_isempty(val__405) then
    return__197 = this__111;
    goto break_10;
  end
  if temper.str_eq(val__405, 'true') then
    isTrue__406 = true;
  else
    if temper.str_eq(val__405, '1') then
      t_44 = true;
    else
      if temper.str_eq(val__405, 'yes') then
        t_43 = true;
      else
        t_43 = temper.str_eq(val__405, 'on');
      end
      t_44 = t_43;
    end
    isTrue__406 = t_44;
  end
  if temper.str_eq(val__405, 'false') then
    isFalse__407 = true;
  else
    if temper.str_eq(val__405, '0') then
      t_46 = true;
    else
      if temper.str_eq(val__405, 'no') then
        t_45 = true;
      else
        t_45 = temper.str_eq(val__405, 'off');
      end
      t_46 = t_45;
    end
    isFalse__407 = t_46;
  end
  if not isTrue__406 then
    t_47 = not isFalse__407;
  else
    t_47 = false;
  end
  if t_47 then
    local eb__408;
    eb__408 = temper.list_tolistbuilder(this__111._errors__353);
    temper.listbuilder_add(eb__408, ChangesetError(field__403.sqlValue, 'must be a boolean (true/false/1/0/yes/no/on/off)'));
    t_48 = this__111._tableDef__350;
    t_49 = this__111._params__351;
    t_50 = this__111._changes__352;
    t_42 = temper.listbuilder_tolist(eb__408);
    return__197 = ChangesetImpl__100(t_48, t_49, t_50, t_42, false);
    goto break_10;
  end
  return__197 = this__111;
  ::break_10::return return__197;
end;
ChangesetImpl__100.methods.parseBoolSqlPart = function(this__112, val__410)
  local return__198, t_51, t_52, t_53, t_54, t_55, t_56;
  ::continue_13::
  if temper.str_eq(val__410, 'true') then
    t_53 = true;
  else
    if temper.str_eq(val__410, '1') then
      t_52 = true;
    else
      if temper.str_eq(val__410, 'yes') then
        t_51 = true;
      else
        t_51 = temper.str_eq(val__410, 'on');
      end
      t_52 = t_51;
    end
    t_53 = t_52;
  end
  if t_53 then
    return__198 = SqlBoolean(true);
    goto break_12;
  end
  if temper.str_eq(val__410, 'false') then
    t_56 = true;
  else
    if temper.str_eq(val__410, '0') then
      t_55 = true;
    else
      if temper.str_eq(val__410, 'no') then
        t_54 = true;
      else
        t_54 = temper.str_eq(val__410, 'off');
      end
      t_55 = t_54;
    end
    t_56 = t_55;
  end
  if t_56 then
    return__198 = SqlBoolean(false);
    goto break_12;
  end
  temper.bubble();
  ::break_12::return return__198;
end;
ChangesetImpl__100.methods.valueToSqlPart = function(this__113, fieldDef__413, val__414)
  local return__199, t_57, t_58, t_59, t_60, ft__416;
  ::continue_15::ft__416 = fieldDef__413.fieldType;
  if temper.instance_of(ft__416, StringField) then
    return__199 = SqlString(val__414);
    goto break_14;
  end
  if temper.instance_of(ft__416, IntField) then
    t_57 = temper.string_toint32(val__414);
    return__199 = SqlInt32(t_57);
    goto break_14;
  end
  if temper.instance_of(ft__416, Int64Field) then
    t_58 = temper.string_toint64(val__414);
    return__199 = SqlInt64(t_58);
    goto break_14;
  end
  if temper.instance_of(ft__416, FloatField) then
    t_59 = temper.string_tofloat64(val__414);
    return__199 = SqlFloat64(t_59);
    goto break_14;
  end
  if temper.instance_of(ft__416, BoolField) then
    return__199 = this__113:parseBoolSqlPart(val__414);
    goto break_14;
  end
  if temper.instance_of(ft__416, DateField) then
    t_60 = temper.date_fromisostring(val__414);
    return__199 = SqlDate(t_60);
    goto break_14;
  end
  temper.bubble();
  ::break_14::return return__199;
end;
ChangesetImpl__100.methods.toInsertSql = function(this__114)
  local t_61, t_62, t_63, t_64, t_65, t_66, t_67, t_68, t_69, t_70, i__419, pairs__421, colNames__422, valParts__423, i__424, b__427, t_71, fn__4895, j__429;
  if not this__114._isValid__354 then
    temper.bubble();
  end
  i__419 = 0;
  while true do
    local f__420;
    t_61 = temper.list_length(this__114._tableDef__350.fields);
    if not (i__419 < t_61) then
      break;
    end
    f__420 = temper.list_get(this__114._tableDef__350.fields, i__419);
    if not f__420.nullable then
      t_62 = f__420.name.sqlValue;
      t_63 = temper.mapped_has(this__114._changes__352, t_62);
      t_68 = not t_63;
    else
      t_68 = false;
    end
    if t_68 then
      temper.bubble();
    end
    i__419 = temper.int32_add(i__419, 1);
  end
  pairs__421 = temper.mapped_tolist(this__114._changes__352);
  if (temper.list_length(pairs__421) == 0) then
    temper.bubble();
  end
  colNames__422 = temper.listbuilder_constructor();
  valParts__423 = temper.listbuilder_constructor();
  i__424 = 0;
  while true do
    local pair__425, fd__426;
    t_64 = temper.list_length(pairs__421);
    if not (i__424 < t_64) then
      break;
    end
    pair__425 = temper.list_get(pairs__421, i__424);
    t_65 = pair__425.key;
    t_69 = this__114._tableDef__350:field(t_65);
    fd__426 = t_69;
    temper.listbuilder_add(colNames__422, fd__426.name.sqlValue);
    t_66 = pair__425.value;
    t_70 = this__114:valueToSqlPart(fd__426, t_66);
    temper.listbuilder_add(valParts__423, t_70);
    i__424 = temper.int32_add(i__424, 1);
  end
  b__427 = SqlBuilder();
  b__427:appendSafe('INSERT INTO ');
  b__427:appendSafe(this__114._tableDef__350.tableName.sqlValue);
  b__427:appendSafe(' (');
  t_71 = temper.listbuilder_tolist(colNames__422);
  fn__4895 = function(c__428)
    return c__428;
  end;
  b__427:appendSafe(temper.listed_join(t_71, ', ', fn__4895));
  b__427:appendSafe(') VALUES (');
  b__427:appendPart(temper.listed_get(valParts__423, 0));
  j__429 = 1;
  while true do
    t_67 = temper.listbuilder_length(valParts__423);
    if not (j__429 < t_67) then
      break;
    end
    b__427:appendSafe(', ');
    b__427:appendPart(temper.listed_get(valParts__423, j__429));
    j__429 = temper.int32_add(j__429, 1);
  end
  b__427:appendSafe(')');
  return b__427.accumulated;
end;
ChangesetImpl__100.methods.toUpdateSql = function(this__115, id__431)
  local t_72, t_73, t_74, t_75, t_76, pairs__433, b__434, i__435;
  if not this__115._isValid__354 then
    temper.bubble();
  end
  pairs__433 = temper.mapped_tolist(this__115._changes__352);
  if (temper.list_length(pairs__433) == 0) then
    temper.bubble();
  end
  b__434 = SqlBuilder();
  b__434:appendSafe('UPDATE ');
  b__434:appendSafe(this__115._tableDef__350.tableName.sqlValue);
  b__434:appendSafe(' SET ');
  i__435 = 0;
  while true do
    local pair__436, fd__437;
    t_72 = temper.list_length(pairs__433);
    if not (i__435 < t_72) then
      break;
    end
    if (i__435 > 0) then
      b__434:appendSafe(', ');
    end
    pair__436 = temper.list_get(pairs__433, i__435);
    t_73 = pair__436.key;
    t_75 = this__115._tableDef__350:field(t_73);
    fd__437 = t_75;
    b__434:appendSafe(fd__437.name.sqlValue);
    b__434:appendSafe(' = ');
    t_74 = pair__436.value;
    t_76 = this__115:valueToSqlPart(fd__437, t_74);
    b__434:appendPart(t_76);
    i__435 = temper.int32_add(i__435, 1);
  end
  b__434:appendSafe(' WHERE id = ');
  b__434:appendInt32(id__431);
  return b__434.accumulated;
end;
ChangesetImpl__100.constructor = function(this__182, _tableDef__439, _params__440, _changes__441, _errors__442, _isValid__443)
  this__182._tableDef__350 = _tableDef__439;
  this__182._params__351 = _params__440;
  this__182._changes__352 = _changes__441;
  this__182._errors__353 = _errors__442;
  this__182._isValid__354 = _isValid__443;
  return nil;
end;
OrderClause = temper.type('OrderClause');
OrderClause.constructor = function(this__206, field__541, ascending__542)
  this__206.field__538 = field__541;
  this__206.ascending__539 = ascending__542;
  return nil;
end;
OrderClause.get.field = function(this__932)
  return this__932.field__538;
end;
OrderClause.get.ascending = function(this__935)
  return this__935.ascending__539;
end;
Query = temper.type('Query');
Query.methods.where = function(this__116, condition__550)
  local nb__552;
  nb__552 = temper.list_tolistbuilder(this__116.conditions__544);
  temper.listbuilder_add(nb__552, condition__550);
  return Query(this__116.tableName__543, temper.listbuilder_tolist(nb__552), this__116.selectedFields__545, this__116.orderClauses__546, this__116.limitVal__547, this__116.offsetVal__548);
end;
Query.methods.select = function(this__117, fields__554)
  return Query(this__117.tableName__543, this__117.conditions__544, fields__554, this__117.orderClauses__546, this__117.limitVal__547, this__117.offsetVal__548);
end;
Query.methods.orderBy = function(this__118, field__557, ascending__558)
  local nb__560;
  nb__560 = temper.list_tolistbuilder(this__118.orderClauses__546);
  temper.listbuilder_add(nb__560, OrderClause(field__557, ascending__558));
  return Query(this__118.tableName__543, this__118.conditions__544, this__118.selectedFields__545, temper.listbuilder_tolist(nb__560), this__118.limitVal__547, this__118.offsetVal__548);
end;
Query.methods.limit = function(this__119, n__562)
  if (n__562 < 0) then
    temper.bubble();
  end
  return Query(this__119.tableName__543, this__119.conditions__544, this__119.selectedFields__545, this__119.orderClauses__546, n__562, this__119.offsetVal__548);
end;
Query.methods.offset = function(this__120, n__565)
  if (n__565 < 0) then
    temper.bubble();
  end
  return Query(this__120.tableName__543, this__120.conditions__544, this__120.selectedFields__545, this__120.orderClauses__546, this__120.limitVal__547, n__565);
end;
Query.methods.toSql = function(this__121)
  local t_77, b__569, lv__574, ov__575;
  b__569 = SqlBuilder();
  b__569:appendSafe('SELECT ');
  if temper.listed_isempty(this__121.selectedFields__545) then
    b__569:appendSafe('*');
  else
    local fn__4451;
    fn__4451 = function(f__570)
      return f__570.sqlValue;
    end;
    b__569:appendSafe(temper.listed_join(this__121.selectedFields__545, ', ', fn__4451));
  end
  b__569:appendSafe(' FROM ');
  b__569:appendSafe(this__121.tableName__543.sqlValue);
  if not temper.listed_isempty(this__121.conditions__544) then
    local i__571;
    b__569:appendSafe(' WHERE ');
    b__569:appendFragment(temper.list_get(this__121.conditions__544, 0));
    i__571 = 1;
    while true do
      t_77 = temper.list_length(this__121.conditions__544);
      if not (i__571 < t_77) then
        break;
      end
      b__569:appendSafe(' AND ');
      b__569:appendFragment(temper.list_get(this__121.conditions__544, i__571));
      i__571 = temper.int32_add(i__571, 1);
    end
  end
  if not temper.listed_isempty(this__121.orderClauses__546) then
    local first__572, fn__4450;
    b__569:appendSafe(' ORDER BY ');
    first__572 = true;
    fn__4450 = function(oc__573)
      local t_78, t_79;
      if not first__572 then
        b__569:appendSafe(', ');
      end
      first__572 = false;
      t_79 = oc__573.field.sqlValue;
      b__569:appendSafe(t_79);
      if oc__573.ascending then
        t_78 = ' ASC';
      else
        t_78 = ' DESC';
      end
      b__569:appendSafe(t_78);
      return nil;
    end;
    temper.list_foreach(this__121.orderClauses__546, fn__4450);
  end
  lv__574 = this__121.limitVal__547;
  if not temper.is_null(lv__574) then
    local lv_80;
    lv_80 = lv__574;
    b__569:appendSafe(' LIMIT ');
    b__569:appendInt32(lv_80);
  end
  ov__575 = this__121.offsetVal__548;
  if not temper.is_null(ov__575) then
    local ov_81;
    ov_81 = ov__575;
    b__569:appendSafe(' OFFSET ');
    b__569:appendInt32(ov_81);
  end
  return b__569.accumulated;
end;
Query.methods.safeToSql = function(this__122, defaultLimit__577)
  local return__221, t_82;
  if (defaultLimit__577 < 0) then
    temper.bubble();
  end
  if not temper.is_null(this__122.limitVal__547) then
    return__221 = this__122:toSql();
  else
    t_82 = this__122:limit(defaultLimit__577);
    return__221 = t_82:toSql();
  end
  return return__221;
end;
Query.constructor = function(this__208, tableName__580, conditions__581, selectedFields__582, orderClauses__583, limitVal__584, offsetVal__585)
  if (limitVal__584 == nil) then
    limitVal__584 = temper.null;
  end
  if (offsetVal__585 == nil) then
    offsetVal__585 = temper.null;
  end
  this__208.tableName__543 = tableName__580;
  this__208.conditions__544 = conditions__581;
  this__208.selectedFields__545 = selectedFields__582;
  this__208.orderClauses__546 = orderClauses__583;
  this__208.limitVal__547 = limitVal__584;
  this__208.offsetVal__548 = offsetVal__585;
  return nil;
end;
Query.get.tableName = function(this__938)
  return this__938.tableName__543;
end;
Query.get.conditions = function(this__941)
  return this__941.conditions__544;
end;
Query.get.selectedFields = function(this__944)
  return this__944.selectedFields__545;
end;
Query.get.orderClauses = function(this__947)
  return this__947.orderClauses__546;
end;
Query.get.limitVal = function(this__950)
  return this__950.limitVal__547;
end;
Query.get.offsetVal = function(this__953)
  return this__953.offsetVal__548;
end;
SafeIdentifier = temper.type('SafeIdentifier');
SafeIdentifier.get.sqlValue = function(this__123)
  temper.virtual();
end;
ValidatedIdentifier__124 = temper.type('ValidatedIdentifier__124', SafeIdentifier);
ValidatedIdentifier__124.get.sqlValue = function(this__125)
  return this__125._value__630;
end;
ValidatedIdentifier__124.constructor = function(this__227, _value__634)
  this__227._value__630 = _value__634;
  return nil;
end;
FieldType = temper.type('FieldType');
StringField = temper.type('StringField', FieldType);
StringField.constructor = function(this__233)
  return nil;
end;
IntField = temper.type('IntField', FieldType);
IntField.constructor = function(this__235)
  return nil;
end;
Int64Field = temper.type('Int64Field', FieldType);
Int64Field.constructor = function(this__237)
  return nil;
end;
FloatField = temper.type('FloatField', FieldType);
FloatField.constructor = function(this__239)
  return nil;
end;
BoolField = temper.type('BoolField', FieldType);
BoolField.constructor = function(this__241)
  return nil;
end;
DateField = temper.type('DateField', FieldType);
DateField.constructor = function(this__243)
  return nil;
end;
FieldDef = temper.type('FieldDef');
FieldDef.constructor = function(this__245, name__652, fieldType__653, nullable__654)
  this__245.name__648 = name__652;
  this__245.fieldType__649 = fieldType__653;
  this__245.nullable__650 = nullable__654;
  return nil;
end;
FieldDef.get.name = function(this__870)
  return this__870.name__648;
end;
FieldDef.get.fieldType = function(this__873)
  return this__873.fieldType__649;
end;
FieldDef.get.nullable = function(this__876)
  return this__876.nullable__650;
end;
TableDef = temper.type('TableDef');
TableDef.methods.field = function(this__126, name__658)
  local return__250, this__3156, n__3157, i__3158;
  ::continue_17::this__3156 = this__126.fields__656;
  n__3157 = temper.list_length(this__3156);
  i__3158 = 0;
  while (i__3158 < n__3157) do
    local el__3159, f__660;
    el__3159 = temper.list_get(this__3156, i__3158);
    i__3158 = temper.int32_add(i__3158, 1);
    f__660 = el__3159;
    if temper.str_eq(f__660.name.sqlValue, name__658) then
      return__250 = f__660;
      goto break_16;
    end
  end
  temper.bubble();
  ::break_16::return return__250;
end;
TableDef.constructor = function(this__247, tableName__662, fields__663)
  this__247.tableName__655 = tableName__662;
  this__247.fields__656 = fields__663;
  return nil;
end;
TableDef.get.tableName = function(this__879)
  return this__879.tableName__655;
end;
TableDef.get.fields = function(this__882)
  return this__882.fields__656;
end;
SqlBuilder = temper.type('SqlBuilder');
SqlBuilder.methods.appendSafe = function(this__127, sqlSource__685)
  local t_83;
  t_83 = SqlSource(sqlSource__685);
  temper.listbuilder_add(this__127.buffer__683, t_83);
  return nil;
end;
SqlBuilder.methods.appendFragment = function(this__128, fragment__688)
  local t_84;
  t_84 = fragment__688.parts;
  temper.listbuilder_addall(this__128.buffer__683, t_84);
  return nil;
end;
SqlBuilder.methods.appendPart = function(this__129, part__691)
  temper.listbuilder_add(this__129.buffer__683, part__691);
  return nil;
end;
SqlBuilder.methods.appendPartList = function(this__130, values__694)
  local fn__5066;
  fn__5066 = function(x__696)
    this__130:appendPart(x__696);
    return nil;
  end;
  this__130:appendList(values__694, fn__5066);
  return nil;
end;
SqlBuilder.methods.appendBoolean = function(this__131, value__698)
  local t_85;
  t_85 = SqlBoolean(value__698);
  temper.listbuilder_add(this__131.buffer__683, t_85);
  return nil;
end;
SqlBuilder.methods.appendBooleanList = function(this__132, values__701)
  local fn__5060;
  fn__5060 = function(x__703)
    this__132:appendBoolean(x__703);
    return nil;
  end;
  this__132:appendList(values__701, fn__5060);
  return nil;
end;
SqlBuilder.methods.appendDate = function(this__133, value__705)
  local t_86;
  t_86 = SqlDate(value__705);
  temper.listbuilder_add(this__133.buffer__683, t_86);
  return nil;
end;
SqlBuilder.methods.appendDateList = function(this__134, values__708)
  local fn__5054;
  fn__5054 = function(x__710)
    this__134:appendDate(x__710);
    return nil;
  end;
  this__134:appendList(values__708, fn__5054);
  return nil;
end;
SqlBuilder.methods.appendFloat64 = function(this__135, value__712)
  local t_87;
  t_87 = SqlFloat64(value__712);
  temper.listbuilder_add(this__135.buffer__683, t_87);
  return nil;
end;
SqlBuilder.methods.appendFloat64List = function(this__136, values__715)
  local fn__5048;
  fn__5048 = function(x__717)
    this__136:appendFloat64(x__717);
    return nil;
  end;
  this__136:appendList(values__715, fn__5048);
  return nil;
end;
SqlBuilder.methods.appendInt32 = function(this__137, value__719)
  local t_88;
  t_88 = SqlInt32(value__719);
  temper.listbuilder_add(this__137.buffer__683, t_88);
  return nil;
end;
SqlBuilder.methods.appendInt32List = function(this__138, values__722)
  local fn__5042;
  fn__5042 = function(x__724)
    this__138:appendInt32(x__724);
    return nil;
  end;
  this__138:appendList(values__722, fn__5042);
  return nil;
end;
SqlBuilder.methods.appendInt64 = function(this__139, value__726)
  local t_89;
  t_89 = SqlInt64(value__726);
  temper.listbuilder_add(this__139.buffer__683, t_89);
  return nil;
end;
SqlBuilder.methods.appendInt64List = function(this__140, values__729)
  local fn__5036;
  fn__5036 = function(x__731)
    this__140:appendInt64(x__731);
    return nil;
  end;
  this__140:appendList(values__729, fn__5036);
  return nil;
end;
SqlBuilder.methods.appendString = function(this__141, value__733)
  local t_90;
  t_90 = SqlString(value__733);
  temper.listbuilder_add(this__141.buffer__683, t_90);
  return nil;
end;
SqlBuilder.methods.appendStringList = function(this__142, values__736)
  local fn__5030;
  fn__5030 = function(x__738)
    this__142:appendString(x__738);
    return nil;
  end;
  this__142:appendList(values__736, fn__5030);
  return nil;
end;
SqlBuilder.methods.appendList = function(this__143, values__740, appendValue__741)
  local t_91, t_92, i__743;
  i__743 = 0;
  while true do
    t_91 = temper.listed_length(values__740);
    if not (i__743 < t_91) then
      break;
    end
    if (i__743 > 0) then
      this__143:appendSafe(', ');
    end
    t_92 = temper.listed_get(values__740, i__743);
    appendValue__741(t_92);
    i__743 = temper.int32_add(i__743, 1);
  end
  return nil;
end;
SqlBuilder.get.accumulated = function(this__144)
  return SqlFragment(temper.listbuilder_tolist(this__144.buffer__683));
end;
SqlBuilder.constructor = function(this__252)
  local t_93;
  t_93 = temper.listbuilder_constructor();
  this__252.buffer__683 = t_93;
  return nil;
end;
SqlFragment = temper.type('SqlFragment');
SqlFragment.methods.toSource = function(this__149)
  return SqlSource(this__149:toString());
end;
SqlFragment.methods.toString = function(this__150)
  local t_94, builder__755, i__756;
  builder__755 = temper.stringbuilder_constructor();
  i__756 = 0;
  while true do
    t_94 = temper.list_length(this__150.parts__750);
    if not (i__756 < t_94) then
      break;
    end
    temper.list_get(this__150.parts__750, i__756):formatTo(builder__755);
    i__756 = temper.int32_add(i__756, 1);
  end
  return temper.stringbuilder_tostring(builder__755);
end;
SqlFragment.constructor = function(this__273, parts__758)
  this__273.parts__750 = parts__758;
  return nil;
end;
SqlFragment.get.parts = function(this__888)
  return this__888.parts__750;
end;
SqlPart = temper.type('SqlPart');
SqlPart.methods.formatTo = function(this__151, builder__760)
  temper.virtual();
end;
SqlSource = temper.type('SqlSource', SqlPart);
SqlSource.methods.formatTo = function(this__152, builder__764)
  temper.stringbuilder_append(builder__764, this__152.source__762);
  return nil;
end;
SqlSource.constructor = function(this__279, source__767)
  this__279.source__762 = source__767;
  return nil;
end;
SqlSource.get.source = function(this__885)
  return this__885.source__762;
end;
SqlBoolean = temper.type('SqlBoolean', SqlPart);
SqlBoolean.methods.formatTo = function(this__153, builder__770)
  local t_95;
  if this__153.value__768 then
    t_95 = 'TRUE';
  else
    t_95 = 'FALSE';
  end
  temper.stringbuilder_append(builder__770, t_95);
  return nil;
end;
SqlBoolean.constructor = function(this__282, value__773)
  this__282.value__768 = value__773;
  return nil;
end;
SqlBoolean.get.value = function(this__891)
  return this__891.value__768;
end;
SqlDate = temper.type('SqlDate', SqlPart);
SqlDate.methods.formatTo = function(this__154, builder__776)
  local t_96, fn__5075;
  temper.stringbuilder_append(builder__776, "'");
  t_96 = temper.date_tostring(this__154.value__774);
  fn__5075 = function(c__778)
    if (c__778 == 39) then
      temper.stringbuilder_append(builder__776, "''");
    else
      local local_97, local_98, local_99;
      local_97, local_98, local_99 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__776, c__778);
      end);
      if local_97 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(t_96, fn__5075);
  temper.stringbuilder_append(builder__776, "'");
  return nil;
end;
SqlDate.constructor = function(this__285, value__780)
  this__285.value__774 = value__780;
  return nil;
end;
SqlDate.get.value = function(this__906)
  return this__906.value__774;
end;
SqlFloat64 = temper.type('SqlFloat64', SqlPart);
SqlFloat64.methods.formatTo = function(this__155, builder__783)
  local t_101, t_102, s__785;
  s__785 = temper.float64_tostring(this__155.value__781);
  if temper.str_eq(s__785, 'NaN') then
    t_102 = true;
  else
    if temper.str_eq(s__785, 'Infinity') then
      t_101 = true;
    else
      t_101 = temper.str_eq(s__785, '-Infinity');
    end
    t_102 = t_101;
  end
  if t_102 then
    temper.stringbuilder_append(builder__783, 'NULL');
  else
    temper.stringbuilder_append(builder__783, s__785);
  end
  return nil;
end;
SqlFloat64.constructor = function(this__288, value__787)
  this__288.value__781 = value__787;
  return nil;
end;
SqlFloat64.get.value = function(this__903)
  return this__903.value__781;
end;
SqlInt32 = temper.type('SqlInt32', SqlPart);
SqlInt32.methods.formatTo = function(this__156, builder__790)
  local t_103;
  t_103 = temper.int32_tostring(this__156.value__788);
  temper.stringbuilder_append(builder__790, t_103);
  return nil;
end;
SqlInt32.constructor = function(this__291, value__793)
  this__291.value__788 = value__793;
  return nil;
end;
SqlInt32.get.value = function(this__897)
  return this__897.value__788;
end;
SqlInt64 = temper.type('SqlInt64', SqlPart);
SqlInt64.methods.formatTo = function(this__157, builder__796)
  local t_104;
  t_104 = temper.int64_tostring(this__157.value__794);
  temper.stringbuilder_append(builder__796, t_104);
  return nil;
end;
SqlInt64.constructor = function(this__294, value__799)
  this__294.value__794 = value__799;
  return nil;
end;
SqlInt64.get.value = function(this__900)
  return this__900.value__794;
end;
SqlString = temper.type('SqlString', SqlPart);
SqlString.methods.formatTo = function(this__158, builder__802)
  local fn__5089;
  temper.stringbuilder_append(builder__802, "'");
  fn__5089 = function(c__804)
    if (c__804 == 39) then
      temper.stringbuilder_append(builder__802, "''");
    else
      local local_105, local_106, local_107;
      local_105, local_106, local_107 = temper.pcall(function()
        temper.stringbuilder_appendcodepoint(builder__802, c__804);
      end);
      if local_105 then
      else
        temper.bubble();
      end
    end
    return nil;
  end;
  temper.string_foreach(this__158.value__800, fn__5089);
  temper.stringbuilder_append(builder__802, "'");
  return nil;
end;
SqlString.constructor = function(this__297, value__806)
  this__297.value__800 = value__806;
  return nil;
end;
SqlString.get.value = function(this__894)
  return this__894.value__800;
end;
changeset = function(tableDef__444, params__445)
  local t_109;
  t_109 = temper.map_constructor(temper.listof());
  return ChangesetImpl__100(tableDef__444, params__445, t_109, temper.listof(), true);
end;
isIdentStart__305 = function(c__635)
  local return__230, t_110, t_111;
  if (c__635 >= 97) then
    t_110 = (c__635 <= 122);
  else
    t_110 = false;
  end
  if t_110 then
    return__230 = true;
  else
    if (c__635 >= 65) then
      t_111 = (c__635 <= 90);
    else
      t_111 = false;
    end
    if t_111 then
      return__230 = true;
    else
      return__230 = (c__635 == 95);
    end
  end
  return return__230;
end;
isIdentPart__306 = function(c__637)
  local return__231;
  if isIdentStart__305(c__637) then
    return__231 = true;
  elseif (c__637 >= 48) then
    return__231 = (c__637 <= 57);
  else
    return__231 = false;
  end
  return return__231;
end;
safeIdentifier = function(name__639)
  local t_112, idx__641, t_113;
  if temper.string_isempty(name__639) then
    temper.bubble();
  end
  idx__641 = 1.0;
  if not isIdentStart__305(temper.string_get(name__639, idx__641)) then
    temper.bubble();
  end
  t_113 = temper.string_next(name__639, idx__641);
  idx__641 = t_113;
  while true do
    if not temper.string_hasindex(name__639, idx__641) then
      break;
    end
    if not isIdentPart__306(temper.string_get(name__639, idx__641)) then
      temper.bubble();
    end
    t_112 = temper.string_next(name__639, idx__641);
    idx__641 = t_112;
  end
  return ValidatedIdentifier__124(name__639);
end;
deleteSql = function(tableDef__534, id__535)
  local b__537;
  b__537 = SqlBuilder();
  b__537:appendSafe('DELETE FROM ');
  b__537:appendSafe(tableDef__534.tableName.sqlValue);
  b__537:appendSafe(' WHERE id = ');
  b__537:appendInt32(id__535);
  return b__537.accumulated;
end;
from = function(tableName__586)
  return Query(tableName__586, temper.listof(), temper.listof(), temper.listof(), temper.null, temper.null);
end;
exports = {};
exports.ChangesetError = ChangesetError;
exports.Changeset = Changeset;
exports.OrderClause = OrderClause;
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
return exports;
