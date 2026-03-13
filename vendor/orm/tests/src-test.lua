local temper = require('temper-core');
local safeIdentifier, TableDef, FieldDef, StringField, IntField, FloatField, BoolField, changeset, from, SqlBuilder, col, SqlInt32, SqlString, countAll, countCol, sumCol, avgCol, minCol, maxCol, unionSql, unionAllSql, intersectSql, exceptSql, subquery, existsSql, update, SqlBoolean, deleteFrom, NullsFirst, NullsLast, ForUpdate, ForShare, local_1107, local_1108, csid__544, userTable__545, sid__546, exports;
safeIdentifier = temper.import('orm/src', 'safeIdentifier');
TableDef = temper.import('orm/src', 'TableDef');
FieldDef = temper.import('orm/src', 'FieldDef');
StringField = temper.import('orm/src', 'StringField');
IntField = temper.import('orm/src', 'IntField');
FloatField = temper.import('orm/src', 'FloatField');
BoolField = temper.import('orm/src', 'BoolField');
changeset = temper.import('orm/src', 'changeset');
from = temper.import('orm/src', 'from');
SqlBuilder = temper.import('orm/src', 'SqlBuilder');
col = temper.import('orm/src', 'col');
SqlInt32 = temper.import('orm/src', 'SqlInt32');
SqlString = temper.import('orm/src', 'SqlString');
countAll = temper.import('orm/src', 'countAll');
countCol = temper.import('orm/src', 'countCol');
sumCol = temper.import('orm/src', 'sumCol');
avgCol = temper.import('orm/src', 'avgCol');
minCol = temper.import('orm/src', 'minCol');
maxCol = temper.import('orm/src', 'maxCol');
unionSql = temper.import('orm/src', 'unionSql');
unionAllSql = temper.import('orm/src', 'unionAllSql');
intersectSql = temper.import('orm/src', 'intersectSql');
exceptSql = temper.import('orm/src', 'exceptSql');
subquery = temper.import('orm/src', 'subquery');
existsSql = temper.import('orm/src', 'existsSql');
update = temper.import('orm/src', 'update');
SqlBoolean = temper.import('orm/src', 'SqlBoolean');
deleteFrom = temper.import('orm/src', 'deleteFrom');
NullsFirst = temper.import('orm/src', 'NullsFirst');
NullsLast = temper.import('orm/src', 'NullsLast');
ForUpdate = temper.import('orm/src', 'ForUpdate');
ForShare = temper.import('orm/src', 'ForShare');
local_1107 = (unpack or table.unpack);
local_1108 = require('luaunit');
local_1108.FAILURE_PREFIX = temper.test_failure_prefix;
Test_ = {};
csid__544 = function(name__689)
  local return__335, t_144, local_145, local_146, local_147;
  local_145, local_146, local_147 = temper.pcall(function()
    t_144 = safeIdentifier(name__689);
    return__335 = t_144;
  end);
  if local_145 then
  else
    return__335 = temper.bubble();
  end
  return return__335;
end;
userTable__545 = function()
  return TableDef(csid__544('users'), temper.listof(FieldDef(csid__544('name'), StringField(), false), FieldDef(csid__544('email'), StringField(), false), FieldDef(csid__544('age'), IntField(), true), FieldDef(csid__544('score'), FloatField(), true), FieldDef(csid__544('active'), BoolField(), true)));
end;
Test_.test_castWhitelistsAllowedFields__1645 = function()
  temper.test('cast whitelists allowed fields', function(test_149)
    local params__693, t_150, t_151, t_152, cs__694, t_153, fn__11172, t_154, fn__11171, t_155, fn__11170, t_156, fn__11169;
    params__693 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com'), temper.pair_constructor('admin', 'true')));
    t_150 = userTable__545();
    t_151 = csid__544('name');
    t_152 = csid__544('email');
    cs__694 = changeset(t_150, params__693):cast(temper.listof(t_151, t_152));
    t_153 = temper.mapped_has(cs__694.changes, 'name');
    fn__11172 = function()
      return 'name should be in changes';
    end;
    temper.test_assert(test_149, t_153, fn__11172);
    t_154 = temper.mapped_has(cs__694.changes, 'email');
    fn__11171 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_149, t_154, fn__11171);
    t_155 = not temper.mapped_has(cs__694.changes, 'admin');
    fn__11170 = function()
      return 'admin must be dropped (not in whitelist)';
    end;
    temper.test_assert(test_149, t_155, fn__11170);
    t_156 = cs__694.isValid;
    fn__11169 = function()
      return 'should still be valid';
    end;
    temper.test_assert(test_149, t_156, fn__11169);
    return nil;
  end);
end;
Test_.test_castIsReplacingNotAdditiveSecondCallResetsWhitelist__1646 = function()
  temper.test('cast is replacing not additive \xe2\x80\x94 second call resets whitelist', function(test_157)
    local params__696, t_158, t_159, cs__697, t_160, fn__11151, t_161, fn__11150;
    params__696 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com')));
    t_158 = userTable__545();
    t_159 = csid__544('name');
    cs__697 = changeset(t_158, params__696):cast(temper.listof(t_159)):cast(temper.listof(csid__544('email')));
    t_160 = not temper.mapped_has(cs__697.changes, 'name');
    fn__11151 = function()
      return 'name must be excluded by second cast';
    end;
    temper.test_assert(test_157, t_160, fn__11151);
    t_161 = temper.mapped_has(cs__697.changes, 'email');
    fn__11150 = function()
      return 'email should be present';
    end;
    temper.test_assert(test_157, t_161, fn__11150);
    return nil;
  end);
end;
Test_.test_castIgnoresEmptyStringValues__1647 = function()
  temper.test('cast ignores empty string values', function(test_162)
    local params__699, t_163, t_164, t_165, cs__700, t_166, fn__11133, t_167, fn__11132;
    params__699 = temper.map_constructor(temper.listof(temper.pair_constructor('name', ''), temper.pair_constructor('email', 'bob@example.com')));
    t_163 = userTable__545();
    t_164 = csid__544('name');
    t_165 = csid__544('email');
    cs__700 = changeset(t_163, params__699):cast(temper.listof(t_164, t_165));
    t_166 = not temper.mapped_has(cs__700.changes, 'name');
    fn__11133 = function()
      return 'empty name should not be in changes';
    end;
    temper.test_assert(test_162, t_166, fn__11133);
    t_167 = temper.mapped_has(cs__700.changes, 'email');
    fn__11132 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_162, t_167, fn__11132);
    return nil;
  end);
end;
Test_.test_validateRequiredPassesWhenFieldPresent__1648 = function()
  temper.test('validateRequired passes when field present', function(test_168)
    local params__702, t_169, t_170, cs__703, t_171, fn__11116, t_172, fn__11115;
    params__702 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_169 = userTable__545();
    t_170 = csid__544('name');
    cs__703 = changeset(t_169, params__702):cast(temper.listof(t_170)):validateRequired(temper.listof(csid__544('name')));
    t_171 = cs__703.isValid;
    fn__11116 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_168, t_171, fn__11116);
    t_172 = (temper.list_length(cs__703.errors) == 0);
    fn__11115 = function()
      return 'no errors expected';
    end;
    temper.test_assert(test_168, t_172, fn__11115);
    return nil;
  end);
end;
Test_.test_validateRequiredFailsWhenFieldMissing__1649 = function()
  temper.test('validateRequired fails when field missing', function(test_173)
    local params__705, t_174, t_175, cs__706, t_176, fn__11093, t_177, fn__11092, t_178, fn__11091;
    params__705 = temper.map_constructor(temper.listof());
    t_174 = userTable__545();
    t_175 = csid__544('name');
    cs__706 = changeset(t_174, params__705):cast(temper.listof(t_175)):validateRequired(temper.listof(csid__544('name')));
    t_176 = not cs__706.isValid;
    fn__11093 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_173, t_176, fn__11093);
    t_177 = (temper.list_length(cs__706.errors) == 1);
    fn__11092 = function()
      return 'should have one error';
    end;
    temper.test_assert(test_173, t_177, fn__11092);
    t_178 = temper.str_eq((temper.list_get(cs__706.errors, 0)).field, 'name');
    fn__11091 = function()
      return 'error should name the field';
    end;
    temper.test_assert(test_173, t_178, fn__11091);
    return nil;
  end);
end;
Test_.test_validateLengthPassesWithinRange__1650 = function()
  temper.test('validateLength passes within range', function(test_179)
    local params__708, t_180, t_181, cs__709, t_182, fn__11080;
    params__708 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_180 = userTable__545();
    t_181 = csid__544('name');
    cs__709 = changeset(t_180, params__708):cast(temper.listof(t_181)):validateLength(csid__544('name'), 2, 50);
    t_182 = cs__709.isValid;
    fn__11080 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_179, t_182, fn__11080);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooShort__1651 = function()
  temper.test('validateLength fails when too short', function(test_183)
    local params__711, t_184, t_185, cs__712, t_186, fn__11068;
    params__711 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'A')));
    t_184 = userTable__545();
    t_185 = csid__544('name');
    cs__712 = changeset(t_184, params__711):cast(temper.listof(t_185)):validateLength(csid__544('name'), 2, 50);
    t_186 = not cs__712.isValid;
    fn__11068 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_183, t_186, fn__11068);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooLong__1652 = function()
  temper.test('validateLength fails when too long', function(test_187)
    local params__714, t_188, t_189, cs__715, t_190, fn__11056;
    params__714 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')));
    t_188 = userTable__545();
    t_189 = csid__544('name');
    cs__715 = changeset(t_188, params__714):cast(temper.listof(t_189)):validateLength(csid__544('name'), 2, 10);
    t_190 = not cs__715.isValid;
    fn__11056 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_187, t_190, fn__11056);
    return nil;
  end);
end;
Test_.test_validateIntPassesForValidInteger__1653 = function()
  temper.test('validateInt passes for valid integer', function(test_191)
    local params__717, t_192, t_193, cs__718, t_194, fn__11045;
    params__717 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '30')));
    t_192 = userTable__545();
    t_193 = csid__544('age');
    cs__718 = changeset(t_192, params__717):cast(temper.listof(t_193)):validateInt(csid__544('age'));
    t_194 = cs__718.isValid;
    fn__11045 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_191, t_194, fn__11045);
    return nil;
  end);
end;
Test_.test_validateIntFailsForNonInteger__1654 = function()
  temper.test('validateInt fails for non-integer', function(test_195)
    local params__720, t_196, t_197, cs__721, t_198, fn__11033;
    params__720 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_196 = userTable__545();
    t_197 = csid__544('age');
    cs__721 = changeset(t_196, params__720):cast(temper.listof(t_197)):validateInt(csid__544('age'));
    t_198 = not cs__721.isValid;
    fn__11033 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_195, t_198, fn__11033);
    return nil;
  end);
end;
Test_.test_validateFloatPassesForValidFloat__1655 = function()
  temper.test('validateFloat passes for valid float', function(test_199)
    local params__723, t_200, t_201, cs__724, t_202, fn__11022;
    params__723 = temper.map_constructor(temper.listof(temper.pair_constructor('score', '9.5')));
    t_200 = userTable__545();
    t_201 = csid__544('score');
    cs__724 = changeset(t_200, params__723):cast(temper.listof(t_201)):validateFloat(csid__544('score'));
    t_202 = cs__724.isValid;
    fn__11022 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_199, t_202, fn__11022);
    return nil;
  end);
end;
Test_.test_validateInt64_passesForValid64_bitInteger__1656 = function()
  temper.test('validateInt64 passes for valid 64-bit integer', function(test_203)
    local params__726, t_204, t_205, cs__727, t_206, fn__11011;
    params__726 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '9999999999')));
    t_204 = userTable__545();
    t_205 = csid__544('age');
    cs__727 = changeset(t_204, params__726):cast(temper.listof(t_205)):validateInt64(csid__544('age'));
    t_206 = cs__727.isValid;
    fn__11011 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_203, t_206, fn__11011);
    return nil;
  end);
end;
Test_.test_validateInt64_failsForNonInteger__1657 = function()
  temper.test('validateInt64 fails for non-integer', function(test_207)
    local params__729, t_208, t_209, cs__730, t_210, fn__10999;
    params__729 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_208 = userTable__545();
    t_209 = csid__544('age');
    cs__730 = changeset(t_208, params__729):cast(temper.listof(t_209)):validateInt64(csid__544('age'));
    t_210 = not cs__730.isValid;
    fn__10999 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_207, t_210, fn__10999);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsTrue1_yesOn__1658 = function()
  temper.test('validateBool accepts true/1/yes/on', function(test_211)
    local fn__10996;
    fn__10996 = function(v__732)
      local params__733, t_212, t_213, cs__734, t_214, fn__10985;
      params__733 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__732)));
      t_212 = userTable__545();
      t_213 = csid__544('active');
      cs__734 = changeset(t_212, params__733):cast(temper.listof(t_213)):validateBool(csid__544('active'));
      t_214 = cs__734.isValid;
      fn__10985 = function()
        return temper.concat('should accept: ', v__732);
      end;
      temper.test_assert(test_211, t_214, fn__10985);
      return nil;
    end;
    temper.list_foreach(temper.listof('true', '1', 'yes', 'on'), fn__10996);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsFalse0_noOff__1659 = function()
  temper.test('validateBool accepts false/0/no/off', function(test_215)
    local fn__10982;
    fn__10982 = function(v__736)
      local params__737, t_216, t_217, cs__738, t_218, fn__10971;
      params__737 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__736)));
      t_216 = userTable__545();
      t_217 = csid__544('active');
      cs__738 = changeset(t_216, params__737):cast(temper.listof(t_217)):validateBool(csid__544('active'));
      t_218 = cs__738.isValid;
      fn__10971 = function()
        return temper.concat('should accept: ', v__736);
      end;
      temper.test_assert(test_215, t_218, fn__10971);
      return nil;
    end;
    temper.list_foreach(temper.listof('false', '0', 'no', 'off'), fn__10982);
    return nil;
  end);
end;
Test_.test_validateBoolRejectsAmbiguousValues__1660 = function()
  temper.test('validateBool rejects ambiguous values', function(test_219)
    local fn__10968;
    fn__10968 = function(v__740)
      local params__741, t_220, t_221, cs__742, t_222, fn__10956;
      params__741 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__740)));
      t_220 = userTable__545();
      t_221 = csid__544('active');
      cs__742 = changeset(t_220, params__741):cast(temper.listof(t_221)):validateBool(csid__544('active'));
      t_222 = not cs__742.isValid;
      fn__10956 = function()
        return temper.concat('should reject ambiguous: ', v__740);
      end;
      temper.test_assert(test_219, t_222, fn__10956);
      return nil;
    end;
    temper.list_foreach(temper.listof('TRUE', 'Yes', 'maybe', '2', 'enabled'), fn__10968);
    return nil;
  end);
