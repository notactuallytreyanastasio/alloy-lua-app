local temper = require('temper-core');
local safeIdentifier, TableDef, FieldDef, StringField, IntField, FloatField, BoolField, changeset, from, SqlBuilder, col, SqlInt32, SqlString, countAll, countCol, sumCol, avgCol, minCol, maxCol, local_844, local_845, csid__441, userTable__442, sid__443, exports;
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
local_844 = (unpack or table.unpack);
local_845 = require('luaunit');
local_845.FAILURE_PREFIX = temper.test_failure_prefix;
Test_ = {};
csid__441 = function(name__586)
  local return__284, t_137, local_138, local_139, local_140;
  local_138, local_139, local_140 = temper.pcall(function()
    t_137 = safeIdentifier(name__586);
    return__284 = t_137;
  end);
  if local_138 then
  else
    return__284 = temper.bubble();
  end
  return return__284;
end;
userTable__442 = function()
  return TableDef(csid__441('users'), temper.listof(FieldDef(csid__441('name'), StringField(), false), FieldDef(csid__441('email'), StringField(), false), FieldDef(csid__441('age'), IntField(), true), FieldDef(csid__441('score'), FloatField(), true), FieldDef(csid__441('active'), BoolField(), true)));
end;
Test_.test_castWhitelistsAllowedFields__1320 = function()
  temper.test('cast whitelists allowed fields', function(test_142)
    local params__590, t_143, t_144, t_145, cs__591, t_146, fn__8518, t_147, fn__8517, t_148, fn__8516, t_149, fn__8515;
    params__590 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com'), temper.pair_constructor('admin', 'true')));
    t_143 = userTable__442();
    t_144 = csid__441('name');
    t_145 = csid__441('email');
    cs__591 = changeset(t_143, params__590):cast(temper.listof(t_144, t_145));
    t_146 = temper.mapped_has(cs__591.changes, 'name');
    fn__8518 = function()
      return 'name should be in changes';
    end;
    temper.test_assert(test_142, t_146, fn__8518);
    t_147 = temper.mapped_has(cs__591.changes, 'email');
    fn__8517 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_142, t_147, fn__8517);
    t_148 = not temper.mapped_has(cs__591.changes, 'admin');
    fn__8516 = function()
      return 'admin must be dropped (not in whitelist)';
    end;
    temper.test_assert(test_142, t_148, fn__8516);
    t_149 = cs__591.isValid;
    fn__8515 = function()
      return 'should still be valid';
    end;
    temper.test_assert(test_142, t_149, fn__8515);
    return nil;
  end);
end;
Test_.test_castIsReplacingNotAdditiveSecondCallResetsWhitelist__1321 = function()
  temper.test('cast is replacing not additive \xe2\x80\x94 second call resets whitelist', function(test_150)
    local params__593, t_151, t_152, cs__594, t_153, fn__8497, t_154, fn__8496;
    params__593 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com')));
    t_151 = userTable__442();
    t_152 = csid__441('name');
    cs__594 = changeset(t_151, params__593):cast(temper.listof(t_152)):cast(temper.listof(csid__441('email')));
    t_153 = not temper.mapped_has(cs__594.changes, 'name');
    fn__8497 = function()
      return 'name must be excluded by second cast';
    end;
    temper.test_assert(test_150, t_153, fn__8497);
    t_154 = temper.mapped_has(cs__594.changes, 'email');
    fn__8496 = function()
      return 'email should be present';
    end;
    temper.test_assert(test_150, t_154, fn__8496);
    return nil;
  end);
end;
Test_.test_castIgnoresEmptyStringValues__1322 = function()
  temper.test('cast ignores empty string values', function(test_155)
    local params__596, t_156, t_157, t_158, cs__597, t_159, fn__8479, t_160, fn__8478;
    params__596 = temper.map_constructor(temper.listof(temper.pair_constructor('name', ''), temper.pair_constructor('email', 'bob@example.com')));
    t_156 = userTable__442();
    t_157 = csid__441('name');
    t_158 = csid__441('email');
    cs__597 = changeset(t_156, params__596):cast(temper.listof(t_157, t_158));
    t_159 = not temper.mapped_has(cs__597.changes, 'name');
    fn__8479 = function()
      return 'empty name should not be in changes';
    end;
    temper.test_assert(test_155, t_159, fn__8479);
    t_160 = temper.mapped_has(cs__597.changes, 'email');
    fn__8478 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_155, t_160, fn__8478);
    return nil;
  end);
end;
Test_.test_validateRequiredPassesWhenFieldPresent__1323 = function()
  temper.test('validateRequired passes when field present', function(test_161)
    local params__599, t_162, t_163, cs__600, t_164, fn__8462, t_165, fn__8461;
    params__599 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_162 = userTable__442();
    t_163 = csid__441('name');
    cs__600 = changeset(t_162, params__599):cast(temper.listof(t_163)):validateRequired(temper.listof(csid__441('name')));
    t_164 = cs__600.isValid;
    fn__8462 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_161, t_164, fn__8462);
    t_165 = (temper.list_length(cs__600.errors) == 0);
    fn__8461 = function()
      return 'no errors expected';
    end;
    temper.test_assert(test_161, t_165, fn__8461);
    return nil;
  end);
end;
Test_.test_validateRequiredFailsWhenFieldMissing__1324 = function()
  temper.test('validateRequired fails when field missing', function(test_166)
    local params__602, t_167, t_168, cs__603, t_169, fn__8439, t_170, fn__8438, t_171, fn__8437;
    params__602 = temper.map_constructor(temper.listof());
    t_167 = userTable__442();
    t_168 = csid__441('name');
    cs__603 = changeset(t_167, params__602):cast(temper.listof(t_168)):validateRequired(temper.listof(csid__441('name')));
    t_169 = not cs__603.isValid;
    fn__8439 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_166, t_169, fn__8439);
    t_170 = (temper.list_length(cs__603.errors) == 1);
    fn__8438 = function()
      return 'should have one error';
    end;
    temper.test_assert(test_166, t_170, fn__8438);
    t_171 = temper.str_eq((temper.list_get(cs__603.errors, 0)).field, 'name');
    fn__8437 = function()
      return 'error should name the field';
    end;
    temper.test_assert(test_166, t_171, fn__8437);
    return nil;
  end);
end;
Test_.test_validateLengthPassesWithinRange__1325 = function()
  temper.test('validateLength passes within range', function(test_172)
    local params__605, t_173, t_174, cs__606, t_175, fn__8426;
    params__605 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_173 = userTable__442();
    t_174 = csid__441('name');
    cs__606 = changeset(t_173, params__605):cast(temper.listof(t_174)):validateLength(csid__441('name'), 2, 50);
    t_175 = cs__606.isValid;
    fn__8426 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_172, t_175, fn__8426);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooShort__1326 = function()
  temper.test('validateLength fails when too short', function(test_176)
    local params__608, t_177, t_178, cs__609, t_179, fn__8414;
    params__608 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'A')));
    t_177 = userTable__442();
    t_178 = csid__441('name');
    cs__609 = changeset(t_177, params__608):cast(temper.listof(t_178)):validateLength(csid__441('name'), 2, 50);
    t_179 = not cs__609.isValid;
    fn__8414 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_176, t_179, fn__8414);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooLong__1327 = function()
  temper.test('validateLength fails when too long', function(test_180)
    local params__611, t_181, t_182, cs__612, t_183, fn__8402;
    params__611 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')));
    t_181 = userTable__442();
    t_182 = csid__441('name');
    cs__612 = changeset(t_181, params__611):cast(temper.listof(t_182)):validateLength(csid__441('name'), 2, 10);
    t_183 = not cs__612.isValid;
    fn__8402 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_180, t_183, fn__8402);
    return nil;
  end);
end;
Test_.test_validateIntPassesForValidInteger__1328 = function()
  temper.test('validateInt passes for valid integer', function(test_184)
    local params__614, t_185, t_186, cs__615, t_187, fn__8391;
    params__614 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '30')));
    t_185 = userTable__442();
    t_186 = csid__441('age');
    cs__615 = changeset(t_185, params__614):cast(temper.listof(t_186)):validateInt(csid__441('age'));
    t_187 = cs__615.isValid;
    fn__8391 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_184, t_187, fn__8391);
    return nil;
  end);
end;
Test_.test_validateIntFailsForNonInteger__1329 = function()
  temper.test('validateInt fails for non-integer', function(test_188)
    local params__617, t_189, t_190, cs__618, t_191, fn__8379;
    params__617 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_189 = userTable__442();
    t_190 = csid__441('age');
    cs__618 = changeset(t_189, params__617):cast(temper.listof(t_190)):validateInt(csid__441('age'));
    t_191 = not cs__618.isValid;
    fn__8379 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_188, t_191, fn__8379);
    return nil;
  end);
end;
Test_.test_validateFloatPassesForValidFloat__1330 = function()
  temper.test('validateFloat passes for valid float', function(test_192)
    local params__620, t_193, t_194, cs__621, t_195, fn__8368;
    params__620 = temper.map_constructor(temper.listof(temper.pair_constructor('score', '9.5')));
    t_193 = userTable__442();
    t_194 = csid__441('score');
    cs__621 = changeset(t_193, params__620):cast(temper.listof(t_194)):validateFloat(csid__441('score'));
    t_195 = cs__621.isValid;
    fn__8368 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_192, t_195, fn__8368);
    return nil;
  end);
end;
Test_.test_validateInt64_passesForValid64_bitInteger__1331 = function()
  temper.test('validateInt64 passes for valid 64-bit integer', function(test_196)
    local params__623, t_197, t_198, cs__624, t_199, fn__8357;
    params__623 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '9999999999')));
    t_197 = userTable__442();
    t_198 = csid__441('age');
    cs__624 = changeset(t_197, params__623):cast(temper.listof(t_198)):validateInt64(csid__441('age'));
    t_199 = cs__624.isValid;
    fn__8357 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_196, t_199, fn__8357);
    return nil;
  end);
end;
Test_.test_validateInt64_failsForNonInteger__1332 = function()
  temper.test('validateInt64 fails for non-integer', function(test_200)
    local params__626, t_201, t_202, cs__627, t_203, fn__8345;
    params__626 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_201 = userTable__442();
    t_202 = csid__441('age');
    cs__627 = changeset(t_201, params__626):cast(temper.listof(t_202)):validateInt64(csid__441('age'));
    t_203 = not cs__627.isValid;
    fn__8345 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_200, t_203, fn__8345);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsTrue1_yesOn__1333 = function()
  temper.test('validateBool accepts true/1/yes/on', function(test_204)
    local fn__8342;
    fn__8342 = function(v__629)
      local params__630, t_205, t_206, cs__631, t_207, fn__8331;
      params__630 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__629)));
      t_205 = userTable__442();
      t_206 = csid__441('active');
      cs__631 = changeset(t_205, params__630):cast(temper.listof(t_206)):validateBool(csid__441('active'));
      t_207 = cs__631.isValid;
      fn__8331 = function()
        return temper.concat('should accept: ', v__629);
      end;
      temper.test_assert(test_204, t_207, fn__8331);
      return nil;
    end;
    temper.list_foreach(temper.listof('true', '1', 'yes', 'on'), fn__8342);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsFalse0_noOff__1334 = function()
  temper.test('validateBool accepts false/0/no/off', function(test_208)
    local fn__8328;
    fn__8328 = function(v__633)
      local params__634, t_209, t_210, cs__635, t_211, fn__8317;
      params__634 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__633)));
      t_209 = userTable__442();
      t_210 = csid__441('active');
      cs__635 = changeset(t_209, params__634):cast(temper.listof(t_210)):validateBool(csid__441('active'));
      t_211 = cs__635.isValid;
      fn__8317 = function()
        return temper.concat('should accept: ', v__633);
      end;
      temper.test_assert(test_208, t_211, fn__8317);
      return nil;
    end;
    temper.list_foreach(temper.listof('false', '0', 'no', 'off'), fn__8328);
    return nil;
  end);
