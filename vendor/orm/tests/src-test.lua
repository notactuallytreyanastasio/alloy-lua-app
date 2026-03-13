local temper = require('temper-core');
local safeIdentifier, TableDef, FieldDef, StringField, IntField, FloatField, BoolField, changeset, from, SqlBuilder, col, SqlInt32, SqlString, countAll, countCol, sumCol, avgCol, minCol, maxCol, unionSql, unionAllSql, intersectSql, exceptSql, subquery, existsSql, local_914, local_915, csid__459, userTable__460, sid__461, exports;
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
local_914 = (unpack or table.unpack);
local_915 = require('luaunit');
local_915.FAILURE_PREFIX = temper.test_failure_prefix;
Test_ = {};
csid__459 = function(name__604)
  local return__295, t_138, local_139, local_140, local_141;
  local_139, local_140, local_141 = temper.pcall(function()
    t_138 = safeIdentifier(name__604);
    return__295 = t_138;
  end);
  if local_139 then
  else
    return__295 = temper.bubble();
  end
  return return__295;
end;
userTable__460 = function()
  return TableDef(csid__459('users'), temper.listof(FieldDef(csid__459('name'), StringField(), false), FieldDef(csid__459('email'), StringField(), false), FieldDef(csid__459('age'), IntField(), true), FieldDef(csid__459('score'), FloatField(), true), FieldDef(csid__459('active'), BoolField(), true)));
end;
Test_.test_castWhitelistsAllowedFields__1404 = function()
  temper.test('cast whitelists allowed fields', function(test_143)
    local params__608, t_144, t_145, t_146, cs__609, t_147, fn__9392, t_148, fn__9391, t_149, fn__9390, t_150, fn__9389;
    params__608 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com'), temper.pair_constructor('admin', 'true')));
    t_144 = userTable__460();
    t_145 = csid__459('name');
    t_146 = csid__459('email');
    cs__609 = changeset(t_144, params__608):cast(temper.listof(t_145, t_146));
    t_147 = temper.mapped_has(cs__609.changes, 'name');
    fn__9392 = function()
      return 'name should be in changes';
    end;
    temper.test_assert(test_143, t_147, fn__9392);
    t_148 = temper.mapped_has(cs__609.changes, 'email');
    fn__9391 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_143, t_148, fn__9391);
    t_149 = not temper.mapped_has(cs__609.changes, 'admin');
    fn__9390 = function()
      return 'admin must be dropped (not in whitelist)';
    end;
    temper.test_assert(test_143, t_149, fn__9390);
    t_150 = cs__609.isValid;
    fn__9389 = function()
      return 'should still be valid';
    end;
    temper.test_assert(test_143, t_150, fn__9389);
    return nil;
  end);
end;
Test_.test_castIsReplacingNotAdditiveSecondCallResetsWhitelist__1405 = function()
  temper.test('cast is replacing not additive \xe2\x80\x94 second call resets whitelist', function(test_151)
    local params__611, t_152, t_153, cs__612, t_154, fn__9371, t_155, fn__9370;
    params__611 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com')));
    t_152 = userTable__460();
    t_153 = csid__459('name');
    cs__612 = changeset(t_152, params__611):cast(temper.listof(t_153)):cast(temper.listof(csid__459('email')));
    t_154 = not temper.mapped_has(cs__612.changes, 'name');
    fn__9371 = function()
      return 'name must be excluded by second cast';
    end;
    temper.test_assert(test_151, t_154, fn__9371);
    t_155 = temper.mapped_has(cs__612.changes, 'email');
    fn__9370 = function()
      return 'email should be present';
    end;
    temper.test_assert(test_151, t_155, fn__9370);
    return nil;
  end);
end;
Test_.test_castIgnoresEmptyStringValues__1406 = function()
  temper.test('cast ignores empty string values', function(test_156)
    local params__614, t_157, t_158, t_159, cs__615, t_160, fn__9353, t_161, fn__9352;
    params__614 = temper.map_constructor(temper.listof(temper.pair_constructor('name', ''), temper.pair_constructor('email', 'bob@example.com')));
    t_157 = userTable__460();
    t_158 = csid__459('name');
    t_159 = csid__459('email');
    cs__615 = changeset(t_157, params__614):cast(temper.listof(t_158, t_159));
    t_160 = not temper.mapped_has(cs__615.changes, 'name');
    fn__9353 = function()
      return 'empty name should not be in changes';
    end;
    temper.test_assert(test_156, t_160, fn__9353);
    t_161 = temper.mapped_has(cs__615.changes, 'email');
    fn__9352 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_156, t_161, fn__9352);
    return nil;
  end);
end;
Test_.test_validateRequiredPassesWhenFieldPresent__1407 = function()
  temper.test('validateRequired passes when field present', function(test_162)
    local params__617, t_163, t_164, cs__618, t_165, fn__9336, t_166, fn__9335;
    params__617 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_163 = userTable__460();
    t_164 = csid__459('name');
    cs__618 = changeset(t_163, params__617):cast(temper.listof(t_164)):validateRequired(temper.listof(csid__459('name')));
    t_165 = cs__618.isValid;
    fn__9336 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_162, t_165, fn__9336);
    t_166 = (temper.list_length(cs__618.errors) == 0);
    fn__9335 = function()
      return 'no errors expected';
    end;
    temper.test_assert(test_162, t_166, fn__9335);
    return nil;
  end);
end;
Test_.test_validateRequiredFailsWhenFieldMissing__1408 = function()
  temper.test('validateRequired fails when field missing', function(test_167)
    local params__620, t_168, t_169, cs__621, t_170, fn__9313, t_171, fn__9312, t_172, fn__9311;
    params__620 = temper.map_constructor(temper.listof());
    t_168 = userTable__460();
    t_169 = csid__459('name');
    cs__621 = changeset(t_168, params__620):cast(temper.listof(t_169)):validateRequired(temper.listof(csid__459('name')));
    t_170 = not cs__621.isValid;
    fn__9313 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_167, t_170, fn__9313);
    t_171 = (temper.list_length(cs__621.errors) == 1);
    fn__9312 = function()
      return 'should have one error';
    end;
    temper.test_assert(test_167, t_171, fn__9312);
    t_172 = temper.str_eq((temper.list_get(cs__621.errors, 0)).field, 'name');
    fn__9311 = function()
      return 'error should name the field';
    end;
    temper.test_assert(test_167, t_172, fn__9311);
    return nil;
  end);
end;
Test_.test_validateLengthPassesWithinRange__1409 = function()
  temper.test('validateLength passes within range', function(test_173)
    local params__623, t_174, t_175, cs__624, t_176, fn__9300;
    params__623 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_174 = userTable__460();
    t_175 = csid__459('name');
    cs__624 = changeset(t_174, params__623):cast(temper.listof(t_175)):validateLength(csid__459('name'), 2, 50);
    t_176 = cs__624.isValid;
    fn__9300 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_173, t_176, fn__9300);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooShort__1410 = function()
  temper.test('validateLength fails when too short', function(test_177)
    local params__626, t_178, t_179, cs__627, t_180, fn__9288;
    params__626 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'A')));
    t_178 = userTable__460();
    t_179 = csid__459('name');
    cs__627 = changeset(t_178, params__626):cast(temper.listof(t_179)):validateLength(csid__459('name'), 2, 50);
    t_180 = not cs__627.isValid;
    fn__9288 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_177, t_180, fn__9288);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooLong__1411 = function()
  temper.test('validateLength fails when too long', function(test_181)
    local params__629, t_182, t_183, cs__630, t_184, fn__9276;
    params__629 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')));
    t_182 = userTable__460();
    t_183 = csid__459('name');
    cs__630 = changeset(t_182, params__629):cast(temper.listof(t_183)):validateLength(csid__459('name'), 2, 10);
    t_184 = not cs__630.isValid;
    fn__9276 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_181, t_184, fn__9276);
    return nil;
  end);
end;
Test_.test_validateIntPassesForValidInteger__1412 = function()
  temper.test('validateInt passes for valid integer', function(test_185)
    local params__632, t_186, t_187, cs__633, t_188, fn__9265;
    params__632 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '30')));
    t_186 = userTable__460();
    t_187 = csid__459('age');
    cs__633 = changeset(t_186, params__632):cast(temper.listof(t_187)):validateInt(csid__459('age'));
    t_188 = cs__633.isValid;
    fn__9265 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_185, t_188, fn__9265);
    return nil;
  end);
end;
Test_.test_validateIntFailsForNonInteger__1413 = function()
  temper.test('validateInt fails for non-integer', function(test_189)
    local params__635, t_190, t_191, cs__636, t_192, fn__9253;
    params__635 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_190 = userTable__460();
    t_191 = csid__459('age');
    cs__636 = changeset(t_190, params__635):cast(temper.listof(t_191)):validateInt(csid__459('age'));
    t_192 = not cs__636.isValid;
    fn__9253 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_189, t_192, fn__9253);
    return nil;
  end);
end;
Test_.test_validateFloatPassesForValidFloat__1414 = function()
  temper.test('validateFloat passes for valid float', function(test_193)
    local params__638, t_194, t_195, cs__639, t_196, fn__9242;
    params__638 = temper.map_constructor(temper.listof(temper.pair_constructor('score', '9.5')));
    t_194 = userTable__460();
    t_195 = csid__459('score');
    cs__639 = changeset(t_194, params__638):cast(temper.listof(t_195)):validateFloat(csid__459('score'));
    t_196 = cs__639.isValid;
    fn__9242 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_193, t_196, fn__9242);
    return nil;
  end);
end;
Test_.test_validateInt64_passesForValid64_bitInteger__1415 = function()
  temper.test('validateInt64 passes for valid 64-bit integer', function(test_197)
    local params__641, t_198, t_199, cs__642, t_200, fn__9231;
    params__641 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '9999999999')));
    t_198 = userTable__460();
    t_199 = csid__459('age');
    cs__642 = changeset(t_198, params__641):cast(temper.listof(t_199)):validateInt64(csid__459('age'));
    t_200 = cs__642.isValid;
    fn__9231 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_197, t_200, fn__9231);
    return nil;
  end);
end;
Test_.test_validateInt64_failsForNonInteger__1416 = function()
  temper.test('validateInt64 fails for non-integer', function(test_201)
    local params__644, t_202, t_203, cs__645, t_204, fn__9219;
    params__644 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_202 = userTable__460();
    t_203 = csid__459('age');
    cs__645 = changeset(t_202, params__644):cast(temper.listof(t_203)):validateInt64(csid__459('age'));
    t_204 = not cs__645.isValid;
    fn__9219 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_201, t_204, fn__9219);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsTrue1_yesOn__1417 = function()
  temper.test('validateBool accepts true/1/yes/on', function(test_205)
    local fn__9216;
    fn__9216 = function(v__647)
      local params__648, t_206, t_207, cs__649, t_208, fn__9205;
      params__648 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__647)));
      t_206 = userTable__460();
      t_207 = csid__459('active');
      cs__649 = changeset(t_206, params__648):cast(temper.listof(t_207)):validateBool(csid__459('active'));
      t_208 = cs__649.isValid;
      fn__9205 = function()
        return temper.concat('should accept: ', v__647);
      end;
      temper.test_assert(test_205, t_208, fn__9205);
      return nil;
    end;
    temper.list_foreach(temper.listof('true', '1', 'yes', 'on'), fn__9216);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsFalse0_noOff__1418 = function()
  temper.test('validateBool accepts false/0/no/off', function(test_209)
    local fn__9202;
    fn__9202 = function(v__651)
      local params__652, t_210, t_211, cs__653, t_212, fn__9191;
      params__652 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__651)));
      t_210 = userTable__460();
      t_211 = csid__459('active');
      cs__653 = changeset(t_210, params__652):cast(temper.listof(t_211)):validateBool(csid__459('active'));
      t_212 = cs__653.isValid;
      fn__9191 = function()
        return temper.concat('should accept: ', v__651);
      end;
      temper.test_assert(test_209, t_212, fn__9191);
      return nil;
    end;
    temper.list_foreach(temper.listof('false', '0', 'no', 'off'), fn__9202);
    return nil;
  end);
end;
Test_.test_validateBoolRejectsAmbiguousValues__1419 = function()
  temper.test('validateBool rejects ambiguous values', function(test_213)
    local fn__9188;
    fn__9188 = function(v__655)
      local params__656, t_214, t_215, cs__657, t_216, fn__9176;
      params__656 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__655)));
      t_214 = userTable__460();
      t_215 = csid__459('active');
      cs__657 = changeset(t_214, params__656):cast(temper.listof(t_215)):validateBool(csid__459('active'));
      t_216 = not cs__657.isValid;
      fn__9176 = function()
        return temper.concat('should reject ambiguous: ', v__655);
      end;
      temper.test_assert(test_213, t_216, fn__9176);
      return nil;
    end;
    temper.list_foreach(temper.listof('TRUE', 'Yes', 'maybe', '2', 'enabled'), fn__9188);
    return nil;
  end);