end;
Test_.test_toInsertSqlEscapesBobbyTables__1661 = function()
  temper.test('toInsertSql escapes Bobby Tables', function(test_223)
    local t_224, params__744, t_225, t_226, t_227, cs__745, sqlFrag__746, local_228, local_229, local_230, s__747, t_232, fn__10940;
    params__744 = temper.map_constructor(temper.listof(temper.pair_constructor('name', "Robert'); DROP TABLE users;--"), temper.pair_constructor('email', 'bobby@evil.com')));
    t_225 = userTable__545();
    t_226 = csid__544('name');
    t_227 = csid__544('email');
    cs__745 = changeset(t_225, params__744):cast(temper.listof(t_226, t_227)):validateRequired(temper.listof(csid__544('name'), csid__544('email')));
    local_228, local_229, local_230 = temper.pcall(function()
      t_224 = cs__745:toInsertSql();
      sqlFrag__746 = t_224;
    end);
    if local_228 then
    else
      sqlFrag__746 = temper.bubble();
    end
    s__747 = sqlFrag__746:toString();
    t_232 = temper.is_string_index(temper.string_indexof(s__747, "''"));
    fn__10940 = function()
      return temper.concat('single quote must be doubled: ', s__747);
    end;
    temper.test_assert(test_223, t_232, fn__10940);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForStringField__1662 = function()
  temper.test('toInsertSql produces correct SQL for string field', function(test_233)
    local t_234, params__749, t_235, t_236, t_237, cs__750, sqlFrag__751, local_238, local_239, local_240, s__752, t_242, fn__10920, t_243, fn__10919;
    params__749 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'a@example.com')));
    t_235 = userTable__545();
    t_236 = csid__544('name');
    t_237 = csid__544('email');
    cs__750 = changeset(t_235, params__749):cast(temper.listof(t_236, t_237)):validateRequired(temper.listof(csid__544('name'), csid__544('email')));
    local_238, local_239, local_240 = temper.pcall(function()
      t_234 = cs__750:toInsertSql();
      sqlFrag__751 = t_234;
    end);
    if local_238 then
    else
      sqlFrag__751 = temper.bubble();
    end
    s__752 = sqlFrag__751:toString();
    t_242 = temper.is_string_index(temper.string_indexof(s__752, 'INSERT INTO users'));
    fn__10920 = function()
      return temper.concat('has INSERT INTO: ', s__752);
    end;
    temper.test_assert(test_233, t_242, fn__10920);
    t_243 = temper.is_string_index(temper.string_indexof(s__752, "'Alice'"));
    fn__10919 = function()
      return temper.concat('has quoted name: ', s__752);
    end;
    temper.test_assert(test_233, t_243, fn__10919);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForIntField__1663 = function()
  temper.test('toInsertSql produces correct SQL for int field', function(test_244)
    local t_245, params__754, t_246, t_247, t_248, t_249, cs__755, sqlFrag__756, local_250, local_251, local_252, s__757, t_254, fn__10901;
    params__754 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob'), temper.pair_constructor('email', 'b@example.com'), temper.pair_constructor('age', '25')));
    t_246 = userTable__545();
    t_247 = csid__544('name');
    t_248 = csid__544('email');
    t_249 = csid__544('age');
    cs__755 = changeset(t_246, params__754):cast(temper.listof(t_247, t_248, t_249)):validateRequired(temper.listof(csid__544('name'), csid__544('email')));
    local_250, local_251, local_252 = temper.pcall(function()
      t_245 = cs__755:toInsertSql();
      sqlFrag__756 = t_245;
    end);
    if local_250 then
    else
      sqlFrag__756 = temper.bubble();
    end
    s__757 = sqlFrag__756:toString();
    t_254 = temper.is_string_index(temper.string_indexof(s__757, '25'));
    fn__10901 = function()
      return temper.concat('age rendered unquoted: ', s__757);
    end;
    temper.test_assert(test_244, t_254, fn__10901);
    return nil;
  end);
end;
Test_.test_toInsertSqlBubblesOnInvalidChangeset__1664 = function()
  temper.test('toInsertSql bubbles on invalid changeset', function(test_255)
    local params__759, t_256, t_257, cs__760, didBubble__761, local_258, local_259, local_260, fn__10892;
    params__759 = temper.map_constructor(temper.listof());
    t_256 = userTable__545();
    t_257 = csid__544('name');
    cs__760 = changeset(t_256, params__759):cast(temper.listof(t_257)):validateRequired(temper.listof(csid__544('name')));
    local_258, local_259, local_260 = temper.pcall(function()
      cs__760:toInsertSql();
      didBubble__761 = false;
    end);
    if local_258 then
    else
      didBubble__761 = true;
    end
    fn__10892 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_255, didBubble__761, fn__10892);
    return nil;
  end);
end;
Test_.test_toInsertSqlEnforcesNonNullableFieldsIndependentlyOfIsValid__1665 = function()
  temper.test('toInsertSql enforces non-nullable fields independently of isValid', function(test_262)
    local strictTable__763, params__764, t_263, cs__765, t_264, fn__10874, didBubble__766, local_265, local_266, local_267, fn__10873;
    strictTable__763 = TableDef(csid__544('posts'), temper.listof(FieldDef(csid__544('title'), StringField(), false), FieldDef(csid__544('body'), StringField(), true)));
    params__764 = temper.map_constructor(temper.listof(temper.pair_constructor('body', 'hello')));
    t_263 = csid__544('body');
    cs__765 = changeset(strictTable__763, params__764):cast(temper.listof(t_263));
    t_264 = cs__765.isValid;
    fn__10874 = function()
      return 'changeset should appear valid (no explicit validation run)';
    end;
    temper.test_assert(test_262, t_264, fn__10874);
    local_265, local_266, local_267 = temper.pcall(function()
      cs__765:toInsertSql();
      didBubble__766 = false;
    end);
    if local_265 then
    else
      didBubble__766 = true;
    end
    fn__10873 = function()
      return 'toInsertSql should enforce nullable regardless of isValid';
    end;
    temper.test_assert(test_262, didBubble__766, fn__10873);
    return nil;
  end);
end;
Test_.test_toUpdateSqlProducesCorrectSql__1666 = function()
  temper.test('toUpdateSql produces correct SQL', function(test_269)
    local t_270, params__768, t_271, t_272, cs__769, sqlFrag__770, local_273, local_274, local_275, s__771, t_277, fn__10861;
    params__768 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob')));
    t_271 = userTable__545();
    t_272 = csid__544('name');
    cs__769 = changeset(t_271, params__768):cast(temper.listof(t_272)):validateRequired(temper.listof(csid__544('name')));
    local_273, local_274, local_275 = temper.pcall(function()
      t_270 = cs__769:toUpdateSql(42);
      sqlFrag__770 = t_270;
    end);
    if local_273 then
    else
      sqlFrag__770 = temper.bubble();
    end
    s__771 = sqlFrag__770:toString();
    t_277 = temper.str_eq(s__771, "UPDATE users SET name = 'Bob' WHERE id = 42");
    fn__10861 = function()
      return temper.concat('got: ', s__771);
    end;
    temper.test_assert(test_269, t_277, fn__10861);
    return nil;
  end);
end;
Test_.test_toUpdateSqlBubblesOnInvalidChangeset__1667 = function()
  temper.test('toUpdateSql bubbles on invalid changeset', function(test_278)
    local params__773, t_279, t_280, cs__774, didBubble__775, local_281, local_282, local_283, fn__10852;
    params__773 = temper.map_constructor(temper.listof());
    t_279 = userTable__545();
    t_280 = csid__544('name');
    cs__774 = changeset(t_279, params__773):cast(temper.listof(t_280)):validateRequired(temper.listof(csid__544('name')));
    local_281, local_282, local_283 = temper.pcall(function()
      cs__774:toUpdateSql(1);
      didBubble__775 = false;
    end);
    if local_281 then
    else
      didBubble__775 = true;
    end
    fn__10852 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_278, didBubble__775, fn__10852);
    return nil;
  end);
end;
sid__546 = function(name__1120)
  local return__465, t_285, local_286, local_287, local_288;
  local_286, local_287, local_288 = temper.pcall(function()
    t_285 = safeIdentifier(name__1120);
    return__465 = t_285;
  end);
  if local_286 then
  else
    return__465 = temper.bubble();
  end
  return return__465;
end;
Test_.test_bareFromProducesSelect__1749 = function()
  temper.test('bare from produces SELECT *', function(test_290)
    local q__1123, t_291, fn__10332;
    q__1123 = from(sid__546('users'));
    t_291 = temper.str_eq(q__1123:toSql():toString(), 'SELECT * FROM users');
    fn__10332 = function()
      return 'bare query';
    end;
    temper.test_assert(test_290, t_291, fn__10332);
    return nil;
  end);