end;
Test_.test_validateBoolRejectsAmbiguousValues__1335 = function()
  temper.test('validateBool rejects ambiguous values', function(test_212)
    local fn__8314;
    fn__8314 = function(v__637)
      local params__638, t_213, t_214, cs__639, t_215, fn__8302;
      params__638 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__637)));
      t_213 = userTable__442();
      t_214 = csid__441('active');
      cs__639 = changeset(t_213, params__638):cast(temper.listof(t_214)):validateBool(csid__441('active'));
      t_215 = not cs__639.isValid;
      fn__8302 = function()
        return temper.concat('should reject ambiguous: ', v__637);
      end;
      temper.test_assert(test_212, t_215, fn__8302);
      return nil;
    end;
    temper.list_foreach(temper.listof('TRUE', 'Yes', 'maybe', '2', 'enabled'), fn__8314);
    return nil;
  end);
end;
Test_.test_toInsertSqlEscapesBobbyTables__1336 = function()
  temper.test('toInsertSql escapes Bobby Tables', function(test_216)
    local t_217, params__641, t_218, t_219, t_220, cs__642, sqlFrag__643, local_221, local_222, local_223, s__644, t_225, fn__8286;
    params__641 = temper.map_constructor(temper.listof(temper.pair_constructor('name', "Robert'); DROP TABLE users;--"), temper.pair_constructor('email', 'bobby@evil.com')));
    t_218 = userTable__442();
    t_219 = csid__441('name');
    t_220 = csid__441('email');
    cs__642 = changeset(t_218, params__641):cast(temper.listof(t_219, t_220)):validateRequired(temper.listof(csid__441('name'), csid__441('email')));
    local_221, local_222, local_223 = temper.pcall(function()
      t_217 = cs__642:toInsertSql();
      sqlFrag__643 = t_217;
    end);
    if local_221 then
    else
      sqlFrag__643 = temper.bubble();
    end
    s__644 = sqlFrag__643:toString();
    t_225 = temper.is_string_index(temper.string_indexof(s__644, "''"));
    fn__8286 = function()
      return temper.concat('single quote must be doubled: ', s__644);
    end;
    temper.test_assert(test_216, t_225, fn__8286);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForStringField__1337 = function()
  temper.test('toInsertSql produces correct SQL for string field', function(test_226)
    local t_227, params__646, t_228, t_229, t_230, cs__647, sqlFrag__648, local_231, local_232, local_233, s__649, t_235, fn__8266, t_236, fn__8265;
    params__646 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'a@example.com')));
    t_228 = userTable__442();
    t_229 = csid__441('name');
    t_230 = csid__441('email');
    cs__647 = changeset(t_228, params__646):cast(temper.listof(t_229, t_230)):validateRequired(temper.listof(csid__441('name'), csid__441('email')));
    local_231, local_232, local_233 = temper.pcall(function()
      t_227 = cs__647:toInsertSql();
      sqlFrag__648 = t_227;
    end);
    if local_231 then
    else
      sqlFrag__648 = temper.bubble();
    end
    s__649 = sqlFrag__648:toString();
    t_235 = temper.is_string_index(temper.string_indexof(s__649, 'INSERT INTO users'));
    fn__8266 = function()
      return temper.concat('has INSERT INTO: ', s__649);
    end;
    temper.test_assert(test_226, t_235, fn__8266);
    t_236 = temper.is_string_index(temper.string_indexof(s__649, "'Alice'"));
    fn__8265 = function()
      return temper.concat('has quoted name: ', s__649);
    end;
    temper.test_assert(test_226, t_236, fn__8265);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForIntField__1338 = function()
  temper.test('toInsertSql produces correct SQL for int field', function(test_237)
    local t_238, params__651, t_239, t_240, t_241, t_242, cs__652, sqlFrag__653, local_243, local_244, local_245, s__654, t_247, fn__8247;
    params__651 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob'), temper.pair_constructor('email', 'b@example.com'), temper.pair_constructor('age', '25')));
    t_239 = userTable__442();
    t_240 = csid__441('name');
    t_241 = csid__441('email');
    t_242 = csid__441('age');
    cs__652 = changeset(t_239, params__651):cast(temper.listof(t_240, t_241, t_242)):validateRequired(temper.listof(csid__441('name'), csid__441('email')));
    local_243, local_244, local_245 = temper.pcall(function()
      t_238 = cs__652:toInsertSql();
      sqlFrag__653 = t_238;
    end);
    if local_243 then
    else
      sqlFrag__653 = temper.bubble();
    end
    s__654 = sqlFrag__653:toString();
    t_247 = temper.is_string_index(temper.string_indexof(s__654, '25'));
    fn__8247 = function()
      return temper.concat('age rendered unquoted: ', s__654);
    end;
    temper.test_assert(test_237, t_247, fn__8247);
    return nil;
  end);
end;
Test_.test_toInsertSqlBubblesOnInvalidChangeset__1339 = function()
  temper.test('toInsertSql bubbles on invalid changeset', function(test_248)
    local params__656, t_249, t_250, cs__657, didBubble__658, local_251, local_252, local_253, fn__8238;
    params__656 = temper.map_constructor(temper.listof());
    t_249 = userTable__442();
    t_250 = csid__441('name');
    cs__657 = changeset(t_249, params__656):cast(temper.listof(t_250)):validateRequired(temper.listof(csid__441('name')));
    local_251, local_252, local_253 = temper.pcall(function()
      cs__657:toInsertSql();
      didBubble__658 = false;
    end);
    if local_251 then
    else
      didBubble__658 = true;
    end
    fn__8238 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_248, didBubble__658, fn__8238);
    return nil;
  end);
end;
Test_.test_toInsertSqlEnforcesNonNullableFieldsIndependentlyOfIsValid__1340 = function()
  temper.test('toInsertSql enforces non-nullable fields independently of isValid', function(test_255)
    local strictTable__660, params__661, t_256, cs__662, t_257, fn__8220, didBubble__663, local_258, local_259, local_260, fn__8219;
    strictTable__660 = TableDef(csid__441('posts'), temper.listof(FieldDef(csid__441('title'), StringField(), false), FieldDef(csid__441('body'), StringField(), true)));
    params__661 = temper.map_constructor(temper.listof(temper.pair_constructor('body', 'hello')));
    t_256 = csid__441('body');
    cs__662 = changeset(strictTable__660, params__661):cast(temper.listof(t_256));
    t_257 = cs__662.isValid;
    fn__8220 = function()
      return 'changeset should appear valid (no explicit validation run)';
    end;
    temper.test_assert(test_255, t_257, fn__8220);
    local_258, local_259, local_260 = temper.pcall(function()
      cs__662:toInsertSql();
      didBubble__663 = false;
    end);
    if local_258 then
    else
      didBubble__663 = true;
    end
    fn__8219 = function()
      return 'toInsertSql should enforce nullable regardless of isValid';
    end;
    temper.test_assert(test_255, didBubble__663, fn__8219);
    return nil;
  end);
end;
Test_.test_toUpdateSqlProducesCorrectSql__1341 = function()
  temper.test('toUpdateSql produces correct SQL', function(test_262)
    local t_263, params__665, t_264, t_265, cs__666, sqlFrag__667, local_266, local_267, local_268, s__668, t_270, fn__8207;
    params__665 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob')));
    t_264 = userTable__442();
    t_265 = csid__441('name');
    cs__666 = changeset(t_264, params__665):cast(temper.listof(t_265)):validateRequired(temper.listof(csid__441('name')));
    local_266, local_267, local_268 = temper.pcall(function()
      t_263 = cs__666:toUpdateSql(42);
      sqlFrag__667 = t_263;
    end);
    if local_266 then
    else
      sqlFrag__667 = temper.bubble();
    end
    s__668 = sqlFrag__667:toString();
    t_270 = temper.str_eq(s__668, "UPDATE users SET name = 'Bob' WHERE id = 42");
    fn__8207 = function()
      return temper.concat('got: ', s__668);
    end;
    temper.test_assert(test_262, t_270, fn__8207);
    return nil;
  end);
end;
Test_.test_toUpdateSqlBubblesOnInvalidChangeset__1342 = function()
  temper.test('toUpdateSql bubbles on invalid changeset', function(test_271)
    local params__670, t_272, t_273, cs__671, didBubble__672, local_274, local_275, local_276, fn__8198;
    params__670 = temper.map_constructor(temper.listof());
    t_272 = userTable__442();
    t_273 = csid__441('name');
    cs__671 = changeset(t_272, params__670):cast(temper.listof(t_273)):validateRequired(temper.listof(csid__441('name')));
    local_274, local_275, local_276 = temper.pcall(function()
      cs__671:toUpdateSql(1);
      didBubble__672 = false;
    end);
    if local_274 then
    else
      didBubble__672 = true;
    end
    fn__8198 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_271, didBubble__672, fn__8198);
    return nil;
  end);
end;
sid__443 = function(name__886)
  local return__362, t_278, local_279, local_280, local_281;
  local_279, local_280, local_281 = temper.pcall(function()
    t_278 = safeIdentifier(name__886);
    return__362 = t_278;
  end);
  if local_279 then
  else
    return__362 = temper.bubble();
  end
  return return__362;
end;
Test_.test_bareFromProducesSelect__1391 = function()
  temper.test('bare from produces SELECT *', function(test_283)
    local q__889, t_284, fn__7861;
    q__889 = from(sid__443('users'));
    t_284 = temper.str_eq(q__889:toSql():toString(), 'SELECT * FROM users');
    fn__7861 = function()
      return 'bare query';
    end;
    temper.test_assert(test_283, t_284, fn__7861);
    return nil;
  end);