end;
Test_.test_toInsertSqlEscapesBobbyTables__1420 = function()
  temper.test('toInsertSql escapes Bobby Tables', function(test_217)
    local t_218, params__659, t_219, t_220, t_221, cs__660, sqlFrag__661, local_222, local_223, local_224, s__662, t_226, fn__9160;
    params__659 = temper.map_constructor(temper.listof(temper.pair_constructor('name', "Robert'); DROP TABLE users;--"), temper.pair_constructor('email', 'bobby@evil.com')));
    t_219 = userTable__460();
    t_220 = csid__459('name');
    t_221 = csid__459('email');
    cs__660 = changeset(t_219, params__659):cast(temper.listof(t_220, t_221)):validateRequired(temper.listof(csid__459('name'), csid__459('email')));
    local_222, local_223, local_224 = temper.pcall(function()
      t_218 = cs__660:toInsertSql();
      sqlFrag__661 = t_218;
    end);
    if local_222 then
    else
      sqlFrag__661 = temper.bubble();
    end
    s__662 = sqlFrag__661:toString();
    t_226 = temper.is_string_index(temper.string_indexof(s__662, "''"));
    fn__9160 = function()
      return temper.concat('single quote must be doubled: ', s__662);
    end;
    temper.test_assert(test_217, t_226, fn__9160);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForStringField__1421 = function()
  temper.test('toInsertSql produces correct SQL for string field', function(test_227)
    local t_228, params__664, t_229, t_230, t_231, cs__665, sqlFrag__666, local_232, local_233, local_234, s__667, t_236, fn__9140, t_237, fn__9139;
    params__664 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'a@example.com')));
    t_229 = userTable__460();
    t_230 = csid__459('name');
    t_231 = csid__459('email');
    cs__665 = changeset(t_229, params__664):cast(temper.listof(t_230, t_231)):validateRequired(temper.listof(csid__459('name'), csid__459('email')));
    local_232, local_233, local_234 = temper.pcall(function()
      t_228 = cs__665:toInsertSql();
      sqlFrag__666 = t_228;
    end);
    if local_232 then
    else
      sqlFrag__666 = temper.bubble();
    end
    s__667 = sqlFrag__666:toString();
    t_236 = temper.is_string_index(temper.string_indexof(s__667, 'INSERT INTO users'));
    fn__9140 = function()
      return temper.concat('has INSERT INTO: ', s__667);
    end;
    temper.test_assert(test_227, t_236, fn__9140);
    t_237 = temper.is_string_index(temper.string_indexof(s__667, "'Alice'"));
    fn__9139 = function()
      return temper.concat('has quoted name: ', s__667);
    end;
    temper.test_assert(test_227, t_237, fn__9139);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForIntField__1422 = function()
  temper.test('toInsertSql produces correct SQL for int field', function(test_238)
    local t_239, params__669, t_240, t_241, t_242, t_243, cs__670, sqlFrag__671, local_244, local_245, local_246, s__672, t_248, fn__9121;
    params__669 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob'), temper.pair_constructor('email', 'b@example.com'), temper.pair_constructor('age', '25')));
    t_240 = userTable__460();
    t_241 = csid__459('name');
    t_242 = csid__459('email');
    t_243 = csid__459('age');
    cs__670 = changeset(t_240, params__669):cast(temper.listof(t_241, t_242, t_243)):validateRequired(temper.listof(csid__459('name'), csid__459('email')));
    local_244, local_245, local_246 = temper.pcall(function()
      t_239 = cs__670:toInsertSql();
      sqlFrag__671 = t_239;
    end);
    if local_244 then
    else
      sqlFrag__671 = temper.bubble();
    end
    s__672 = sqlFrag__671:toString();
    t_248 = temper.is_string_index(temper.string_indexof(s__672, '25'));
    fn__9121 = function()
      return temper.concat('age rendered unquoted: ', s__672);
    end;
    temper.test_assert(test_238, t_248, fn__9121);
    return nil;
  end);
end;
Test_.test_toInsertSqlBubblesOnInvalidChangeset__1423 = function()
  temper.test('toInsertSql bubbles on invalid changeset', function(test_249)
    local params__674, t_250, t_251, cs__675, didBubble__676, local_252, local_253, local_254, fn__9112;
    params__674 = temper.map_constructor(temper.listof());
    t_250 = userTable__460();
    t_251 = csid__459('name');
    cs__675 = changeset(t_250, params__674):cast(temper.listof(t_251)):validateRequired(temper.listof(csid__459('name')));
    local_252, local_253, local_254 = temper.pcall(function()
      cs__675:toInsertSql();
      didBubble__676 = false;
    end);
    if local_252 then
    else
      didBubble__676 = true;
    end
    fn__9112 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_249, didBubble__676, fn__9112);
    return nil;
  end);
end;
Test_.test_toInsertSqlEnforcesNonNullableFieldsIndependentlyOfIsValid__1424 = function()
  temper.test('toInsertSql enforces non-nullable fields independently of isValid', function(test_256)
    local strictTable__678, params__679, t_257, cs__680, t_258, fn__9094, didBubble__681, local_259, local_260, local_261, fn__9093;
    strictTable__678 = TableDef(csid__459('posts'), temper.listof(FieldDef(csid__459('title'), StringField(), false), FieldDef(csid__459('body'), StringField(), true)));
    params__679 = temper.map_constructor(temper.listof(temper.pair_constructor('body', 'hello')));
    t_257 = csid__459('body');
    cs__680 = changeset(strictTable__678, params__679):cast(temper.listof(t_257));
    t_258 = cs__680.isValid;
    fn__9094 = function()
      return 'changeset should appear valid (no explicit validation run)';
    end;
    temper.test_assert(test_256, t_258, fn__9094);
    local_259, local_260, local_261 = temper.pcall(function()
      cs__680:toInsertSql();
      didBubble__681 = false;
    end);
    if local_259 then
    else
      didBubble__681 = true;
    end
    fn__9093 = function()
      return 'toInsertSql should enforce nullable regardless of isValid';
    end;
    temper.test_assert(test_256, didBubble__681, fn__9093);
    return nil;
  end);
end;
Test_.test_toUpdateSqlProducesCorrectSql__1425 = function()
  temper.test('toUpdateSql produces correct SQL', function(test_263)
    local t_264, params__683, t_265, t_266, cs__684, sqlFrag__685, local_267, local_268, local_269, s__686, t_271, fn__9081;
    params__683 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob')));
    t_265 = userTable__460();
    t_266 = csid__459('name');
    cs__684 = changeset(t_265, params__683):cast(temper.listof(t_266)):validateRequired(temper.listof(csid__459('name')));
    local_267, local_268, local_269 = temper.pcall(function()
      t_264 = cs__684:toUpdateSql(42);
      sqlFrag__685 = t_264;
    end);
    if local_267 then
    else
      sqlFrag__685 = temper.bubble();
    end
    s__686 = sqlFrag__685:toString();
    t_271 = temper.str_eq(s__686, "UPDATE users SET name = 'Bob' WHERE id = 42");
    fn__9081 = function()
      return temper.concat('got: ', s__686);
    end;
    temper.test_assert(test_263, t_271, fn__9081);
    return nil;
  end);
end;
Test_.test_toUpdateSqlBubblesOnInvalidChangeset__1426 = function()
  temper.test('toUpdateSql bubbles on invalid changeset', function(test_272)
    local params__688, t_273, t_274, cs__689, didBubble__690, local_275, local_276, local_277, fn__9072;
    params__688 = temper.map_constructor(temper.listof());
    t_273 = userTable__460();
    t_274 = csid__459('name');
    cs__689 = changeset(t_273, params__688):cast(temper.listof(t_274)):validateRequired(temper.listof(csid__459('name')));
    local_275, local_276, local_277 = temper.pcall(function()
      cs__689:toUpdateSql(1);
      didBubble__690 = false;
    end);
    if local_275 then
    else
      didBubble__690 = true;
    end
    fn__9072 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_272, didBubble__690, fn__9072);
    return nil;
  end);
end;
sid__461 = function(name__932)
  local return__380, t_279, local_280, local_281, local_282;
  local_280, local_281, local_282 = temper.pcall(function()
    t_279 = safeIdentifier(name__932);
    return__380 = t_279;
  end);
  if local_280 then
  else
    return__380 = temper.bubble();
  end
  return return__380;
end;
Test_.test_bareFromProducesSelect__1475 = function()
  temper.test('bare from produces SELECT *', function(test_284)
    local q__935, t_285, fn__8676;
    q__935 = from(sid__461('users'));
    t_285 = temper.str_eq(q__935:toSql():toString(), 'SELECT * FROM users');
    fn__8676 = function()
      return 'bare query';
    end;
    temper.test_assert(test_284, t_285, fn__8676);
    return nil;
  end);