end;
Test_.test_selectRestrictsColumns__1750 = function()
  temper.test('select restricts columns', function(test_292)
    local t_293, t_294, t_295, q__1125, t_296, fn__10322;
    t_293 = sid__546('users');
    t_294 = sid__546('id');
    t_295 = sid__546('name');
    q__1125 = from(t_293):select(temper.listof(t_294, t_295));
    t_296 = temper.str_eq(q__1125:toSql():toString(), 'SELECT id, name FROM users');
    fn__10322 = function()
      return 'select columns';
    end;
    temper.test_assert(test_292, t_296, fn__10322);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithIntValue__1751 = function()
  temper.test('where adds condition with int value', function(test_297)
    local t_298, t_299, t_300, q__1127, t_301, fn__10310;
    t_298 = sid__546('users');
    t_299 = SqlBuilder();
    t_299:appendSafe('age > ');
    t_299:appendInt32(18);
    t_300 = t_299.accumulated;
    q__1127 = from(t_298):where(t_300);
    t_301 = temper.str_eq(q__1127:toSql():toString(), 'SELECT * FROM users WHERE age > 18');
    fn__10310 = function()
      return 'where int';
    end;
    temper.test_assert(test_297, t_301, fn__10310);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithBoolValue__1753 = function()
  temper.test('where adds condition with bool value', function(test_302)
    local t_303, t_304, t_305, q__1129, t_306, fn__10298;
    t_303 = sid__546('users');
    t_304 = SqlBuilder();
    t_304:appendSafe('active = ');
    t_304:appendBoolean(true);
    t_305 = t_304.accumulated;
    q__1129 = from(t_303):where(t_305);
    t_306 = temper.str_eq(q__1129:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE');
    fn__10298 = function()
      return 'where bool';
    end;
    temper.test_assert(test_302, t_306, fn__10298);
    return nil;
  end);
end;
Test_.test_chainedWhereUsesAnd__1755 = function()
  temper.test('chained where uses AND', function(test_307)
    local t_308, t_309, t_310, t_311, t_312, q__1131, t_313, fn__10281;
    t_308 = sid__546('users');
    t_309 = SqlBuilder();
    t_309:appendSafe('age > ');
    t_309:appendInt32(18);
    t_310 = t_309.accumulated;
    t_311 = from(t_308):where(t_310);
    t_312 = SqlBuilder();
    t_312:appendSafe('active = ');
    t_312:appendBoolean(true);
    q__1131 = t_311:where(t_312.accumulated);
    t_313 = temper.str_eq(q__1131:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE');
    fn__10281 = function()
      return 'chained where';
    end;
    temper.test_assert(test_307, t_313, fn__10281);
    return nil;
  end);
end;
Test_.test_orderByAsc__1758 = function()
  temper.test('orderBy ASC', function(test_314)
    local t_315, t_316, q__1133, t_317, fn__10272;
    t_315 = sid__546('users');
    t_316 = sid__546('name');
    q__1133 = from(t_315):orderBy(t_316, true);
    t_317 = temper.str_eq(q__1133:toSql():toString(), 'SELECT * FROM users ORDER BY name ASC');
    fn__10272 = function()
      return 'order asc';
    end;
    temper.test_assert(test_314, t_317, fn__10272);
    return nil;
  end);
end;
Test_.test_orderByDesc__1759 = function()
  temper.test('orderBy DESC', function(test_318)
    local t_319, t_320, q__1135, t_321, fn__10263;
    t_319 = sid__546('users');
    t_320 = sid__546('created_at');
    q__1135 = from(t_319):orderBy(t_320, false);
    t_321 = temper.str_eq(q__1135:toSql():toString(), 'SELECT * FROM users ORDER BY created_at DESC');
    fn__10263 = function()
      return 'order desc';
    end;
    temper.test_assert(test_318, t_321, fn__10263);
    return nil;
  end);
end;
Test_.test_limitAndOffset__1760 = function()
  temper.test('limit and offset', function(test_322)
    local t_323, t_324, q__1137, local_325, local_326, local_327, t_329, fn__10256;
    local_325, local_326, local_327 = temper.pcall(function()
      t_323 = from(sid__546('users')):limit(10);
      t_324 = t_323:offset(20);
      q__1137 = t_324;
    end);
    if local_325 then
    else
      q__1137 = temper.bubble();
    end
    t_329 = temper.str_eq(q__1137:toSql():toString(), 'SELECT * FROM users LIMIT 10 OFFSET 20');
    fn__10256 = function()
      return 'limit/offset';
    end;
    temper.test_assert(test_322, t_329, fn__10256);
    return nil;
  end);
end;
Test_.test_limitBubblesOnNegative__1761 = function()
  temper.test('limit bubbles on negative', function(test_330)
    local didBubble__1139, local_331, local_332, local_333, fn__10252;
    local_331, local_332, local_333 = temper.pcall(function()
      from(sid__546('users')):limit(-1);
      didBubble__1139 = false;
    end);
    if local_331 then
    else
      didBubble__1139 = true;
    end
    fn__10252 = function()
      return 'negative limit should bubble';
    end;
    temper.test_assert(test_330, didBubble__1139, fn__10252);
    return nil;
  end);
end;
Test_.test_offsetBubblesOnNegative__1762 = function()
  temper.test('offset bubbles on negative', function(test_335)
    local didBubble__1141, local_336, local_337, local_338, fn__10248;
    local_336, local_337, local_338 = temper.pcall(function()
      from(sid__546('users')):offset(-1);
      didBubble__1141 = false;
    end);
    if local_336 then
    else
      didBubble__1141 = true;
    end
    fn__10248 = function()
      return 'negative offset should bubble';
    end;
    temper.test_assert(test_335, didBubble__1141, fn__10248);
    return nil;
  end);
end;
Test_.test_complexComposedQuery__1763 = function()
  temper.test('complex composed query', function(test_340)
    local t_341, t_342, t_343, t_344, t_345, t_346, t_347, t_348, t_349, t_350, minAge__1143, q__1144, local_351, local_352, local_353, t_355, fn__10225;
    minAge__1143 = 21;
    local_351, local_352, local_353 = temper.pcall(function()
      t_341 = sid__546('users');
      t_342 = sid__546('id');
      t_343 = sid__546('name');
      t_344 = sid__546('email');
      t_345 = from(t_341):select(temper.listof(t_342, t_343, t_344));
      t_346 = SqlBuilder();
      t_346:appendSafe('age >= ');
      t_346:appendInt32(21);
      t_347 = t_345:where(t_346.accumulated);
      t_348 = SqlBuilder();
      t_348:appendSafe('active = ');
      t_348:appendBoolean(true);
      t_349 = t_347:where(t_348.accumulated):orderBy(sid__546('name'), true):limit(25);
      t_350 = t_349:offset(0);
      q__1144 = t_350;
    end);
    if local_351 then
    else
      q__1144 = temper.bubble();
    end
    t_355 = temper.str_eq(q__1144:toSql():toString(), 'SELECT id, name, email FROM users WHERE age >= 21 AND active = TRUE ORDER BY name ASC LIMIT 25 OFFSET 0');
    fn__10225 = function()
      return 'complex query';
    end;
    temper.test_assert(test_340, t_355, fn__10225);
    return nil;
  end);
end;
Test_.test_safeToSqlAppliesDefaultLimitWhenNoneSet__1766 = function()
  temper.test('safeToSql applies default limit when none set', function(test_356)
    local t_357, t_358, q__1146, local_359, local_360, local_361, s__1147, t_363, fn__10219;
    q__1146 = from(sid__546('users'));
    local_359, local_360, local_361 = temper.pcall(function()
      t_357 = q__1146:safeToSql(100);
      t_358 = t_357;
    end);
    if local_359 then
    else
      t_358 = temper.bubble();
    end
    s__1147 = t_358:toString();
    t_363 = temper.str_eq(s__1147, 'SELECT * FROM users LIMIT 100');
    fn__10219 = function()
      return temper.concat('should have limit: ', s__1147);
    end;
    temper.test_assert(test_356, t_363, fn__10219);
    return nil;
  end);
end;
Test_.test_safeToSqlRespectsExplicitLimit__1767 = function()
  temper.test('safeToSql respects explicit limit', function(test_364)
    local t_365, t_366, t_367, q__1149, local_368, local_369, local_370, local_372, local_373, local_374, s__1150, t_376, fn__10213;
    local_368, local_369, local_370 = temper.pcall(function()
      t_365 = from(sid__546('users')):limit(5);
      q__1149 = t_365;
    end);
    if local_368 then
    else
      q__1149 = temper.bubble();
    end
    local_372, local_373, local_374 = temper.pcall(function()
      t_366 = q__1149:safeToSql(100);
      t_367 = t_366;
    end);
    if local_372 then
    else
      t_367 = temper.bubble();
    end
    s__1150 = t_367:toString();
    t_376 = temper.str_eq(s__1150, 'SELECT * FROM users LIMIT 5');
    fn__10213 = function()
      return temper.concat('explicit limit preserved: ', s__1150);
    end;
    temper.test_assert(test_364, t_376, fn__10213);
    return nil;
  end);
end;
Test_.test_safeToSqlBubblesOnNegativeDefaultLimit__1768 = function()
  temper.test('safeToSql bubbles on negative defaultLimit', function(test_377)
    local didBubble__1152, local_378, local_379, local_380, fn__10209;
    local_378, local_379, local_380 = temper.pcall(function()
      from(sid__546('users')):safeToSql(-1);
      didBubble__1152 = false;
    end);
    if local_378 then
    else
      didBubble__1152 = true;
    end
    fn__10209 = function()
      return 'negative defaultLimit should bubble';
    end;
    temper.test_assert(test_377, didBubble__1152, fn__10209);
    return nil;
  end);
end;
Test_.test_whereWithInjectionAttemptInStringValueIsEscaped__1769 = function()
  temper.test('where with injection attempt in string value is escaped', function(test_382)
    local evil__1154, t_383, t_384, t_385, q__1155, s__1156, t_386, fn__10192, t_387, fn__10191;
    evil__1154 = "'; DROP TABLE users; --";
    t_383 = sid__546('users');
    t_384 = SqlBuilder();
    t_384:appendSafe('name = ');
    t_384:appendString("'; DROP TABLE users; --");
    t_385 = t_384.accumulated;
    q__1155 = from(t_383):where(t_385);
    s__1156 = q__1155:toSql():toString();
    t_386 = temper.is_string_index(temper.string_indexof(s__1156, "''"));
    fn__10192 = function()
      return temper.concat('quotes must be doubled: ', s__1156);
    end;
    temper.test_assert(test_382, t_386, fn__10192);
    t_387 = temper.is_string_index(temper.string_indexof(s__1156, 'SELECT * FROM users WHERE name ='));
    fn__10191 = function()
      return temper.concat('structure intact: ', s__1156);
    end;
    temper.test_assert(test_382, t_387, fn__10191);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsUserSuppliedTableNameWithMetacharacters__1771 = function()
  temper.test('safeIdentifier rejects user-supplied table name with metacharacters', function(test_388)
    local attack__1158, didBubble__1159, local_389, local_390, local_391, fn__10188;
    attack__1158 = 'users; DROP TABLE users; --';
    local_389, local_390, local_391 = temper.pcall(function()
      safeIdentifier('users; DROP TABLE users; --');
      didBubble__1159 = false;
    end);
    if local_389 then
    else
      didBubble__1159 = true;
    end
    fn__10188 = function()
      return 'metacharacter-containing name must be rejected at construction';
    end;
    temper.test_assert(test_388, didBubble__1159, fn__10188);
    return nil;
  end);
end;
Test_.test_innerJoinProducesInnerJoin__1772 = function()
  temper.test('innerJoin produces INNER JOIN', function(test_393)
    local t_394, t_395, t_396, t_397, q__1161, t_398, fn__10176;
    t_394 = sid__546('users');
    t_395 = sid__546('orders');
    t_396 = SqlBuilder();
    t_396:appendSafe('users.id = orders.user_id');
    t_397 = t_396.accumulated;
    q__1161 = from(t_394):innerJoin(t_395, t_397);
    t_398 = temper.str_eq(q__1161:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id');
    fn__10176 = function()
      return 'inner join';
    end;
    temper.test_assert(test_393, t_398, fn__10176);
    return nil;
  end);
end;
Test_.test_leftJoinProducesLeftJoin__1774 = function()
  temper.test('leftJoin produces LEFT JOIN', function(test_399)
    local t_400, t_401, t_402, t_403, q__1163, t_404, fn__10164;
    t_400 = sid__546('users');
    t_401 = sid__546('profiles');
    t_402 = SqlBuilder();
    t_402:appendSafe('users.id = profiles.user_id');
    t_403 = t_402.accumulated;
    q__1163 = from(t_400):leftJoin(t_401, t_403);
    t_404 = temper.str_eq(q__1163:toSql():toString(), 'SELECT * FROM users LEFT JOIN profiles ON users.id = profiles.user_id');
    fn__10164 = function()
      return 'left join';
    end;
    temper.test_assert(test_399, t_404, fn__10164);
    return nil;
  end);
end;
Test_.test_rightJoinProducesRightJoin__1776 = function()
  temper.test('rightJoin produces RIGHT JOIN', function(test_405)
    local t_406, t_407, t_408, t_409, q__1165, t_410, fn__10152;
    t_406 = sid__546('orders');
    t_407 = sid__546('users');
    t_408 = SqlBuilder();
    t_408:appendSafe('orders.user_id = users.id');
    t_409 = t_408.accumulated;
    q__1165 = from(t_406):rightJoin(t_407, t_409);
    t_410 = temper.str_eq(q__1165:toSql():toString(), 'SELECT * FROM orders RIGHT JOIN users ON orders.user_id = users.id');
    fn__10152 = function()
      return 'right join';
    end;
    temper.test_assert(test_405, t_410, fn__10152);
    return nil;
  end);
end;
Test_.test_fullJoinProducesFullOuterJoin__1778 = function()
  temper.test('fullJoin produces FULL OUTER JOIN', function(test_411)
    local t_412, t_413, t_414, t_415, q__1167, t_416, fn__10140;
    t_412 = sid__546('users');
    t_413 = sid__546('orders');
    t_414 = SqlBuilder();
    t_414:appendSafe('users.id = orders.user_id');
    t_415 = t_414.accumulated;
    q__1167 = from(t_412):fullJoin(t_413, t_415);
    t_416 = temper.str_eq(q__1167:toSql():toString(), 'SELECT * FROM users FULL OUTER JOIN orders ON users.id = orders.user_id');
    fn__10140 = function()
      return 'full join';
    end;
    temper.test_assert(test_411, t_416, fn__10140);
    return nil;
  end);
end;
Test_.test_chainedJoins__1780 = function()
  temper.test('chained joins', function(test_417)
    local t_418, t_419, t_420, t_421, t_422, t_423, t_424, q__1169, t_425, fn__10123;
    t_418 = sid__546('users');
    t_419 = sid__546('orders');
    t_420 = SqlBuilder();
    t_420:appendSafe('users.id = orders.user_id');
    t_421 = t_420.accumulated;
    t_422 = from(t_418):innerJoin(t_419, t_421);
    t_423 = sid__546('profiles');
    t_424 = SqlBuilder();
    t_424:appendSafe('users.id = profiles.user_id');
    q__1169 = t_422:leftJoin(t_423, t_424.accumulated);
    t_425 = temper.str_eq(q__1169:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id LEFT JOIN profiles ON users.id = profiles.user_id');
    fn__10123 = function()
      return 'chained joins';
    end;
    temper.test_assert(test_417, t_425, fn__10123);
    return nil;
  end);
end;
Test_.test_joinWithWhereAndOrderBy__1783 = function()
  temper.test('join with where and orderBy', function(test_426)
    local t_427, t_428, t_429, t_430, t_431, t_432, t_433, q__1171, local_434, local_435, local_436, t_438, fn__10104;
    local_434, local_435, local_436 = temper.pcall(function()
      t_427 = sid__546('users');
      t_428 = sid__546('orders');
      t_429 = SqlBuilder();
      t_429:appendSafe('users.id = orders.user_id');
      t_430 = t_429.accumulated;
      t_431 = from(t_427):innerJoin(t_428, t_430);
      t_432 = SqlBuilder();
      t_432:appendSafe('orders.total > ');
      t_432:appendInt32(100);
      t_433 = t_431:where(t_432.accumulated):orderBy(sid__546('name'), true):limit(10);
      q__1171 = t_433;
    end);
    if local_434 then
    else
      q__1171 = temper.bubble();
    end
    t_438 = temper.str_eq(q__1171:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id WHERE orders.total > 100 ORDER BY name ASC LIMIT 10');
    fn__10104 = function()
      return 'join with where/order/limit';
    end;
    temper.test_assert(test_426, t_438, fn__10104);
    return nil;
  end);
end;
Test_.test_colHelperProducesQualifiedReference__1786 = function()
  temper.test('col helper produces qualified reference', function(test_439)
    local c__1173, t_440, fn__10096;
    c__1173 = col(sid__546('users'), sid__546('id'));
    t_440 = temper.str_eq(c__1173:toString(), 'users.id');
    fn__10096 = function()
      return 'col helper';
    end;
    temper.test_assert(test_439, t_440, fn__10096);
    return nil;
  end);
end;
Test_.test_joinWithColHelper__1787 = function()
  temper.test('join with col helper', function(test_441)
    local onCond__1175, b__1176, t_442, t_443, t_444, q__1177, t_445, fn__10076;
    onCond__1175 = col(sid__546('users'), sid__546('id'));
    b__1176 = SqlBuilder();
    b__1176:appendFragment(onCond__1175);
    b__1176:appendSafe(' = ');
    b__1176:appendFragment(col(sid__546('orders'), sid__546('user_id')));
    t_442 = sid__546('users');
    t_443 = sid__546('orders');
    t_444 = b__1176.accumulated;
    q__1177 = from(t_442):innerJoin(t_443, t_444);
    t_445 = temper.str_eq(q__1177:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id');
    fn__10076 = function()
      return 'join with col';
    end;
    temper.test_assert(test_441, t_445, fn__10076);
    return nil;
  end);
end;
Test_.test_orWhereBasic__1788 = function()
  temper.test('orWhere basic', function(test_446)
    local t_447, t_448, t_449, q__1179, t_450, fn__10064;
    t_447 = sid__546('users');
    t_448 = SqlBuilder();
    t_448:appendSafe('status = ');
    t_448:appendString('active');
    t_449 = t_448.accumulated;
    q__1179 = from(t_447):orWhere(t_449);
    t_450 = temper.str_eq(q__1179:toSql():toString(), "SELECT * FROM users WHERE status = 'active'");
    fn__10064 = function()
      return 'orWhere basic';
    end;
    temper.test_assert(test_446, t_450, fn__10064);
    return nil;
  end);
end;
Test_.test_whereThenOrWhere__1790 = function()
  temper.test('where then orWhere', function(test_451)
    local t_452, t_453, t_454, t_455, t_456, q__1181, t_457, fn__10047;
    t_452 = sid__546('users');
    t_453 = SqlBuilder();
    t_453:appendSafe('age > ');
    t_453:appendInt32(18);
    t_454 = t_453.accumulated;
    t_455 = from(t_452):where(t_454);
    t_456 = SqlBuilder();
    t_456:appendSafe('vip = ');
    t_456:appendBoolean(true);
    q__1181 = t_455:orWhere(t_456.accumulated);
    t_457 = temper.str_eq(q__1181:toSql():toString(), 'SELECT * FROM users WHERE age > 18 OR vip = TRUE');
    fn__10047 = function()
      return 'where then orWhere';
    end;
    temper.test_assert(test_451, t_457, fn__10047);
    return nil;
  end);
end;
Test_.test_multipleOrWhere__1793 = function()
  temper.test('multiple orWhere', function(test_458)
    local t_459, t_460, t_461, t_462, t_463, t_464, t_465, q__1183, t_466, fn__10025;
    t_459 = sid__546('users');
    t_460 = SqlBuilder();
    t_460:appendSafe('active = ');
    t_460:appendBoolean(true);
    t_461 = t_460.accumulated;
    t_462 = from(t_459):where(t_461);
    t_463 = SqlBuilder();
    t_463:appendSafe('role = ');
    t_463:appendString('admin');
    t_464 = t_462:orWhere(t_463.accumulated);
    t_465 = SqlBuilder();
    t_465:appendSafe('role = ');
    t_465:appendString('moderator');
    q__1183 = t_464:orWhere(t_465.accumulated);
    t_466 = temper.str_eq(q__1183:toSql():toString(), "SELECT * FROM users WHERE active = TRUE OR role = 'admin' OR role = 'moderator'");
    fn__10025 = function()
      return 'multiple orWhere';
    end;
    temper.test_assert(test_458, t_466, fn__10025);
    return nil;
  end);
end;
Test_.test_mixedWhereAndOrWhere__1797 = function()
  temper.test('mixed where and orWhere', function(test_467)
    local t_468, t_469, t_470, t_471, t_472, t_473, t_474, q__1185, t_475, fn__10003;
    t_468 = sid__546('users');
    t_469 = SqlBuilder();
    t_469:appendSafe('age > ');
    t_469:appendInt32(18);
    t_470 = t_469.accumulated;
    t_471 = from(t_468):where(t_470);
    t_472 = SqlBuilder();
    t_472:appendSafe('active = ');
    t_472:appendBoolean(true);
    t_473 = t_471:where(t_472.accumulated);
    t_474 = SqlBuilder();
    t_474:appendSafe('vip = ');
    t_474:appendBoolean(true);
    q__1185 = t_473:orWhere(t_474.accumulated);
    t_475 = temper.str_eq(q__1185:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE OR vip = TRUE');
    fn__10003 = function()
      return 'mixed where and orWhere';
    end;
    temper.test_assert(test_467, t_475, fn__10003);
    return nil;
  end);
end;
Test_.test_whereNull__1801 = function()
  temper.test('whereNull', function(test_476)
    local t_477, t_478, q__1187, t_479, fn__9994;
    t_477 = sid__546('users');
    t_478 = sid__546('deleted_at');
    q__1187 = from(t_477):whereNull(t_478);
    t_479 = temper.str_eq(q__1187:toSql():toString(), 'SELECT * FROM users WHERE deleted_at IS NULL');
    fn__9994 = function()
      return 'whereNull';
    end;
    temper.test_assert(test_476, t_479, fn__9994);
    return nil;
  end);
end;
Test_.test_whereNotNull__1802 = function()
  temper.test('whereNotNull', function(test_480)
    local t_481, t_482, q__1189, t_483, fn__9985;
    t_481 = sid__546('users');
    t_482 = sid__546('email');
    q__1189 = from(t_481):whereNotNull(t_482);
    t_483 = temper.str_eq(q__1189:toSql():toString(), 'SELECT * FROM users WHERE email IS NOT NULL');
    fn__9985 = function()
      return 'whereNotNull';
    end;
    temper.test_assert(test_480, t_483, fn__9985);
    return nil;
  end);
end;
Test_.test_whereNullChainedWithWhere__1803 = function()
  temper.test('whereNull chained with where', function(test_484)
    local t_485, t_486, t_487, q__1191, t_488, fn__9971;
    t_485 = sid__546('users');
    t_486 = SqlBuilder();
    t_486:appendSafe('active = ');
    t_486:appendBoolean(true);
    t_487 = t_486.accumulated;
    q__1191 = from(t_485):where(t_487):whereNull(sid__546('deleted_at'));
    t_488 = temper.str_eq(q__1191:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE AND deleted_at IS NULL');
    fn__9971 = function()
      return 'whereNull chained';
    end;
    temper.test_assert(test_484, t_488, fn__9971);
    return nil;
  end);
end;
Test_.test_whereNotNullChainedWithOrWhere__1805 = function()
  temper.test('whereNotNull chained with orWhere', function(test_489)
    local t_490, t_491, t_492, t_493, q__1193, t_494, fn__9957;
    t_490 = sid__546('users');
    t_491 = sid__546('deleted_at');
    t_492 = from(t_490):whereNull(t_491);
    t_493 = SqlBuilder();
    t_493:appendSafe('role = ');
    t_493:appendString('admin');
    q__1193 = t_492:orWhere(t_493.accumulated);
    t_494 = temper.str_eq(q__1193:toSql():toString(), "SELECT * FROM users WHERE deleted_at IS NULL OR role = 'admin'");
    fn__9957 = function()
      return 'whereNotNull with orWhere';
    end;
    temper.test_assert(test_489, t_494, fn__9957);
    return nil;
  end);
end;
Test_.test_whereInWithIntValues__1807 = function()
  temper.test('whereIn with int values', function(test_495)
    local t_496, t_497, t_498, t_499, t_500, q__1195, t_501, fn__9945;
    t_496 = sid__546('users');
    t_497 = sid__546('id');
    t_498 = SqlInt32(1);
    t_499 = SqlInt32(2);
    t_500 = SqlInt32(3);
    q__1195 = from(t_496):whereIn(t_497, temper.listof(t_498, t_499, t_500));
    t_501 = temper.str_eq(q__1195:toSql():toString(), 'SELECT * FROM users WHERE id IN (1, 2, 3)');
    fn__9945 = function()
      return 'whereIn ints';
    end;
    temper.test_assert(test_495, t_501, fn__9945);
    return nil;
  end);
end;
Test_.test_whereInWithStringValuesEscaping__1808 = function()
  temper.test('whereIn with string values escaping', function(test_502)
    local t_503, t_504, t_505, t_506, q__1197, t_507, fn__9934;
    t_503 = sid__546('users');
    t_504 = sid__546('name');
    t_505 = SqlString('Alice');
    t_506 = SqlString("Bob's");
    q__1197 = from(t_503):whereIn(t_504, temper.listof(t_505, t_506));
    t_507 = temper.str_eq(q__1197:toSql():toString(), "SELECT * FROM users WHERE name IN ('Alice', 'Bob''s')");
    fn__9934 = function()
      return 'whereIn strings';
    end;
    temper.test_assert(test_502, t_507, fn__9934);
    return nil;
  end);
end;
Test_.test_whereInWithEmptyListProduces1_0__1809 = function()
  temper.test('whereIn with empty list produces 1=0', function(test_508)
    local t_509, t_510, q__1199, t_511, fn__9925;
    t_509 = sid__546('users');
    t_510 = sid__546('id');
    q__1199 = from(t_509):whereIn(t_510, temper.listof());
    t_511 = temper.str_eq(q__1199:toSql():toString(), 'SELECT * FROM users WHERE 1 = 0');
    fn__9925 = function()
      return 'whereIn empty';
    end;
    temper.test_assert(test_508, t_511, fn__9925);
    return nil;
  end);
end;
Test_.test_whereInChained__1810 = function()
  temper.test('whereIn chained', function(test_512)
    local t_513, t_514, t_515, q__1201, t_516, fn__9909;
    t_513 = sid__546('users');
    t_514 = SqlBuilder();
    t_514:appendSafe('active = ');
    t_514:appendBoolean(true);
    t_515 = t_514.accumulated;
    q__1201 = from(t_513):where(t_515):whereIn(sid__546('role'), temper.listof(SqlString('admin'), SqlString('user')));
    t_516 = temper.str_eq(q__1201:toSql():toString(), "SELECT * FROM users WHERE active = TRUE AND role IN ('admin', 'user')");
    fn__9909 = function()
      return 'whereIn chained';
    end;
    temper.test_assert(test_512, t_516, fn__9909);
    return nil;
  end);
end;
Test_.test_whereInSingleElement__1812 = function()
  temper.test('whereIn single element', function(test_517)
    local t_518, t_519, t_520, q__1203, t_521, fn__9899;
    t_518 = sid__546('users');
    t_519 = sid__546('id');
    t_520 = SqlInt32(42);
    q__1203 = from(t_518):whereIn(t_519, temper.listof(t_520));
    t_521 = temper.str_eq(q__1203:toSql():toString(), 'SELECT * FROM users WHERE id IN (42)');
    fn__9899 = function()
      return 'whereIn single';
    end;
    temper.test_assert(test_517, t_521, fn__9899);
    return nil;
  end);
end;
Test_.test_whereNotBasic__1813 = function()
  temper.test('whereNot basic', function(test_522)
    local t_523, t_524, t_525, q__1205, t_526, fn__9887;
    t_523 = sid__546('users');
    t_524 = SqlBuilder();
    t_524:appendSafe('active = ');
    t_524:appendBoolean(true);
    t_525 = t_524.accumulated;
    q__1205 = from(t_523):whereNot(t_525);
    t_526 = temper.str_eq(q__1205:toSql():toString(), 'SELECT * FROM users WHERE NOT (active = TRUE)');
    fn__9887 = function()
      return 'whereNot';
    end;
    temper.test_assert(test_522, t_526, fn__9887);
    return nil;
  end);
end;
Test_.test_whereNotChained__1815 = function()
  temper.test('whereNot chained', function(test_527)
    local t_528, t_529, t_530, t_531, t_532, q__1207, t_533, fn__9870;
    t_528 = sid__546('users');
    t_529 = SqlBuilder();
    t_529:appendSafe('age > ');
    t_529:appendInt32(18);
    t_530 = t_529.accumulated;
    t_531 = from(t_528):where(t_530);
    t_532 = SqlBuilder();
    t_532:appendSafe('banned = ');
    t_532:appendBoolean(true);
    q__1207 = t_531:whereNot(t_532.accumulated);
    t_533 = temper.str_eq(q__1207:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND NOT (banned = TRUE)');
    fn__9870 = function()
      return 'whereNot chained';
    end;
    temper.test_assert(test_527, t_533, fn__9870);
    return nil;
  end);
end;
Test_.test_whereBetweenIntegers__1818 = function()
  temper.test('whereBetween integers', function(test_534)
    local t_535, t_536, t_537, t_538, q__1209, t_539, fn__9859;
    t_535 = sid__546('users');
    t_536 = sid__546('age');
    t_537 = SqlInt32(18);
    t_538 = SqlInt32(65);
    q__1209 = from(t_535):whereBetween(t_536, t_537, t_538);
    t_539 = temper.str_eq(q__1209:toSql():toString(), 'SELECT * FROM users WHERE age BETWEEN 18 AND 65');
    fn__9859 = function()
      return 'whereBetween ints';
    end;
    temper.test_assert(test_534, t_539, fn__9859);
    return nil;
  end);
end;
Test_.test_whereBetweenChained__1819 = function()
  temper.test('whereBetween chained', function(test_540)
    local t_541, t_542, t_543, q__1211, t_544, fn__9843;
    t_541 = sid__546('users');
    t_542 = SqlBuilder();
    t_542:appendSafe('active = ');
    t_542:appendBoolean(true);
    t_543 = t_542.accumulated;
    q__1211 = from(t_541):where(t_543):whereBetween(sid__546('age'), SqlInt32(21), SqlInt32(30));
    t_544 = temper.str_eq(q__1211:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE AND age BETWEEN 21 AND 30');
    fn__9843 = function()
      return 'whereBetween chained';
    end;
    temper.test_assert(test_540, t_544, fn__9843);
    return nil;
  end);
end;
Test_.test_whereLikeBasic__1821 = function()
  temper.test('whereLike basic', function(test_545)
    local t_546, t_547, q__1213, t_548, fn__9834;
    t_546 = sid__546('users');
    t_547 = sid__546('name');
    q__1213 = from(t_546):whereLike(t_547, 'John%');
    t_548 = temper.str_eq(q__1213:toSql():toString(), "SELECT * FROM users WHERE name LIKE 'John%'");
    fn__9834 = function()
      return 'whereLike';
    end;
    temper.test_assert(test_545, t_548, fn__9834);
    return nil;
  end);
end;
Test_.test_whereIlikeBasic__1822 = function()
  temper.test('whereILike basic', function(test_549)
    local t_550, t_551, q__1215, t_552, fn__9825;
    t_550 = sid__546('users');
    t_551 = sid__546('email');
    q__1215 = from(t_550):whereILike(t_551, '%@gmail.com');
    t_552 = temper.str_eq(q__1215:toSql():toString(), "SELECT * FROM users WHERE email ILIKE '%@gmail.com'");
    fn__9825 = function()
      return 'whereILike';
    end;
    temper.test_assert(test_549, t_552, fn__9825);
    return nil;
  end);
end;
Test_.test_whereLikeWithInjectionAttempt__1823 = function()
  temper.test('whereLike with injection attempt', function(test_553)
    local t_554, t_555, q__1217, s__1218, t_556, fn__9811, t_557, fn__9810;
    t_554 = sid__546('users');
    t_555 = sid__546('name');
    q__1217 = from(t_554):whereLike(t_555, "'; DROP TABLE users; --");
    s__1218 = q__1217:toSql():toString();
    t_556 = temper.is_string_index(temper.string_indexof(s__1218, "''"));
    fn__9811 = function()
      return temper.concat('like injection escaped: ', s__1218);
    end;
    temper.test_assert(test_553, t_556, fn__9811);
    t_557 = temper.is_string_index(temper.string_indexof(s__1218, 'LIKE'));
    fn__9810 = function()
      return temper.concat('like structure intact: ', s__1218);
    end;
    temper.test_assert(test_553, t_557, fn__9810);
    return nil;
  end);
end;
Test_.test_whereLikeWildcardPatterns__1824 = function()
  temper.test('whereLike wildcard patterns', function(test_558)
    local t_559, t_560, q__1220, t_561, fn__9801;
    t_559 = sid__546('users');
    t_560 = sid__546('name');
    q__1220 = from(t_559):whereLike(t_560, '%son%');
    t_561 = temper.str_eq(q__1220:toSql():toString(), "SELECT * FROM users WHERE name LIKE '%son%'");
    fn__9801 = function()
      return 'whereLike wildcard';
    end;
    temper.test_assert(test_558, t_561, fn__9801);
    return nil;
  end);
end;
Test_.test_countAllProducesCount__1825 = function()
  temper.test('countAll produces COUNT(*)', function(test_562)
    local f__1222, t_563, fn__9795;
    f__1222 = countAll();
    t_563 = temper.str_eq(f__1222:toString(), 'COUNT(*)');
    fn__9795 = function()
      return 'countAll';
    end;
    temper.test_assert(test_562, t_563, fn__9795);
    return nil;
  end);
end;
Test_.test_countColProducesCountField__1826 = function()
  temper.test('countCol produces COUNT(field)', function(test_564)
    local f__1224, t_565, fn__9788;
    f__1224 = countCol(sid__546('id'));
    t_565 = temper.str_eq(f__1224:toString(), 'COUNT(id)');
    fn__9788 = function()
      return 'countCol';
    end;
    temper.test_assert(test_564, t_565, fn__9788);
    return nil;
  end);
end;
Test_.test_sumColProducesSumField__1827 = function()
  temper.test('sumCol produces SUM(field)', function(test_566)
    local f__1226, t_567, fn__9781;
    f__1226 = sumCol(sid__546('amount'));
    t_567 = temper.str_eq(f__1226:toString(), 'SUM(amount)');
    fn__9781 = function()
      return 'sumCol';
    end;
    temper.test_assert(test_566, t_567, fn__9781);
    return nil;
  end);
end;
Test_.test_avgColProducesAvgField__1828 = function()
  temper.test('avgCol produces AVG(field)', function(test_568)
    local f__1228, t_569, fn__9774;
    f__1228 = avgCol(sid__546('price'));
    t_569 = temper.str_eq(f__1228:toString(), 'AVG(price)');
    fn__9774 = function()
      return 'avgCol';
    end;
    temper.test_assert(test_568, t_569, fn__9774);
    return nil;
  end);
end;
Test_.test_minColProducesMinField__1829 = function()
  temper.test('minCol produces MIN(field)', function(test_570)
    local f__1230, t_571, fn__9767;
    f__1230 = minCol(sid__546('created_at'));
    t_571 = temper.str_eq(f__1230:toString(), 'MIN(created_at)');
    fn__9767 = function()
      return 'minCol';
    end;
    temper.test_assert(test_570, t_571, fn__9767);
    return nil;
  end);
end;
Test_.test_maxColProducesMaxField__1830 = function()
  temper.test('maxCol produces MAX(field)', function(test_572)
    local f__1232, t_573, fn__9760;
    f__1232 = maxCol(sid__546('score'));
    t_573 = temper.str_eq(f__1232:toString(), 'MAX(score)');
    fn__9760 = function()
      return 'maxCol';
    end;
    temper.test_assert(test_572, t_573, fn__9760);
    return nil;
  end);
end;
Test_.test_selectExprWithAggregate__1831 = function()
  temper.test('selectExpr with aggregate', function(test_574)
    local t_575, t_576, q__1234, t_577, fn__9751;
    t_575 = sid__546('orders');
    t_576 = countAll();
    q__1234 = from(t_575):selectExpr(temper.listof(t_576));
    t_577 = temper.str_eq(q__1234:toSql():toString(), 'SELECT COUNT(*) FROM orders');
    fn__9751 = function()
      return 'selectExpr count';
    end;
    temper.test_assert(test_574, t_577, fn__9751);
    return nil;
  end);
end;
Test_.test_selectExprWithMultipleExpressions__1832 = function()
  temper.test('selectExpr with multiple expressions', function(test_578)
    local nameFrag__1236, t_579, t_580, q__1237, t_581, fn__9739;
    nameFrag__1236 = col(sid__546('users'), sid__546('name'));
    t_579 = sid__546('users');
    t_580 = countAll();
    q__1237 = from(t_579):selectExpr(temper.listof(nameFrag__1236, t_580));
    t_581 = temper.str_eq(q__1237:toSql():toString(), 'SELECT users.name, COUNT(*) FROM users');
    fn__9739 = function()
      return 'selectExpr multi';
    end;
    temper.test_assert(test_578, t_581, fn__9739);
    return nil;
  end);
end;
Test_.test_selectExprOverridesSelectedFields__1833 = function()
  temper.test('selectExpr overrides selectedFields', function(test_582)
    local t_583, t_584, t_585, q__1239, t_586, fn__9727;
    t_583 = sid__546('users');
    t_584 = sid__546('id');
    t_585 = sid__546('name');
    q__1239 = from(t_583):select(temper.listof(t_584, t_585)):selectExpr(temper.listof(countAll()));
    t_586 = temper.str_eq(q__1239:toSql():toString(), 'SELECT COUNT(*) FROM users');
    fn__9727 = function()
      return 'selectExpr overrides select';
    end;
    temper.test_assert(test_582, t_586, fn__9727);
    return nil;
  end);
end;
Test_.test_groupBySingleField__1834 = function()
  temper.test('groupBy single field', function(test_587)
    local t_588, t_589, t_590, q__1241, t_591, fn__9713;
    t_588 = sid__546('orders');
    t_589 = col(sid__546('orders'), sid__546('status'));
    t_590 = countAll();
    q__1241 = from(t_588):selectExpr(temper.listof(t_589, t_590)):groupBy(sid__546('status'));
    t_591 = temper.str_eq(q__1241:toSql():toString(), 'SELECT orders.status, COUNT(*) FROM orders GROUP BY status');
    fn__9713 = function()
      return 'groupBy single';
    end;
    temper.test_assert(test_587, t_591, fn__9713);
    return nil;
  end);
end;
Test_.test_groupByMultipleFields__1835 = function()
  temper.test('groupBy multiple fields', function(test_592)
    local t_593, t_594, q__1243, t_595, fn__9702;
    t_593 = sid__546('orders');
    t_594 = sid__546('status');
    q__1243 = from(t_593):groupBy(t_594):groupBy(sid__546('category'));
    t_595 = temper.str_eq(q__1243:toSql():toString(), 'SELECT * FROM orders GROUP BY status, category');
    fn__9702 = function()
      return 'groupBy multiple';
    end;
    temper.test_assert(test_592, t_595, fn__9702);
    return nil;
  end);
end;
Test_.test_havingBasic__1836 = function()
  temper.test('having basic', function(test_596)
    local t_597, t_598, t_599, t_600, t_601, q__1245, t_602, fn__9683;
    t_597 = sid__546('orders');
    t_598 = col(sid__546('orders'), sid__546('status'));
    t_599 = countAll();
    t_600 = from(t_597):selectExpr(temper.listof(t_598, t_599)):groupBy(sid__546('status'));
    t_601 = SqlBuilder();
    t_601:appendSafe('COUNT(*) > ');
    t_601:appendInt32(5);
    q__1245 = t_600:having(t_601.accumulated);
    t_602 = temper.str_eq(q__1245:toSql():toString(), 'SELECT orders.status, COUNT(*) FROM orders GROUP BY status HAVING COUNT(*) > 5');
    fn__9683 = function()
      return 'having basic';
    end;
    temper.test_assert(test_596, t_602, fn__9683);
    return nil;
  end);
end;
Test_.test_orHaving__1838 = function()
  temper.test('orHaving', function(test_603)
    local t_604, t_605, t_606, t_607, t_608, t_609, q__1247, t_610, fn__9664;
    t_604 = sid__546('orders');
    t_605 = sid__546('status');
    t_606 = from(t_604):groupBy(t_605);
    t_607 = SqlBuilder();
    t_607:appendSafe('COUNT(*) > ');
    t_607:appendInt32(5);
    t_608 = t_606:having(t_607.accumulated);
    t_609 = SqlBuilder();
    t_609:appendSafe('SUM(total) > ');
    t_609:appendInt32(1000);
    q__1247 = t_608:orHaving(t_609.accumulated);
    t_610 = temper.str_eq(q__1247:toSql():toString(), 'SELECT * FROM orders GROUP BY status HAVING COUNT(*) > 5 OR SUM(total) > 1000');
    fn__9664 = function()
      return 'orHaving';
    end;
    temper.test_assert(test_603, t_610, fn__9664);
    return nil;
  end);
end;
Test_.test_distinctBasic__1841 = function()
  temper.test('distinct basic', function(test_611)
    local t_612, t_613, q__1249, t_614, fn__9654;
    t_612 = sid__546('users');
    t_613 = sid__546('name');
    q__1249 = from(t_612):select(temper.listof(t_613)):distinct();
    t_614 = temper.str_eq(q__1249:toSql():toString(), 'SELECT DISTINCT name FROM users');
    fn__9654 = function()
      return 'distinct';
    end;
    temper.test_assert(test_611, t_614, fn__9654);
    return nil;
  end);
end;
Test_.test_distinctWithWhere__1842 = function()
  temper.test('distinct with where', function(test_615)
    local t_616, t_617, t_618, t_619, q__1251, t_620, fn__9639;
    t_616 = sid__546('users');
    t_617 = sid__546('email');
    t_618 = from(t_616):select(temper.listof(t_617));
    t_619 = SqlBuilder();
    t_619:appendSafe('active = ');
    t_619:appendBoolean(true);
    q__1251 = t_618:where(t_619.accumulated):distinct();
    t_620 = temper.str_eq(q__1251:toSql():toString(), 'SELECT DISTINCT email FROM users WHERE active = TRUE');
    fn__9639 = function()
      return 'distinct with where';
    end;
    temper.test_assert(test_615, t_620, fn__9639);
    return nil;
  end);
end;
Test_.test_countSqlBare__1844 = function()
  temper.test('countSql bare', function(test_621)
    local q__1253, t_622, fn__9632;
    q__1253 = from(sid__546('users'));
    t_622 = temper.str_eq(q__1253:countSql():toString(), 'SELECT COUNT(*) FROM users');
    fn__9632 = function()
      return 'countSql bare';
    end;
    temper.test_assert(test_621, t_622, fn__9632);
    return nil;
  end);
end;
Test_.test_countSqlWithWhere__1845 = function()
  temper.test('countSql with WHERE', function(test_623)
    local t_624, t_625, t_626, q__1255, t_627, fn__9620;
    t_624 = sid__546('users');
    t_625 = SqlBuilder();
    t_625:appendSafe('active = ');
    t_625:appendBoolean(true);
    t_626 = t_625.accumulated;
    q__1255 = from(t_624):where(t_626);
    t_627 = temper.str_eq(q__1255:countSql():toString(), 'SELECT COUNT(*) FROM users WHERE active = TRUE');
    fn__9620 = function()
      return 'countSql with where';
    end;
    temper.test_assert(test_623, t_627, fn__9620);
    return nil;
  end);
end;
Test_.test_countSqlWithJoin__1847 = function()
  temper.test('countSql with JOIN', function(test_628)
    local t_629, t_630, t_631, t_632, t_633, t_634, q__1257, t_635, fn__9603;
    t_629 = sid__546('users');
    t_630 = sid__546('orders');
    t_631 = SqlBuilder();
    t_631:appendSafe('users.id = orders.user_id');
    t_632 = t_631.accumulated;
    t_633 = from(t_629):innerJoin(t_630, t_632);
    t_634 = SqlBuilder();
    t_634:appendSafe('orders.total > ');
    t_634:appendInt32(100);
    q__1257 = t_633:where(t_634.accumulated);
    t_635 = temper.str_eq(q__1257:countSql():toString(), 'SELECT COUNT(*) FROM users INNER JOIN orders ON users.id = orders.user_id WHERE orders.total > 100');
    fn__9603 = function()
      return 'countSql with join';
    end;
    temper.test_assert(test_628, t_635, fn__9603);
    return nil;
  end);
end;
Test_.test_countSqlDropsOrderByLimitOffset__1850 = function()
  temper.test('countSql drops orderBy/limit/offset', function(test_636)
    local t_637, t_638, t_639, t_640, t_641, q__1259, local_642, local_643, local_644, s__1260, t_646, fn__9589;
    local_642, local_643, local_644 = temper.pcall(function()
      t_637 = sid__546('users');
      t_638 = SqlBuilder();
      t_638:appendSafe('active = ');
      t_638:appendBoolean(true);
      t_639 = t_638.accumulated;
      t_640 = from(t_637):where(t_639):orderBy(sid__546('name'), true):limit(10);
      t_641 = t_640:offset(20);
      q__1259 = t_641;
    end);
    if local_642 then
    else
      q__1259 = temper.bubble();
    end
    s__1260 = q__1259:countSql():toString();
    t_646 = temper.str_eq(s__1260, 'SELECT COUNT(*) FROM users WHERE active = TRUE');
    fn__9589 = function()
      return temper.concat('countSql drops extras: ', s__1260);
    end;
    temper.test_assert(test_636, t_646, fn__9589);
    return nil;
  end);
end;
Test_.test_fullAggregationQuery__1852 = function()
  temper.test('full aggregation query', function(test_647)
    local t_648, t_649, t_650, t_651, t_652, t_653, t_654, t_655, t_656, t_657, t_658, q__1262, expected__1263, t_659, fn__9556;
    t_648 = sid__546('orders');
    t_649 = col(sid__546('orders'), sid__546('status'));
    t_650 = countAll();
    t_651 = sumCol(sid__546('total'));
    t_652 = from(t_648):selectExpr(temper.listof(t_649, t_650, t_651));
    t_653 = sid__546('users');
    t_654 = SqlBuilder();
    t_654:appendSafe('orders.user_id = users.id');
    t_655 = t_652:innerJoin(t_653, t_654.accumulated);
    t_656 = SqlBuilder();
    t_656:appendSafe('users.active = ');
    t_656:appendBoolean(true);
    t_657 = t_655:where(t_656.accumulated):groupBy(sid__546('status'));
    t_658 = SqlBuilder();
    t_658:appendSafe('COUNT(*) > ');
    t_658:appendInt32(3);
    q__1262 = t_657:having(t_658.accumulated):orderBy(sid__546('status'), true);
    expected__1263 = 'SELECT orders.status, COUNT(*), SUM(total) FROM orders INNER JOIN users ON orders.user_id = users.id WHERE users.active = TRUE GROUP BY status HAVING COUNT(*) > 3 ORDER BY status ASC';
    t_659 = temper.str_eq(q__1262:toSql():toString(), 'SELECT orders.status, COUNT(*), SUM(total) FROM orders INNER JOIN users ON orders.user_id = users.id WHERE users.active = TRUE GROUP BY status HAVING COUNT(*) > 3 ORDER BY status ASC');
    fn__9556 = function()
      return 'full aggregation';
    end;
    temper.test_assert(test_647, t_659, fn__9556);
    return nil;
  end);
end;
Test_.test_unionSql__1856 = function()
  temper.test('unionSql', function(test_660)
    local t_661, t_662, t_663, a__1265, t_664, t_665, t_666, b__1266, s__1267, t_667, fn__9538;
    t_661 = sid__546('users');
    t_662 = SqlBuilder();
    t_662:appendSafe('role = ');
    t_662:appendString('admin');
    t_663 = t_662.accumulated;
    a__1265 = from(t_661):where(t_663);
    t_664 = sid__546('users');
    t_665 = SqlBuilder();
    t_665:appendSafe('role = ');
    t_665:appendString('moderator');
    t_666 = t_665.accumulated;
    b__1266 = from(t_664):where(t_666);
    s__1267 = unionSql(a__1265, b__1266):toString();
    t_667 = temper.str_eq(s__1267, "(SELECT * FROM users WHERE role = 'admin') UNION (SELECT * FROM users WHERE role = 'moderator')");
    fn__9538 = function()
      return temper.concat('unionSql: ', s__1267);
    end;
    temper.test_assert(test_660, t_667, fn__9538);
    return nil;
  end);
end;
Test_.test_unionAllSql__1859 = function()
  temper.test('unionAllSql', function(test_668)
    local t_669, t_670, a__1269, t_671, t_672, b__1270, s__1271, t_673, fn__9526;
    t_669 = sid__546('users');
    t_670 = sid__546('name');
    a__1269 = from(t_669):select(temper.listof(t_670));
    t_671 = sid__546('contacts');
    t_672 = sid__546('name');
    b__1270 = from(t_671):select(temper.listof(t_672));
    s__1271 = unionAllSql(a__1269, b__1270):toString();
    t_673 = temper.str_eq(s__1271, '(SELECT name FROM users) UNION ALL (SELECT name FROM contacts)');
    fn__9526 = function()
      return temper.concat('unionAllSql: ', s__1271);
    end;
    temper.test_assert(test_668, t_673, fn__9526);
    return nil;
  end);
end;
Test_.test_intersectSql__1860 = function()
  temper.test('intersectSql', function(test_674)
    local t_675, t_676, a__1273, t_677, t_678, b__1274, s__1275, t_679, fn__9514;
    t_675 = sid__546('users');
    t_676 = sid__546('email');
    a__1273 = from(t_675):select(temper.listof(t_676));
    t_677 = sid__546('subscribers');
    t_678 = sid__546('email');
    b__1274 = from(t_677):select(temper.listof(t_678));
    s__1275 = intersectSql(a__1273, b__1274):toString();
    t_679 = temper.str_eq(s__1275, '(SELECT email FROM users) INTERSECT (SELECT email FROM subscribers)');
    fn__9514 = function()
      return temper.concat('intersectSql: ', s__1275);
    end;
    temper.test_assert(test_674, t_679, fn__9514);
    return nil;
  end);
end;
Test_.test_exceptSql__1861 = function()
  temper.test('exceptSql', function(test_680)
    local t_681, t_682, a__1277, t_683, t_684, b__1278, s__1279, t_685, fn__9502;
    t_681 = sid__546('users');
    t_682 = sid__546('id');
    a__1277 = from(t_681):select(temper.listof(t_682));
    t_683 = sid__546('banned');
    t_684 = sid__546('id');
    b__1278 = from(t_683):select(temper.listof(t_684));
    s__1279 = exceptSql(a__1277, b__1278):toString();
    t_685 = temper.str_eq(s__1279, '(SELECT id FROM users) EXCEPT (SELECT id FROM banned)');
    fn__9502 = function()
      return temper.concat('exceptSql: ', s__1279);
    end;
    temper.test_assert(test_680, t_685, fn__9502);
    return nil;
  end);
end;
Test_.test_subqueryWithAlias__1862 = function()
  temper.test('subquery with alias', function(test_686)
    local t_687, t_688, t_689, t_690, inner__1281, s__1282, t_691, fn__9487;
    t_687 = sid__546('orders');
    t_688 = sid__546('user_id');
    t_689 = from(t_687):select(temper.listof(t_688));
    t_690 = SqlBuilder();
    t_690:appendSafe('total > ');
    t_690:appendInt32(100);
    inner__1281 = t_689:where(t_690.accumulated);
    s__1282 = subquery(inner__1281, sid__546('big_orders')):toString();
    t_691 = temper.str_eq(s__1282, '(SELECT user_id FROM orders WHERE total > 100) AS big_orders');
    fn__9487 = function()
      return temper.concat('subquery: ', s__1282);
    end;
    temper.test_assert(test_686, t_691, fn__9487);
    return nil;
  end);
end;
Test_.test_existsSql__1864 = function()
  temper.test('existsSql', function(test_692)
    local t_693, t_694, t_695, inner__1284, s__1285, t_696, fn__9476;
    t_693 = sid__546('orders');
    t_694 = SqlBuilder();
    t_694:appendSafe('orders.user_id = users.id');
    t_695 = t_694.accumulated;
    inner__1284 = from(t_693):where(t_695);
    s__1285 = existsSql(inner__1284):toString();
    t_696 = temper.str_eq(s__1285, 'EXISTS (SELECT * FROM orders WHERE orders.user_id = users.id)');
    fn__9476 = function()
      return temper.concat('existsSql: ', s__1285);
    end;
    temper.test_assert(test_692, t_696, fn__9476);
    return nil;
  end);
end;
Test_.test_whereInSubquery__1866 = function()
  temper.test('whereInSubquery', function(test_697)
    local t_698, t_699, t_700, t_701, sub__1287, t_702, t_703, q__1288, s__1289, t_704, fn__9459;
    t_698 = sid__546('orders');
    t_699 = sid__546('user_id');
    t_700 = from(t_698):select(temper.listof(t_699));
    t_701 = SqlBuilder();
    t_701:appendSafe('total > ');
    t_701:appendInt32(1000);
    sub__1287 = t_700:where(t_701.accumulated);
    t_702 = sid__546('users');
    t_703 = sid__546('id');
    q__1288 = from(t_702):whereInSubquery(t_703, sub__1287);
    s__1289 = q__1288:toSql():toString();
    t_704 = temper.str_eq(s__1289, 'SELECT * FROM users WHERE id IN (SELECT user_id FROM orders WHERE total > 1000)');
    fn__9459 = function()
      return temper.concat('whereInSubquery: ', s__1289);
    end;
    temper.test_assert(test_697, t_704, fn__9459);
    return nil;
  end);
end;
Test_.test_setOperationWithWhereOnEachSide__1868 = function()
  temper.test('set operation with WHERE on each side', function(test_705)
    local t_706, t_707, t_708, t_709, t_710, a__1291, t_711, t_712, t_713, b__1292, s__1293, t_714, fn__9436;
    t_706 = sid__546('users');
    t_707 = SqlBuilder();
    t_707:appendSafe('age > ');
    t_707:appendInt32(18);
    t_708 = t_707.accumulated;
    t_709 = from(t_706):where(t_708);
    t_710 = SqlBuilder();
    t_710:appendSafe('active = ');
    t_710:appendBoolean(true);
    a__1291 = t_709:where(t_710.accumulated);
    t_711 = sid__546('users');
    t_712 = SqlBuilder();
    t_712:appendSafe('role = ');
    t_712:appendString('vip');
    t_713 = t_712.accumulated;
    b__1292 = from(t_711):where(t_713);
    s__1293 = unionSql(a__1291, b__1292):toString();
    t_714 = temper.str_eq(s__1293, "(SELECT * FROM users WHERE age > 18 AND active = TRUE) UNION (SELECT * FROM users WHERE role = 'vip')");
    fn__9436 = function()
      return temper.concat('union with where: ', s__1293);
    end;
    temper.test_assert(test_705, t_714, fn__9436);
    return nil;
  end);
end;
Test_.test_whereInSubqueryChainedWithWhere__1872 = function()
  temper.test('whereInSubquery chained with where', function(test_715)
    local t_716, t_717, sub__1295, t_718, t_719, t_720, q__1296, s__1297, t_721, fn__9419;
    t_716 = sid__546('orders');
    t_717 = sid__546('user_id');
    sub__1295 = from(t_716):select(temper.listof(t_717));
    t_718 = sid__546('users');
    t_719 = SqlBuilder();
    t_719:appendSafe('active = ');
    t_719:appendBoolean(true);
    t_720 = t_719.accumulated;
    q__1296 = from(t_718):where(t_720):whereInSubquery(sid__546('id'), sub__1295);
    s__1297 = q__1296:toSql():toString();
    t_721 = temper.str_eq(s__1297, 'SELECT * FROM users WHERE active = TRUE AND id IN (SELECT user_id FROM orders)');
    fn__9419 = function()
      return temper.concat('whereInSubquery chained: ', s__1297);
    end;
    temper.test_assert(test_715, t_721, fn__9419);
    return nil;
  end);
end;
Test_.test_existsSqlUsedInWhere__1874 = function()
  temper.test('existsSql used in where', function(test_722)
    local t_723, t_724, t_725, sub__1299, t_726, t_727, q__1300, s__1301, t_728, fn__9405;
    t_723 = sid__546('orders');
    t_724 = SqlBuilder();
    t_724:appendSafe('orders.user_id = users.id');
    t_725 = t_724.accumulated;
    sub__1299 = from(t_723):where(t_725);
    t_726 = sid__546('users');
    t_727 = existsSql(sub__1299);
    q__1300 = from(t_726):where(t_727);
    s__1301 = q__1300:toSql():toString();
    t_728 = temper.str_eq(s__1301, 'SELECT * FROM users WHERE EXISTS (SELECT * FROM orders WHERE orders.user_id = users.id)');
    fn__9405 = function()
      return temper.concat('exists in where: ', s__1301);
    end;
    temper.test_assert(test_722, t_728, fn__9405);
    return nil;
  end);
end;
Test_.test_updateQueryBasic__1876 = function()
  temper.test('UpdateQuery basic', function(test_729)
    local t_730, t_731, t_732, t_733, t_734, t_735, q__1303, local_736, local_737, local_738, t_740, fn__9391;
    local_736, local_737, local_738 = temper.pcall(function()
      t_730 = sid__546('users');
      t_731 = sid__546('name');
      t_732 = SqlString('Alice');
      t_733 = update(t_730):set(t_731, t_732);
      t_734 = SqlBuilder();
      t_734:appendSafe('id = ');
      t_734:appendInt32(1);
      t_735 = t_733:where(t_734.accumulated):toSql();
      q__1303 = t_735;
    end);
    if local_736 then
    else
      q__1303 = temper.bubble();
    end
    t_740 = temper.str_eq(q__1303:toString(), "UPDATE users SET name = 'Alice' WHERE id = 1");
    fn__9391 = function()
      return 'update basic';
    end;
    temper.test_assert(test_729, t_740, fn__9391);
    return nil;
  end);
end;
Test_.test_updateQueryMultipleSet__1878 = function()
  temper.test('UpdateQuery multiple SET', function(test_741)
    local t_742, t_743, t_744, t_745, t_746, t_747, q__1305, local_748, local_749, local_750, t_752, fn__9374;
    local_748, local_749, local_750 = temper.pcall(function()
      t_742 = sid__546('users');
      t_743 = sid__546('name');
      t_744 = SqlString('Bob');
      t_745 = update(t_742):set(t_743, t_744):set(sid__546('age'), SqlInt32(30));
      t_746 = SqlBuilder();
      t_746:appendSafe('id = ');
      t_746:appendInt32(2);
      t_747 = t_745:where(t_746.accumulated):toSql();
      q__1305 = t_747;
    end);
    if local_748 then
    else
      q__1305 = temper.bubble();
    end
    t_752 = temper.str_eq(q__1305:toString(), "UPDATE users SET name = 'Bob', age = 30 WHERE id = 2");
    fn__9374 = function()
      return 'update multi set';
    end;
    temper.test_assert(test_741, t_752, fn__9374);
    return nil;
  end);
end;
Test_.test_updateQueryMultipleWhere__1880 = function()
  temper.test('UpdateQuery multiple WHERE', function(test_753)
    local t_754, t_755, t_756, t_757, t_758, t_759, t_760, t_761, q__1307, local_762, local_763, local_764, t_766, fn__9355;
    local_762, local_763, local_764 = temper.pcall(function()
      t_754 = sid__546('users');
      t_755 = sid__546('active');
      t_756 = SqlBoolean(false);
      t_757 = update(t_754):set(t_755, t_756);
      t_758 = SqlBuilder();
      t_758:appendSafe('age < ');
      t_758:appendInt32(18);
      t_759 = t_757:where(t_758.accumulated);
      t_760 = SqlBuilder();
      t_760:appendSafe('role = ');
      t_760:appendString('guest');
      t_761 = t_759:where(t_760.accumulated):toSql();
      q__1307 = t_761;
    end);
    if local_762 then
    else
      q__1307 = temper.bubble();
    end
    t_766 = temper.str_eq(q__1307:toString(), "UPDATE users SET active = FALSE WHERE age < 18 AND role = 'guest'");
    fn__9355 = function()
      return 'update multi where';
    end;
    temper.test_assert(test_753, t_766, fn__9355);
    return nil;
  end);
end;
Test_.test_updateQueryOrWhere__1883 = function()
  temper.test('UpdateQuery orWhere', function(test_767)
    local t_768, t_769, t_770, t_771, t_772, t_773, t_774, t_775, q__1309, local_776, local_777, local_778, t_780, fn__9336;
    local_776, local_777, local_778 = temper.pcall(function()
      t_768 = sid__546('users');
      t_769 = sid__546('status');
      t_770 = SqlString('banned');
      t_771 = update(t_768):set(t_769, t_770);
      t_772 = SqlBuilder();
      t_772:appendSafe('spam_count > ');
      t_772:appendInt32(10);
      t_773 = t_771:where(t_772.accumulated);
      t_774 = SqlBuilder();
      t_774:appendSafe('reported = ');
      t_774:appendBoolean(true);
      t_775 = t_773:orWhere(t_774.accumulated):toSql();
      q__1309 = t_775;
    end);
    if local_776 then
    else
      q__1309 = temper.bubble();
    end
    t_780 = temper.str_eq(q__1309:toString(), "UPDATE users SET status = 'banned' WHERE spam_count > 10 OR reported = TRUE");
    fn__9336 = function()
      return 'update orWhere';
    end;
    temper.test_assert(test_767, t_780, fn__9336);
    return nil;
  end);
end;
Test_.test_updateQueryBubblesWithoutWhere__1886 = function()
  temper.test('UpdateQuery bubbles without WHERE', function(test_781)
    local t_782, t_783, t_784, didBubble__1311, local_785, local_786, local_787, fn__9329;
    local_785, local_786, local_787 = temper.pcall(function()
      t_782 = sid__546('users');
      t_783 = sid__546('x');
      t_784 = SqlInt32(1);
      update(t_782):set(t_783, t_784):toSql();
      didBubble__1311 = false;
    end);
    if local_785 then
    else
      didBubble__1311 = true;
    end
    fn__9329 = function()
      return 'update without WHERE should bubble';
    end;
    temper.test_assert(test_781, didBubble__1311, fn__9329);
    return nil;
  end);
end;
Test_.test_updateQueryBubblesWithoutSet__1887 = function()
  temper.test('UpdateQuery bubbles without SET', function(test_789)
    local t_790, t_791, t_792, didBubble__1313, local_793, local_794, local_795, fn__9320;
    local_793, local_794, local_795 = temper.pcall(function()
      t_790 = sid__546('users');
      t_791 = SqlBuilder();
      t_791:appendSafe('id = ');
      t_791:appendInt32(1);
      t_792 = t_791.accumulated;
      update(t_790):where(t_792):toSql();
      didBubble__1313 = false;
    end);
    if local_793 then
    else
      didBubble__1313 = true;
    end
    fn__9320 = function()
      return 'update without SET should bubble';
    end;
    temper.test_assert(test_789, didBubble__1313, fn__9320);
    return nil;
  end);
end;
Test_.test_updateQueryWithLimit__1889 = function()
  temper.test('UpdateQuery with limit', function(test_797)
    local t_798, t_799, t_800, t_801, t_802, t_803, t_804, q__1315, local_805, local_806, local_807, t_809, fn__9306;
    local_805, local_806, local_807 = temper.pcall(function()
      t_798 = sid__546('users');
      t_799 = sid__546('active');
      t_800 = SqlBoolean(false);
      t_801 = update(t_798):set(t_799, t_800);
      t_802 = SqlBuilder();
      t_802:appendSafe('last_login < ');
      t_802:appendString('2024-01-01');
      t_803 = t_801:where(t_802.accumulated):limit(100);
      t_804 = t_803:toSql();
      q__1315 = t_804;
    end);
    if local_805 then
    else
      q__1315 = temper.bubble();
    end
    t_809 = temper.str_eq(q__1315:toString(), "UPDATE users SET active = FALSE WHERE last_login < '2024-01-01' LIMIT 100");
    fn__9306 = function()
      return 'update limit';
    end;
    temper.test_assert(test_797, t_809, fn__9306);
    return nil;
  end);
end;
Test_.test_updateQueryEscaping__1891 = function()
  temper.test('UpdateQuery escaping', function(test_810)
    local t_811, t_812, t_813, t_814, t_815, t_816, q__1317, local_817, local_818, local_819, t_821, fn__9292;
    local_817, local_818, local_819 = temper.pcall(function()
      t_811 = sid__546('users');
      t_812 = sid__546('bio');
      t_813 = SqlString("It's a test");
      t_814 = update(t_811):set(t_812, t_813);
      t_815 = SqlBuilder();
      t_815:appendSafe('id = ');
      t_815:appendInt32(1);
      t_816 = t_814:where(t_815.accumulated):toSql();
      q__1317 = t_816;
    end);
    if local_817 then
    else
      q__1317 = temper.bubble();
    end
    t_821 = temper.str_eq(q__1317:toString(), "UPDATE users SET bio = 'It''s a test' WHERE id = 1");
    fn__9292 = function()
      return 'update escaping';
    end;
    temper.test_assert(test_810, t_821, fn__9292);
    return nil;
  end);
end;
Test_.test_deleteQueryBasic__1893 = function()
  temper.test('DeleteQuery basic', function(test_822)
    local t_823, t_824, t_825, t_826, q__1319, local_827, local_828, local_829, t_831, fn__9281;
    local_827, local_828, local_829 = temper.pcall(function()
      t_823 = sid__546('users');
      t_824 = SqlBuilder();
      t_824:appendSafe('id = ');
      t_824:appendInt32(1);
      t_825 = t_824.accumulated;
      t_826 = deleteFrom(t_823):where(t_825):toSql();
      q__1319 = t_826;
    end);
    if local_827 then
    else
      q__1319 = temper.bubble();
    end
    t_831 = temper.str_eq(q__1319:toString(), 'DELETE FROM users WHERE id = 1');
    fn__9281 = function()
      return 'delete basic';
    end;
    temper.test_assert(test_822, t_831, fn__9281);
    return nil;
  end);
end;
Test_.test_deleteQueryMultipleWhere__1895 = function()
  temper.test('DeleteQuery multiple WHERE', function(test_832)
    local t_833, t_834, t_835, t_836, t_837, t_838, q__1321, local_839, local_840, local_841, t_843, fn__9265;
    local_839, local_840, local_841 = temper.pcall(function()
      t_833 = sid__546('logs');
      t_834 = SqlBuilder();
      t_834:appendSafe('created_at < ');
      t_834:appendString('2024-01-01');
      t_835 = t_834.accumulated;
      t_836 = deleteFrom(t_833):where(t_835);
      t_837 = SqlBuilder();
      t_837:appendSafe('level = ');
      t_837:appendString('debug');
      t_838 = t_836:where(t_837.accumulated):toSql();
      q__1321 = t_838;
    end);
    if local_839 then
    else
      q__1321 = temper.bubble();
    end
    t_843 = temper.str_eq(q__1321:toString(), "DELETE FROM logs WHERE created_at < '2024-01-01' AND level = 'debug'");
    fn__9265 = function()
      return 'delete multi where';
    end;
    temper.test_assert(test_832, t_843, fn__9265);
    return nil;
  end);
end;
Test_.test_deleteQueryBubblesWithoutWhere__1898 = function()
  temper.test('DeleteQuery bubbles without WHERE', function(test_844)
    local didBubble__1323, local_845, local_846, local_847, fn__9261;
    local_845, local_846, local_847 = temper.pcall(function()
      deleteFrom(sid__546('users')):toSql();
      didBubble__1323 = false;
    end);
    if local_845 then
    else
      didBubble__1323 = true;
    end
    fn__9261 = function()
      return 'delete without WHERE should bubble';
    end;
    temper.test_assert(test_844, didBubble__1323, fn__9261);
    return nil;
  end);
end;
Test_.test_deleteQueryOrWhere__1899 = function()
  temper.test('DeleteQuery orWhere', function(test_849)
    local t_850, t_851, t_852, t_853, t_854, t_855, q__1325, local_856, local_857, local_858, t_860, fn__9245;
    local_856, local_857, local_858 = temper.pcall(function()
      t_850 = sid__546('sessions');
      t_851 = SqlBuilder();
      t_851:appendSafe('expired = ');
      t_851:appendBoolean(true);
      t_852 = t_851.accumulated;
      t_853 = deleteFrom(t_850):where(t_852);
      t_854 = SqlBuilder();
      t_854:appendSafe('created_at < ');
      t_854:appendString('2023-01-01');
      t_855 = t_853:orWhere(t_854.accumulated):toSql();
      q__1325 = t_855;
    end);
    if local_856 then
    else
      q__1325 = temper.bubble();
    end
    t_860 = temper.str_eq(q__1325:toString(), "DELETE FROM sessions WHERE expired = TRUE OR created_at < '2023-01-01'");
    fn__9245 = function()
      return 'delete orWhere';
    end;
    temper.test_assert(test_849, t_860, fn__9245);
    return nil;
  end);
end;
Test_.test_deleteQueryWithLimit__1902 = function()
  temper.test('DeleteQuery with limit', function(test_861)
    local t_862, t_863, t_864, t_865, t_866, q__1327, local_867, local_868, local_869, t_871, fn__9234;
    local_867, local_868, local_869 = temper.pcall(function()
      t_862 = sid__546('logs');
      t_863 = SqlBuilder();
      t_863:appendSafe('level = ');
      t_863:appendString('debug');
      t_864 = t_863.accumulated;
      t_865 = deleteFrom(t_862):where(t_864):limit(1000);
      t_866 = t_865:toSql();
      q__1327 = t_866;
    end);
    if local_867 then
    else
      q__1327 = temper.bubble();
    end
    t_871 = temper.str_eq(q__1327:toString(), "DELETE FROM logs WHERE level = 'debug' LIMIT 1000");
    fn__9234 = function()
      return 'delete limit';
    end;
    temper.test_assert(test_861, t_871, fn__9234);
    return nil;
  end);
end;
Test_.test_orderByNullsNullsFirst__1904 = function()
  temper.test('orderByNulls NULLS FIRST', function(test_872)
    local t_873, t_874, t_875, q__1329, t_876, fn__9224;
    t_873 = sid__546('users');
    t_874 = sid__546('email');
    t_875 = NullsFirst();
    q__1329 = from(t_873):orderByNulls(t_874, true, t_875);
    t_876 = temper.str_eq(q__1329:toSql():toString(), 'SELECT * FROM users ORDER BY email ASC NULLS FIRST');
    fn__9224 = function()
      return 'nulls first';
    end;
    temper.test_assert(test_872, t_876, fn__9224);
    return nil;
  end);
end;
Test_.test_orderByNullsNullsLast__1905 = function()
  temper.test('orderByNulls NULLS LAST', function(test_877)
    local t_878, t_879, t_880, q__1331, t_881, fn__9214;
    t_878 = sid__546('users');
    t_879 = sid__546('score');
    t_880 = NullsLast();
    q__1331 = from(t_878):orderByNulls(t_879, false, t_880);
    t_881 = temper.str_eq(q__1331:toSql():toString(), 'SELECT * FROM users ORDER BY score DESC NULLS LAST');
    fn__9214 = function()
      return 'nulls last';
    end;
    temper.test_assert(test_877, t_881, fn__9214);
    return nil;
  end);
end;
Test_.test_mixedOrderByAndOrderByNulls__1906 = function()
  temper.test('mixed orderBy and orderByNulls', function(test_882)
    local t_883, t_884, q__1333, t_885, fn__9202;
    t_883 = sid__546('users');
    t_884 = sid__546('name');
    q__1333 = from(t_883):orderBy(t_884, true):orderByNulls(sid__546('email'), true, NullsFirst());
    t_885 = temper.str_eq(q__1333:toSql():toString(), 'SELECT * FROM users ORDER BY name ASC, email ASC NULLS FIRST');
    fn__9202 = function()
      return 'mixed order';
    end;
    temper.test_assert(test_882, t_885, fn__9202);
    return nil;
  end);
end;
Test_.test_crossJoin__1907 = function()
  temper.test('crossJoin', function(test_886)
    local t_887, t_888, q__1335, t_889, fn__9193;
    t_887 = sid__546('users');
    t_888 = sid__546('colors');
    q__1335 = from(t_887):crossJoin(t_888);
    t_889 = temper.str_eq(q__1335:toSql():toString(), 'SELECT * FROM users CROSS JOIN colors');
    fn__9193 = function()
      return 'cross join';
    end;
    temper.test_assert(test_886, t_889, fn__9193);
    return nil;
  end);
end;
Test_.test_crossJoinCombinedWithOtherJoins__1908 = function()
  temper.test('crossJoin combined with other joins', function(test_890)
    local t_891, t_892, t_893, t_894, q__1337, t_895, fn__9179;
    t_891 = sid__546('users');
    t_892 = sid__546('orders');
    t_893 = SqlBuilder();
    t_893:appendSafe('users.id = orders.user_id');
    t_894 = t_893.accumulated;
    q__1337 = from(t_891):innerJoin(t_892, t_894):crossJoin(sid__546('colors'));
    t_895 = temper.str_eq(q__1337:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id CROSS JOIN colors');
    fn__9179 = function()
      return 'cross + inner join';
    end;
    temper.test_assert(test_890, t_895, fn__9179);
    return nil;
  end);
end;
Test_.test_lockForUpdate__1910 = function()
  temper.test('lock FOR UPDATE', function(test_896)
    local t_897, t_898, t_899, q__1339, t_900, fn__9165;
    t_897 = sid__546('users');
    t_898 = SqlBuilder();
    t_898:appendSafe('id = ');
    t_898:appendInt32(1);
    t_899 = t_898.accumulated;
    q__1339 = from(t_897):where(t_899):lock(ForUpdate());
    t_900 = temper.str_eq(q__1339:toSql():toString(), 'SELECT * FROM users WHERE id = 1 FOR UPDATE');
    fn__9165 = function()
      return 'for update';
    end;
    temper.test_assert(test_896, t_900, fn__9165);
    return nil;
  end);
end;
Test_.test_lockForShare__1912 = function()
  temper.test('lock FOR SHARE', function(test_901)
    local t_902, t_903, q__1341, t_904, fn__9154;
    t_902 = sid__546('users');
    t_903 = sid__546('name');
    q__1341 = from(t_902):select(temper.listof(t_903)):lock(ForShare());
    t_904 = temper.str_eq(q__1341:toSql():toString(), 'SELECT name FROM users FOR SHARE');
    fn__9154 = function()
      return 'for share';
    end;
    temper.test_assert(test_901, t_904, fn__9154);
    return nil;
  end);
end;
Test_.test_lockWithFullQuery__1913 = function()
  temper.test('lock with full query', function(test_905)
    local t_906, t_907, t_908, t_909, t_910, q__1343, local_911, local_912, local_913, t_915, fn__9140;
    local_911, local_912, local_913 = temper.pcall(function()
      t_906 = sid__546('accounts');
      t_907 = SqlBuilder();
      t_907:appendSafe('id = ');
      t_907:appendInt32(42);
      t_908 = t_907.accumulated;
      t_910 = from(t_906):where(t_908):limit(1);
      t_909 = t_910:lock(ForUpdate());
      q__1343 = t_909;
    end);
    if local_911 then
    else
      q__1343 = temper.bubble();
    end
    t_915 = temper.str_eq(q__1343:toSql():toString(), 'SELECT * FROM accounts WHERE id = 42 LIMIT 1 FOR UPDATE');
    fn__9140 = function()
      return 'lock full query';
    end;
    temper.test_assert(test_905, t_915, fn__9140);
    return nil;
  end);
end;
Test_.test_safeIdentifierAcceptsValidNames__1915 = function()
  temper.test('safeIdentifier accepts valid names', function(test_916)
    local t_917, id__1381, local_918, local_919, local_920, t_922, fn__9135;
    local_918, local_919, local_920 = temper.pcall(function()
      t_917 = safeIdentifier('user_name');
      id__1381 = t_917;
    end);
    if local_918 then
    else
      id__1381 = temper.bubble();
    end
    t_922 = temper.str_eq(id__1381.sqlValue, 'user_name');
    fn__9135 = function()
      return 'value should round-trip';
    end;
    temper.test_assert(test_916, t_922, fn__9135);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsEmptyString__1916 = function()
  temper.test('safeIdentifier rejects empty string', function(test_923)
    local didBubble__1383, local_924, local_925, local_926, fn__9132;
    local_924, local_925, local_926 = temper.pcall(function()
      safeIdentifier('');
      didBubble__1383 = false;
    end);
    if local_924 then
    else
      didBubble__1383 = true;
    end
    fn__9132 = function()
      return 'empty string should bubble';
    end;
    temper.test_assert(test_923, didBubble__1383, fn__9132);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsLeadingDigit__1917 = function()
  temper.test('safeIdentifier rejects leading digit', function(test_928)
    local didBubble__1385, local_929, local_930, local_931, fn__9129;
    local_929, local_930, local_931 = temper.pcall(function()
      safeIdentifier('1col');
      didBubble__1385 = false;
    end);
    if local_929 then
    else
      didBubble__1385 = true;
    end
    fn__9129 = function()
      return 'leading digit should bubble';
    end;
    temper.test_assert(test_928, didBubble__1385, fn__9129);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsSqlMetacharacters__1918 = function()
  temper.test('safeIdentifier rejects SQL metacharacters', function(test_933)
    local cases__1387, fn__9126;
    cases__1387 = temper.listof('name); DROP TABLE', "col'", 'a b', 'a-b', 'a.b', 'a;b');
    fn__9126 = function(c__1388)
      local didBubble__1389, local_934, local_935, local_936, fn__9123;
      local_934, local_935, local_936 = temper.pcall(function()
        safeIdentifier(c__1388);
        didBubble__1389 = false;
      end);
      if local_934 then
      else
        didBubble__1389 = true;
      end
      fn__9123 = function()
        return temper.concat('should reject: ', c__1388);
      end;
      temper.test_assert(test_933, didBubble__1389, fn__9123);
      return nil;
    end;
    temper.list_foreach(cases__1387, fn__9126);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupFound__1919 = function()
  temper.test('TableDef field lookup - found', function(test_938)
    local t_939, t_940, t_941, t_942, t_943, t_944, t_945, local_946, local_947, local_948, local_950, local_951, local_952, t_954, t_955, local_956, local_957, local_958, t_960, t_961, td__1391, f__1392, local_962, local_963, local_964, t_966, fn__9112;
    local_946, local_947, local_948 = temper.pcall(function()
      t_939 = safeIdentifier('users');
      t_940 = t_939;
    end);
    if local_946 then
    else
      t_940 = temper.bubble();
    end
    local_950, local_951, local_952 = temper.pcall(function()
      t_941 = safeIdentifier('name');
      t_942 = t_941;
    end);
    if local_950 then
    else
      t_942 = temper.bubble();
    end
    t_954 = StringField();
    t_955 = FieldDef(t_942, t_954, false);
    local_956, local_957, local_958 = temper.pcall(function()
      t_943 = safeIdentifier('age');
      t_944 = t_943;
    end);
    if local_956 then
    else
      t_944 = temper.bubble();
    end
    t_960 = IntField();
    t_961 = FieldDef(t_944, t_960, false);
    td__1391 = TableDef(t_940, temper.listof(t_955, t_961));
    local_962, local_963, local_964 = temper.pcall(function()
      t_945 = td__1391:field('age');
      f__1392 = t_945;
    end);
    if local_962 then
    else
      f__1392 = temper.bubble();
    end
    t_966 = temper.str_eq(f__1392.name.sqlValue, 'age');
    fn__9112 = function()
      return 'should find age field';
    end;
    temper.test_assert(test_938, t_966, fn__9112);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupNotFoundBubbles__1920 = function()
  temper.test('TableDef field lookup - not found bubbles', function(test_967)
    local t_968, t_969, t_970, t_971, local_972, local_973, local_974, local_976, local_977, local_978, t_980, t_981, td__1394, didBubble__1395, local_982, local_983, local_984, fn__9106;
    local_972, local_973, local_974 = temper.pcall(function()
      t_968 = safeIdentifier('users');
      t_969 = t_968;
    end);
    if local_972 then
    else
      t_969 = temper.bubble();
    end
    local_976, local_977, local_978 = temper.pcall(function()
      t_970 = safeIdentifier('name');
      t_971 = t_970;
    end);
    if local_976 then
    else
      t_971 = temper.bubble();
    end
    t_980 = StringField();
    t_981 = FieldDef(t_971, t_980, false);
    td__1394 = TableDef(t_969, temper.listof(t_981));
    local_982, local_983, local_984 = temper.pcall(function()
      td__1394:field('nonexistent');
      didBubble__1395 = false;
    end);
    if local_982 then
    else
      didBubble__1395 = true;
    end
    fn__9106 = function()
      return 'unknown field should bubble';
    end;
    temper.test_assert(test_967, didBubble__1395, fn__9106);
    return nil;
  end);
end;
Test_.test_fieldDefNullableFlag__1921 = function()
  temper.test('FieldDef nullable flag', function(test_986)
    local t_987, t_988, t_989, t_990, local_991, local_992, local_993, t_995, required__1397, local_996, local_997, local_998, t_1000, optional__1398, t_1001, fn__9094, t_1002, fn__9093;
    local_991, local_992, local_993 = temper.pcall(function()
      t_987 = safeIdentifier('email');
      t_988 = t_987;
    end);
    if local_991 then
    else
      t_988 = temper.bubble();
    end
    t_995 = StringField();
    required__1397 = FieldDef(t_988, t_995, false);
    local_996, local_997, local_998 = temper.pcall(function()
      t_989 = safeIdentifier('bio');
      t_990 = t_989;
    end);
    if local_996 then
    else
      t_990 = temper.bubble();
    end
    t_1000 = StringField();
    optional__1398 = FieldDef(t_990, t_1000, true);
    t_1001 = not required__1397.nullable;
    fn__9094 = function()
      return 'required field should not be nullable';
    end;
    temper.test_assert(test_986, t_1001, fn__9094);
    t_1002 = optional__1398.nullable;
    fn__9093 = function()
      return 'optional field should be nullable';
    end;
    temper.test_assert(test_986, t_1002, fn__9093);
    return nil;
  end);
end;
Test_.test_stringEscaping__1922 = function()
  temper.test('string escaping', function(test_1003)
    local build__1524, buildWrong__1525, actual_1005, t_1006, fn__9082, bobbyTables__1530, actual_1007, t_1008, fn__9081, fn__9080;
    build__1524 = function(name__1526)
      local t_1004;
      t_1004 = SqlBuilder();
      t_1004:appendSafe('select * from hi where name = ');
      t_1004:appendString(name__1526);
      return t_1004.accumulated:toString();
    end;
    buildWrong__1525 = function(name__1528)
      return temper.concat("select * from hi where name = '", name__1528, "'");
    end;
    actual_1005 = build__1524('world');
    t_1006 = temper.str_eq(actual_1005, "select * from hi where name = 'world'");
    fn__9082 = function()
      return temper.concat('expected build("world") == (', "select * from hi where name = 'world'", ') not (', actual_1005, ')');
    end;
    temper.test_assert(test_1003, t_1006, fn__9082);
    bobbyTables__1530 = "Robert'); drop table hi;--";
    actual_1007 = build__1524("Robert'); drop table hi;--");
    t_1008 = temper.str_eq(actual_1007, "select * from hi where name = 'Robert''); drop table hi;--'");
    fn__9081 = function()
      return temper.concat('expected build(bobbyTables) == (', "select * from hi where name = 'Robert''); drop table hi;--'", ') not (', actual_1007, ')');
    end;
    temper.test_assert(test_1003, t_1008, fn__9081);
    fn__9080 = function()
      return "expected buildWrong(bobbyTables) == (select * from hi where name = 'Robert'); drop table hi;--') not (select * from hi where name = 'Robert'); drop table hi;--')";
    end;
    temper.test_assert(test_1003, true, fn__9080);
    return nil;
  end);
end;
Test_.test_stringEdgeCases__1930 = function()
  temper.test('string edge cases', function(test_1009)
    local t_1010, actual_1011, t_1012, fn__9042, t_1013, actual_1014, t_1015, fn__9041, t_1016, actual_1017, t_1018, fn__9040, t_1019, actual_1020, t_1021, fn__9039;
    t_1010 = SqlBuilder();
    t_1010:appendSafe('v = ');
    t_1010:appendString('');
    actual_1011 = t_1010.accumulated:toString();
    t_1012 = temper.str_eq(actual_1011, "v = ''");
    fn__9042 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "").toString() == (', "v = ''", ') not (', actual_1011, ')');
    end;
    temper.test_assert(test_1009, t_1012, fn__9042);
    t_1013 = SqlBuilder();
    t_1013:appendSafe('v = ');
    t_1013:appendString("a''b");
    actual_1014 = t_1013.accumulated:toString();
    t_1015 = temper.str_eq(actual_1014, "v = 'a''''b'");
    fn__9041 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v = \", \\interpolate, \"a''b\").toString() == (", "v = 'a''''b'", ') not (', actual_1014, ')');
    end;
    temper.test_assert(test_1009, t_1015, fn__9041);
    t_1016 = SqlBuilder();
    t_1016:appendSafe('v = ');
    t_1016:appendString('Hello \xe4\xb8\x96\xe7\x95\x8c');
    actual_1017 = t_1016.accumulated:toString();
    t_1018 = temper.str_eq(actual_1017, "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'");
    fn__9040 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Hello \xe4\xb8\x96\xe7\x95\x8c").toString() == (', "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'", ') not (', actual_1017, ')');
    end;
    temper.test_assert(test_1009, t_1018, fn__9040);
    t_1019 = SqlBuilder();
    t_1019:appendSafe('v = ');
    t_1019:appendString('Line1\nLine2');
    actual_1020 = t_1019.accumulated:toString();
    t_1021 = temper.str_eq(actual_1020, "v = 'Line1\nLine2'");
    fn__9039 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Line1\\nLine2").toString() == (', "v = 'Line1\nLine2'", ') not (', actual_1020, ')');
    end;
    temper.test_assert(test_1009, t_1021, fn__9039);
    return nil;
  end);
end;
Test_.test_numbersAndBooleans__1943 = function()
  temper.test('numbers and booleans', function(test_1022)
    local t_1023, t_1024, actual_1025, t_1026, fn__9013, date__1533, local_1027, local_1028, local_1029, t_1031, actual_1032, t_1033, fn__9012;
    t_1024 = SqlBuilder();
    t_1024:appendSafe('select ');
    t_1024:appendInt32(42);
    t_1024:appendSafe(', ');
    t_1024:appendInt64(temper.int64_constructor(43));
    t_1024:appendSafe(', ');
    t_1024:appendFloat64(19.99);
    t_1024:appendSafe(', ');
    t_1024:appendBoolean(true);
    t_1024:appendSafe(', ');
    t_1024:appendBoolean(false);
    actual_1025 = t_1024.accumulated:toString();
    t_1026 = temper.str_eq(actual_1025, 'select 42, 43, 19.99, TRUE, FALSE');
    fn__9013 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, 42, ", ", \\interpolate, 43, ", ", \\interpolate, 19.99, ", ", \\interpolate, true, ", ", \\interpolate, false).toString() == (', 'select 42, 43, 19.99, TRUE, FALSE', ') not (', actual_1025, ')');
    end;
    temper.test_assert(test_1022, t_1026, fn__9013);
    local_1027, local_1028, local_1029 = temper.pcall(function()
      t_1023 = temper.date_constructor(2024, 12, 25);
      date__1533 = t_1023;
    end);
    if local_1027 then
    else
      date__1533 = temper.bubble();
    end
    t_1031 = SqlBuilder();
    t_1031:appendSafe('insert into t values (');
    t_1031:appendDate(date__1533);
    t_1031:appendSafe(')');
    actual_1032 = t_1031.accumulated:toString();
    t_1033 = temper.str_eq(actual_1032, "insert into t values ('2024-12-25')");
    fn__9012 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "insert into t values (", \\interpolate, date, ")").toString() == (', "insert into t values ('2024-12-25')", ') not (', actual_1032, ')');
    end;
    temper.test_assert(test_1022, t_1033, fn__9012);
    return nil;
  end);
end;
Test_.test_lists__1950 = function()
  temper.test('lists', function(test_1034)
    local t_1035, t_1036, t_1037, t_1038, t_1039, actual_1040, t_1041, fn__8957, t_1042, actual_1043, t_1044, fn__8956, t_1045, actual_1046, t_1047, fn__8955, t_1048, actual_1049, t_1050, fn__8954, t_1051, actual_1052, t_1053, fn__8953, local_1054, local_1055, local_1056, local_1058, local_1059, local_1060, dates__1535, t_1062, actual_1063, t_1064, fn__8952;
    t_1039 = SqlBuilder();
    t_1039:appendSafe('v IN (');
    t_1039:appendStringList(temper.listof('a', 'b', "c'd"));
    t_1039:appendSafe(')');
    actual_1040 = t_1039.accumulated:toString();
    t_1041 = temper.str_eq(actual_1040, "v IN ('a', 'b', 'c''d')");
    fn__8957 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v IN (\", \\interpolate, list(\"a\", \"b\", \"c'd\"), \")\").toString() == (", "v IN ('a', 'b', 'c''d')", ') not (', actual_1040, ')');
    end;
    temper.test_assert(test_1034, t_1041, fn__8957);
    t_1042 = SqlBuilder();
    t_1042:appendSafe('v IN (');
    t_1042:appendInt32List(temper.listof(1, 2, 3));
    t_1042:appendSafe(')');
    actual_1043 = t_1042.accumulated:toString();
    t_1044 = temper.str_eq(actual_1043, 'v IN (1, 2, 3)');
    fn__8956 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2, 3), ")").toString() == (', 'v IN (1, 2, 3)', ') not (', actual_1043, ')');
    end;
    temper.test_assert(test_1034, t_1044, fn__8956);
    t_1045 = SqlBuilder();
    t_1045:appendSafe('v IN (');
    t_1045:appendInt64List(temper.listof(temper.int64_constructor(1), temper.int64_constructor(2)));
    t_1045:appendSafe(')');
    actual_1046 = t_1045.accumulated:toString();
    t_1047 = temper.str_eq(actual_1046, 'v IN (1, 2)');
    fn__8955 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2), ")").toString() == (', 'v IN (1, 2)', ') not (', actual_1046, ')');
    end;
    temper.test_assert(test_1034, t_1047, fn__8955);
    t_1048 = SqlBuilder();
    t_1048:appendSafe('v IN (');
    t_1048:appendFloat64List(temper.listof(1.0, 2.0));
    t_1048:appendSafe(')');
    actual_1049 = t_1048.accumulated:toString();
    t_1050 = temper.str_eq(actual_1049, 'v IN (1.0, 2.0)');
    fn__8954 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1.0, 2.0), ")").toString() == (', 'v IN (1.0, 2.0)', ') not (', actual_1049, ')');
    end;
    temper.test_assert(test_1034, t_1050, fn__8954);
    t_1051 = SqlBuilder();
    t_1051:appendSafe('v IN (');
    t_1051:appendBooleanList(temper.listof(true, false));
    t_1051:appendSafe(')');
    actual_1052 = t_1051.accumulated:toString();
    t_1053 = temper.str_eq(actual_1052, 'v IN (TRUE, FALSE)');
    fn__8953 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(true, false), ")").toString() == (', 'v IN (TRUE, FALSE)', ') not (', actual_1052, ')');
    end;
    temper.test_assert(test_1034, t_1053, fn__8953);
    local_1054, local_1055, local_1056 = temper.pcall(function()
      t_1035 = temper.date_constructor(2024, 1, 1);
      t_1036 = t_1035;
    end);
    if local_1054 then
    else
      t_1036 = temper.bubble();
    end
    local_1058, local_1059, local_1060 = temper.pcall(function()
      t_1037 = temper.date_constructor(2024, 12, 25);
      t_1038 = t_1037;
    end);
    if local_1058 then
    else
      t_1038 = temper.bubble();
    end
    dates__1535 = temper.listof(t_1036, t_1038);
    t_1062 = SqlBuilder();
    t_1062:appendSafe('v IN (');
    t_1062:appendDateList(dates__1535);
    t_1062:appendSafe(')');
    actual_1063 = t_1062.accumulated:toString();
    t_1064 = temper.str_eq(actual_1063, "v IN ('2024-01-01', '2024-12-25')");
    fn__8952 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, dates, ")").toString() == (', "v IN ('2024-01-01', '2024-12-25')", ') not (', actual_1063, ')');
    end;
    temper.test_assert(test_1034, t_1064, fn__8952);
    return nil;
  end);
end;
Test_.test_sqlFloat64_naNRendersAsNull__1969 = function()
  temper.test('SqlFloat64 NaN renders as NULL', function(test_1065)
    local nan__1537, t_1066, actual_1067, t_1068, fn__8943;
    nan__1537 = temper.fdiv(0.0, 0.0);
    t_1066 = SqlBuilder();
    t_1066:appendSafe('v = ');
    t_1066:appendFloat64(nan__1537);
    actual_1067 = t_1066.accumulated:toString();
    t_1068 = temper.str_eq(actual_1067, 'v = NULL');
    fn__8943 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, nan).toString() == (', 'v = NULL', ') not (', actual_1067, ')');
    end;
    temper.test_assert(test_1065, t_1068, fn__8943);
    return nil;
  end);
end;
Test_.test_sqlFloat64_infinityRendersAsNull__1973 = function()
  temper.test('SqlFloat64 Infinity renders as NULL', function(test_1069)
    local inf__1539, t_1070, actual_1071, t_1072, fn__8934;
    inf__1539 = temper.fdiv(1.0, 0.0);
    t_1070 = SqlBuilder();
    t_1070:appendSafe('v = ');
    t_1070:appendFloat64(inf__1539);
    actual_1071 = t_1070.accumulated:toString();
    t_1072 = temper.str_eq(actual_1071, 'v = NULL');
    fn__8934 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, inf).toString() == (', 'v = NULL', ') not (', actual_1071, ')');
    end;
    temper.test_assert(test_1069, t_1072, fn__8934);
    return nil;
  end);
end;
Test_.test_sqlFloat64_negativeInfinityRendersAsNull__1977 = function()
  temper.test('SqlFloat64 negative Infinity renders as NULL', function(test_1073)
    local ninf__1541, t_1074, actual_1075, t_1076, fn__8925;
    ninf__1541 = temper.fdiv(-1.0, 0.0);
    t_1074 = SqlBuilder();
    t_1074:appendSafe('v = ');
    t_1074:appendFloat64(ninf__1541);
    actual_1075 = t_1074.accumulated:toString();
    t_1076 = temper.str_eq(actual_1075, 'v = NULL');
    fn__8925 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, ninf).toString() == (', 'v = NULL', ') not (', actual_1075, ')');
    end;
    temper.test_assert(test_1073, t_1076, fn__8925);
    return nil;
  end);
end;
Test_.test_sqlFloat64_normalValuesStillWork__1981 = function()
  temper.test('SqlFloat64 normal values still work', function(test_1077)
    local t_1078, actual_1079, t_1080, fn__8900, t_1081, actual_1082, t_1083, fn__8899, t_1084, actual_1085, t_1086, fn__8898;
    t_1078 = SqlBuilder();
    t_1078:appendSafe('v = ');
    t_1078:appendFloat64(3.14);
    actual_1079 = t_1078.accumulated:toString();
    t_1080 = temper.str_eq(actual_1079, 'v = 3.14');
    fn__8900 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 3.14).toString() == (', 'v = 3.14', ') not (', actual_1079, ')');
    end;
    temper.test_assert(test_1077, t_1080, fn__8900);
    t_1081 = SqlBuilder();
    t_1081:appendSafe('v = ');
    t_1081:appendFloat64(0.0);
    actual_1082 = t_1081.accumulated:toString();
    t_1083 = temper.str_eq(actual_1082, 'v = 0.0');
    fn__8899 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 0.0).toString() == (', 'v = 0.0', ') not (', actual_1082, ')');
    end;
    temper.test_assert(test_1077, t_1083, fn__8899);
    t_1084 = SqlBuilder();
    t_1084:appendSafe('v = ');
    t_1084:appendFloat64(-42.5);
    actual_1085 = t_1084.accumulated:toString();
    t_1086 = temper.str_eq(actual_1085, 'v = -42.5');
    fn__8898 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, -42.5).toString() == (', 'v = -42.5', ') not (', actual_1085, ')');
    end;
    temper.test_assert(test_1077, t_1086, fn__8898);
    return nil;
  end);