end;
Test_.test_selectRestrictsColumns__1392 = function()
  temper.test('select restricts columns', function(test_285)
    local t_286, t_287, t_288, q__891, t_289, fn__7851;
    t_286 = sid__443('users');
    t_287 = sid__443('id');
    t_288 = sid__443('name');
    q__891 = from(t_286):select(temper.listof(t_287, t_288));
    t_289 = temper.str_eq(q__891:toSql():toString(), 'SELECT id, name FROM users');
    fn__7851 = function()
      return 'select columns';
    end;
    temper.test_assert(test_285, t_289, fn__7851);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithIntValue__1393 = function()
  temper.test('where adds condition with int value', function(test_290)
    local t_291, t_292, t_293, q__893, t_294, fn__7839;
    t_291 = sid__443('users');
    t_292 = SqlBuilder();
    t_292:appendSafe('age > ');
    t_292:appendInt32(18);
    t_293 = t_292.accumulated;
    q__893 = from(t_291):where(t_293);
    t_294 = temper.str_eq(q__893:toSql():toString(), 'SELECT * FROM users WHERE age > 18');
    fn__7839 = function()
      return 'where int';
    end;
    temper.test_assert(test_290, t_294, fn__7839);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithBoolValue__1395 = function()
  temper.test('where adds condition with bool value', function(test_295)
    local t_296, t_297, t_298, q__895, t_299, fn__7827;
    t_296 = sid__443('users');
    t_297 = SqlBuilder();
    t_297:appendSafe('active = ');
    t_297:appendBoolean(true);
    t_298 = t_297.accumulated;
    q__895 = from(t_296):where(t_298);
    t_299 = temper.str_eq(q__895:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE');
    fn__7827 = function()
      return 'where bool';
    end;
    temper.test_assert(test_295, t_299, fn__7827);
    return nil;
  end);
end;
Test_.test_chainedWhereUsesAnd__1397 = function()
  temper.test('chained where uses AND', function(test_300)
    local t_301, t_302, t_303, t_304, t_305, q__897, t_306, fn__7810;
    t_301 = sid__443('users');
    t_302 = SqlBuilder();
    t_302:appendSafe('age > ');
    t_302:appendInt32(18);
    t_303 = t_302.accumulated;
    t_304 = from(t_301):where(t_303);
    t_305 = SqlBuilder();
    t_305:appendSafe('active = ');
    t_305:appendBoolean(true);
    q__897 = t_304:where(t_305.accumulated);
    t_306 = temper.str_eq(q__897:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE');
    fn__7810 = function()
      return 'chained where';
    end;
    temper.test_assert(test_300, t_306, fn__7810);
    return nil;
  end);
end;
Test_.test_orderByAsc__1400 = function()
  temper.test('orderBy ASC', function(test_307)
    local t_308, t_309, q__899, t_310, fn__7801;
    t_308 = sid__443('users');
    t_309 = sid__443('name');
    q__899 = from(t_308):orderBy(t_309, true);
    t_310 = temper.str_eq(q__899:toSql():toString(), 'SELECT * FROM users ORDER BY name ASC');
    fn__7801 = function()
      return 'order asc';
    end;
    temper.test_assert(test_307, t_310, fn__7801);
    return nil;
  end);
end;
Test_.test_orderByDesc__1401 = function()
  temper.test('orderBy DESC', function(test_311)
    local t_312, t_313, q__901, t_314, fn__7792;
    t_312 = sid__443('users');
    t_313 = sid__443('created_at');
    q__901 = from(t_312):orderBy(t_313, false);
    t_314 = temper.str_eq(q__901:toSql():toString(), 'SELECT * FROM users ORDER BY created_at DESC');
    fn__7792 = function()
      return 'order desc';
    end;
    temper.test_assert(test_311, t_314, fn__7792);
    return nil;
  end);
end;
Test_.test_limitAndOffset__1402 = function()
  temper.test('limit and offset', function(test_315)
    local t_316, t_317, q__903, local_318, local_319, local_320, t_322, fn__7785;
    local_318, local_319, local_320 = temper.pcall(function()
      t_316 = from(sid__443('users')):limit(10);
      t_317 = t_316:offset(20);
      q__903 = t_317;
    end);
    if local_318 then
    else
      q__903 = temper.bubble();
    end
    t_322 = temper.str_eq(q__903:toSql():toString(), 'SELECT * FROM users LIMIT 10 OFFSET 20');
    fn__7785 = function()
      return 'limit/offset';
    end;
    temper.test_assert(test_315, t_322, fn__7785);
    return nil;
  end);
end;
Test_.test_limitBubblesOnNegative__1403 = function()
  temper.test('limit bubbles on negative', function(test_323)
    local didBubble__905, local_324, local_325, local_326, fn__7781;
    local_324, local_325, local_326 = temper.pcall(function()
      from(sid__443('users')):limit(-1);
      didBubble__905 = false;
    end);
    if local_324 then
    else
      didBubble__905 = true;
    end
    fn__7781 = function()
      return 'negative limit should bubble';
    end;
    temper.test_assert(test_323, didBubble__905, fn__7781);
    return nil;
  end);
end;
Test_.test_offsetBubblesOnNegative__1404 = function()
  temper.test('offset bubbles on negative', function(test_328)
    local didBubble__907, local_329, local_330, local_331, fn__7777;
    local_329, local_330, local_331 = temper.pcall(function()
      from(sid__443('users')):offset(-1);
      didBubble__907 = false;
    end);
    if local_329 then
    else
      didBubble__907 = true;
    end
    fn__7777 = function()
      return 'negative offset should bubble';
    end;
    temper.test_assert(test_328, didBubble__907, fn__7777);
    return nil;
  end);
end;
Test_.test_complexComposedQuery__1405 = function()
  temper.test('complex composed query', function(test_333)
    local t_334, t_335, t_336, t_337, t_338, t_339, t_340, t_341, t_342, t_343, minAge__909, q__910, local_344, local_345, local_346, t_348, fn__7754;
    minAge__909 = 21;
    local_344, local_345, local_346 = temper.pcall(function()
      t_334 = sid__443('users');
      t_335 = sid__443('id');
      t_336 = sid__443('name');
      t_337 = sid__443('email');
      t_338 = from(t_334):select(temper.listof(t_335, t_336, t_337));
      t_339 = SqlBuilder();
      t_339:appendSafe('age >= ');
      t_339:appendInt32(21);
      t_340 = t_338:where(t_339.accumulated);
      t_341 = SqlBuilder();
      t_341:appendSafe('active = ');
      t_341:appendBoolean(true);
      t_342 = t_340:where(t_341.accumulated):orderBy(sid__443('name'), true):limit(25);
      t_343 = t_342:offset(0);
      q__910 = t_343;
    end);
    if local_344 then
    else
      q__910 = temper.bubble();
    end
    t_348 = temper.str_eq(q__910:toSql():toString(), 'SELECT id, name, email FROM users WHERE age >= 21 AND active = TRUE ORDER BY name ASC LIMIT 25 OFFSET 0');
    fn__7754 = function()
      return 'complex query';
    end;
    temper.test_assert(test_333, t_348, fn__7754);
    return nil;
  end);
end;
Test_.test_safeToSqlAppliesDefaultLimitWhenNoneSet__1408 = function()
  temper.test('safeToSql applies default limit when none set', function(test_349)
    local t_350, t_351, q__912, local_352, local_353, local_354, s__913, t_356, fn__7748;
    q__912 = from(sid__443('users'));
    local_352, local_353, local_354 = temper.pcall(function()
      t_350 = q__912:safeToSql(100);
      t_351 = t_350;
    end);
    if local_352 then
    else
      t_351 = temper.bubble();
    end
    s__913 = t_351:toString();
    t_356 = temper.str_eq(s__913, 'SELECT * FROM users LIMIT 100');
    fn__7748 = function()
      return temper.concat('should have limit: ', s__913);
    end;
    temper.test_assert(test_349, t_356, fn__7748);
    return nil;
  end);
end;
Test_.test_safeToSqlRespectsExplicitLimit__1409 = function()
  temper.test('safeToSql respects explicit limit', function(test_357)
    local t_358, t_359, t_360, q__915, local_361, local_362, local_363, local_365, local_366, local_367, s__916, t_369, fn__7742;
    local_361, local_362, local_363 = temper.pcall(function()
      t_358 = from(sid__443('users')):limit(5);
      q__915 = t_358;
    end);
    if local_361 then
    else
      q__915 = temper.bubble();
    end
    local_365, local_366, local_367 = temper.pcall(function()
      t_359 = q__915:safeToSql(100);
      t_360 = t_359;
    end);
    if local_365 then
    else
      t_360 = temper.bubble();
    end
    s__916 = t_360:toString();
    t_369 = temper.str_eq(s__916, 'SELECT * FROM users LIMIT 5');
    fn__7742 = function()
      return temper.concat('explicit limit preserved: ', s__916);
    end;
    temper.test_assert(test_357, t_369, fn__7742);
    return nil;
  end);
end;
Test_.test_safeToSqlBubblesOnNegativeDefaultLimit__1410 = function()
  temper.test('safeToSql bubbles on negative defaultLimit', function(test_370)
    local didBubble__918, local_371, local_372, local_373, fn__7738;
    local_371, local_372, local_373 = temper.pcall(function()
      from(sid__443('users')):safeToSql(-1);
      didBubble__918 = false;
    end);
    if local_371 then
    else
      didBubble__918 = true;
    end
    fn__7738 = function()
      return 'negative defaultLimit should bubble';
    end;
    temper.test_assert(test_370, didBubble__918, fn__7738);
    return nil;
  end);
end;
Test_.test_whereWithInjectionAttemptInStringValueIsEscaped__1411 = function()
  temper.test('where with injection attempt in string value is escaped', function(test_375)
    local evil__920, t_376, t_377, t_378, q__921, s__922, t_379, fn__7721, t_380, fn__7720;
    evil__920 = "'; DROP TABLE users; --";
    t_376 = sid__443('users');
    t_377 = SqlBuilder();
    t_377:appendSafe('name = ');
    t_377:appendString("'; DROP TABLE users; --");
    t_378 = t_377.accumulated;
    q__921 = from(t_376):where(t_378);
    s__922 = q__921:toSql():toString();
    t_379 = temper.is_string_index(temper.string_indexof(s__922, "''"));
    fn__7721 = function()
      return temper.concat('quotes must be doubled: ', s__922);
    end;
    temper.test_assert(test_375, t_379, fn__7721);
    t_380 = temper.is_string_index(temper.string_indexof(s__922, 'SELECT * FROM users WHERE name ='));
    fn__7720 = function()
      return temper.concat('structure intact: ', s__922);
    end;
    temper.test_assert(test_375, t_380, fn__7720);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsUserSuppliedTableNameWithMetacharacters__1413 = function()
  temper.test('safeIdentifier rejects user-supplied table name with metacharacters', function(test_381)
    local attack__924, didBubble__925, local_382, local_383, local_384, fn__7717;
    attack__924 = 'users; DROP TABLE users; --';
    local_382, local_383, local_384 = temper.pcall(function()
      safeIdentifier('users; DROP TABLE users; --');
      didBubble__925 = false;
    end);
    if local_382 then
    else
      didBubble__925 = true;
    end
    fn__7717 = function()
      return 'metacharacter-containing name must be rejected at construction';
    end;
    temper.test_assert(test_381, didBubble__925, fn__7717);
    return nil;
  end);
end;
Test_.test_innerJoinProducesInnerJoin__1414 = function()
  temper.test('innerJoin produces INNER JOIN', function(test_386)
    local t_387, t_388, t_389, t_390, q__927, t_391, fn__7705;
    t_387 = sid__443('users');
    t_388 = sid__443('orders');
    t_389 = SqlBuilder();
    t_389:appendSafe('users.id = orders.user_id');
    t_390 = t_389.accumulated;
    q__927 = from(t_387):innerJoin(t_388, t_390);
    t_391 = temper.str_eq(q__927:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id');
    fn__7705 = function()
      return 'inner join';
    end;
    temper.test_assert(test_386, t_391, fn__7705);
    return nil;
  end);
end;
Test_.test_leftJoinProducesLeftJoin__1416 = function()
  temper.test('leftJoin produces LEFT JOIN', function(test_392)
    local t_393, t_394, t_395, t_396, q__929, t_397, fn__7693;
    t_393 = sid__443('users');
    t_394 = sid__443('profiles');
    t_395 = SqlBuilder();
    t_395:appendSafe('users.id = profiles.user_id');
    t_396 = t_395.accumulated;
    q__929 = from(t_393):leftJoin(t_394, t_396);
    t_397 = temper.str_eq(q__929:toSql():toString(), 'SELECT * FROM users LEFT JOIN profiles ON users.id = profiles.user_id');
    fn__7693 = function()
      return 'left join';
    end;
    temper.test_assert(test_392, t_397, fn__7693);
    return nil;
  end);
end;
Test_.test_rightJoinProducesRightJoin__1418 = function()
  temper.test('rightJoin produces RIGHT JOIN', function(test_398)
    local t_399, t_400, t_401, t_402, q__931, t_403, fn__7681;
    t_399 = sid__443('orders');
    t_400 = sid__443('users');
    t_401 = SqlBuilder();
    t_401:appendSafe('orders.user_id = users.id');
    t_402 = t_401.accumulated;
    q__931 = from(t_399):rightJoin(t_400, t_402);
    t_403 = temper.str_eq(q__931:toSql():toString(), 'SELECT * FROM orders RIGHT JOIN users ON orders.user_id = users.id');
    fn__7681 = function()
      return 'right join';
    end;
    temper.test_assert(test_398, t_403, fn__7681);
    return nil;
  end);
end;
Test_.test_fullJoinProducesFullOuterJoin__1420 = function()
  temper.test('fullJoin produces FULL OUTER JOIN', function(test_404)
    local t_405, t_406, t_407, t_408, q__933, t_409, fn__7669;
    t_405 = sid__443('users');
    t_406 = sid__443('orders');
    t_407 = SqlBuilder();
    t_407:appendSafe('users.id = orders.user_id');
    t_408 = t_407.accumulated;
    q__933 = from(t_405):fullJoin(t_406, t_408);
    t_409 = temper.str_eq(q__933:toSql():toString(), 'SELECT * FROM users FULL OUTER JOIN orders ON users.id = orders.user_id');
    fn__7669 = function()
      return 'full join';
    end;
    temper.test_assert(test_404, t_409, fn__7669);
    return nil;
  end);
end;
Test_.test_chainedJoins__1422 = function()
  temper.test('chained joins', function(test_410)
    local t_411, t_412, t_413, t_414, t_415, t_416, t_417, q__935, t_418, fn__7652;
    t_411 = sid__443('users');
    t_412 = sid__443('orders');
    t_413 = SqlBuilder();
    t_413:appendSafe('users.id = orders.user_id');
    t_414 = t_413.accumulated;
    t_415 = from(t_411):innerJoin(t_412, t_414);
    t_416 = sid__443('profiles');
    t_417 = SqlBuilder();
    t_417:appendSafe('users.id = profiles.user_id');
    q__935 = t_415:leftJoin(t_416, t_417.accumulated);
    t_418 = temper.str_eq(q__935:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id LEFT JOIN profiles ON users.id = profiles.user_id');
    fn__7652 = function()
      return 'chained joins';
    end;
    temper.test_assert(test_410, t_418, fn__7652);
    return nil;
  end);
end;
Test_.test_joinWithWhereAndOrderBy__1425 = function()
  temper.test('join with where and orderBy', function(test_419)
    local t_420, t_421, t_422, t_423, t_424, t_425, t_426, q__937, local_427, local_428, local_429, t_431, fn__7633;
    local_427, local_428, local_429 = temper.pcall(function()
      t_420 = sid__443('users');
      t_421 = sid__443('orders');
      t_422 = SqlBuilder();
      t_422:appendSafe('users.id = orders.user_id');
      t_423 = t_422.accumulated;
      t_424 = from(t_420):innerJoin(t_421, t_423);
      t_425 = SqlBuilder();
      t_425:appendSafe('orders.total > ');
      t_425:appendInt32(100);
      t_426 = t_424:where(t_425.accumulated):orderBy(sid__443('name'), true):limit(10);
      q__937 = t_426;
    end);
    if local_427 then
    else
      q__937 = temper.bubble();
    end
    t_431 = temper.str_eq(q__937:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id WHERE orders.total > 100 ORDER BY name ASC LIMIT 10');
    fn__7633 = function()
      return 'join with where/order/limit';
    end;
    temper.test_assert(test_419, t_431, fn__7633);
    return nil;
  end);
end;
Test_.test_colHelperProducesQualifiedReference__1428 = function()
  temper.test('col helper produces qualified reference', function(test_432)
    local c__939, t_433, fn__7625;
    c__939 = col(sid__443('users'), sid__443('id'));
    t_433 = temper.str_eq(c__939:toString(), 'users.id');
    fn__7625 = function()
      return 'col helper';
    end;
    temper.test_assert(test_432, t_433, fn__7625);
    return nil;
  end);
end;
Test_.test_joinWithColHelper__1429 = function()
  temper.test('join with col helper', function(test_434)
    local onCond__941, b__942, t_435, t_436, t_437, q__943, t_438, fn__7605;
    onCond__941 = col(sid__443('users'), sid__443('id'));
    b__942 = SqlBuilder();
    b__942:appendFragment(onCond__941);
    b__942:appendSafe(' = ');
    b__942:appendFragment(col(sid__443('orders'), sid__443('user_id')));
    t_435 = sid__443('users');
    t_436 = sid__443('orders');
    t_437 = b__942.accumulated;
    q__943 = from(t_435):innerJoin(t_436, t_437);
    t_438 = temper.str_eq(q__943:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id');
    fn__7605 = function()
      return 'join with col';
    end;
    temper.test_assert(test_434, t_438, fn__7605);
    return nil;
  end);
end;
Test_.test_orWhereBasic__1430 = function()
  temper.test('orWhere basic', function(test_439)
    local t_440, t_441, t_442, q__945, t_443, fn__7593;
    t_440 = sid__443('users');
    t_441 = SqlBuilder();
    t_441:appendSafe('status = ');
    t_441:appendString('active');
    t_442 = t_441.accumulated;
    q__945 = from(t_440):orWhere(t_442);
    t_443 = temper.str_eq(q__945:toSql():toString(), "SELECT * FROM users WHERE status = 'active'");
    fn__7593 = function()
      return 'orWhere basic';
    end;
    temper.test_assert(test_439, t_443, fn__7593);
    return nil;
  end);
end;
Test_.test_whereThenOrWhere__1432 = function()
  temper.test('where then orWhere', function(test_444)
    local t_445, t_446, t_447, t_448, t_449, q__947, t_450, fn__7576;
    t_445 = sid__443('users');
    t_446 = SqlBuilder();
    t_446:appendSafe('age > ');
    t_446:appendInt32(18);
    t_447 = t_446.accumulated;
    t_448 = from(t_445):where(t_447);
    t_449 = SqlBuilder();
    t_449:appendSafe('vip = ');
    t_449:appendBoolean(true);
    q__947 = t_448:orWhere(t_449.accumulated);
    t_450 = temper.str_eq(q__947:toSql():toString(), 'SELECT * FROM users WHERE age > 18 OR vip = TRUE');
    fn__7576 = function()
      return 'where then orWhere';
    end;
    temper.test_assert(test_444, t_450, fn__7576);
    return nil;
  end);
end;
Test_.test_multipleOrWhere__1435 = function()
  temper.test('multiple orWhere', function(test_451)
    local t_452, t_453, t_454, t_455, t_456, t_457, t_458, q__949, t_459, fn__7554;
    t_452 = sid__443('users');
    t_453 = SqlBuilder();
    t_453:appendSafe('active = ');
    t_453:appendBoolean(true);
    t_454 = t_453.accumulated;
    t_455 = from(t_452):where(t_454);
    t_456 = SqlBuilder();
    t_456:appendSafe('role = ');
    t_456:appendString('admin');
    t_457 = t_455:orWhere(t_456.accumulated);
    t_458 = SqlBuilder();
    t_458:appendSafe('role = ');
    t_458:appendString('moderator');
    q__949 = t_457:orWhere(t_458.accumulated);
    t_459 = temper.str_eq(q__949:toSql():toString(), "SELECT * FROM users WHERE active = TRUE OR role = 'admin' OR role = 'moderator'");
    fn__7554 = function()
      return 'multiple orWhere';
    end;
    temper.test_assert(test_451, t_459, fn__7554);
    return nil;
  end);
end;
Test_.test_mixedWhereAndOrWhere__1439 = function()
  temper.test('mixed where and orWhere', function(test_460)
    local t_461, t_462, t_463, t_464, t_465, t_466, t_467, q__951, t_468, fn__7532;
    t_461 = sid__443('users');
    t_462 = SqlBuilder();
    t_462:appendSafe('age > ');
    t_462:appendInt32(18);
    t_463 = t_462.accumulated;
    t_464 = from(t_461):where(t_463);
    t_465 = SqlBuilder();
    t_465:appendSafe('active = ');
    t_465:appendBoolean(true);
    t_466 = t_464:where(t_465.accumulated);
    t_467 = SqlBuilder();
    t_467:appendSafe('vip = ');
    t_467:appendBoolean(true);
    q__951 = t_466:orWhere(t_467.accumulated);
    t_468 = temper.str_eq(q__951:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE OR vip = TRUE');
    fn__7532 = function()
      return 'mixed where and orWhere';
    end;
    temper.test_assert(test_460, t_468, fn__7532);
    return nil;
  end);
end;
Test_.test_whereNull__1443 = function()
  temper.test('whereNull', function(test_469)
    local t_470, t_471, q__953, t_472, fn__7523;
    t_470 = sid__443('users');
    t_471 = sid__443('deleted_at');
    q__953 = from(t_470):whereNull(t_471);
    t_472 = temper.str_eq(q__953:toSql():toString(), 'SELECT * FROM users WHERE deleted_at IS NULL');
    fn__7523 = function()
      return 'whereNull';
    end;
    temper.test_assert(test_469, t_472, fn__7523);
    return nil;
  end);
end;
Test_.test_whereNotNull__1444 = function()
  temper.test('whereNotNull', function(test_473)
    local t_474, t_475, q__955, t_476, fn__7514;
    t_474 = sid__443('users');
    t_475 = sid__443('email');
    q__955 = from(t_474):whereNotNull(t_475);
    t_476 = temper.str_eq(q__955:toSql():toString(), 'SELECT * FROM users WHERE email IS NOT NULL');
    fn__7514 = function()
      return 'whereNotNull';
    end;
    temper.test_assert(test_473, t_476, fn__7514);
    return nil;
  end);
end;
Test_.test_whereNullChainedWithWhere__1445 = function()
  temper.test('whereNull chained with where', function(test_477)
    local t_478, t_479, t_480, q__957, t_481, fn__7500;
    t_478 = sid__443('users');
    t_479 = SqlBuilder();
    t_479:appendSafe('active = ');
    t_479:appendBoolean(true);
    t_480 = t_479.accumulated;
    q__957 = from(t_478):where(t_480):whereNull(sid__443('deleted_at'));
    t_481 = temper.str_eq(q__957:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE AND deleted_at IS NULL');
    fn__7500 = function()
      return 'whereNull chained';
    end;
    temper.test_assert(test_477, t_481, fn__7500);
    return nil;
  end);
end;
Test_.test_whereNotNullChainedWithOrWhere__1447 = function()
  temper.test('whereNotNull chained with orWhere', function(test_482)
    local t_483, t_484, t_485, t_486, q__959, t_487, fn__7486;
    t_483 = sid__443('users');
    t_484 = sid__443('deleted_at');
    t_485 = from(t_483):whereNull(t_484);
    t_486 = SqlBuilder();
    t_486:appendSafe('role = ');
    t_486:appendString('admin');
    q__959 = t_485:orWhere(t_486.accumulated);
    t_487 = temper.str_eq(q__959:toSql():toString(), "SELECT * FROM users WHERE deleted_at IS NULL OR role = 'admin'");
    fn__7486 = function()
      return 'whereNotNull with orWhere';
    end;
    temper.test_assert(test_482, t_487, fn__7486);
    return nil;
  end);
end;
Test_.test_whereInWithIntValues__1449 = function()
  temper.test('whereIn with int values', function(test_488)
    local t_489, t_490, t_491, t_492, t_493, q__961, t_494, fn__7474;
    t_489 = sid__443('users');
    t_490 = sid__443('id');
    t_491 = SqlInt32(1);
    t_492 = SqlInt32(2);
    t_493 = SqlInt32(3);
    q__961 = from(t_489):whereIn(t_490, temper.listof(t_491, t_492, t_493));
    t_494 = temper.str_eq(q__961:toSql():toString(), 'SELECT * FROM users WHERE id IN (1, 2, 3)');
    fn__7474 = function()
      return 'whereIn ints';
    end;
    temper.test_assert(test_488, t_494, fn__7474);
    return nil;
  end);
end;
Test_.test_whereInWithStringValuesEscaping__1450 = function()
  temper.test('whereIn with string values escaping', function(test_495)
    local t_496, t_497, t_498, t_499, q__963, t_500, fn__7463;
    t_496 = sid__443('users');
    t_497 = sid__443('name');
    t_498 = SqlString('Alice');
    t_499 = SqlString("Bob's");
    q__963 = from(t_496):whereIn(t_497, temper.listof(t_498, t_499));
    t_500 = temper.str_eq(q__963:toSql():toString(), "SELECT * FROM users WHERE name IN ('Alice', 'Bob''s')");
    fn__7463 = function()
      return 'whereIn strings';
    end;
    temper.test_assert(test_495, t_500, fn__7463);
    return nil;
  end);
end;
Test_.test_whereInWithEmptyListProduces1_0__1451 = function()
  temper.test('whereIn with empty list produces 1=0', function(test_501)
    local t_502, t_503, q__965, t_504, fn__7454;
    t_502 = sid__443('users');
    t_503 = sid__443('id');
    q__965 = from(t_502):whereIn(t_503, temper.listof());
    t_504 = temper.str_eq(q__965:toSql():toString(), 'SELECT * FROM users WHERE 1 = 0');
    fn__7454 = function()
      return 'whereIn empty';
    end;
    temper.test_assert(test_501, t_504, fn__7454);
    return nil;
  end);
end;
Test_.test_whereInChained__1452 = function()
  temper.test('whereIn chained', function(test_505)
    local t_506, t_507, t_508, q__967, t_509, fn__7438;
    t_506 = sid__443('users');
    t_507 = SqlBuilder();
    t_507:appendSafe('active = ');
    t_507:appendBoolean(true);
    t_508 = t_507.accumulated;
    q__967 = from(t_506):where(t_508):whereIn(sid__443('role'), temper.listof(SqlString('admin'), SqlString('user')));
    t_509 = temper.str_eq(q__967:toSql():toString(), "SELECT * FROM users WHERE active = TRUE AND role IN ('admin', 'user')");
    fn__7438 = function()
      return 'whereIn chained';
    end;
    temper.test_assert(test_505, t_509, fn__7438);
    return nil;
  end);
end;
Test_.test_whereInSingleElement__1454 = function()
  temper.test('whereIn single element', function(test_510)
    local t_511, t_512, t_513, q__969, t_514, fn__7428;
    t_511 = sid__443('users');
    t_512 = sid__443('id');
    t_513 = SqlInt32(42);
    q__969 = from(t_511):whereIn(t_512, temper.listof(t_513));
    t_514 = temper.str_eq(q__969:toSql():toString(), 'SELECT * FROM users WHERE id IN (42)');
    fn__7428 = function()
      return 'whereIn single';
    end;
    temper.test_assert(test_510, t_514, fn__7428);
    return nil;
  end);
end;
Test_.test_whereNotBasic__1455 = function()
  temper.test('whereNot basic', function(test_515)
    local t_516, t_517, t_518, q__971, t_519, fn__7416;
    t_516 = sid__443('users');
    t_517 = SqlBuilder();
    t_517:appendSafe('active = ');
    t_517:appendBoolean(true);
    t_518 = t_517.accumulated;
    q__971 = from(t_516):whereNot(t_518);
    t_519 = temper.str_eq(q__971:toSql():toString(), 'SELECT * FROM users WHERE NOT (active = TRUE)');
    fn__7416 = function()
      return 'whereNot';
    end;
    temper.test_assert(test_515, t_519, fn__7416);
    return nil;
  end);
end;
Test_.test_whereNotChained__1457 = function()
  temper.test('whereNot chained', function(test_520)
    local t_521, t_522, t_523, t_524, t_525, q__973, t_526, fn__7399;
    t_521 = sid__443('users');
    t_522 = SqlBuilder();
    t_522:appendSafe('age > ');
    t_522:appendInt32(18);
    t_523 = t_522.accumulated;
    t_524 = from(t_521):where(t_523);
    t_525 = SqlBuilder();
    t_525:appendSafe('banned = ');
    t_525:appendBoolean(true);
    q__973 = t_524:whereNot(t_525.accumulated);
    t_526 = temper.str_eq(q__973:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND NOT (banned = TRUE)');
    fn__7399 = function()
      return 'whereNot chained';
    end;
    temper.test_assert(test_520, t_526, fn__7399);
    return nil;
  end);
end;
Test_.test_whereBetweenIntegers__1460 = function()
  temper.test('whereBetween integers', function(test_527)
    local t_528, t_529, t_530, t_531, q__975, t_532, fn__7388;
    t_528 = sid__443('users');
    t_529 = sid__443('age');
    t_530 = SqlInt32(18);
    t_531 = SqlInt32(65);
    q__975 = from(t_528):whereBetween(t_529, t_530, t_531);
    t_532 = temper.str_eq(q__975:toSql():toString(), 'SELECT * FROM users WHERE age BETWEEN 18 AND 65');
    fn__7388 = function()
      return 'whereBetween ints';
    end;
    temper.test_assert(test_527, t_532, fn__7388);
    return nil;
  end);
end;
Test_.test_whereBetweenChained__1461 = function()
  temper.test('whereBetween chained', function(test_533)
    local t_534, t_535, t_536, q__977, t_537, fn__7372;
    t_534 = sid__443('users');
    t_535 = SqlBuilder();
    t_535:appendSafe('active = ');
    t_535:appendBoolean(true);
    t_536 = t_535.accumulated;
    q__977 = from(t_534):where(t_536):whereBetween(sid__443('age'), SqlInt32(21), SqlInt32(30));
    t_537 = temper.str_eq(q__977:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE AND age BETWEEN 21 AND 30');
    fn__7372 = function()
      return 'whereBetween chained';
    end;
    temper.test_assert(test_533, t_537, fn__7372);
    return nil;
  end);
end;
Test_.test_whereLikeBasic__1463 = function()
  temper.test('whereLike basic', function(test_538)
    local t_539, t_540, q__979, t_541, fn__7363;
    t_539 = sid__443('users');
    t_540 = sid__443('name');
    q__979 = from(t_539):whereLike(t_540, 'John%');
    t_541 = temper.str_eq(q__979:toSql():toString(), "SELECT * FROM users WHERE name LIKE 'John%'");
    fn__7363 = function()
      return 'whereLike';
    end;
    temper.test_assert(test_538, t_541, fn__7363);
    return nil;
  end);
end;
Test_.test_whereIlikeBasic__1464 = function()
  temper.test('whereILike basic', function(test_542)
    local t_543, t_544, q__981, t_545, fn__7354;
    t_543 = sid__443('users');
    t_544 = sid__443('email');
    q__981 = from(t_543):whereILike(t_544, '%@gmail.com');
    t_545 = temper.str_eq(q__981:toSql():toString(), "SELECT * FROM users WHERE email ILIKE '%@gmail.com'");
    fn__7354 = function()
      return 'whereILike';
    end;
    temper.test_assert(test_542, t_545, fn__7354);
    return nil;
  end);
end;
Test_.test_whereLikeWithInjectionAttempt__1465 = function()
  temper.test('whereLike with injection attempt', function(test_546)
    local t_547, t_548, q__983, s__984, t_549, fn__7340, t_550, fn__7339;
    t_547 = sid__443('users');
    t_548 = sid__443('name');
    q__983 = from(t_547):whereLike(t_548, "'; DROP TABLE users; --");
    s__984 = q__983:toSql():toString();
    t_549 = temper.is_string_index(temper.string_indexof(s__984, "''"));
    fn__7340 = function()
      return temper.concat('like injection escaped: ', s__984);
    end;
    temper.test_assert(test_546, t_549, fn__7340);
    t_550 = temper.is_string_index(temper.string_indexof(s__984, 'LIKE'));
    fn__7339 = function()
      return temper.concat('like structure intact: ', s__984);
    end;
    temper.test_assert(test_546, t_550, fn__7339);
    return nil;
  end);
end;
Test_.test_whereLikeWildcardPatterns__1466 = function()
  temper.test('whereLike wildcard patterns', function(test_551)
    local t_552, t_553, q__986, t_554, fn__7330;
    t_552 = sid__443('users');
    t_553 = sid__443('name');
    q__986 = from(t_552):whereLike(t_553, '%son%');
    t_554 = temper.str_eq(q__986:toSql():toString(), "SELECT * FROM users WHERE name LIKE '%son%'");
    fn__7330 = function()
      return 'whereLike wildcard';
    end;
    temper.test_assert(test_551, t_554, fn__7330);
    return nil;
  end);
end;
Test_.test_countAllProducesCount__1467 = function()
  temper.test('countAll produces COUNT(*)', function(test_555)
    local f__988, t_556, fn__7324;
    f__988 = countAll();
    t_556 = temper.str_eq(f__988:toString(), 'COUNT(*)');
    fn__7324 = function()
      return 'countAll';
    end;
    temper.test_assert(test_555, t_556, fn__7324);
    return nil;
  end);
end;
Test_.test_countColProducesCountField__1468 = function()
  temper.test('countCol produces COUNT(field)', function(test_557)
    local f__990, t_558, fn__7317;
    f__990 = countCol(sid__443('id'));
    t_558 = temper.str_eq(f__990:toString(), 'COUNT(id)');
    fn__7317 = function()
      return 'countCol';
    end;
    temper.test_assert(test_557, t_558, fn__7317);
    return nil;
  end);
end;
Test_.test_sumColProducesSumField__1469 = function()
  temper.test('sumCol produces SUM(field)', function(test_559)
    local f__992, t_560, fn__7310;
    f__992 = sumCol(sid__443('amount'));
    t_560 = temper.str_eq(f__992:toString(), 'SUM(amount)');
    fn__7310 = function()
      return 'sumCol';
    end;
    temper.test_assert(test_559, t_560, fn__7310);
    return nil;
  end);
end;
Test_.test_avgColProducesAvgField__1470 = function()
  temper.test('avgCol produces AVG(field)', function(test_561)
    local f__994, t_562, fn__7303;
    f__994 = avgCol(sid__443('price'));
    t_562 = temper.str_eq(f__994:toString(), 'AVG(price)');
    fn__7303 = function()
      return 'avgCol';
    end;
    temper.test_assert(test_561, t_562, fn__7303);
    return nil;
  end);
end;
Test_.test_minColProducesMinField__1471 = function()
  temper.test('minCol produces MIN(field)', function(test_563)
    local f__996, t_564, fn__7296;
    f__996 = minCol(sid__443('created_at'));
    t_564 = temper.str_eq(f__996:toString(), 'MIN(created_at)');
    fn__7296 = function()
      return 'minCol';
    end;
    temper.test_assert(test_563, t_564, fn__7296);
    return nil;
  end);
end;
Test_.test_maxColProducesMaxField__1472 = function()
  temper.test('maxCol produces MAX(field)', function(test_565)
    local f__998, t_566, fn__7289;
    f__998 = maxCol(sid__443('score'));
    t_566 = temper.str_eq(f__998:toString(), 'MAX(score)');
    fn__7289 = function()
      return 'maxCol';
    end;
    temper.test_assert(test_565, t_566, fn__7289);
    return nil;
  end);
end;
Test_.test_selectExprWithAggregate__1473 = function()
  temper.test('selectExpr with aggregate', function(test_567)
    local t_568, t_569, q__1000, t_570, fn__7280;
    t_568 = sid__443('orders');
    t_569 = countAll();
    q__1000 = from(t_568):selectExpr(temper.listof(t_569));
    t_570 = temper.str_eq(q__1000:toSql():toString(), 'SELECT COUNT(*) FROM orders');
    fn__7280 = function()
      return 'selectExpr count';
    end;
    temper.test_assert(test_567, t_570, fn__7280);
    return nil;
  end);
end;
Test_.test_selectExprWithMultipleExpressions__1474 = function()
  temper.test('selectExpr with multiple expressions', function(test_571)
    local nameFrag__1002, t_572, t_573, q__1003, t_574, fn__7268;
    nameFrag__1002 = col(sid__443('users'), sid__443('name'));
    t_572 = sid__443('users');
    t_573 = countAll();
    q__1003 = from(t_572):selectExpr(temper.listof(nameFrag__1002, t_573));
    t_574 = temper.str_eq(q__1003:toSql():toString(), 'SELECT users.name, COUNT(*) FROM users');
    fn__7268 = function()
      return 'selectExpr multi';
    end;
    temper.test_assert(test_571, t_574, fn__7268);
    return nil;
  end);
end;
Test_.test_selectExprOverridesSelectedFields__1475 = function()
  temper.test('selectExpr overrides selectedFields', function(test_575)
    local t_576, t_577, t_578, q__1005, t_579, fn__7256;
    t_576 = sid__443('users');
    t_577 = sid__443('id');
    t_578 = sid__443('name');
    q__1005 = from(t_576):select(temper.listof(t_577, t_578)):selectExpr(temper.listof(countAll()));
    t_579 = temper.str_eq(q__1005:toSql():toString(), 'SELECT COUNT(*) FROM users');
    fn__7256 = function()
      return 'selectExpr overrides select';
    end;
    temper.test_assert(test_575, t_579, fn__7256);
    return nil;
  end);
end;
Test_.test_groupBySingleField__1476 = function()
  temper.test('groupBy single field', function(test_580)
    local t_581, t_582, t_583, q__1007, t_584, fn__7242;
    t_581 = sid__443('orders');
    t_582 = col(sid__443('orders'), sid__443('status'));
    t_583 = countAll();
    q__1007 = from(t_581):selectExpr(temper.listof(t_582, t_583)):groupBy(sid__443('status'));
    t_584 = temper.str_eq(q__1007:toSql():toString(), 'SELECT orders.status, COUNT(*) FROM orders GROUP BY status');
    fn__7242 = function()
      return 'groupBy single';
    end;
    temper.test_assert(test_580, t_584, fn__7242);
    return nil;
  end);
end;
Test_.test_groupByMultipleFields__1477 = function()
  temper.test('groupBy multiple fields', function(test_585)
    local t_586, t_587, q__1009, t_588, fn__7231;
    t_586 = sid__443('orders');
    t_587 = sid__443('status');
    q__1009 = from(t_586):groupBy(t_587):groupBy(sid__443('category'));
    t_588 = temper.str_eq(q__1009:toSql():toString(), 'SELECT * FROM orders GROUP BY status, category');
    fn__7231 = function()
      return 'groupBy multiple';
    end;
    temper.test_assert(test_585, t_588, fn__7231);
    return nil;
  end);
end;
Test_.test_havingBasic__1478 = function()
  temper.test('having basic', function(test_589)
    local t_590, t_591, t_592, t_593, t_594, q__1011, t_595, fn__7212;
    t_590 = sid__443('orders');
    t_591 = col(sid__443('orders'), sid__443('status'));
    t_592 = countAll();
    t_593 = from(t_590):selectExpr(temper.listof(t_591, t_592)):groupBy(sid__443('status'));
    t_594 = SqlBuilder();
    t_594:appendSafe('COUNT(*) > ');
    t_594:appendInt32(5);
    q__1011 = t_593:having(t_594.accumulated);
    t_595 = temper.str_eq(q__1011:toSql():toString(), 'SELECT orders.status, COUNT(*) FROM orders GROUP BY status HAVING COUNT(*) > 5');
    fn__7212 = function()
      return 'having basic';
    end;
    temper.test_assert(test_589, t_595, fn__7212);
    return nil;
  end);
end;
Test_.test_orHaving__1480 = function()
  temper.test('orHaving', function(test_596)
    local t_597, t_598, t_599, t_600, t_601, t_602, q__1013, t_603, fn__7193;
    t_597 = sid__443('orders');
    t_598 = sid__443('status');
    t_599 = from(t_597):groupBy(t_598);
    t_600 = SqlBuilder();
    t_600:appendSafe('COUNT(*) > ');
    t_600:appendInt32(5);
    t_601 = t_599:having(t_600.accumulated);
    t_602 = SqlBuilder();
    t_602:appendSafe('SUM(total) > ');
    t_602:appendInt32(1000);
    q__1013 = t_601:orHaving(t_602.accumulated);
    t_603 = temper.str_eq(q__1013:toSql():toString(), 'SELECT * FROM orders GROUP BY status HAVING COUNT(*) > 5 OR SUM(total) > 1000');
    fn__7193 = function()
      return 'orHaving';
    end;
    temper.test_assert(test_596, t_603, fn__7193);
    return nil;
  end);
end;
Test_.test_distinctBasic__1483 = function()
  temper.test('distinct basic', function(test_604)
    local t_605, t_606, q__1015, t_607, fn__7183;
    t_605 = sid__443('users');
    t_606 = sid__443('name');
    q__1015 = from(t_605):select(temper.listof(t_606)):distinct();
    t_607 = temper.str_eq(q__1015:toSql():toString(), 'SELECT DISTINCT name FROM users');
    fn__7183 = function()
      return 'distinct';
    end;
    temper.test_assert(test_604, t_607, fn__7183);
    return nil;
  end);
end;
Test_.test_distinctWithWhere__1484 = function()
  temper.test('distinct with where', function(test_608)
    local t_609, t_610, t_611, t_612, q__1017, t_613, fn__7168;
    t_609 = sid__443('users');
    t_610 = sid__443('email');
    t_611 = from(t_609):select(temper.listof(t_610));
    t_612 = SqlBuilder();
    t_612:appendSafe('active = ');
    t_612:appendBoolean(true);
    q__1017 = t_611:where(t_612.accumulated):distinct();
    t_613 = temper.str_eq(q__1017:toSql():toString(), 'SELECT DISTINCT email FROM users WHERE active = TRUE');
    fn__7168 = function()
      return 'distinct with where';
    end;
    temper.test_assert(test_608, t_613, fn__7168);
    return nil;
  end);
end;
Test_.test_countSqlBare__1486 = function()
  temper.test('countSql bare', function(test_614)
    local q__1019, t_615, fn__7161;
    q__1019 = from(sid__443('users'));
    t_615 = temper.str_eq(q__1019:countSql():toString(), 'SELECT COUNT(*) FROM users');
    fn__7161 = function()
      return 'countSql bare';
    end;
    temper.test_assert(test_614, t_615, fn__7161);
    return nil;
  end);
end;
Test_.test_countSqlWithWhere__1487 = function()
  temper.test('countSql with WHERE', function(test_616)
    local t_617, t_618, t_619, q__1021, t_620, fn__7149;
    t_617 = sid__443('users');
    t_618 = SqlBuilder();
    t_618:appendSafe('active = ');
    t_618:appendBoolean(true);
    t_619 = t_618.accumulated;
    q__1021 = from(t_617):where(t_619);
    t_620 = temper.str_eq(q__1021:countSql():toString(), 'SELECT COUNT(*) FROM users WHERE active = TRUE');
    fn__7149 = function()
      return 'countSql with where';
    end;
    temper.test_assert(test_616, t_620, fn__7149);
    return nil;
  end);
end;
Test_.test_countSqlWithJoin__1489 = function()
  temper.test('countSql with JOIN', function(test_621)
    local t_622, t_623, t_624, t_625, t_626, t_627, q__1023, t_628, fn__7132;
    t_622 = sid__443('users');
    t_623 = sid__443('orders');
    t_624 = SqlBuilder();
    t_624:appendSafe('users.id = orders.user_id');
    t_625 = t_624.accumulated;
    t_626 = from(t_622):innerJoin(t_623, t_625);
    t_627 = SqlBuilder();
    t_627:appendSafe('orders.total > ');
    t_627:appendInt32(100);
    q__1023 = t_626:where(t_627.accumulated);
    t_628 = temper.str_eq(q__1023:countSql():toString(), 'SELECT COUNT(*) FROM users INNER JOIN orders ON users.id = orders.user_id WHERE orders.total > 100');
    fn__7132 = function()
      return 'countSql with join';
    end;
    temper.test_assert(test_621, t_628, fn__7132);
    return nil;
  end);
end;
Test_.test_countSqlDropsOrderByLimitOffset__1492 = function()
  temper.test('countSql drops orderBy/limit/offset', function(test_629)
    local t_630, t_631, t_632, t_633, t_634, q__1025, local_635, local_636, local_637, s__1026, t_639, fn__7118;
    local_635, local_636, local_637 = temper.pcall(function()
      t_630 = sid__443('users');
      t_631 = SqlBuilder();
      t_631:appendSafe('active = ');
      t_631:appendBoolean(true);
      t_632 = t_631.accumulated;
      t_633 = from(t_630):where(t_632):orderBy(sid__443('name'), true):limit(10);
      t_634 = t_633:offset(20);
      q__1025 = t_634;
    end);
    if local_635 then
    else
      q__1025 = temper.bubble();
    end
    s__1026 = q__1025:countSql():toString();
    t_639 = temper.str_eq(s__1026, 'SELECT COUNT(*) FROM users WHERE active = TRUE');
    fn__7118 = function()
      return temper.concat('countSql drops extras: ', s__1026);
    end;
    temper.test_assert(test_629, t_639, fn__7118);
    return nil;
  end);
end;
Test_.test_fullAggregationQuery__1494 = function()
  temper.test('full aggregation query', function(test_640)
    local t_641, t_642, t_643, t_644, t_645, t_646, t_647, t_648, t_649, t_650, t_651, q__1028, expected__1029, t_652, fn__7085;
    t_641 = sid__443('orders');
    t_642 = col(sid__443('orders'), sid__443('status'));
    t_643 = countAll();
    t_644 = sumCol(sid__443('total'));
    t_645 = from(t_641):selectExpr(temper.listof(t_642, t_643, t_644));
    t_646 = sid__443('users');
    t_647 = SqlBuilder();
    t_647:appendSafe('orders.user_id = users.id');
    t_648 = t_645:innerJoin(t_646, t_647.accumulated);
    t_649 = SqlBuilder();
    t_649:appendSafe('users.active = ');
    t_649:appendBoolean(true);
    t_650 = t_648:where(t_649.accumulated):groupBy(sid__443('status'));
    t_651 = SqlBuilder();
    t_651:appendSafe('COUNT(*) > ');
    t_651:appendInt32(3);
    q__1028 = t_650:having(t_651.accumulated):orderBy(sid__443('status'), true);
    expected__1029 = 'SELECT orders.status, COUNT(*), SUM(total) FROM orders INNER JOIN users ON orders.user_id = users.id WHERE users.active = TRUE GROUP BY status HAVING COUNT(*) > 3 ORDER BY status ASC';
    t_652 = temper.str_eq(q__1028:toSql():toString(), 'SELECT orders.status, COUNT(*), SUM(total) FROM orders INNER JOIN users ON orders.user_id = users.id WHERE users.active = TRUE GROUP BY status HAVING COUNT(*) > 3 ORDER BY status ASC');
    fn__7085 = function()
      return 'full aggregation';
    end;
    temper.test_assert(test_640, t_652, fn__7085);
    return nil;
  end);
end;
Test_.test_safeIdentifierAcceptsValidNames__1498 = function()
  temper.test('safeIdentifier accepts valid names', function(test_653)
    local t_654, id__1067, local_655, local_656, local_657, t_659, fn__7080;
    local_655, local_656, local_657 = temper.pcall(function()
      t_654 = safeIdentifier('user_name');
      id__1067 = t_654;
    end);
    if local_655 then
    else
      id__1067 = temper.bubble();
    end
    t_659 = temper.str_eq(id__1067.sqlValue, 'user_name');
    fn__7080 = function()
      return 'value should round-trip';
    end;
    temper.test_assert(test_653, t_659, fn__7080);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsEmptyString__1499 = function()
  temper.test('safeIdentifier rejects empty string', function(test_660)
    local didBubble__1069, local_661, local_662, local_663, fn__7077;
    local_661, local_662, local_663 = temper.pcall(function()
      safeIdentifier('');
      didBubble__1069 = false;
    end);
    if local_661 then
    else
      didBubble__1069 = true;
    end
    fn__7077 = function()
      return 'empty string should bubble';
    end;
    temper.test_assert(test_660, didBubble__1069, fn__7077);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsLeadingDigit__1500 = function()
  temper.test('safeIdentifier rejects leading digit', function(test_665)
    local didBubble__1071, local_666, local_667, local_668, fn__7074;
    local_666, local_667, local_668 = temper.pcall(function()
      safeIdentifier('1col');
      didBubble__1071 = false;
    end);
    if local_666 then
    else
      didBubble__1071 = true;
    end
    fn__7074 = function()
      return 'leading digit should bubble';
    end;
    temper.test_assert(test_665, didBubble__1071, fn__7074);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsSqlMetacharacters__1501 = function()
  temper.test('safeIdentifier rejects SQL metacharacters', function(test_670)
    local cases__1073, fn__7071;
    cases__1073 = temper.listof('name); DROP TABLE', "col'", 'a b', 'a-b', 'a.b', 'a;b');
    fn__7071 = function(c__1074)
      local didBubble__1075, local_671, local_672, local_673, fn__7068;
      local_671, local_672, local_673 = temper.pcall(function()
        safeIdentifier(c__1074);
        didBubble__1075 = false;
      end);
      if local_671 then
      else
        didBubble__1075 = true;
      end
      fn__7068 = function()
        return temper.concat('should reject: ', c__1074);
      end;
      temper.test_assert(test_670, didBubble__1075, fn__7068);
      return nil;
    end;
    temper.list_foreach(cases__1073, fn__7071);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupFound__1502 = function()
  temper.test('TableDef field lookup - found', function(test_675)
    local t_676, t_677, t_678, t_679, t_680, t_681, t_682, local_683, local_684, local_685, local_687, local_688, local_689, t_691, t_692, local_693, local_694, local_695, t_697, t_698, td__1077, f__1078, local_699, local_700, local_701, t_703, fn__7057;
    local_683, local_684, local_685 = temper.pcall(function()
      t_676 = safeIdentifier('users');
      t_677 = t_676;
    end);
    if local_683 then
    else
      t_677 = temper.bubble();
    end
    local_687, local_688, local_689 = temper.pcall(function()
      t_678 = safeIdentifier('name');
      t_679 = t_678;
    end);
    if local_687 then
    else
      t_679 = temper.bubble();
    end
    t_691 = StringField();
    t_692 = FieldDef(t_679, t_691, false);
    local_693, local_694, local_695 = temper.pcall(function()
      t_680 = safeIdentifier('age');
      t_681 = t_680;
    end);
    if local_693 then
    else
      t_681 = temper.bubble();
    end
    t_697 = IntField();
    t_698 = FieldDef(t_681, t_697, false);
    td__1077 = TableDef(t_677, temper.listof(t_692, t_698));
    local_699, local_700, local_701 = temper.pcall(function()
      t_682 = td__1077:field('age');
      f__1078 = t_682;
    end);
    if local_699 then
    else
      f__1078 = temper.bubble();
    end
    t_703 = temper.str_eq(f__1078.name.sqlValue, 'age');
    fn__7057 = function()
      return 'should find age field';
    end;
    temper.test_assert(test_675, t_703, fn__7057);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupNotFoundBubbles__1503 = function()
  temper.test('TableDef field lookup - not found bubbles', function(test_704)
    local t_705, t_706, t_707, t_708, local_709, local_710, local_711, local_713, local_714, local_715, t_717, t_718, td__1080, didBubble__1081, local_719, local_720, local_721, fn__7051;
    local_709, local_710, local_711 = temper.pcall(function()
      t_705 = safeIdentifier('users');
      t_706 = t_705;
    end);
    if local_709 then
    else
      t_706 = temper.bubble();
    end
    local_713, local_714, local_715 = temper.pcall(function()
      t_707 = safeIdentifier('name');
      t_708 = t_707;
    end);
    if local_713 then
    else
      t_708 = temper.bubble();
    end
    t_717 = StringField();
    t_718 = FieldDef(t_708, t_717, false);
    td__1080 = TableDef(t_706, temper.listof(t_718));
    local_719, local_720, local_721 = temper.pcall(function()
      td__1080:field('nonexistent');
      didBubble__1081 = false;
    end);
    if local_719 then
    else
      didBubble__1081 = true;
    end
    fn__7051 = function()
      return 'unknown field should bubble';
    end;
    temper.test_assert(test_704, didBubble__1081, fn__7051);
    return nil;
  end);
end;
Test_.test_fieldDefNullableFlag__1504 = function()
  temper.test('FieldDef nullable flag', function(test_723)
    local t_724, t_725, t_726, t_727, local_728, local_729, local_730, t_732, required__1083, local_733, local_734, local_735, t_737, optional__1084, t_738, fn__7039, t_739, fn__7038;
    local_728, local_729, local_730 = temper.pcall(function()
      t_724 = safeIdentifier('email');
      t_725 = t_724;
    end);
    if local_728 then
    else
      t_725 = temper.bubble();
    end
    t_732 = StringField();
    required__1083 = FieldDef(t_725, t_732, false);
    local_733, local_734, local_735 = temper.pcall(function()
      t_726 = safeIdentifier('bio');
      t_727 = t_726;
    end);
    if local_733 then
    else
      t_727 = temper.bubble();
    end
    t_737 = StringField();
    optional__1084 = FieldDef(t_727, t_737, true);
    t_738 = not required__1083.nullable;
    fn__7039 = function()
      return 'required field should not be nullable';
    end;
    temper.test_assert(test_723, t_738, fn__7039);
    t_739 = optional__1084.nullable;
    fn__7038 = function()
      return 'optional field should be nullable';
    end;
    temper.test_assert(test_723, t_739, fn__7038);
    return nil;
  end);
end;
Test_.test_stringEscaping__1505 = function()
  temper.test('string escaping', function(test_740)
    local build__1210, buildWrong__1211, actual_742, t_743, fn__7027, bobbyTables__1216, actual_744, t_745, fn__7026, fn__7025;
    build__1210 = function(name__1212)
      local t_741;
      t_741 = SqlBuilder();
      t_741:appendSafe('select * from hi where name = ');
      t_741:appendString(name__1212);
      return t_741.accumulated:toString();
    end;
    buildWrong__1211 = function(name__1214)
      return temper.concat("select * from hi where name = '", name__1214, "'");
    end;
    actual_742 = build__1210('world');
    t_743 = temper.str_eq(actual_742, "select * from hi where name = 'world'");
    fn__7027 = function()
      return temper.concat('expected build("world") == (', "select * from hi where name = 'world'", ') not (', actual_742, ')');
    end;
    temper.test_assert(test_740, t_743, fn__7027);
    bobbyTables__1216 = "Robert'); drop table hi;--";
    actual_744 = build__1210("Robert'); drop table hi;--");
    t_745 = temper.str_eq(actual_744, "select * from hi where name = 'Robert''); drop table hi;--'");
    fn__7026 = function()
      return temper.concat('expected build(bobbyTables) == (', "select * from hi where name = 'Robert''); drop table hi;--'", ') not (', actual_744, ')');
    end;
    temper.test_assert(test_740, t_745, fn__7026);
    fn__7025 = function()
      return "expected buildWrong(bobbyTables) == (select * from hi where name = 'Robert'); drop table hi;--') not (select * from hi where name = 'Robert'); drop table hi;--')";
    end;
    temper.test_assert(test_740, true, fn__7025);
    return nil;
  end);
end;
Test_.test_stringEdgeCases__1513 = function()
  temper.test('string edge cases', function(test_746)
    local t_747, actual_748, t_749, fn__6987, t_750, actual_751, t_752, fn__6986, t_753, actual_754, t_755, fn__6985, t_756, actual_757, t_758, fn__6984;
    t_747 = SqlBuilder();
    t_747:appendSafe('v = ');
    t_747:appendString('');
    actual_748 = t_747.accumulated:toString();
    t_749 = temper.str_eq(actual_748, "v = ''");
    fn__6987 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "").toString() == (', "v = ''", ') not (', actual_748, ')');
    end;
    temper.test_assert(test_746, t_749, fn__6987);
    t_750 = SqlBuilder();
    t_750:appendSafe('v = ');
    t_750:appendString("a''b");
    actual_751 = t_750.accumulated:toString();
    t_752 = temper.str_eq(actual_751, "v = 'a''''b'");
    fn__6986 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v = \", \\interpolate, \"a''b\").toString() == (", "v = 'a''''b'", ') not (', actual_751, ')');
    end;
    temper.test_assert(test_746, t_752, fn__6986);
    t_753 = SqlBuilder();
    t_753:appendSafe('v = ');
    t_753:appendString('Hello \xe4\xb8\x96\xe7\x95\x8c');
    actual_754 = t_753.accumulated:toString();
    t_755 = temper.str_eq(actual_754, "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'");
    fn__6985 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Hello \xe4\xb8\x96\xe7\x95\x8c").toString() == (', "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'", ') not (', actual_754, ')');
    end;
    temper.test_assert(test_746, t_755, fn__6985);
    t_756 = SqlBuilder();
    t_756:appendSafe('v = ');
    t_756:appendString('Line1\nLine2');
    actual_757 = t_756.accumulated:toString();
    t_758 = temper.str_eq(actual_757, "v = 'Line1\nLine2'");
    fn__6984 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Line1\\nLine2").toString() == (', "v = 'Line1\nLine2'", ') not (', actual_757, ')');
    end;
    temper.test_assert(test_746, t_758, fn__6984);
    return nil;
  end);
end;
Test_.test_numbersAndBooleans__1526 = function()
  temper.test('numbers and booleans', function(test_759)
    local t_760, t_761, actual_762, t_763, fn__6958, date__1219, local_764, local_765, local_766, t_768, actual_769, t_770, fn__6957;
    t_761 = SqlBuilder();
    t_761:appendSafe('select ');
    t_761:appendInt32(42);
    t_761:appendSafe(', ');
    t_761:appendInt64(temper.int64_constructor(43));
    t_761:appendSafe(', ');
    t_761:appendFloat64(19.99);
    t_761:appendSafe(', ');
    t_761:appendBoolean(true);
    t_761:appendSafe(', ');
    t_761:appendBoolean(false);
    actual_762 = t_761.accumulated:toString();
    t_763 = temper.str_eq(actual_762, 'select 42, 43, 19.99, TRUE, FALSE');
    fn__6958 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, 42, ", ", \\interpolate, 43, ", ", \\interpolate, 19.99, ", ", \\interpolate, true, ", ", \\interpolate, false).toString() == (', 'select 42, 43, 19.99, TRUE, FALSE', ') not (', actual_762, ')');
    end;
    temper.test_assert(test_759, t_763, fn__6958);
    local_764, local_765, local_766 = temper.pcall(function()
      t_760 = temper.date_constructor(2024, 12, 25);
      date__1219 = t_760;
    end);
    if local_764 then
    else
      date__1219 = temper.bubble();
    end
    t_768 = SqlBuilder();
    t_768:appendSafe('insert into t values (');
    t_768:appendDate(date__1219);
    t_768:appendSafe(')');
    actual_769 = t_768.accumulated:toString();
    t_770 = temper.str_eq(actual_769, "insert into t values ('2024-12-25')");
    fn__6957 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "insert into t values (", \\interpolate, date, ")").toString() == (', "insert into t values ('2024-12-25')", ') not (', actual_769, ')');
    end;
    temper.test_assert(test_759, t_770, fn__6957);
    return nil;
  end);
end;
Test_.test_lists__1533 = function()
  temper.test('lists', function(test_771)
    local t_772, t_773, t_774, t_775, t_776, actual_777, t_778, fn__6902, t_779, actual_780, t_781, fn__6901, t_782, actual_783, t_784, fn__6900, t_785, actual_786, t_787, fn__6899, t_788, actual_789, t_790, fn__6898, local_791, local_792, local_793, local_795, local_796, local_797, dates__1221, t_799, actual_800, t_801, fn__6897;
    t_776 = SqlBuilder();
    t_776:appendSafe('v IN (');
    t_776:appendStringList(temper.listof('a', 'b', "c'd"));
    t_776:appendSafe(')');
    actual_777 = t_776.accumulated:toString();
    t_778 = temper.str_eq(actual_777, "v IN ('a', 'b', 'c''d')");
    fn__6902 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v IN (\", \\interpolate, list(\"a\", \"b\", \"c'd\"), \")\").toString() == (", "v IN ('a', 'b', 'c''d')", ') not (', actual_777, ')');
    end;
    temper.test_assert(test_771, t_778, fn__6902);
    t_779 = SqlBuilder();
    t_779:appendSafe('v IN (');
    t_779:appendInt32List(temper.listof(1, 2, 3));
    t_779:appendSafe(')');
    actual_780 = t_779.accumulated:toString();
    t_781 = temper.str_eq(actual_780, 'v IN (1, 2, 3)');
    fn__6901 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2, 3), ")").toString() == (', 'v IN (1, 2, 3)', ') not (', actual_780, ')');
    end;
    temper.test_assert(test_771, t_781, fn__6901);
    t_782 = SqlBuilder();
    t_782:appendSafe('v IN (');
    t_782:appendInt64List(temper.listof(temper.int64_constructor(1), temper.int64_constructor(2)));
    t_782:appendSafe(')');
    actual_783 = t_782.accumulated:toString();
    t_784 = temper.str_eq(actual_783, 'v IN (1, 2)');
    fn__6900 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2), ")").toString() == (', 'v IN (1, 2)', ') not (', actual_783, ')');
    end;
    temper.test_assert(test_771, t_784, fn__6900);
    t_785 = SqlBuilder();
    t_785:appendSafe('v IN (');
    t_785:appendFloat64List(temper.listof(1.0, 2.0));
    t_785:appendSafe(')');
    actual_786 = t_785.accumulated:toString();
    t_787 = temper.str_eq(actual_786, 'v IN (1.0, 2.0)');
    fn__6899 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1.0, 2.0), ")").toString() == (', 'v IN (1.0, 2.0)', ') not (', actual_786, ')');
    end;
    temper.test_assert(test_771, t_787, fn__6899);
    t_788 = SqlBuilder();
    t_788:appendSafe('v IN (');
    t_788:appendBooleanList(temper.listof(true, false));
    t_788:appendSafe(')');
    actual_789 = t_788.accumulated:toString();
    t_790 = temper.str_eq(actual_789, 'v IN (TRUE, FALSE)');
    fn__6898 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(true, false), ")").toString() == (', 'v IN (TRUE, FALSE)', ') not (', actual_789, ')');
    end;
    temper.test_assert(test_771, t_790, fn__6898);
    local_791, local_792, local_793 = temper.pcall(function()
      t_772 = temper.date_constructor(2024, 1, 1);
      t_773 = t_772;
    end);
    if local_791 then
    else
      t_773 = temper.bubble();
    end
    local_795, local_796, local_797 = temper.pcall(function()
      t_774 = temper.date_constructor(2024, 12, 25);
      t_775 = t_774;
    end);
    if local_795 then
    else
      t_775 = temper.bubble();
    end
    dates__1221 = temper.listof(t_773, t_775);
    t_799 = SqlBuilder();
    t_799:appendSafe('v IN (');
    t_799:appendDateList(dates__1221);
    t_799:appendSafe(')');
    actual_800 = t_799.accumulated:toString();
    t_801 = temper.str_eq(actual_800, "v IN ('2024-01-01', '2024-12-25')");
    fn__6897 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, dates, ")").toString() == (', "v IN ('2024-01-01', '2024-12-25')", ') not (', actual_800, ')');
    end;
    temper.test_assert(test_771, t_801, fn__6897);
    return nil;
  end);
end;
Test_.test_sqlFloat64_naNRendersAsNull__1552 = function()
  temper.test('SqlFloat64 NaN renders as NULL', function(test_802)
    local nan__1223, t_803, actual_804, t_805, fn__6888;
    nan__1223 = temper.fdiv(0.0, 0.0);
    t_803 = SqlBuilder();
    t_803:appendSafe('v = ');
    t_803:appendFloat64(nan__1223);
    actual_804 = t_803.accumulated:toString();
    t_805 = temper.str_eq(actual_804, 'v = NULL');
    fn__6888 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, nan).toString() == (', 'v = NULL', ') not (', actual_804, ')');
    end;
    temper.test_assert(test_802, t_805, fn__6888);
    return nil;
  end);
end;
Test_.test_sqlFloat64_infinityRendersAsNull__1556 = function()
  temper.test('SqlFloat64 Infinity renders as NULL', function(test_806)
    local inf__1225, t_807, actual_808, t_809, fn__6879;
    inf__1225 = temper.fdiv(1.0, 0.0);
    t_807 = SqlBuilder();
    t_807:appendSafe('v = ');
    t_807:appendFloat64(inf__1225);
    actual_808 = t_807.accumulated:toString();
    t_809 = temper.str_eq(actual_808, 'v = NULL');
    fn__6879 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, inf).toString() == (', 'v = NULL', ') not (', actual_808, ')');
    end;
    temper.test_assert(test_806, t_809, fn__6879);
    return nil;
  end);
end;
Test_.test_sqlFloat64_negativeInfinityRendersAsNull__1560 = function()
  temper.test('SqlFloat64 negative Infinity renders as NULL', function(test_810)
    local ninf__1227, t_811, actual_812, t_813, fn__6870;
    ninf__1227 = temper.fdiv(-1.0, 0.0);
    t_811 = SqlBuilder();
    t_811:appendSafe('v = ');
    t_811:appendFloat64(ninf__1227);
    actual_812 = t_811.accumulated:toString();
    t_813 = temper.str_eq(actual_812, 'v = NULL');
    fn__6870 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, ninf).toString() == (', 'v = NULL', ') not (', actual_812, ')');
    end;
    temper.test_assert(test_810, t_813, fn__6870);
    return nil;
  end);
end;
Test_.test_sqlFloat64_normalValuesStillWork__1564 = function()
  temper.test('SqlFloat64 normal values still work', function(test_814)
    local t_815, actual_816, t_817, fn__6845, t_818, actual_819, t_820, fn__6844, t_821, actual_822, t_823, fn__6843;
    t_815 = SqlBuilder();
    t_815:appendSafe('v = ');
    t_815:appendFloat64(3.14);
    actual_816 = t_815.accumulated:toString();
    t_817 = temper.str_eq(actual_816, 'v = 3.14');
    fn__6845 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 3.14).toString() == (', 'v = 3.14', ') not (', actual_816, ')');
    end;
    temper.test_assert(test_814, t_817, fn__6845);
    t_818 = SqlBuilder();
    t_818:appendSafe('v = ');
    t_818:appendFloat64(0.0);
    actual_819 = t_818.accumulated:toString();
    t_820 = temper.str_eq(actual_819, 'v = 0.0');
    fn__6844 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 0.0).toString() == (', 'v = 0.0', ') not (', actual_819, ')');
    end;
    temper.test_assert(test_814, t_820, fn__6844);
    t_821 = SqlBuilder();
    t_821:appendSafe('v = ');
    t_821:appendFloat64(-42.5);
    actual_822 = t_821.accumulated:toString();
    t_823 = temper.str_eq(actual_822, 'v = -42.5');
    fn__6843 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, -42.5).toString() == (', 'v = -42.5', ') not (', actual_822, ')');
    end;
    temper.test_assert(test_814, t_823, fn__6843);
    return nil;
  end);