end;
Test_.test_selectRestrictsColumns__1476 = function()
  temper.test('select restricts columns', function(test_286)
    local t_287, t_288, t_289, q__937, t_290, fn__8666;
    t_287 = sid__461('users');
    t_288 = sid__461('id');
    t_289 = sid__461('name');
    q__937 = from(t_287):select(temper.listof(t_288, t_289));
    t_290 = temper.str_eq(q__937:toSql():toString(), 'SELECT id, name FROM users');
    fn__8666 = function()
      return 'select columns';
    end;
    temper.test_assert(test_286, t_290, fn__8666);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithIntValue__1477 = function()
  temper.test('where adds condition with int value', function(test_291)
    local t_292, t_293, t_294, q__939, t_295, fn__8654;
    t_292 = sid__461('users');
    t_293 = SqlBuilder();
    t_293:appendSafe('age > ');
    t_293:appendInt32(18);
    t_294 = t_293.accumulated;
    q__939 = from(t_292):where(t_294);
    t_295 = temper.str_eq(q__939:toSql():toString(), 'SELECT * FROM users WHERE age > 18');
    fn__8654 = function()
      return 'where int';
    end;
    temper.test_assert(test_291, t_295, fn__8654);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithBoolValue__1479 = function()
  temper.test('where adds condition with bool value', function(test_296)
    local t_297, t_298, t_299, q__941, t_300, fn__8642;
    t_297 = sid__461('users');
    t_298 = SqlBuilder();
    t_298:appendSafe('active = ');
    t_298:appendBoolean(true);
    t_299 = t_298.accumulated;
    q__941 = from(t_297):where(t_299);
    t_300 = temper.str_eq(q__941:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE');
    fn__8642 = function()
      return 'where bool';
    end;
    temper.test_assert(test_296, t_300, fn__8642);
    return nil;
  end);
end;
Test_.test_chainedWhereUsesAnd__1481 = function()
  temper.test('chained where uses AND', function(test_301)
    local t_302, t_303, t_304, t_305, t_306, q__943, t_307, fn__8625;
    t_302 = sid__461('users');
    t_303 = SqlBuilder();
    t_303:appendSafe('age > ');
    t_303:appendInt32(18);
    t_304 = t_303.accumulated;
    t_305 = from(t_302):where(t_304);
    t_306 = SqlBuilder();
    t_306:appendSafe('active = ');
    t_306:appendBoolean(true);
    q__943 = t_305:where(t_306.accumulated);
    t_307 = temper.str_eq(q__943:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE');
    fn__8625 = function()
      return 'chained where';
    end;
    temper.test_assert(test_301, t_307, fn__8625);
    return nil;
  end);
end;
Test_.test_orderByAsc__1484 = function()
  temper.test('orderBy ASC', function(test_308)
    local t_309, t_310, q__945, t_311, fn__8616;
    t_309 = sid__461('users');
    t_310 = sid__461('name');
    q__945 = from(t_309):orderBy(t_310, true);
    t_311 = temper.str_eq(q__945:toSql():toString(), 'SELECT * FROM users ORDER BY name ASC');
    fn__8616 = function()
      return 'order asc';
    end;
    temper.test_assert(test_308, t_311, fn__8616);
    return nil;
  end);
end;
Test_.test_orderByDesc__1485 = function()
  temper.test('orderBy DESC', function(test_312)
    local t_313, t_314, q__947, t_315, fn__8607;
    t_313 = sid__461('users');
    t_314 = sid__461('created_at');
    q__947 = from(t_313):orderBy(t_314, false);
    t_315 = temper.str_eq(q__947:toSql():toString(), 'SELECT * FROM users ORDER BY created_at DESC');
    fn__8607 = function()
      return 'order desc';
    end;
    temper.test_assert(test_312, t_315, fn__8607);
    return nil;
  end);
end;
Test_.test_limitAndOffset__1486 = function()
  temper.test('limit and offset', function(test_316)
    local t_317, t_318, q__949, local_319, local_320, local_321, t_323, fn__8600;
    local_319, local_320, local_321 = temper.pcall(function()
      t_317 = from(sid__461('users')):limit(10);
      t_318 = t_317:offset(20);
      q__949 = t_318;
    end);
    if local_319 then
    else
      q__949 = temper.bubble();
    end
    t_323 = temper.str_eq(q__949:toSql():toString(), 'SELECT * FROM users LIMIT 10 OFFSET 20');
    fn__8600 = function()
      return 'limit/offset';
    end;
    temper.test_assert(test_316, t_323, fn__8600);
    return nil;
  end);
end;
Test_.test_limitBubblesOnNegative__1487 = function()
  temper.test('limit bubbles on negative', function(test_324)
    local didBubble__951, local_325, local_326, local_327, fn__8596;
    local_325, local_326, local_327 = temper.pcall(function()
      from(sid__461('users')):limit(-1);
      didBubble__951 = false;
    end);
    if local_325 then
    else
      didBubble__951 = true;
    end
    fn__8596 = function()
      return 'negative limit should bubble';
    end;
    temper.test_assert(test_324, didBubble__951, fn__8596);
    return nil;
  end);
end;
Test_.test_offsetBubblesOnNegative__1488 = function()
  temper.test('offset bubbles on negative', function(test_329)
    local didBubble__953, local_330, local_331, local_332, fn__8592;
    local_330, local_331, local_332 = temper.pcall(function()
      from(sid__461('users')):offset(-1);
      didBubble__953 = false;
    end);
    if local_330 then
    else
      didBubble__953 = true;
    end
    fn__8592 = function()
      return 'negative offset should bubble';
    end;
    temper.test_assert(test_329, didBubble__953, fn__8592);
    return nil;
  end);
end;
Test_.test_complexComposedQuery__1489 = function()
  temper.test('complex composed query', function(test_334)
    local t_335, t_336, t_337, t_338, t_339, t_340, t_341, t_342, t_343, t_344, minAge__955, q__956, local_345, local_346, local_347, t_349, fn__8569;
    minAge__955 = 21;
    local_345, local_346, local_347 = temper.pcall(function()
      t_335 = sid__461('users');
      t_336 = sid__461('id');
      t_337 = sid__461('name');
      t_338 = sid__461('email');
      t_339 = from(t_335):select(temper.listof(t_336, t_337, t_338));
      t_340 = SqlBuilder();
      t_340:appendSafe('age >= ');
      t_340:appendInt32(21);
      t_341 = t_339:where(t_340.accumulated);
      t_342 = SqlBuilder();
      t_342:appendSafe('active = ');
      t_342:appendBoolean(true);
      t_343 = t_341:where(t_342.accumulated):orderBy(sid__461('name'), true):limit(25);
      t_344 = t_343:offset(0);
      q__956 = t_344;
    end);
    if local_345 then
    else
      q__956 = temper.bubble();
    end
    t_349 = temper.str_eq(q__956:toSql():toString(), 'SELECT id, name, email FROM users WHERE age >= 21 AND active = TRUE ORDER BY name ASC LIMIT 25 OFFSET 0');
    fn__8569 = function()
      return 'complex query';
    end;
    temper.test_assert(test_334, t_349, fn__8569);
    return nil;
  end);
end;
Test_.test_safeToSqlAppliesDefaultLimitWhenNoneSet__1492 = function()
  temper.test('safeToSql applies default limit when none set', function(test_350)
    local t_351, t_352, q__958, local_353, local_354, local_355, s__959, t_357, fn__8563;
    q__958 = from(sid__461('users'));
    local_353, local_354, local_355 = temper.pcall(function()
      t_351 = q__958:safeToSql(100);
      t_352 = t_351;
    end);
    if local_353 then
    else
      t_352 = temper.bubble();
    end
    s__959 = t_352:toString();
    t_357 = temper.str_eq(s__959, 'SELECT * FROM users LIMIT 100');
    fn__8563 = function()
      return temper.concat('should have limit: ', s__959);
    end;
    temper.test_assert(test_350, t_357, fn__8563);
    return nil;
  end);
end;
Test_.test_safeToSqlRespectsExplicitLimit__1493 = function()
  temper.test('safeToSql respects explicit limit', function(test_358)
    local t_359, t_360, t_361, q__961, local_362, local_363, local_364, local_366, local_367, local_368, s__962, t_370, fn__8557;
    local_362, local_363, local_364 = temper.pcall(function()
      t_359 = from(sid__461('users')):limit(5);
      q__961 = t_359;
    end);
    if local_362 then
    else
      q__961 = temper.bubble();
    end
    local_366, local_367, local_368 = temper.pcall(function()
      t_360 = q__961:safeToSql(100);
      t_361 = t_360;
    end);
    if local_366 then
    else
      t_361 = temper.bubble();
    end
    s__962 = t_361:toString();
    t_370 = temper.str_eq(s__962, 'SELECT * FROM users LIMIT 5');
    fn__8557 = function()
      return temper.concat('explicit limit preserved: ', s__962);
    end;
    temper.test_assert(test_358, t_370, fn__8557);
    return nil;
  end);
end;
Test_.test_safeToSqlBubblesOnNegativeDefaultLimit__1494 = function()
  temper.test('safeToSql bubbles on negative defaultLimit', function(test_371)
    local didBubble__964, local_372, local_373, local_374, fn__8553;
    local_372, local_373, local_374 = temper.pcall(function()
      from(sid__461('users')):safeToSql(-1);
      didBubble__964 = false;
    end);
    if local_372 then
    else
      didBubble__964 = true;
    end
    fn__8553 = function()
      return 'negative defaultLimit should bubble';
    end;
    temper.test_assert(test_371, didBubble__964, fn__8553);
    return nil;
  end);
end;
Test_.test_whereWithInjectionAttemptInStringValueIsEscaped__1495 = function()
  temper.test('where with injection attempt in string value is escaped', function(test_376)
    local evil__966, t_377, t_378, t_379, q__967, s__968, t_380, fn__8536, t_381, fn__8535;
    evil__966 = "'; DROP TABLE users; --";
    t_377 = sid__461('users');
    t_378 = SqlBuilder();
    t_378:appendSafe('name = ');
    t_378:appendString("'; DROP TABLE users; --");
    t_379 = t_378.accumulated;
    q__967 = from(t_377):where(t_379);
    s__968 = q__967:toSql():toString();
    t_380 = temper.is_string_index(temper.string_indexof(s__968, "''"));
    fn__8536 = function()
      return temper.concat('quotes must be doubled: ', s__968);
    end;
    temper.test_assert(test_376, t_380, fn__8536);
    t_381 = temper.is_string_index(temper.string_indexof(s__968, 'SELECT * FROM users WHERE name ='));
    fn__8535 = function()
      return temper.concat('structure intact: ', s__968);
    end;
    temper.test_assert(test_376, t_381, fn__8535);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsUserSuppliedTableNameWithMetacharacters__1497 = function()
  temper.test('safeIdentifier rejects user-supplied table name with metacharacters', function(test_382)
    local attack__970, didBubble__971, local_383, local_384, local_385, fn__8532;
    attack__970 = 'users; DROP TABLE users; --';
    local_383, local_384, local_385 = temper.pcall(function()
      safeIdentifier('users; DROP TABLE users; --');
      didBubble__971 = false;
    end);
    if local_383 then
    else
      didBubble__971 = true;
    end
    fn__8532 = function()
      return 'metacharacter-containing name must be rejected at construction';
    end;
    temper.test_assert(test_382, didBubble__971, fn__8532);
    return nil;
  end);
end;
Test_.test_innerJoinProducesInnerJoin__1498 = function()
  temper.test('innerJoin produces INNER JOIN', function(test_387)
    local t_388, t_389, t_390, t_391, q__973, t_392, fn__8520;
    t_388 = sid__461('users');
    t_389 = sid__461('orders');
    t_390 = SqlBuilder();
    t_390:appendSafe('users.id = orders.user_id');
    t_391 = t_390.accumulated;
    q__973 = from(t_388):innerJoin(t_389, t_391);
    t_392 = temper.str_eq(q__973:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id');
    fn__8520 = function()
      return 'inner join';
    end;
    temper.test_assert(test_387, t_392, fn__8520);
    return nil;
  end);
end;
Test_.test_leftJoinProducesLeftJoin__1500 = function()
  temper.test('leftJoin produces LEFT JOIN', function(test_393)
    local t_394, t_395, t_396, t_397, q__975, t_398, fn__8508;
    t_394 = sid__461('users');
    t_395 = sid__461('profiles');
    t_396 = SqlBuilder();
    t_396:appendSafe('users.id = profiles.user_id');
    t_397 = t_396.accumulated;
    q__975 = from(t_394):leftJoin(t_395, t_397);
    t_398 = temper.str_eq(q__975:toSql():toString(), 'SELECT * FROM users LEFT JOIN profiles ON users.id = profiles.user_id');
    fn__8508 = function()
      return 'left join';
    end;
    temper.test_assert(test_393, t_398, fn__8508);
    return nil;
  end);
end;
Test_.test_rightJoinProducesRightJoin__1502 = function()
  temper.test('rightJoin produces RIGHT JOIN', function(test_399)
    local t_400, t_401, t_402, t_403, q__977, t_404, fn__8496;
    t_400 = sid__461('orders');
    t_401 = sid__461('users');
    t_402 = SqlBuilder();
    t_402:appendSafe('orders.user_id = users.id');
    t_403 = t_402.accumulated;
    q__977 = from(t_400):rightJoin(t_401, t_403);
    t_404 = temper.str_eq(q__977:toSql():toString(), 'SELECT * FROM orders RIGHT JOIN users ON orders.user_id = users.id');
    fn__8496 = function()
      return 'right join';
    end;
    temper.test_assert(test_399, t_404, fn__8496);
    return nil;
  end);
end;
Test_.test_fullJoinProducesFullOuterJoin__1504 = function()
  temper.test('fullJoin produces FULL OUTER JOIN', function(test_405)
    local t_406, t_407, t_408, t_409, q__979, t_410, fn__8484;
    t_406 = sid__461('users');
    t_407 = sid__461('orders');
    t_408 = SqlBuilder();
    t_408:appendSafe('users.id = orders.user_id');
    t_409 = t_408.accumulated;
    q__979 = from(t_406):fullJoin(t_407, t_409);
    t_410 = temper.str_eq(q__979:toSql():toString(), 'SELECT * FROM users FULL OUTER JOIN orders ON users.id = orders.user_id');
    fn__8484 = function()
      return 'full join';
    end;
    temper.test_assert(test_405, t_410, fn__8484);
    return nil;
  end);
end;
Test_.test_chainedJoins__1506 = function()
  temper.test('chained joins', function(test_411)
    local t_412, t_413, t_414, t_415, t_416, t_417, t_418, q__981, t_419, fn__8467;
    t_412 = sid__461('users');
    t_413 = sid__461('orders');
    t_414 = SqlBuilder();
    t_414:appendSafe('users.id = orders.user_id');
    t_415 = t_414.accumulated;
    t_416 = from(t_412):innerJoin(t_413, t_415);
    t_417 = sid__461('profiles');
    t_418 = SqlBuilder();
    t_418:appendSafe('users.id = profiles.user_id');
    q__981 = t_416:leftJoin(t_417, t_418.accumulated);
    t_419 = temper.str_eq(q__981:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id LEFT JOIN profiles ON users.id = profiles.user_id');
    fn__8467 = function()
      return 'chained joins';
    end;
    temper.test_assert(test_411, t_419, fn__8467);
    return nil;
  end);
end;
Test_.test_joinWithWhereAndOrderBy__1509 = function()
  temper.test('join with where and orderBy', function(test_420)
    local t_421, t_422, t_423, t_424, t_425, t_426, t_427, q__983, local_428, local_429, local_430, t_432, fn__8448;
    local_428, local_429, local_430 = temper.pcall(function()
      t_421 = sid__461('users');
      t_422 = sid__461('orders');
      t_423 = SqlBuilder();
      t_423:appendSafe('users.id = orders.user_id');
      t_424 = t_423.accumulated;
      t_425 = from(t_421):innerJoin(t_422, t_424);
      t_426 = SqlBuilder();
      t_426:appendSafe('orders.total > ');
      t_426:appendInt32(100);
      t_427 = t_425:where(t_426.accumulated):orderBy(sid__461('name'), true):limit(10);
      q__983 = t_427;
    end);
    if local_428 then
    else
      q__983 = temper.bubble();
    end
    t_432 = temper.str_eq(q__983:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id WHERE orders.total > 100 ORDER BY name ASC LIMIT 10');
    fn__8448 = function()
      return 'join with where/order/limit';
    end;
    temper.test_assert(test_420, t_432, fn__8448);
    return nil;
  end);
end;
Test_.test_colHelperProducesQualifiedReference__1512 = function()
  temper.test('col helper produces qualified reference', function(test_433)
    local c__985, t_434, fn__8440;
    c__985 = col(sid__461('users'), sid__461('id'));
    t_434 = temper.str_eq(c__985:toString(), 'users.id');
    fn__8440 = function()
      return 'col helper';
    end;
    temper.test_assert(test_433, t_434, fn__8440);
    return nil;
  end);
end;
Test_.test_joinWithColHelper__1513 = function()
  temper.test('join with col helper', function(test_435)
    local onCond__987, b__988, t_436, t_437, t_438, q__989, t_439, fn__8420;
    onCond__987 = col(sid__461('users'), sid__461('id'));
    b__988 = SqlBuilder();
    b__988:appendFragment(onCond__987);
    b__988:appendSafe(' = ');
    b__988:appendFragment(col(sid__461('orders'), sid__461('user_id')));
    t_436 = sid__461('users');
    t_437 = sid__461('orders');
    t_438 = b__988.accumulated;
    q__989 = from(t_436):innerJoin(t_437, t_438);
    t_439 = temper.str_eq(q__989:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id');
    fn__8420 = function()
      return 'join with col';
    end;
    temper.test_assert(test_435, t_439, fn__8420);
    return nil;
  end);
end;
Test_.test_orWhereBasic__1514 = function()
  temper.test('orWhere basic', function(test_440)
    local t_441, t_442, t_443, q__991, t_444, fn__8408;
    t_441 = sid__461('users');
    t_442 = SqlBuilder();
    t_442:appendSafe('status = ');
    t_442:appendString('active');
    t_443 = t_442.accumulated;
    q__991 = from(t_441):orWhere(t_443);
    t_444 = temper.str_eq(q__991:toSql():toString(), "SELECT * FROM users WHERE status = 'active'");
    fn__8408 = function()
      return 'orWhere basic';
    end;
    temper.test_assert(test_440, t_444, fn__8408);
    return nil;
  end);
end;
Test_.test_whereThenOrWhere__1516 = function()
  temper.test('where then orWhere', function(test_445)
    local t_446, t_447, t_448, t_449, t_450, q__993, t_451, fn__8391;
    t_446 = sid__461('users');
    t_447 = SqlBuilder();
    t_447:appendSafe('age > ');
    t_447:appendInt32(18);
    t_448 = t_447.accumulated;
    t_449 = from(t_446):where(t_448);
    t_450 = SqlBuilder();
    t_450:appendSafe('vip = ');
    t_450:appendBoolean(true);
    q__993 = t_449:orWhere(t_450.accumulated);
    t_451 = temper.str_eq(q__993:toSql():toString(), 'SELECT * FROM users WHERE age > 18 OR vip = TRUE');
    fn__8391 = function()
      return 'where then orWhere';
    end;
    temper.test_assert(test_445, t_451, fn__8391);
    return nil;
  end);
end;
Test_.test_multipleOrWhere__1519 = function()
  temper.test('multiple orWhere', function(test_452)
    local t_453, t_454, t_455, t_456, t_457, t_458, t_459, q__995, t_460, fn__8369;
    t_453 = sid__461('users');
    t_454 = SqlBuilder();
    t_454:appendSafe('active = ');
    t_454:appendBoolean(true);
    t_455 = t_454.accumulated;
    t_456 = from(t_453):where(t_455);
    t_457 = SqlBuilder();
    t_457:appendSafe('role = ');
    t_457:appendString('admin');
    t_458 = t_456:orWhere(t_457.accumulated);
    t_459 = SqlBuilder();
    t_459:appendSafe('role = ');
    t_459:appendString('moderator');
    q__995 = t_458:orWhere(t_459.accumulated);
    t_460 = temper.str_eq(q__995:toSql():toString(), "SELECT * FROM users WHERE active = TRUE OR role = 'admin' OR role = 'moderator'");
    fn__8369 = function()
      return 'multiple orWhere';
    end;
    temper.test_assert(test_452, t_460, fn__8369);
    return nil;
  end);
end;
Test_.test_mixedWhereAndOrWhere__1523 = function()
  temper.test('mixed where and orWhere', function(test_461)
    local t_462, t_463, t_464, t_465, t_466, t_467, t_468, q__997, t_469, fn__8347;
    t_462 = sid__461('users');
    t_463 = SqlBuilder();
    t_463:appendSafe('age > ');
    t_463:appendInt32(18);
    t_464 = t_463.accumulated;
    t_465 = from(t_462):where(t_464);
    t_466 = SqlBuilder();
    t_466:appendSafe('active = ');
    t_466:appendBoolean(true);
    t_467 = t_465:where(t_466.accumulated);
    t_468 = SqlBuilder();
    t_468:appendSafe('vip = ');
    t_468:appendBoolean(true);
    q__997 = t_467:orWhere(t_468.accumulated);
    t_469 = temper.str_eq(q__997:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE OR vip = TRUE');
    fn__8347 = function()
      return 'mixed where and orWhere';
    end;
    temper.test_assert(test_461, t_469, fn__8347);
    return nil;
  end);
end;
Test_.test_whereNull__1527 = function()
  temper.test('whereNull', function(test_470)
    local t_471, t_472, q__999, t_473, fn__8338;
    t_471 = sid__461('users');
    t_472 = sid__461('deleted_at');
    q__999 = from(t_471):whereNull(t_472);
    t_473 = temper.str_eq(q__999:toSql():toString(), 'SELECT * FROM users WHERE deleted_at IS NULL');
    fn__8338 = function()
      return 'whereNull';
    end;
    temper.test_assert(test_470, t_473, fn__8338);
    return nil;
  end);
end;
Test_.test_whereNotNull__1528 = function()
  temper.test('whereNotNull', function(test_474)
    local t_475, t_476, q__1001, t_477, fn__8329;
    t_475 = sid__461('users');
    t_476 = sid__461('email');
    q__1001 = from(t_475):whereNotNull(t_476);
    t_477 = temper.str_eq(q__1001:toSql():toString(), 'SELECT * FROM users WHERE email IS NOT NULL');
    fn__8329 = function()
      return 'whereNotNull';
    end;
    temper.test_assert(test_474, t_477, fn__8329);
    return nil;
  end);
end;
Test_.test_whereNullChainedWithWhere__1529 = function()
  temper.test('whereNull chained with where', function(test_478)
    local t_479, t_480, t_481, q__1003, t_482, fn__8315;
    t_479 = sid__461('users');
    t_480 = SqlBuilder();
    t_480:appendSafe('active = ');
    t_480:appendBoolean(true);
    t_481 = t_480.accumulated;
    q__1003 = from(t_479):where(t_481):whereNull(sid__461('deleted_at'));
    t_482 = temper.str_eq(q__1003:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE AND deleted_at IS NULL');
    fn__8315 = function()
      return 'whereNull chained';
    end;
    temper.test_assert(test_478, t_482, fn__8315);
    return nil;
  end);
end;
Test_.test_whereNotNullChainedWithOrWhere__1531 = function()
  temper.test('whereNotNull chained with orWhere', function(test_483)
    local t_484, t_485, t_486, t_487, q__1005, t_488, fn__8301;
    t_484 = sid__461('users');
    t_485 = sid__461('deleted_at');
    t_486 = from(t_484):whereNull(t_485);
    t_487 = SqlBuilder();
    t_487:appendSafe('role = ');
    t_487:appendString('admin');
    q__1005 = t_486:orWhere(t_487.accumulated);
    t_488 = temper.str_eq(q__1005:toSql():toString(), "SELECT * FROM users WHERE deleted_at IS NULL OR role = 'admin'");
    fn__8301 = function()
      return 'whereNotNull with orWhere';
    end;
    temper.test_assert(test_483, t_488, fn__8301);
    return nil;
  end);
end;
Test_.test_whereInWithIntValues__1533 = function()
  temper.test('whereIn with int values', function(test_489)
    local t_490, t_491, t_492, t_493, t_494, q__1007, t_495, fn__8289;
    t_490 = sid__461('users');
    t_491 = sid__461('id');
    t_492 = SqlInt32(1);
    t_493 = SqlInt32(2);
    t_494 = SqlInt32(3);
    q__1007 = from(t_490):whereIn(t_491, temper.listof(t_492, t_493, t_494));
    t_495 = temper.str_eq(q__1007:toSql():toString(), 'SELECT * FROM users WHERE id IN (1, 2, 3)');
    fn__8289 = function()
      return 'whereIn ints';
    end;
    temper.test_assert(test_489, t_495, fn__8289);
    return nil;
  end);
end;
Test_.test_whereInWithStringValuesEscaping__1534 = function()
  temper.test('whereIn with string values escaping', function(test_496)
    local t_497, t_498, t_499, t_500, q__1009, t_501, fn__8278;
    t_497 = sid__461('users');
    t_498 = sid__461('name');
    t_499 = SqlString('Alice');
    t_500 = SqlString("Bob's");
    q__1009 = from(t_497):whereIn(t_498, temper.listof(t_499, t_500));
    t_501 = temper.str_eq(q__1009:toSql():toString(), "SELECT * FROM users WHERE name IN ('Alice', 'Bob''s')");
    fn__8278 = function()
      return 'whereIn strings';
    end;
    temper.test_assert(test_496, t_501, fn__8278);
    return nil;
  end);
end;
Test_.test_whereInWithEmptyListProduces1_0__1535 = function()
  temper.test('whereIn with empty list produces 1=0', function(test_502)
    local t_503, t_504, q__1011, t_505, fn__8269;
    t_503 = sid__461('users');
    t_504 = sid__461('id');
    q__1011 = from(t_503):whereIn(t_504, temper.listof());
    t_505 = temper.str_eq(q__1011:toSql():toString(), 'SELECT * FROM users WHERE 1 = 0');
    fn__8269 = function()
      return 'whereIn empty';
    end;
    temper.test_assert(test_502, t_505, fn__8269);
    return nil;
  end);
end;
Test_.test_whereInChained__1536 = function()
  temper.test('whereIn chained', function(test_506)
    local t_507, t_508, t_509, q__1013, t_510, fn__8253;
    t_507 = sid__461('users');
    t_508 = SqlBuilder();
    t_508:appendSafe('active = ');
    t_508:appendBoolean(true);
    t_509 = t_508.accumulated;
    q__1013 = from(t_507):where(t_509):whereIn(sid__461('role'), temper.listof(SqlString('admin'), SqlString('user')));
    t_510 = temper.str_eq(q__1013:toSql():toString(), "SELECT * FROM users WHERE active = TRUE AND role IN ('admin', 'user')");
    fn__8253 = function()
      return 'whereIn chained';
    end;
    temper.test_assert(test_506, t_510, fn__8253);
    return nil;
  end);
end;
Test_.test_whereInSingleElement__1538 = function()
  temper.test('whereIn single element', function(test_511)
    local t_512, t_513, t_514, q__1015, t_515, fn__8243;
    t_512 = sid__461('users');
    t_513 = sid__461('id');
    t_514 = SqlInt32(42);
    q__1015 = from(t_512):whereIn(t_513, temper.listof(t_514));
    t_515 = temper.str_eq(q__1015:toSql():toString(), 'SELECT * FROM users WHERE id IN (42)');
    fn__8243 = function()
      return 'whereIn single';
    end;
    temper.test_assert(test_511, t_515, fn__8243);
    return nil;
  end);
end;
Test_.test_whereNotBasic__1539 = function()
  temper.test('whereNot basic', function(test_516)
    local t_517, t_518, t_519, q__1017, t_520, fn__8231;
    t_517 = sid__461('users');
    t_518 = SqlBuilder();
    t_518:appendSafe('active = ');
    t_518:appendBoolean(true);
    t_519 = t_518.accumulated;
    q__1017 = from(t_517):whereNot(t_519);
    t_520 = temper.str_eq(q__1017:toSql():toString(), 'SELECT * FROM users WHERE NOT (active = TRUE)');
    fn__8231 = function()
      return 'whereNot';
    end;
    temper.test_assert(test_516, t_520, fn__8231);
    return nil;
  end);
end;
Test_.test_whereNotChained__1541 = function()
  temper.test('whereNot chained', function(test_521)
    local t_522, t_523, t_524, t_525, t_526, q__1019, t_527, fn__8214;
    t_522 = sid__461('users');
    t_523 = SqlBuilder();
    t_523:appendSafe('age > ');
    t_523:appendInt32(18);
    t_524 = t_523.accumulated;
    t_525 = from(t_522):where(t_524);
    t_526 = SqlBuilder();
    t_526:appendSafe('banned = ');
    t_526:appendBoolean(true);
    q__1019 = t_525:whereNot(t_526.accumulated);
    t_527 = temper.str_eq(q__1019:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND NOT (banned = TRUE)');
    fn__8214 = function()
      return 'whereNot chained';
    end;
    temper.test_assert(test_521, t_527, fn__8214);
    return nil;
  end);
end;
Test_.test_whereBetweenIntegers__1544 = function()
  temper.test('whereBetween integers', function(test_528)
    local t_529, t_530, t_531, t_532, q__1021, t_533, fn__8203;
    t_529 = sid__461('users');
    t_530 = sid__461('age');
    t_531 = SqlInt32(18);
    t_532 = SqlInt32(65);
    q__1021 = from(t_529):whereBetween(t_530, t_531, t_532);
    t_533 = temper.str_eq(q__1021:toSql():toString(), 'SELECT * FROM users WHERE age BETWEEN 18 AND 65');
    fn__8203 = function()
      return 'whereBetween ints';
    end;
    temper.test_assert(test_528, t_533, fn__8203);
    return nil;
  end);
end;
Test_.test_whereBetweenChained__1545 = function()
  temper.test('whereBetween chained', function(test_534)
    local t_535, t_536, t_537, q__1023, t_538, fn__8187;
    t_535 = sid__461('users');
    t_536 = SqlBuilder();
    t_536:appendSafe('active = ');
    t_536:appendBoolean(true);
    t_537 = t_536.accumulated;
    q__1023 = from(t_535):where(t_537):whereBetween(sid__461('age'), SqlInt32(21), SqlInt32(30));
    t_538 = temper.str_eq(q__1023:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE AND age BETWEEN 21 AND 30');
    fn__8187 = function()
      return 'whereBetween chained';
    end;
    temper.test_assert(test_534, t_538, fn__8187);
    return nil;
  end);
end;
Test_.test_whereLikeBasic__1547 = function()
  temper.test('whereLike basic', function(test_539)
    local t_540, t_541, q__1025, t_542, fn__8178;
    t_540 = sid__461('users');
    t_541 = sid__461('name');
    q__1025 = from(t_540):whereLike(t_541, 'John%');
    t_542 = temper.str_eq(q__1025:toSql():toString(), "SELECT * FROM users WHERE name LIKE 'John%'");
    fn__8178 = function()
      return 'whereLike';
    end;
    temper.test_assert(test_539, t_542, fn__8178);
    return nil;
  end);
end;
Test_.test_whereIlikeBasic__1548 = function()
  temper.test('whereILike basic', function(test_543)
    local t_544, t_545, q__1027, t_546, fn__8169;
    t_544 = sid__461('users');
    t_545 = sid__461('email');
    q__1027 = from(t_544):whereILike(t_545, '%@gmail.com');
    t_546 = temper.str_eq(q__1027:toSql():toString(), "SELECT * FROM users WHERE email ILIKE '%@gmail.com'");
    fn__8169 = function()
      return 'whereILike';
    end;
    temper.test_assert(test_543, t_546, fn__8169);
    return nil;
  end);
end;
Test_.test_whereLikeWithInjectionAttempt__1549 = function()
  temper.test('whereLike with injection attempt', function(test_547)
    local t_548, t_549, q__1029, s__1030, t_550, fn__8155, t_551, fn__8154;
    t_548 = sid__461('users');
    t_549 = sid__461('name');
    q__1029 = from(t_548):whereLike(t_549, "'; DROP TABLE users; --");
    s__1030 = q__1029:toSql():toString();
    t_550 = temper.is_string_index(temper.string_indexof(s__1030, "''"));
    fn__8155 = function()
      return temper.concat('like injection escaped: ', s__1030);
    end;
    temper.test_assert(test_547, t_550, fn__8155);
    t_551 = temper.is_string_index(temper.string_indexof(s__1030, 'LIKE'));
    fn__8154 = function()
      return temper.concat('like structure intact: ', s__1030);
    end;
    temper.test_assert(test_547, t_551, fn__8154);
    return nil;
  end);
end;
Test_.test_whereLikeWildcardPatterns__1550 = function()
  temper.test('whereLike wildcard patterns', function(test_552)
    local t_553, t_554, q__1032, t_555, fn__8145;
    t_553 = sid__461('users');
    t_554 = sid__461('name');
    q__1032 = from(t_553):whereLike(t_554, '%son%');
    t_555 = temper.str_eq(q__1032:toSql():toString(), "SELECT * FROM users WHERE name LIKE '%son%'");
    fn__8145 = function()
      return 'whereLike wildcard';
    end;
    temper.test_assert(test_552, t_555, fn__8145);
    return nil;
  end);
end;
Test_.test_countAllProducesCount__1551 = function()
  temper.test('countAll produces COUNT(*)', function(test_556)
    local f__1034, t_557, fn__8139;
    f__1034 = countAll();
    t_557 = temper.str_eq(f__1034:toString(), 'COUNT(*)');
    fn__8139 = function()
      return 'countAll';
    end;
    temper.test_assert(test_556, t_557, fn__8139);
    return nil;
  end);
end;
Test_.test_countColProducesCountField__1552 = function()
  temper.test('countCol produces COUNT(field)', function(test_558)
    local f__1036, t_559, fn__8132;
    f__1036 = countCol(sid__461('id'));
    t_559 = temper.str_eq(f__1036:toString(), 'COUNT(id)');
    fn__8132 = function()
      return 'countCol';
    end;
    temper.test_assert(test_558, t_559, fn__8132);
    return nil;
  end);
end;
Test_.test_sumColProducesSumField__1553 = function()
  temper.test('sumCol produces SUM(field)', function(test_560)
    local f__1038, t_561, fn__8125;
    f__1038 = sumCol(sid__461('amount'));
    t_561 = temper.str_eq(f__1038:toString(), 'SUM(amount)');
    fn__8125 = function()
      return 'sumCol';
    end;
    temper.test_assert(test_560, t_561, fn__8125);
    return nil;
  end);
end;
Test_.test_avgColProducesAvgField__1554 = function()
  temper.test('avgCol produces AVG(field)', function(test_562)
    local f__1040, t_563, fn__8118;
    f__1040 = avgCol(sid__461('price'));
    t_563 = temper.str_eq(f__1040:toString(), 'AVG(price)');
    fn__8118 = function()
      return 'avgCol';
    end;
    temper.test_assert(test_562, t_563, fn__8118);
    return nil;
  end);
end;
Test_.test_minColProducesMinField__1555 = function()
  temper.test('minCol produces MIN(field)', function(test_564)
    local f__1042, t_565, fn__8111;
    f__1042 = minCol(sid__461('created_at'));
    t_565 = temper.str_eq(f__1042:toString(), 'MIN(created_at)');
    fn__8111 = function()
      return 'minCol';
    end;
    temper.test_assert(test_564, t_565, fn__8111);
    return nil;
  end);
end;
Test_.test_maxColProducesMaxField__1556 = function()
  temper.test('maxCol produces MAX(field)', function(test_566)
    local f__1044, t_567, fn__8104;
    f__1044 = maxCol(sid__461('score'));
    t_567 = temper.str_eq(f__1044:toString(), 'MAX(score)');
    fn__8104 = function()
      return 'maxCol';
    end;
    temper.test_assert(test_566, t_567, fn__8104);
    return nil;
  end);
end;
Test_.test_selectExprWithAggregate__1557 = function()
  temper.test('selectExpr with aggregate', function(test_568)
    local t_569, t_570, q__1046, t_571, fn__8095;
    t_569 = sid__461('orders');
    t_570 = countAll();
    q__1046 = from(t_569):selectExpr(temper.listof(t_570));
    t_571 = temper.str_eq(q__1046:toSql():toString(), 'SELECT COUNT(*) FROM orders');
    fn__8095 = function()
      return 'selectExpr count';
    end;
    temper.test_assert(test_568, t_571, fn__8095);
    return nil;
  end);
end;
Test_.test_selectExprWithMultipleExpressions__1558 = function()
  temper.test('selectExpr with multiple expressions', function(test_572)
    local nameFrag__1048, t_573, t_574, q__1049, t_575, fn__8083;
    nameFrag__1048 = col(sid__461('users'), sid__461('name'));
    t_573 = sid__461('users');
    t_574 = countAll();
    q__1049 = from(t_573):selectExpr(temper.listof(nameFrag__1048, t_574));
    t_575 = temper.str_eq(q__1049:toSql():toString(), 'SELECT users.name, COUNT(*) FROM users');
    fn__8083 = function()
      return 'selectExpr multi';
    end;
    temper.test_assert(test_572, t_575, fn__8083);
    return nil;
  end);
end;
Test_.test_selectExprOverridesSelectedFields__1559 = function()
  temper.test('selectExpr overrides selectedFields', function(test_576)
    local t_577, t_578, t_579, q__1051, t_580, fn__8071;
    t_577 = sid__461('users');
    t_578 = sid__461('id');
    t_579 = sid__461('name');
    q__1051 = from(t_577):select(temper.listof(t_578, t_579)):selectExpr(temper.listof(countAll()));
    t_580 = temper.str_eq(q__1051:toSql():toString(), 'SELECT COUNT(*) FROM users');
    fn__8071 = function()
      return 'selectExpr overrides select';
    end;
    temper.test_assert(test_576, t_580, fn__8071);
    return nil;
  end);
end;
Test_.test_groupBySingleField__1560 = function()
  temper.test('groupBy single field', function(test_581)
    local t_582, t_583, t_584, q__1053, t_585, fn__8057;
    t_582 = sid__461('orders');
    t_583 = col(sid__461('orders'), sid__461('status'));
    t_584 = countAll();
    q__1053 = from(t_582):selectExpr(temper.listof(t_583, t_584)):groupBy(sid__461('status'));
    t_585 = temper.str_eq(q__1053:toSql():toString(), 'SELECT orders.status, COUNT(*) FROM orders GROUP BY status');
    fn__8057 = function()
      return 'groupBy single';
    end;
    temper.test_assert(test_581, t_585, fn__8057);
    return nil;
  end);
end;
Test_.test_groupByMultipleFields__1561 = function()
  temper.test('groupBy multiple fields', function(test_586)
    local t_587, t_588, q__1055, t_589, fn__8046;
    t_587 = sid__461('orders');
    t_588 = sid__461('status');
    q__1055 = from(t_587):groupBy(t_588):groupBy(sid__461('category'));
    t_589 = temper.str_eq(q__1055:toSql():toString(), 'SELECT * FROM orders GROUP BY status, category');
    fn__8046 = function()
      return 'groupBy multiple';
    end;
    temper.test_assert(test_586, t_589, fn__8046);
    return nil;
  end);
end;
Test_.test_havingBasic__1562 = function()
  temper.test('having basic', function(test_590)
    local t_591, t_592, t_593, t_594, t_595, q__1057, t_596, fn__8027;
    t_591 = sid__461('orders');
    t_592 = col(sid__461('orders'), sid__461('status'));
    t_593 = countAll();
    t_594 = from(t_591):selectExpr(temper.listof(t_592, t_593)):groupBy(sid__461('status'));
    t_595 = SqlBuilder();
    t_595:appendSafe('COUNT(*) > ');
    t_595:appendInt32(5);
    q__1057 = t_594:having(t_595.accumulated);
    t_596 = temper.str_eq(q__1057:toSql():toString(), 'SELECT orders.status, COUNT(*) FROM orders GROUP BY status HAVING COUNT(*) > 5');
    fn__8027 = function()
      return 'having basic';
    end;
    temper.test_assert(test_590, t_596, fn__8027);
    return nil;
  end);
end;
Test_.test_orHaving__1564 = function()
  temper.test('orHaving', function(test_597)
    local t_598, t_599, t_600, t_601, t_602, t_603, q__1059, t_604, fn__8008;
    t_598 = sid__461('orders');
    t_599 = sid__461('status');
    t_600 = from(t_598):groupBy(t_599);
    t_601 = SqlBuilder();
    t_601:appendSafe('COUNT(*) > ');
    t_601:appendInt32(5);
    t_602 = t_600:having(t_601.accumulated);
    t_603 = SqlBuilder();
    t_603:appendSafe('SUM(total) > ');
    t_603:appendInt32(1000);
    q__1059 = t_602:orHaving(t_603.accumulated);
    t_604 = temper.str_eq(q__1059:toSql():toString(), 'SELECT * FROM orders GROUP BY status HAVING COUNT(*) > 5 OR SUM(total) > 1000');
    fn__8008 = function()
      return 'orHaving';
    end;
    temper.test_assert(test_597, t_604, fn__8008);
    return nil;
  end);
end;
Test_.test_distinctBasic__1567 = function()
  temper.test('distinct basic', function(test_605)
    local t_606, t_607, q__1061, t_608, fn__7998;
    t_606 = sid__461('users');
    t_607 = sid__461('name');
    q__1061 = from(t_606):select(temper.listof(t_607)):distinct();
    t_608 = temper.str_eq(q__1061:toSql():toString(), 'SELECT DISTINCT name FROM users');
    fn__7998 = function()
      return 'distinct';
    end;
    temper.test_assert(test_605, t_608, fn__7998);
    return nil;
  end);
end;
Test_.test_distinctWithWhere__1568 = function()
  temper.test('distinct with where', function(test_609)
    local t_610, t_611, t_612, t_613, q__1063, t_614, fn__7983;
    t_610 = sid__461('users');
    t_611 = sid__461('email');
    t_612 = from(t_610):select(temper.listof(t_611));
    t_613 = SqlBuilder();
    t_613:appendSafe('active = ');
    t_613:appendBoolean(true);
    q__1063 = t_612:where(t_613.accumulated):distinct();
    t_614 = temper.str_eq(q__1063:toSql():toString(), 'SELECT DISTINCT email FROM users WHERE active = TRUE');
    fn__7983 = function()
      return 'distinct with where';
    end;
    temper.test_assert(test_609, t_614, fn__7983);
    return nil;
  end);
end;
Test_.test_countSqlBare__1570 = function()
  temper.test('countSql bare', function(test_615)
    local q__1065, t_616, fn__7976;
    q__1065 = from(sid__461('users'));
    t_616 = temper.str_eq(q__1065:countSql():toString(), 'SELECT COUNT(*) FROM users');
    fn__7976 = function()
      return 'countSql bare';
    end;
    temper.test_assert(test_615, t_616, fn__7976);
    return nil;
  end);
end;
Test_.test_countSqlWithWhere__1571 = function()
  temper.test('countSql with WHERE', function(test_617)
    local t_618, t_619, t_620, q__1067, t_621, fn__7964;
    t_618 = sid__461('users');
    t_619 = SqlBuilder();
    t_619:appendSafe('active = ');
    t_619:appendBoolean(true);
    t_620 = t_619.accumulated;
    q__1067 = from(t_618):where(t_620);
    t_621 = temper.str_eq(q__1067:countSql():toString(), 'SELECT COUNT(*) FROM users WHERE active = TRUE');
    fn__7964 = function()
      return 'countSql with where';
    end;
    temper.test_assert(test_617, t_621, fn__7964);
    return nil;
  end);
end;
Test_.test_countSqlWithJoin__1573 = function()
  temper.test('countSql with JOIN', function(test_622)
    local t_623, t_624, t_625, t_626, t_627, t_628, q__1069, t_629, fn__7947;
    t_623 = sid__461('users');
    t_624 = sid__461('orders');
    t_625 = SqlBuilder();
    t_625:appendSafe('users.id = orders.user_id');
    t_626 = t_625.accumulated;
    t_627 = from(t_623):innerJoin(t_624, t_626);
    t_628 = SqlBuilder();
    t_628:appendSafe('orders.total > ');
    t_628:appendInt32(100);
    q__1069 = t_627:where(t_628.accumulated);
    t_629 = temper.str_eq(q__1069:countSql():toString(), 'SELECT COUNT(*) FROM users INNER JOIN orders ON users.id = orders.user_id WHERE orders.total > 100');
    fn__7947 = function()
      return 'countSql with join';
    end;
    temper.test_assert(test_622, t_629, fn__7947);
    return nil;
  end);
end;
Test_.test_countSqlDropsOrderByLimitOffset__1576 = function()
  temper.test('countSql drops orderBy/limit/offset', function(test_630)
    local t_631, t_632, t_633, t_634, t_635, q__1071, local_636, local_637, local_638, s__1072, t_640, fn__7933;
    local_636, local_637, local_638 = temper.pcall(function()
      t_631 = sid__461('users');
      t_632 = SqlBuilder();
      t_632:appendSafe('active = ');
      t_632:appendBoolean(true);
      t_633 = t_632.accumulated;
      t_634 = from(t_631):where(t_633):orderBy(sid__461('name'), true):limit(10);
      t_635 = t_634:offset(20);
      q__1071 = t_635;
    end);
    if local_636 then
    else
      q__1071 = temper.bubble();
    end
    s__1072 = q__1071:countSql():toString();
    t_640 = temper.str_eq(s__1072, 'SELECT COUNT(*) FROM users WHERE active = TRUE');
    fn__7933 = function()
      return temper.concat('countSql drops extras: ', s__1072);
    end;
    temper.test_assert(test_630, t_640, fn__7933);
    return nil;
  end);
end;
Test_.test_fullAggregationQuery__1578 = function()
  temper.test('full aggregation query', function(test_641)
    local t_642, t_643, t_644, t_645, t_646, t_647, t_648, t_649, t_650, t_651, t_652, q__1074, expected__1075, t_653, fn__7900;
    t_642 = sid__461('orders');
    t_643 = col(sid__461('orders'), sid__461('status'));
    t_644 = countAll();
    t_645 = sumCol(sid__461('total'));
    t_646 = from(t_642):selectExpr(temper.listof(t_643, t_644, t_645));
    t_647 = sid__461('users');
    t_648 = SqlBuilder();
    t_648:appendSafe('orders.user_id = users.id');
    t_649 = t_646:innerJoin(t_647, t_648.accumulated);
    t_650 = SqlBuilder();
    t_650:appendSafe('users.active = ');
    t_650:appendBoolean(true);
    t_651 = t_649:where(t_650.accumulated):groupBy(sid__461('status'));
    t_652 = SqlBuilder();
    t_652:appendSafe('COUNT(*) > ');
    t_652:appendInt32(3);
    q__1074 = t_651:having(t_652.accumulated):orderBy(sid__461('status'), true);
    expected__1075 = 'SELECT orders.status, COUNT(*), SUM(total) FROM orders INNER JOIN users ON orders.user_id = users.id WHERE users.active = TRUE GROUP BY status HAVING COUNT(*) > 3 ORDER BY status ASC';
    t_653 = temper.str_eq(q__1074:toSql():toString(), 'SELECT orders.status, COUNT(*), SUM(total) FROM orders INNER JOIN users ON orders.user_id = users.id WHERE users.active = TRUE GROUP BY status HAVING COUNT(*) > 3 ORDER BY status ASC');
    fn__7900 = function()
      return 'full aggregation';
    end;
    temper.test_assert(test_641, t_653, fn__7900);
    return nil;
  end);
end;
Test_.test_unionSql__1582 = function()
  temper.test('unionSql', function(test_654)
    local t_655, t_656, t_657, a__1077, t_658, t_659, t_660, b__1078, s__1079, t_661, fn__7882;
    t_655 = sid__461('users');
    t_656 = SqlBuilder();
    t_656:appendSafe('role = ');
    t_656:appendString('admin');
    t_657 = t_656.accumulated;
    a__1077 = from(t_655):where(t_657);
    t_658 = sid__461('users');
    t_659 = SqlBuilder();
    t_659:appendSafe('role = ');
    t_659:appendString('moderator');
    t_660 = t_659.accumulated;
    b__1078 = from(t_658):where(t_660);
    s__1079 = unionSql(a__1077, b__1078):toString();
    t_661 = temper.str_eq(s__1079, "(SELECT * FROM users WHERE role = 'admin') UNION (SELECT * FROM users WHERE role = 'moderator')");
    fn__7882 = function()
      return temper.concat('unionSql: ', s__1079);
    end;
    temper.test_assert(test_654, t_661, fn__7882);
    return nil;
  end);
end;
Test_.test_unionAllSql__1585 = function()
  temper.test('unionAllSql', function(test_662)
    local t_663, t_664, a__1081, t_665, t_666, b__1082, s__1083, t_667, fn__7870;
    t_663 = sid__461('users');
    t_664 = sid__461('name');
    a__1081 = from(t_663):select(temper.listof(t_664));
    t_665 = sid__461('contacts');
    t_666 = sid__461('name');
    b__1082 = from(t_665):select(temper.listof(t_666));
    s__1083 = unionAllSql(a__1081, b__1082):toString();
    t_667 = temper.str_eq(s__1083, '(SELECT name FROM users) UNION ALL (SELECT name FROM contacts)');
    fn__7870 = function()
      return temper.concat('unionAllSql: ', s__1083);
    end;
    temper.test_assert(test_662, t_667, fn__7870);
    return nil;
  end);
end;
Test_.test_intersectSql__1586 = function()
  temper.test('intersectSql', function(test_668)
    local t_669, t_670, a__1085, t_671, t_672, b__1086, s__1087, t_673, fn__7858;
    t_669 = sid__461('users');
    t_670 = sid__461('email');
    a__1085 = from(t_669):select(temper.listof(t_670));
    t_671 = sid__461('subscribers');
    t_672 = sid__461('email');
    b__1086 = from(t_671):select(temper.listof(t_672));
    s__1087 = intersectSql(a__1085, b__1086):toString();
    t_673 = temper.str_eq(s__1087, '(SELECT email FROM users) INTERSECT (SELECT email FROM subscribers)');
    fn__7858 = function()
      return temper.concat('intersectSql: ', s__1087);
    end;
    temper.test_assert(test_668, t_673, fn__7858);
    return nil;
  end);
end;
Test_.test_exceptSql__1587 = function()
  temper.test('exceptSql', function(test_674)
    local t_675, t_676, a__1089, t_677, t_678, b__1090, s__1091, t_679, fn__7846;
    t_675 = sid__461('users');
    t_676 = sid__461('id');
    a__1089 = from(t_675):select(temper.listof(t_676));
    t_677 = sid__461('banned');
    t_678 = sid__461('id');
    b__1090 = from(t_677):select(temper.listof(t_678));
    s__1091 = exceptSql(a__1089, b__1090):toString();
    t_679 = temper.str_eq(s__1091, '(SELECT id FROM users) EXCEPT (SELECT id FROM banned)');
    fn__7846 = function()
      return temper.concat('exceptSql: ', s__1091);
    end;
    temper.test_assert(test_674, t_679, fn__7846);
    return nil;
  end);
end;
Test_.test_subqueryWithAlias__1588 = function()
  temper.test('subquery with alias', function(test_680)
    local t_681, t_682, t_683, t_684, inner__1093, s__1094, t_685, fn__7831;
    t_681 = sid__461('orders');
    t_682 = sid__461('user_id');
    t_683 = from(t_681):select(temper.listof(t_682));
    t_684 = SqlBuilder();
    t_684:appendSafe('total > ');
    t_684:appendInt32(100);
    inner__1093 = t_683:where(t_684.accumulated);
    s__1094 = subquery(inner__1093, sid__461('big_orders')):toString();
    t_685 = temper.str_eq(s__1094, '(SELECT user_id FROM orders WHERE total > 100) AS big_orders');
    fn__7831 = function()
      return temper.concat('subquery: ', s__1094);
    end;
    temper.test_assert(test_680, t_685, fn__7831);
    return nil;
  end);
end;
Test_.test_existsSql__1590 = function()
  temper.test('existsSql', function(test_686)
    local t_687, t_688, t_689, inner__1096, s__1097, t_690, fn__7820;
    t_687 = sid__461('orders');
    t_688 = SqlBuilder();
    t_688:appendSafe('orders.user_id = users.id');
    t_689 = t_688.accumulated;
    inner__1096 = from(t_687):where(t_689);
    s__1097 = existsSql(inner__1096):toString();
    t_690 = temper.str_eq(s__1097, 'EXISTS (SELECT * FROM orders WHERE orders.user_id = users.id)');
    fn__7820 = function()
      return temper.concat('existsSql: ', s__1097);
    end;
    temper.test_assert(test_686, t_690, fn__7820);
    return nil;
  end);
end;
Test_.test_whereInSubquery__1592 = function()
  temper.test('whereInSubquery', function(test_691)
    local t_692, t_693, t_694, t_695, sub__1099, t_696, t_697, q__1100, s__1101, t_698, fn__7803;
    t_692 = sid__461('orders');
    t_693 = sid__461('user_id');
    t_694 = from(t_692):select(temper.listof(t_693));
    t_695 = SqlBuilder();
    t_695:appendSafe('total > ');
    t_695:appendInt32(1000);
    sub__1099 = t_694:where(t_695.accumulated);
    t_696 = sid__461('users');
    t_697 = sid__461('id');
    q__1100 = from(t_696):whereInSubquery(t_697, sub__1099);
    s__1101 = q__1100:toSql():toString();
    t_698 = temper.str_eq(s__1101, 'SELECT * FROM users WHERE id IN (SELECT user_id FROM orders WHERE total > 1000)');
    fn__7803 = function()
      return temper.concat('whereInSubquery: ', s__1101);
    end;
    temper.test_assert(test_691, t_698, fn__7803);
    return nil;
  end);
end;
Test_.test_setOperationWithWhereOnEachSide__1594 = function()
  temper.test('set operation with WHERE on each side', function(test_699)
    local t_700, t_701, t_702, t_703, t_704, a__1103, t_705, t_706, t_707, b__1104, s__1105, t_708, fn__7780;
    t_700 = sid__461('users');
    t_701 = SqlBuilder();
    t_701:appendSafe('age > ');
    t_701:appendInt32(18);
    t_702 = t_701.accumulated;
    t_703 = from(t_700):where(t_702);
    t_704 = SqlBuilder();
    t_704:appendSafe('active = ');
    t_704:appendBoolean(true);
    a__1103 = t_703:where(t_704.accumulated);
    t_705 = sid__461('users');
    t_706 = SqlBuilder();
    t_706:appendSafe('role = ');
    t_706:appendString('vip');
    t_707 = t_706.accumulated;
    b__1104 = from(t_705):where(t_707);
    s__1105 = unionSql(a__1103, b__1104):toString();
    t_708 = temper.str_eq(s__1105, "(SELECT * FROM users WHERE age > 18 AND active = TRUE) UNION (SELECT * FROM users WHERE role = 'vip')");
    fn__7780 = function()
      return temper.concat('union with where: ', s__1105);
    end;
    temper.test_assert(test_699, t_708, fn__7780);
    return nil;
  end);
end;
Test_.test_whereInSubqueryChainedWithWhere__1598 = function()
  temper.test('whereInSubquery chained with where', function(test_709)
    local t_710, t_711, sub__1107, t_712, t_713, t_714, q__1108, s__1109, t_715, fn__7763;
    t_710 = sid__461('orders');
    t_711 = sid__461('user_id');
    sub__1107 = from(t_710):select(temper.listof(t_711));
    t_712 = sid__461('users');
    t_713 = SqlBuilder();
    t_713:appendSafe('active = ');
    t_713:appendBoolean(true);
    t_714 = t_713.accumulated;
    q__1108 = from(t_712):where(t_714):whereInSubquery(sid__461('id'), sub__1107);
    s__1109 = q__1108:toSql():toString();
    t_715 = temper.str_eq(s__1109, 'SELECT * FROM users WHERE active = TRUE AND id IN (SELECT user_id FROM orders)');
    fn__7763 = function()
      return temper.concat('whereInSubquery chained: ', s__1109);
    end;
    temper.test_assert(test_709, t_715, fn__7763);
    return nil;
  end);
end;
Test_.test_existsSqlUsedInWhere__1600 = function()
  temper.test('existsSql used in where', function(test_716)
    local t_717, t_718, t_719, sub__1111, t_720, t_721, q__1112, s__1113, t_722, fn__7749;
    t_717 = sid__461('orders');
    t_718 = SqlBuilder();
    t_718:appendSafe('orders.user_id = users.id');
    t_719 = t_718.accumulated;
    sub__1111 = from(t_717):where(t_719);
    t_720 = sid__461('users');
    t_721 = existsSql(sub__1111);
    q__1112 = from(t_720):where(t_721);
    s__1113 = q__1112:toSql():toString();
    t_722 = temper.str_eq(s__1113, 'SELECT * FROM users WHERE EXISTS (SELECT * FROM orders WHERE orders.user_id = users.id)');
    fn__7749 = function()
      return temper.concat('exists in where: ', s__1113);
    end;
    temper.test_assert(test_716, t_722, fn__7749);
    return nil;
  end);
end;
Test_.test_safeIdentifierAcceptsValidNames__1602 = function()
  temper.test('safeIdentifier accepts valid names', function(test_723)
    local t_724, id__1151, local_725, local_726, local_727, t_729, fn__7744;
    local_725, local_726, local_727 = temper.pcall(function()
      t_724 = safeIdentifier('user_name');
      id__1151 = t_724;
    end);
    if local_725 then
    else
      id__1151 = temper.bubble();
    end
    t_729 = temper.str_eq(id__1151.sqlValue, 'user_name');
    fn__7744 = function()
      return 'value should round-trip';
    end;
    temper.test_assert(test_723, t_729, fn__7744);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsEmptyString__1603 = function()
  temper.test('safeIdentifier rejects empty string', function(test_730)
    local didBubble__1153, local_731, local_732, local_733, fn__7741;
    local_731, local_732, local_733 = temper.pcall(function()
      safeIdentifier('');
      didBubble__1153 = false;
    end);
    if local_731 then
    else
      didBubble__1153 = true;
    end
    fn__7741 = function()
      return 'empty string should bubble';
    end;
    temper.test_assert(test_730, didBubble__1153, fn__7741);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsLeadingDigit__1604 = function()
  temper.test('safeIdentifier rejects leading digit', function(test_735)
    local didBubble__1155, local_736, local_737, local_738, fn__7738;
    local_736, local_737, local_738 = temper.pcall(function()
      safeIdentifier('1col');
      didBubble__1155 = false;
    end);
    if local_736 then
    else
      didBubble__1155 = true;
    end
    fn__7738 = function()
      return 'leading digit should bubble';
    end;
    temper.test_assert(test_735, didBubble__1155, fn__7738);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsSqlMetacharacters__1605 = function()
  temper.test('safeIdentifier rejects SQL metacharacters', function(test_740)
    local cases__1157, fn__7735;
    cases__1157 = temper.listof('name); DROP TABLE', "col'", 'a b', 'a-b', 'a.b', 'a;b');
    fn__7735 = function(c__1158)
      local didBubble__1159, local_741, local_742, local_743, fn__7732;
      local_741, local_742, local_743 = temper.pcall(function()
        safeIdentifier(c__1158);
        didBubble__1159 = false;
      end);
      if local_741 then
      else
        didBubble__1159 = true;
      end
      fn__7732 = function()
        return temper.concat('should reject: ', c__1158);
      end;
      temper.test_assert(test_740, didBubble__1159, fn__7732);
      return nil;
    end;
    temper.list_foreach(cases__1157, fn__7735);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupFound__1606 = function()
  temper.test('TableDef field lookup - found', function(test_745)
    local t_746, t_747, t_748, t_749, t_750, t_751, t_752, local_753, local_754, local_755, local_757, local_758, local_759, t_761, t_762, local_763, local_764, local_765, t_767, t_768, td__1161, f__1162, local_769, local_770, local_771, t_773, fn__7721;
    local_753, local_754, local_755 = temper.pcall(function()
      t_746 = safeIdentifier('users');
      t_747 = t_746;
    end);
    if local_753 then
    else
      t_747 = temper.bubble();
    end
    local_757, local_758, local_759 = temper.pcall(function()
      t_748 = safeIdentifier('name');
      t_749 = t_748;
    end);
    if local_757 then
    else
      t_749 = temper.bubble();
    end
    t_761 = StringField();
    t_762 = FieldDef(t_749, t_761, false);
    local_763, local_764, local_765 = temper.pcall(function()
      t_750 = safeIdentifier('age');
      t_751 = t_750;
    end);
    if local_763 then
    else
      t_751 = temper.bubble();
    end
    t_767 = IntField();
    t_768 = FieldDef(t_751, t_767, false);
    td__1161 = TableDef(t_747, temper.listof(t_762, t_768));
    local_769, local_770, local_771 = temper.pcall(function()
      t_752 = td__1161:field('age');
      f__1162 = t_752;
    end);
    if local_769 then
    else
      f__1162 = temper.bubble();
    end
    t_773 = temper.str_eq(f__1162.name.sqlValue, 'age');
    fn__7721 = function()
      return 'should find age field';
    end;
    temper.test_assert(test_745, t_773, fn__7721);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupNotFoundBubbles__1607 = function()
  temper.test('TableDef field lookup - not found bubbles', function(test_774)
    local t_775, t_776, t_777, t_778, local_779, local_780, local_781, local_783, local_784, local_785, t_787, t_788, td__1164, didBubble__1165, local_789, local_790, local_791, fn__7715;
    local_779, local_780, local_781 = temper.pcall(function()
      t_775 = safeIdentifier('users');
      t_776 = t_775;
    end);
    if local_779 then
    else
      t_776 = temper.bubble();
    end
    local_783, local_784, local_785 = temper.pcall(function()
      t_777 = safeIdentifier('name');
      t_778 = t_777;
    end);
    if local_783 then
    else
      t_778 = temper.bubble();
    end
    t_787 = StringField();
    t_788 = FieldDef(t_778, t_787, false);
    td__1164 = TableDef(t_776, temper.listof(t_788));
    local_789, local_790, local_791 = temper.pcall(function()
      td__1164:field('nonexistent');
      didBubble__1165 = false;
    end);
    if local_789 then
    else
      didBubble__1165 = true;
    end
    fn__7715 = function()
      return 'unknown field should bubble';
    end;
    temper.test_assert(test_774, didBubble__1165, fn__7715);
    return nil;
  end);
end;
Test_.test_fieldDefNullableFlag__1608 = function()
  temper.test('FieldDef nullable flag', function(test_793)
    local t_794, t_795, t_796, t_797, local_798, local_799, local_800, t_802, required__1167, local_803, local_804, local_805, t_807, optional__1168, t_808, fn__7703, t_809, fn__7702;
    local_798, local_799, local_800 = temper.pcall(function()
      t_794 = safeIdentifier('email');
      t_795 = t_794;
    end);
    if local_798 then
    else
      t_795 = temper.bubble();
    end
    t_802 = StringField();
    required__1167 = FieldDef(t_795, t_802, false);
    local_803, local_804, local_805 = temper.pcall(function()
      t_796 = safeIdentifier('bio');
      t_797 = t_796;
    end);
    if local_803 then
    else
      t_797 = temper.bubble();
    end
    t_807 = StringField();
    optional__1168 = FieldDef(t_797, t_807, true);
    t_808 = not required__1167.nullable;
    fn__7703 = function()
      return 'required field should not be nullable';
    end;
    temper.test_assert(test_793, t_808, fn__7703);
    t_809 = optional__1168.nullable;
    fn__7702 = function()
      return 'optional field should be nullable';
    end;
    temper.test_assert(test_793, t_809, fn__7702);
    return nil;
  end);
end;
Test_.test_stringEscaping__1609 = function()
  temper.test('string escaping', function(test_810)
    local build__1294, buildWrong__1295, actual_812, t_813, fn__7691, bobbyTables__1300, actual_814, t_815, fn__7690, fn__7689;
    build__1294 = function(name__1296)
      local t_811;
      t_811 = SqlBuilder();
      t_811:appendSafe('select * from hi where name = ');
      t_811:appendString(name__1296);
      return t_811.accumulated:toString();
    end;
    buildWrong__1295 = function(name__1298)
      return temper.concat("select * from hi where name = '", name__1298, "'");
    end;
    actual_812 = build__1294('world');
    t_813 = temper.str_eq(actual_812, "select * from hi where name = 'world'");
    fn__7691 = function()
      return temper.concat('expected build("world") == (', "select * from hi where name = 'world'", ') not (', actual_812, ')');
    end;
    temper.test_assert(test_810, t_813, fn__7691);
    bobbyTables__1300 = "Robert'); drop table hi;--";
    actual_814 = build__1294("Robert'); drop table hi;--");
    t_815 = temper.str_eq(actual_814, "select * from hi where name = 'Robert''); drop table hi;--'");
    fn__7690 = function()
      return temper.concat('expected build(bobbyTables) == (', "select * from hi where name = 'Robert''); drop table hi;--'", ') not (', actual_814, ')');
    end;
    temper.test_assert(test_810, t_815, fn__7690);
    fn__7689 = function()
      return "expected buildWrong(bobbyTables) == (select * from hi where name = 'Robert'); drop table hi;--') not (select * from hi where name = 'Robert'); drop table hi;--')";
    end;
    temper.test_assert(test_810, true, fn__7689);
    return nil;
  end);
end;
Test_.test_stringEdgeCases__1617 = function()
  temper.test('string edge cases', function(test_816)
    local t_817, actual_818, t_819, fn__7651, t_820, actual_821, t_822, fn__7650, t_823, actual_824, t_825, fn__7649, t_826, actual_827, t_828, fn__7648;
    t_817 = SqlBuilder();
    t_817:appendSafe('v = ');
    t_817:appendString('');
    actual_818 = t_817.accumulated:toString();
    t_819 = temper.str_eq(actual_818, "v = ''");
    fn__7651 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "").toString() == (', "v = ''", ') not (', actual_818, ')');
    end;
    temper.test_assert(test_816, t_819, fn__7651);
    t_820 = SqlBuilder();
    t_820:appendSafe('v = ');
    t_820:appendString("a''b");
    actual_821 = t_820.accumulated:toString();
    t_822 = temper.str_eq(actual_821, "v = 'a''''b'");
    fn__7650 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v = \", \\interpolate, \"a''b\").toString() == (", "v = 'a''''b'", ') not (', actual_821, ')');
    end;
    temper.test_assert(test_816, t_822, fn__7650);
    t_823 = SqlBuilder();
    t_823:appendSafe('v = ');
    t_823:appendString('Hello \xe4\xb8\x96\xe7\x95\x8c');
    actual_824 = t_823.accumulated:toString();
    t_825 = temper.str_eq(actual_824, "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'");
    fn__7649 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Hello \xe4\xb8\x96\xe7\x95\x8c").toString() == (', "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'", ') not (', actual_824, ')');
    end;
    temper.test_assert(test_816, t_825, fn__7649);
    t_826 = SqlBuilder();
    t_826:appendSafe('v = ');
    t_826:appendString('Line1\nLine2');
    actual_827 = t_826.accumulated:toString();
    t_828 = temper.str_eq(actual_827, "v = 'Line1\nLine2'");
    fn__7648 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Line1\\nLine2").toString() == (', "v = 'Line1\nLine2'", ') not (', actual_827, ')');
    end;
    temper.test_assert(test_816, t_828, fn__7648);
    return nil;
  end);
end;
Test_.test_numbersAndBooleans__1630 = function()
  temper.test('numbers and booleans', function(test_829)
    local t_830, t_831, actual_832, t_833, fn__7622, date__1303, local_834, local_835, local_836, t_838, actual_839, t_840, fn__7621;
    t_831 = SqlBuilder();
    t_831:appendSafe('select ');
    t_831:appendInt32(42);
    t_831:appendSafe(', ');
    t_831:appendInt64(temper.int64_constructor(43));
    t_831:appendSafe(', ');
    t_831:appendFloat64(19.99);
    t_831:appendSafe(', ');
    t_831:appendBoolean(true);
    t_831:appendSafe(', ');
    t_831:appendBoolean(false);
    actual_832 = t_831.accumulated:toString();
    t_833 = temper.str_eq(actual_832, 'select 42, 43, 19.99, TRUE, FALSE');
    fn__7622 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, 42, ", ", \\interpolate, 43, ", ", \\interpolate, 19.99, ", ", \\interpolate, true, ", ", \\interpolate, false).toString() == (', 'select 42, 43, 19.99, TRUE, FALSE', ') not (', actual_832, ')');
    end;
    temper.test_assert(test_829, t_833, fn__7622);
    local_834, local_835, local_836 = temper.pcall(function()
      t_830 = temper.date_constructor(2024, 12, 25);
      date__1303 = t_830;
    end);
    if local_834 then
    else
      date__1303 = temper.bubble();
    end
    t_838 = SqlBuilder();
    t_838:appendSafe('insert into t values (');
    t_838:appendDate(date__1303);
    t_838:appendSafe(')');
    actual_839 = t_838.accumulated:toString();
    t_840 = temper.str_eq(actual_839, "insert into t values ('2024-12-25')");
    fn__7621 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "insert into t values (", \\interpolate, date, ")").toString() == (', "insert into t values ('2024-12-25')", ') not (', actual_839, ')');
    end;
    temper.test_assert(test_829, t_840, fn__7621);
    return nil;
  end);
end;
Test_.test_lists__1637 = function()
  temper.test('lists', function(test_841)
    local t_842, t_843, t_844, t_845, t_846, actual_847, t_848, fn__7566, t_849, actual_850, t_851, fn__7565, t_852, actual_853, t_854, fn__7564, t_855, actual_856, t_857, fn__7563, t_858, actual_859, t_860, fn__7562, local_861, local_862, local_863, local_865, local_866, local_867, dates__1305, t_869, actual_870, t_871, fn__7561;
    t_846 = SqlBuilder();
    t_846:appendSafe('v IN (');
    t_846:appendStringList(temper.listof('a', 'b', "c'd"));
    t_846:appendSafe(')');
    actual_847 = t_846.accumulated:toString();
    t_848 = temper.str_eq(actual_847, "v IN ('a', 'b', 'c''d')");
    fn__7566 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v IN (\", \\interpolate, list(\"a\", \"b\", \"c'd\"), \")\").toString() == (", "v IN ('a', 'b', 'c''d')", ') not (', actual_847, ')');
    end;
    temper.test_assert(test_841, t_848, fn__7566);
    t_849 = SqlBuilder();
    t_849:appendSafe('v IN (');
    t_849:appendInt32List(temper.listof(1, 2, 3));
    t_849:appendSafe(')');
    actual_850 = t_849.accumulated:toString();
    t_851 = temper.str_eq(actual_850, 'v IN (1, 2, 3)');
    fn__7565 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2, 3), ")").toString() == (', 'v IN (1, 2, 3)', ') not (', actual_850, ')');
    end;
    temper.test_assert(test_841, t_851, fn__7565);
    t_852 = SqlBuilder();
    t_852:appendSafe('v IN (');
    t_852:appendInt64List(temper.listof(temper.int64_constructor(1), temper.int64_constructor(2)));
    t_852:appendSafe(')');
    actual_853 = t_852.accumulated:toString();
    t_854 = temper.str_eq(actual_853, 'v IN (1, 2)');
    fn__7564 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2), ")").toString() == (', 'v IN (1, 2)', ') not (', actual_853, ')');
    end;
    temper.test_assert(test_841, t_854, fn__7564);
    t_855 = SqlBuilder();
    t_855:appendSafe('v IN (');
    t_855:appendFloat64List(temper.listof(1.0, 2.0));
    t_855:appendSafe(')');
    actual_856 = t_855.accumulated:toString();
    t_857 = temper.str_eq(actual_856, 'v IN (1.0, 2.0)');
    fn__7563 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1.0, 2.0), ")").toString() == (', 'v IN (1.0, 2.0)', ') not (', actual_856, ')');
    end;
    temper.test_assert(test_841, t_857, fn__7563);
    t_858 = SqlBuilder();
    t_858:appendSafe('v IN (');
    t_858:appendBooleanList(temper.listof(true, false));
    t_858:appendSafe(')');
    actual_859 = t_858.accumulated:toString();
    t_860 = temper.str_eq(actual_859, 'v IN (TRUE, FALSE)');
    fn__7562 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(true, false), ")").toString() == (', 'v IN (TRUE, FALSE)', ') not (', actual_859, ')');
    end;
    temper.test_assert(test_841, t_860, fn__7562);
    local_861, local_862, local_863 = temper.pcall(function()
      t_842 = temper.date_constructor(2024, 1, 1);
      t_843 = t_842;
    end);
    if local_861 then
    else
      t_843 = temper.bubble();
    end
    local_865, local_866, local_867 = temper.pcall(function()
      t_844 = temper.date_constructor(2024, 12, 25);
      t_845 = t_844;
    end);
    if local_865 then
    else
      t_845 = temper.bubble();
    end
    dates__1305 = temper.listof(t_843, t_845);
    t_869 = SqlBuilder();
    t_869:appendSafe('v IN (');
    t_869:appendDateList(dates__1305);
    t_869:appendSafe(')');
    actual_870 = t_869.accumulated:toString();
    t_871 = temper.str_eq(actual_870, "v IN ('2024-01-01', '2024-12-25')");
    fn__7561 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, dates, ")").toString() == (', "v IN ('2024-01-01', '2024-12-25')", ') not (', actual_870, ')');
    end;
    temper.test_assert(test_841, t_871, fn__7561);
    return nil;
  end);
end;
Test_.test_sqlFloat64_naNRendersAsNull__1656 = function()
  temper.test('SqlFloat64 NaN renders as NULL', function(test_872)
    local nan__1307, t_873, actual_874, t_875, fn__7552;
    nan__1307 = temper.fdiv(0.0, 0.0);
    t_873 = SqlBuilder();
    t_873:appendSafe('v = ');
    t_873:appendFloat64(nan__1307);
    actual_874 = t_873.accumulated:toString();
    t_875 = temper.str_eq(actual_874, 'v = NULL');
    fn__7552 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, nan).toString() == (', 'v = NULL', ') not (', actual_874, ')');
    end;
    temper.test_assert(test_872, t_875, fn__7552);
    return nil;
  end);
end;
Test_.test_sqlFloat64_infinityRendersAsNull__1660 = function()
  temper.test('SqlFloat64 Infinity renders as NULL', function(test_876)
    local inf__1309, t_877, actual_878, t_879, fn__7543;
    inf__1309 = temper.fdiv(1.0, 0.0);
    t_877 = SqlBuilder();
    t_877:appendSafe('v = ');
    t_877:appendFloat64(inf__1309);
    actual_878 = t_877.accumulated:toString();
    t_879 = temper.str_eq(actual_878, 'v = NULL');
    fn__7543 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, inf).toString() == (', 'v = NULL', ') not (', actual_878, ')');
    end;
    temper.test_assert(test_876, t_879, fn__7543);
    return nil;
  end);
end;
Test_.test_sqlFloat64_negativeInfinityRendersAsNull__1664 = function()
  temper.test('SqlFloat64 negative Infinity renders as NULL', function(test_880)
    local ninf__1311, t_881, actual_882, t_883, fn__7534;
    ninf__1311 = temper.fdiv(-1.0, 0.0);
    t_881 = SqlBuilder();
    t_881:appendSafe('v = ');
    t_881:appendFloat64(ninf__1311);
    actual_882 = t_881.accumulated:toString();
    t_883 = temper.str_eq(actual_882, 'v = NULL');
    fn__7534 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, ninf).toString() == (', 'v = NULL', ') not (', actual_882, ')');
    end;
    temper.test_assert(test_880, t_883, fn__7534);
    return nil;
  end);
end;
Test_.test_sqlFloat64_normalValuesStillWork__1668 = function()
  temper.test('SqlFloat64 normal values still work', function(test_884)
    local t_885, actual_886, t_887, fn__7509, t_888, actual_889, t_890, fn__7508, t_891, actual_892, t_893, fn__7507;
    t_885 = SqlBuilder();
    t_885:appendSafe('v = ');
    t_885:appendFloat64(3.14);
    actual_886 = t_885.accumulated:toString();
    t_887 = temper.str_eq(actual_886, 'v = 3.14');
    fn__7509 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 3.14).toString() == (', 'v = 3.14', ') not (', actual_886, ')');
    end;
    temper.test_assert(test_884, t_887, fn__7509);
    t_888 = SqlBuilder();
    t_888:appendSafe('v = ');
    t_888:appendFloat64(0.0);
    actual_889 = t_888.accumulated:toString();
    t_890 = temper.str_eq(actual_889, 'v = 0.0');
    fn__7508 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 0.0).toString() == (', 'v = 0.0', ') not (', actual_889, ')');
    end;
    temper.test_assert(test_884, t_890, fn__7508);
    t_891 = SqlBuilder();
    t_891:appendSafe('v = ');
    t_891:appendFloat64(-42.5);
    actual_892 = t_891.accumulated:toString();
    t_893 = temper.str_eq(actual_892, 'v = -42.5');
    fn__7507 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, -42.5).toString() == (', 'v = -42.5', ') not (', actual_892, ')');
    end;
    temper.test_assert(test_884, t_893, fn__7507);
    return nil;
  end);