end;
Test_.test_sqlDateRendersWithQuotes__1991 = function()
  temper.test('SqlDate renders with quotes', function(test_1087)
    local t_1088, d__1544, local_1089, local_1090, local_1091, t_1093, actual_1094, t_1095, fn__8889;
    local_1089, local_1090, local_1091 = temper.pcall(function()
      t_1088 = temper.date_constructor(2024, 6, 15);
      d__1544 = t_1088;
    end);
    if local_1089 then
    else
      d__1544 = temper.bubble();
    end
    t_1093 = SqlBuilder();
    t_1093:appendSafe('v = ');
    t_1093:appendDate(d__1544);
    actual_1094 = t_1093.accumulated:toString();
    t_1095 = temper.str_eq(actual_1094, "v = '2024-06-15'");
    fn__8889 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, d).toString() == (', "v = '2024-06-15'", ') not (', actual_1094, ')');
    end;
    temper.test_assert(test_1087, t_1095, fn__8889);
    return nil;
  end);
end;
Test_.test_nesting__1995 = function()
  temper.test('nesting', function(test_1096)
    local name__1546, t_1097, condition__1547, t_1098, actual_1099, t_1100, fn__8857, t_1101, actual_1102, t_1103, fn__8856, parts__1548, t_1104, actual_1105, t_1106, fn__8855;
    name__1546 = 'Someone';
    t_1097 = SqlBuilder();
    t_1097:appendSafe('where p.last_name = ');
    t_1097:appendString('Someone');
    condition__1547 = t_1097.accumulated;
    t_1098 = SqlBuilder();
    t_1098:appendSafe('select p.id from person p ');
    t_1098:appendFragment(condition__1547);
    actual_1099 = t_1098.accumulated:toString();
    t_1100 = temper.str_eq(actual_1099, "select p.id from person p where p.last_name = 'Someone'");
    fn__8857 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_1099, ')');
    end;
    temper.test_assert(test_1096, t_1100, fn__8857);
    t_1101 = SqlBuilder();
    t_1101:appendSafe('select p.id from person p ');
    t_1101:appendPart(condition__1547:toSource());
    actual_1102 = t_1101.accumulated:toString();
    t_1103 = temper.str_eq(actual_1102, "select p.id from person p where p.last_name = 'Someone'");
    fn__8856 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition.toSource()).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_1102, ')');
    end;
    temper.test_assert(test_1096, t_1103, fn__8856);
    parts__1548 = temper.listof(SqlString("a'b"), SqlInt32(3));
    t_1104 = SqlBuilder();
    t_1104:appendSafe('select ');
    t_1104:appendPartList(parts__1548);
    actual_1105 = t_1104.accumulated:toString();
    t_1106 = temper.str_eq(actual_1105, "select 'a''b', 3");
    fn__8855 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, parts).toString() == (', "select 'a''b', 3", ') not (', actual_1105, ')');
    end;
    temper.test_assert(test_1096, t_1106, fn__8855);
    return nil;
  end);
end;
exports = {};
local_1108.LuaUnit.run(local_1107({'--pattern', '^Test_%.', local_1107(arg)}));
return exports;