end;
Test_.test_sqlDateRendersWithQuotes__1574 = function()
  temper.test('SqlDate renders with quotes', function(test_824)
    local t_825, d__1230, local_826, local_827, local_828, t_830, actual_831, t_832, fn__6834;
    local_826, local_827, local_828 = temper.pcall(function()
      t_825 = temper.date_constructor(2024, 6, 15);
      d__1230 = t_825;
    end);
    if local_826 then
    else
      d__1230 = temper.bubble();
    end
    t_830 = SqlBuilder();
    t_830:appendSafe('v = ');
    t_830:appendDate(d__1230);
    actual_831 = t_830.accumulated:toString();
    t_832 = temper.str_eq(actual_831, "v = '2024-06-15'");
    fn__6834 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, d).toString() == (', "v = '2024-06-15'", ') not (', actual_831, ')');
    end;
    temper.test_assert(test_824, t_832, fn__6834);
    return nil;
  end);
end;
Test_.test_nesting__1578 = function()
  temper.test('nesting', function(test_833)
    local name__1232, t_834, condition__1233, t_835, actual_836, t_837, fn__6802, t_838, actual_839, t_840, fn__6801, parts__1234, t_841, actual_842, t_843, fn__6800;
    name__1232 = 'Someone';
    t_834 = SqlBuilder();
    t_834:appendSafe('where p.last_name = ');
    t_834:appendString('Someone');
    condition__1233 = t_834.accumulated;
    t_835 = SqlBuilder();
    t_835:appendSafe('select p.id from person p ');
    t_835:appendFragment(condition__1233);
    actual_836 = t_835.accumulated:toString();
    t_837 = temper.str_eq(actual_836, "select p.id from person p where p.last_name = 'Someone'");
    fn__6802 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_836, ')');
    end;
    temper.test_assert(test_833, t_837, fn__6802);
    t_838 = SqlBuilder();
    t_838:appendSafe('select p.id from person p ');
    t_838:appendPart(condition__1233:toSource());
    actual_839 = t_838.accumulated:toString();
    t_840 = temper.str_eq(actual_839, "select p.id from person p where p.last_name = 'Someone'");
    fn__6801 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition.toSource()).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_839, ')');
    end;
    temper.test_assert(test_833, t_840, fn__6801);
    parts__1234 = temper.listof(SqlString("a'b"), SqlInt32(3));
    t_841 = SqlBuilder();
    t_841:appendSafe('select ');
    t_841:appendPartList(parts__1234);
    actual_842 = t_841.accumulated:toString();
    t_843 = temper.str_eq(actual_842, "select 'a''b', 3");
    fn__6800 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, parts).toString() == (', "select 'a''b', 3", ') not (', actual_842, ')');
    end;
    temper.test_assert(test_833, t_843, fn__6800);
    return nil;
  end);
end;
exports = {};
local_845.LuaUnit.run(local_844({'--pattern', '^Test_%.', local_844(arg)}));
return exports;