end;
Test_.test_sqlDateRendersWithQuotes__1678 = function()
  temper.test('SqlDate renders with quotes', function(test_894)
    local t_895, d__1314, local_896, local_897, local_898, t_900, actual_901, t_902, fn__7498;
    local_896, local_897, local_898 = temper.pcall(function()
      t_895 = temper.date_constructor(2024, 6, 15);
      d__1314 = t_895;
    end);
    if local_896 then
    else
      d__1314 = temper.bubble();
    end
    t_900 = SqlBuilder();
    t_900:appendSafe('v = ');
    t_900:appendDate(d__1314);
    actual_901 = t_900.accumulated:toString();
    t_902 = temper.str_eq(actual_901, "v = '2024-06-15'");
    fn__7498 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, d).toString() == (', "v = '2024-06-15'", ') not (', actual_901, ')');
    end;
    temper.test_assert(test_894, t_902, fn__7498);
    return nil;
  end);
end;
Test_.test_nesting__1682 = function()
  temper.test('nesting', function(test_903)
    local name__1316, t_904, condition__1317, t_905, actual_906, t_907, fn__7466, t_908, actual_909, t_910, fn__7465, parts__1318, t_911, actual_912, t_913, fn__7464;
    name__1316 = 'Someone';
    t_904 = SqlBuilder();
    t_904:appendSafe('where p.last_name = ');
    t_904:appendString('Someone');
    condition__1317 = t_904.accumulated;
    t_905 = SqlBuilder();
    t_905:appendSafe('select p.id from person p ');
    t_905:appendFragment(condition__1317);
    actual_906 = t_905.accumulated:toString();
    t_907 = temper.str_eq(actual_906, "select p.id from person p where p.last_name = 'Someone'");
    fn__7466 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_906, ')');
    end;
    temper.test_assert(test_903, t_907, fn__7466);
    t_908 = SqlBuilder();
    t_908:appendSafe('select p.id from person p ');
    t_908:appendPart(condition__1317:toSource());
    actual_909 = t_908.accumulated:toString();
    t_910 = temper.str_eq(actual_909, "select p.id from person p where p.last_name = 'Someone'");
    fn__7465 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition.toSource()).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_909, ')');
    end;
    temper.test_assert(test_903, t_910, fn__7465);
    parts__1318 = temper.listof(SqlString("a'b"), SqlInt32(3));
    t_911 = SqlBuilder();
    t_911:appendSafe('select ');
    t_911:appendPartList(parts__1318);
    actual_912 = t_911.accumulated:toString();
    t_913 = temper.str_eq(actual_912, "select 'a''b', 3");
    fn__7464 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, parts).toString() == (', "select 'a''b', 3", ') not (', actual_912, ')');
    end;
    temper.test_assert(test_903, t_913, fn__7464);
    return nil;
  end);
end;
exports = {};
local_915.LuaUnit.run(local_914({'--pattern', '^Test_%.', local_914(arg)}));
return exports;
