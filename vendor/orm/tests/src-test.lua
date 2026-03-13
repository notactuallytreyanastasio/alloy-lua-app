local temper = require('temper-core');
local safeIdentifier, TableDef, FieldDef, StringField, IntField, FloatField, BoolField, changeset, from, SqlBuilder, SqlString, SqlInt32, local_554, local_555, csid__302, userTable__303, sid__304, exports;
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
SqlString = temper.import('orm/src', 'SqlString');
SqlInt32 = temper.import('orm/src', 'SqlInt32');
local_554 = (unpack or table.unpack);
local_555 = require('luaunit');
local_555.FAILURE_PREFIX = temper.test_failure_prefix;
Test_ = {};
csid__302 = function(name__447)
  local return__203, t_114, local_115, local_116, local_117;
  local_115, local_116, local_117 = temper.pcall(function()
    t_114 = safeIdentifier(name__447);
    return__203 = t_114;
  end);
  if local_115 then
  else
    return__203 = temper.bubble();
  end
  return return__203;
end;
userTable__303 = function()
  return TableDef(csid__302('users'), temper.listof(FieldDef(csid__302('name'), StringField(), false), FieldDef(csid__302('email'), StringField(), false), FieldDef(csid__302('age'), IntField(), true), FieldDef(csid__302('score'), FloatField(), true), FieldDef(csid__302('active'), BoolField(), true)));
end;
Test_.test_castWhitelistsAllowedFields__908 = function()
  temper.test('cast whitelists allowed fields', function(test_119)
    local params__451, t_120, t_121, t_122, cs__452, t_123, fn__4823, t_124, fn__4822, t_125, fn__4821, t_126, fn__4820;
    params__451 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com'), temper.pair_constructor('admin', 'true')));
    t_120 = userTable__303();
    t_121 = csid__302('name');
    t_122 = csid__302('email');
    cs__452 = changeset(t_120, params__451):cast(temper.listof(t_121, t_122));
    t_123 = temper.mapped_has(cs__452.changes, 'name');
    fn__4823 = function()
      return 'name should be in changes';
    end;
    temper.test_assert(test_119, t_123, fn__4823);
    t_124 = temper.mapped_has(cs__452.changes, 'email');
    fn__4822 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_119, t_124, fn__4822);
    t_125 = not temper.mapped_has(cs__452.changes, 'admin');
    fn__4821 = function()
      return 'admin must be dropped (not in whitelist)';
    end;
    temper.test_assert(test_119, t_125, fn__4821);
    t_126 = cs__452.isValid;
    fn__4820 = function()
      return 'should still be valid';
    end;
    temper.test_assert(test_119, t_126, fn__4820);
    return nil;
  end);
end;
Test_.test_castIsReplacingNotAdditiveSecondCallResetsWhitelist__909 = function()
  temper.test('cast is replacing not additive \xe2\x80\x94 second call resets whitelist', function(test_127)
    local params__454, t_128, t_129, cs__455, t_130, fn__4802, t_131, fn__4801;
    params__454 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com')));
    t_128 = userTable__303();
    t_129 = csid__302('name');
    cs__455 = changeset(t_128, params__454):cast(temper.listof(t_129)):cast(temper.listof(csid__302('email')));
    t_130 = not temper.mapped_has(cs__455.changes, 'name');
    fn__4802 = function()
      return 'name must be excluded by second cast';
    end;
    temper.test_assert(test_127, t_130, fn__4802);
    t_131 = temper.mapped_has(cs__455.changes, 'email');
    fn__4801 = function()
      return 'email should be present';
    end;
    temper.test_assert(test_127, t_131, fn__4801);
    return nil;
  end);
end;
Test_.test_castIgnoresEmptyStringValues__910 = function()
  temper.test('cast ignores empty string values', function(test_132)
    local params__457, t_133, t_134, t_135, cs__458, t_136, fn__4784, t_137, fn__4783;
    params__457 = temper.map_constructor(temper.listof(temper.pair_constructor('name', ''), temper.pair_constructor('email', 'bob@example.com')));
    t_133 = userTable__303();
    t_134 = csid__302('name');
    t_135 = csid__302('email');
    cs__458 = changeset(t_133, params__457):cast(temper.listof(t_134, t_135));
    t_136 = not temper.mapped_has(cs__458.changes, 'name');
    fn__4784 = function()
      return 'empty name should not be in changes';
    end;
    temper.test_assert(test_132, t_136, fn__4784);
    t_137 = temper.mapped_has(cs__458.changes, 'email');
    fn__4783 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_132, t_137, fn__4783);
    return nil;
  end);
end;
Test_.test_validateRequiredPassesWhenFieldPresent__911 = function()
  temper.test('validateRequired passes when field present', function(test_138)
    local params__460, t_139, t_140, cs__461, t_141, fn__4767, t_142, fn__4766;
    params__460 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_139 = userTable__303();
    t_140 = csid__302('name');
    cs__461 = changeset(t_139, params__460):cast(temper.listof(t_140)):validateRequired(temper.listof(csid__302('name')));
    t_141 = cs__461.isValid;
    fn__4767 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_138, t_141, fn__4767);
    t_142 = (temper.list_length(cs__461.errors) == 0);
    fn__4766 = function()
      return 'no errors expected';
    end;
    temper.test_assert(test_138, t_142, fn__4766);
    return nil;
  end);
end;
Test_.test_validateRequiredFailsWhenFieldMissing__912 = function()
  temper.test('validateRequired fails when field missing', function(test_143)
    local params__463, t_144, t_145, cs__464, t_146, fn__4744, t_147, fn__4743, t_148, fn__4742;
    params__463 = temper.map_constructor(temper.listof());
    t_144 = userTable__303();
    t_145 = csid__302('name');
    cs__464 = changeset(t_144, params__463):cast(temper.listof(t_145)):validateRequired(temper.listof(csid__302('name')));
    t_146 = not cs__464.isValid;
    fn__4744 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_143, t_146, fn__4744);
    t_147 = (temper.list_length(cs__464.errors) == 1);
    fn__4743 = function()
      return 'should have one error';
    end;
    temper.test_assert(test_143, t_147, fn__4743);
    t_148 = temper.str_eq((temper.list_get(cs__464.errors, 0)).field, 'name');
    fn__4742 = function()
      return 'error should name the field';
    end;
    temper.test_assert(test_143, t_148, fn__4742);
    return nil;
  end);
end;
Test_.test_validateLengthPassesWithinRange__913 = function()
  temper.test('validateLength passes within range', function(test_149)
    local params__466, t_150, t_151, cs__467, t_152, fn__4731;
    params__466 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_150 = userTable__303();
    t_151 = csid__302('name');
    cs__467 = changeset(t_150, params__466):cast(temper.listof(t_151)):validateLength(csid__302('name'), 2, 50);
    t_152 = cs__467.isValid;
    fn__4731 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_149, t_152, fn__4731);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooShort__914 = function()
  temper.test('validateLength fails when too short', function(test_153)
    local params__469, t_154, t_155, cs__470, t_156, fn__4719;
    params__469 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'A')));
    t_154 = userTable__303();
    t_155 = csid__302('name');
    cs__470 = changeset(t_154, params__469):cast(temper.listof(t_155)):validateLength(csid__302('name'), 2, 50);
    t_156 = not cs__470.isValid;
    fn__4719 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_153, t_156, fn__4719);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooLong__915 = function()
  temper.test('validateLength fails when too long', function(test_157)
    local params__472, t_158, t_159, cs__473, t_160, fn__4707;
    params__472 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')));
    t_158 = userTable__303();
    t_159 = csid__302('name');
    cs__473 = changeset(t_158, params__472):cast(temper.listof(t_159)):validateLength(csid__302('name'), 2, 10);
    t_160 = not cs__473.isValid;
    fn__4707 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_157, t_160, fn__4707);
    return nil;
  end);
end;
Test_.test_validateIntPassesForValidInteger__916 = function()
  temper.test('validateInt passes for valid integer', function(test_161)
    local params__475, t_162, t_163, cs__476, t_164, fn__4696;
    params__475 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '30')));
    t_162 = userTable__303();
    t_163 = csid__302('age');
    cs__476 = changeset(t_162, params__475):cast(temper.listof(t_163)):validateInt(csid__302('age'));
    t_164 = cs__476.isValid;
    fn__4696 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_161, t_164, fn__4696);
    return nil;
  end);
end;
Test_.test_validateIntFailsForNonInteger__917 = function()
  temper.test('validateInt fails for non-integer', function(test_165)
    local params__478, t_166, t_167, cs__479, t_168, fn__4684;
    params__478 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_166 = userTable__303();
    t_167 = csid__302('age');
    cs__479 = changeset(t_166, params__478):cast(temper.listof(t_167)):validateInt(csid__302('age'));
    t_168 = not cs__479.isValid;
    fn__4684 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_165, t_168, fn__4684);
    return nil;
  end);
end;
Test_.test_validateFloatPassesForValidFloat__918 = function()
  temper.test('validateFloat passes for valid float', function(test_169)
    local params__481, t_170, t_171, cs__482, t_172, fn__4673;
    params__481 = temper.map_constructor(temper.listof(temper.pair_constructor('score', '9.5')));
    t_170 = userTable__303();
    t_171 = csid__302('score');
    cs__482 = changeset(t_170, params__481):cast(temper.listof(t_171)):validateFloat(csid__302('score'));
    t_172 = cs__482.isValid;
    fn__4673 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_169, t_172, fn__4673);
    return nil;
  end);
end;
Test_.test_validateInt64_passesForValid64_bitInteger__919 = function()
  temper.test('validateInt64 passes for valid 64-bit integer', function(test_173)
    local params__484, t_174, t_175, cs__485, t_176, fn__4662;
    params__484 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '9999999999')));
    t_174 = userTable__303();
    t_175 = csid__302('age');
    cs__485 = changeset(t_174, params__484):cast(temper.listof(t_175)):validateInt64(csid__302('age'));
    t_176 = cs__485.isValid;
    fn__4662 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_173, t_176, fn__4662);
    return nil;
  end);
end;
Test_.test_validateInt64_failsForNonInteger__920 = function()
  temper.test('validateInt64 fails for non-integer', function(test_177)
    local params__487, t_178, t_179, cs__488, t_180, fn__4650;
    params__487 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_178 = userTable__303();
    t_179 = csid__302('age');
    cs__488 = changeset(t_178, params__487):cast(temper.listof(t_179)):validateInt64(csid__302('age'));
    t_180 = not cs__488.isValid;
    fn__4650 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_177, t_180, fn__4650);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsTrue1_yesOn__921 = function()
  temper.test('validateBool accepts true/1/yes/on', function(test_181)
    local fn__4647;
    fn__4647 = function(v__490)
      local params__491, t_182, t_183, cs__492, t_184, fn__4636;
      params__491 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__490)));
      t_182 = userTable__303();
      t_183 = csid__302('active');
      cs__492 = changeset(t_182, params__491):cast(temper.listof(t_183)):validateBool(csid__302('active'));
      t_184 = cs__492.isValid;
      fn__4636 = function()
        return temper.concat('should accept: ', v__490);
      end;
      temper.test_assert(test_181, t_184, fn__4636);
      return nil;
    end;
    temper.list_foreach(temper.listof('true', '1', 'yes', 'on'), fn__4647);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsFalse0_noOff__922 = function()
  temper.test('validateBool accepts false/0/no/off', function(test_185)
    local fn__4633;
    fn__4633 = function(v__494)
      local params__495, t_186, t_187, cs__496, t_188, fn__4622;
      params__495 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__494)));
      t_186 = userTable__303();
      t_187 = csid__302('active');
      cs__496 = changeset(t_186, params__495):cast(temper.listof(t_187)):validateBool(csid__302('active'));
      t_188 = cs__496.isValid;
      fn__4622 = function()
        return temper.concat('should accept: ', v__494);
      end;
      temper.test_assert(test_185, t_188, fn__4622);
      return nil;
    end;
    temper.list_foreach(temper.listof('false', '0', 'no', 'off'), fn__4633);
    return nil;
  end);
end;
Test_.test_validateBoolRejectsAmbiguousValues__923 = function()
  temper.test('validateBool rejects ambiguous values', function(test_189)
    local fn__4619;
    fn__4619 = function(v__498)
      local params__499, t_190, t_191, cs__500, t_192, fn__4607;
      params__499 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__498)));
      t_190 = userTable__303();
      t_191 = csid__302('active');
      cs__500 = changeset(t_190, params__499):cast(temper.listof(t_191)):validateBool(csid__302('active'));
      t_192 = not cs__500.isValid;
      fn__4607 = function()
        return temper.concat('should reject ambiguous: ', v__498);
      end;
      temper.test_assert(test_189, t_192, fn__4607);
      return nil;
    end;
    temper.list_foreach(temper.listof('TRUE', 'Yes', 'maybe', '2', 'enabled'), fn__4619);
    return nil;
  end);
end;
Test_.test_toInsertSqlEscapesBobbyTables__924 = function()
  temper.test('toInsertSql escapes Bobby Tables', function(test_193)
    local t_194, params__502, t_195, t_196, t_197, cs__503, sqlFrag__504, local_198, local_199, local_200, s__505, t_202, fn__4591;
    params__502 = temper.map_constructor(temper.listof(temper.pair_constructor('name', "Robert'); DROP TABLE users;--"), temper.pair_constructor('email', 'bobby@evil.com')));
    t_195 = userTable__303();
    t_196 = csid__302('name');
    t_197 = csid__302('email');
    cs__503 = changeset(t_195, params__502):cast(temper.listof(t_196, t_197)):validateRequired(temper.listof(csid__302('name'), csid__302('email')));
    local_198, local_199, local_200 = temper.pcall(function()
      t_194 = cs__503:toInsertSql();
      sqlFrag__504 = t_194;
    end);
    if local_198 then
    else
      sqlFrag__504 = temper.bubble();
    end
    s__505 = sqlFrag__504:toString();
    t_202 = temper.is_string_index(temper.string_indexof(s__505, "''"));
    fn__4591 = function()
      return temper.concat('single quote must be doubled: ', s__505);
    end;
    temper.test_assert(test_193, t_202, fn__4591);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForStringField__925 = function()
  temper.test('toInsertSql produces correct SQL for string field', function(test_203)
    local t_204, params__507, t_205, t_206, t_207, cs__508, sqlFrag__509, local_208, local_209, local_210, s__510, t_212, fn__4571, t_213, fn__4570;
    params__507 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'a@example.com')));
    t_205 = userTable__303();
    t_206 = csid__302('name');
    t_207 = csid__302('email');
    cs__508 = changeset(t_205, params__507):cast(temper.listof(t_206, t_207)):validateRequired(temper.listof(csid__302('name'), csid__302('email')));
    local_208, local_209, local_210 = temper.pcall(function()
      t_204 = cs__508:toInsertSql();
      sqlFrag__509 = t_204;
    end);
    if local_208 then
    else
      sqlFrag__509 = temper.bubble();
    end
    s__510 = sqlFrag__509:toString();
    t_212 = temper.is_string_index(temper.string_indexof(s__510, 'INSERT INTO users'));
    fn__4571 = function()
      return temper.concat('has INSERT INTO: ', s__510);
    end;
    temper.test_assert(test_203, t_212, fn__4571);
    t_213 = temper.is_string_index(temper.string_indexof(s__510, "'Alice'"));
    fn__4570 = function()
      return temper.concat('has quoted name: ', s__510);
    end;
    temper.test_assert(test_203, t_213, fn__4570);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForIntField__926 = function()
  temper.test('toInsertSql produces correct SQL for int field', function(test_214)
    local t_215, params__512, t_216, t_217, t_218, t_219, cs__513, sqlFrag__514, local_220, local_221, local_222, s__515, t_224, fn__4552;
    params__512 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob'), temper.pair_constructor('email', 'b@example.com'), temper.pair_constructor('age', '25')));
    t_216 = userTable__303();
    t_217 = csid__302('name');
    t_218 = csid__302('email');
    t_219 = csid__302('age');
    cs__513 = changeset(t_216, params__512):cast(temper.listof(t_217, t_218, t_219)):validateRequired(temper.listof(csid__302('name'), csid__302('email')));
    local_220, local_221, local_222 = temper.pcall(function()
      t_215 = cs__513:toInsertSql();
      sqlFrag__514 = t_215;
    end);
    if local_220 then
    else
      sqlFrag__514 = temper.bubble();
    end
    s__515 = sqlFrag__514:toString();
    t_224 = temper.is_string_index(temper.string_indexof(s__515, '25'));
    fn__4552 = function()
      return temper.concat('age rendered unquoted: ', s__515);
    end;
    temper.test_assert(test_214, t_224, fn__4552);
    return nil;
  end);
end;
Test_.test_toInsertSqlBubblesOnInvalidChangeset__927 = function()
  temper.test('toInsertSql bubbles on invalid changeset', function(test_225)
    local params__517, t_226, t_227, cs__518, didBubble__519, local_228, local_229, local_230, fn__4543;
    params__517 = temper.map_constructor(temper.listof());
    t_226 = userTable__303();
    t_227 = csid__302('name');
    cs__518 = changeset(t_226, params__517):cast(temper.listof(t_227)):validateRequired(temper.listof(csid__302('name')));
    local_228, local_229, local_230 = temper.pcall(function()
      cs__518:toInsertSql();
      didBubble__519 = false;
    end);
    if local_228 then
    else
      didBubble__519 = true;
    end
    fn__4543 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_225, didBubble__519, fn__4543);
    return nil;
  end);
end;
Test_.test_toInsertSqlEnforcesNonNullableFieldsIndependentlyOfIsValid__928 = function()
  temper.test('toInsertSql enforces non-nullable fields independently of isValid', function(test_232)
    local strictTable__521, params__522, t_233, cs__523, t_234, fn__4525, didBubble__524, local_235, local_236, local_237, fn__4524;
    strictTable__521 = TableDef(csid__302('posts'), temper.listof(FieldDef(csid__302('title'), StringField(), false), FieldDef(csid__302('body'), StringField(), true)));
    params__522 = temper.map_constructor(temper.listof(temper.pair_constructor('body', 'hello')));
    t_233 = csid__302('body');
    cs__523 = changeset(strictTable__521, params__522):cast(temper.listof(t_233));
    t_234 = cs__523.isValid;
    fn__4525 = function()
      return 'changeset should appear valid (no explicit validation run)';
    end;
    temper.test_assert(test_232, t_234, fn__4525);
    local_235, local_236, local_237 = temper.pcall(function()
      cs__523:toInsertSql();
      didBubble__524 = false;
    end);
    if local_235 then
    else
      didBubble__524 = true;
    end
    fn__4524 = function()
      return 'toInsertSql should enforce nullable regardless of isValid';
    end;
    temper.test_assert(test_232, didBubble__524, fn__4524);
    return nil;
  end);
end;
Test_.test_toUpdateSqlProducesCorrectSql__929 = function()
  temper.test('toUpdateSql produces correct SQL', function(test_239)
    local t_240, params__526, t_241, t_242, cs__527, sqlFrag__528, local_243, local_244, local_245, s__529, t_247, fn__4512;
    params__526 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob')));
    t_241 = userTable__303();
    t_242 = csid__302('name');
    cs__527 = changeset(t_241, params__526):cast(temper.listof(t_242)):validateRequired(temper.listof(csid__302('name')));
    local_243, local_244, local_245 = temper.pcall(function()
      t_240 = cs__527:toUpdateSql(42);
      sqlFrag__528 = t_240;
    end);
    if local_243 then
    else
      sqlFrag__528 = temper.bubble();
    end
    s__529 = sqlFrag__528:toString();
    t_247 = temper.str_eq(s__529, "UPDATE users SET name = 'Bob' WHERE id = 42");
    fn__4512 = function()
      return temper.concat('got: ', s__529);
    end;
    temper.test_assert(test_239, t_247, fn__4512);
    return nil;
  end);
end;
Test_.test_toUpdateSqlBubblesOnInvalidChangeset__930 = function()
  temper.test('toUpdateSql bubbles on invalid changeset', function(test_248)
    local params__531, t_249, t_250, cs__532, didBubble__533, local_251, local_252, local_253, fn__4503;
    params__531 = temper.map_constructor(temper.listof());
    t_249 = userTable__303();
    t_250 = csid__302('name');
    cs__532 = changeset(t_249, params__531):cast(temper.listof(t_250)):validateRequired(temper.listof(csid__302('name')));
    local_251, local_252, local_253 = temper.pcall(function()
      cs__532:toUpdateSql(1);
      didBubble__533 = false;
    end);
    if local_251 then
    else
      didBubble__533 = true;
    end
    fn__4503 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_248, didBubble__533, fn__4503);
    return nil;
  end);
end;
sid__304 = function(name__588)
  local return__223, t_255, local_256, local_257, local_258;
  local_256, local_257, local_258 = temper.pcall(function()
    t_255 = safeIdentifier(name__588);
    return__223 = t_255;
  end);
  if local_256 then
  else
    return__223 = temper.bubble();
  end
  return return__223;
end;
Test_.test_bareFromProducesSelect__955 = function()
  temper.test('bare from produces SELECT *', function(test_260)
    local q__591, t_261, fn__4433;
    q__591 = from(sid__304('users'));
    t_261 = temper.str_eq(q__591:toSql():toString(), 'SELECT * FROM users');
    fn__4433 = function()
      return 'bare query';
    end;
    temper.test_assert(test_260, t_261, fn__4433);
    return nil;
  end);
end;
Test_.test_selectRestrictsColumns__956 = function()
  temper.test('select restricts columns', function(test_262)
    local t_263, t_264, t_265, q__593, t_266, fn__4423;
    t_263 = sid__304('users');
    t_264 = sid__304('id');
    t_265 = sid__304('name');
    q__593 = from(t_263):select(temper.listof(t_264, t_265));
    t_266 = temper.str_eq(q__593:toSql():toString(), 'SELECT id, name FROM users');
    fn__4423 = function()
      return 'select columns';
    end;
    temper.test_assert(test_262, t_266, fn__4423);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithIntValue__957 = function()
  temper.test('where adds condition with int value', function(test_267)
    local t_268, t_269, t_270, q__595, t_271, fn__4411;
    t_268 = sid__304('users');
    t_269 = SqlBuilder();
    t_269:appendSafe('age > ');
    t_269:appendInt32(18);
    t_270 = t_269.accumulated;
    q__595 = from(t_268):where(t_270);
    t_271 = temper.str_eq(q__595:toSql():toString(), 'SELECT * FROM users WHERE age > 18');
    fn__4411 = function()
      return 'where int';
    end;
    temper.test_assert(test_267, t_271, fn__4411);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithBoolValue__959 = function()
  temper.test('where adds condition with bool value', function(test_272)
    local t_273, t_274, t_275, q__597, t_276, fn__4399;
    t_273 = sid__304('users');
    t_274 = SqlBuilder();
    t_274:appendSafe('active = ');
    t_274:appendBoolean(true);
    t_275 = t_274.accumulated;
    q__597 = from(t_273):where(t_275);
    t_276 = temper.str_eq(q__597:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE');
    fn__4399 = function()
      return 'where bool';
    end;
    temper.test_assert(test_272, t_276, fn__4399);
    return nil;
  end);
end;
Test_.test_chainedWhereUsesAnd__961 = function()
  temper.test('chained where uses AND', function(test_277)
    local t_278, t_279, t_280, t_281, t_282, q__599, t_283, fn__4382;
    t_278 = sid__304('users');
    t_279 = SqlBuilder();
    t_279:appendSafe('age > ');
    t_279:appendInt32(18);
    t_280 = t_279.accumulated;
    t_281 = from(t_278):where(t_280);
    t_282 = SqlBuilder();
    t_282:appendSafe('active = ');
    t_282:appendBoolean(true);
    q__599 = t_281:where(t_282.accumulated);
    t_283 = temper.str_eq(q__599:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE');
    fn__4382 = function()
      return 'chained where';
    end;
    temper.test_assert(test_277, t_283, fn__4382);
    return nil;
  end);
end;
Test_.test_orderByAsc__964 = function()
  temper.test('orderBy ASC', function(test_284)
    local t_285, t_286, q__601, t_287, fn__4373;
    t_285 = sid__304('users');
    t_286 = sid__304('name');
    q__601 = from(t_285):orderBy(t_286, true);
    t_287 = temper.str_eq(q__601:toSql():toString(), 'SELECT * FROM users ORDER BY name ASC');
    fn__4373 = function()
      return 'order asc';
    end;
    temper.test_assert(test_284, t_287, fn__4373);
    return nil;
  end);
end;
Test_.test_orderByDesc__965 = function()
  temper.test('orderBy DESC', function(test_288)
    local t_289, t_290, q__603, t_291, fn__4364;
    t_289 = sid__304('users');
    t_290 = sid__304('created_at');
    q__603 = from(t_289):orderBy(t_290, false);
    t_291 = temper.str_eq(q__603:toSql():toString(), 'SELECT * FROM users ORDER BY created_at DESC');
    fn__4364 = function()
      return 'order desc';
    end;
    temper.test_assert(test_288, t_291, fn__4364);
    return nil;
  end);
end;
Test_.test_limitAndOffset__966 = function()
  temper.test('limit and offset', function(test_292)
    local t_293, t_294, q__605, local_295, local_296, local_297, t_299, fn__4357;
    local_295, local_296, local_297 = temper.pcall(function()
      t_293 = from(sid__304('users')):limit(10);
      t_294 = t_293:offset(20);
      q__605 = t_294;
    end);
    if local_295 then
    else
      q__605 = temper.bubble();
    end
    t_299 = temper.str_eq(q__605:toSql():toString(), 'SELECT * FROM users LIMIT 10 OFFSET 20');
    fn__4357 = function()
      return 'limit/offset';
    end;
    temper.test_assert(test_292, t_299, fn__4357);
    return nil;
  end);
end;
Test_.test_limitBubblesOnNegative__967 = function()
  temper.test('limit bubbles on negative', function(test_300)
    local didBubble__607, local_301, local_302, local_303, fn__4353;
    local_301, local_302, local_303 = temper.pcall(function()
      from(sid__304('users')):limit(-1);
      didBubble__607 = false;
    end);
    if local_301 then
    else
      didBubble__607 = true;
    end
    fn__4353 = function()
      return 'negative limit should bubble';
    end;
    temper.test_assert(test_300, didBubble__607, fn__4353);
    return nil;
  end);
end;
Test_.test_offsetBubblesOnNegative__968 = function()
  temper.test('offset bubbles on negative', function(test_305)
    local didBubble__609, local_306, local_307, local_308, fn__4349;
    local_306, local_307, local_308 = temper.pcall(function()
      from(sid__304('users')):offset(-1);
      didBubble__609 = false;
    end);
    if local_306 then
    else
      didBubble__609 = true;
    end
    fn__4349 = function()
      return 'negative offset should bubble';
    end;
    temper.test_assert(test_305, didBubble__609, fn__4349);
    return nil;
  end);
end;
Test_.test_complexComposedQuery__969 = function()
  temper.test('complex composed query', function(test_310)
    local t_311, t_312, t_313, t_314, t_315, t_316, t_317, t_318, t_319, t_320, minAge__611, q__612, local_321, local_322, local_323, t_325, fn__4326;
    minAge__611 = 21;
    local_321, local_322, local_323 = temper.pcall(function()
      t_311 = sid__304('users');
      t_312 = sid__304('id');
      t_313 = sid__304('name');
      t_314 = sid__304('email');
      t_315 = from(t_311):select(temper.listof(t_312, t_313, t_314));
      t_316 = SqlBuilder();
      t_316:appendSafe('age >= ');
      t_316:appendInt32(21);
      t_317 = t_315:where(t_316.accumulated);
      t_318 = SqlBuilder();
      t_318:appendSafe('active = ');
      t_318:appendBoolean(true);
      t_319 = t_317:where(t_318.accumulated):orderBy(sid__304('name'), true):limit(25);
      t_320 = t_319:offset(0);
      q__612 = t_320;
    end);
    if local_321 then
    else
      q__612 = temper.bubble();
    end
    t_325 = temper.str_eq(q__612:toSql():toString(), 'SELECT id, name, email FROM users WHERE age >= 21 AND active = TRUE ORDER BY name ASC LIMIT 25 OFFSET 0');
    fn__4326 = function()
      return 'complex query';
    end;
    temper.test_assert(test_310, t_325, fn__4326);
    return nil;
  end);
end;
Test_.test_safeToSqlAppliesDefaultLimitWhenNoneSet__972 = function()
  temper.test('safeToSql applies default limit when none set', function(test_326)
    local t_327, t_328, q__614, local_329, local_330, local_331, s__615, t_333, fn__4320;
    q__614 = from(sid__304('users'));
    local_329, local_330, local_331 = temper.pcall(function()
      t_327 = q__614:safeToSql(100);
      t_328 = t_327;
    end);
    if local_329 then
    else
      t_328 = temper.bubble();
    end
    s__615 = t_328:toString();
    t_333 = temper.str_eq(s__615, 'SELECT * FROM users LIMIT 100');
    fn__4320 = function()
      return temper.concat('should have limit: ', s__615);
    end;
    temper.test_assert(test_326, t_333, fn__4320);
    return nil;
  end);
end;
Test_.test_safeToSqlRespectsExplicitLimit__973 = function()
  temper.test('safeToSql respects explicit limit', function(test_334)
    local t_335, t_336, t_337, q__617, local_338, local_339, local_340, local_342, local_343, local_344, s__618, t_346, fn__4314;
    local_338, local_339, local_340 = temper.pcall(function()
      t_335 = from(sid__304('users')):limit(5);
      q__617 = t_335;
    end);
    if local_338 then
    else
      q__617 = temper.bubble();
    end
    local_342, local_343, local_344 = temper.pcall(function()
      t_336 = q__617:safeToSql(100);
      t_337 = t_336;
    end);
    if local_342 then
    else
      t_337 = temper.bubble();
    end
    s__618 = t_337:toString();
    t_346 = temper.str_eq(s__618, 'SELECT * FROM users LIMIT 5');
    fn__4314 = function()
      return temper.concat('explicit limit preserved: ', s__618);
    end;
    temper.test_assert(test_334, t_346, fn__4314);
    return nil;
  end);
end;
Test_.test_safeToSqlBubblesOnNegativeDefaultLimit__974 = function()
  temper.test('safeToSql bubbles on negative defaultLimit', function(test_347)
    local didBubble__620, local_348, local_349, local_350, fn__4310;
    local_348, local_349, local_350 = temper.pcall(function()
      from(sid__304('users')):safeToSql(-1);
      didBubble__620 = false;
    end);
    if local_348 then
    else
      didBubble__620 = true;
    end
    fn__4310 = function()
      return 'negative defaultLimit should bubble';
    end;
    temper.test_assert(test_347, didBubble__620, fn__4310);
    return nil;
  end);
end;
Test_.test_whereWithInjectionAttemptInStringValueIsEscaped__975 = function()
  temper.test('where with injection attempt in string value is escaped', function(test_352)
    local evil__622, t_353, t_354, t_355, q__623, s__624, t_356, fn__4293, t_357, fn__4292;
    evil__622 = "'; DROP TABLE users; --";
    t_353 = sid__304('users');
    t_354 = SqlBuilder();
    t_354:appendSafe('name = ');
    t_354:appendString("'; DROP TABLE users; --");
    t_355 = t_354.accumulated;
    q__623 = from(t_353):where(t_355);
    s__624 = q__623:toSql():toString();
    t_356 = temper.is_string_index(temper.string_indexof(s__624, "''"));
    fn__4293 = function()
      return temper.concat('quotes must be doubled: ', s__624);
    end;
    temper.test_assert(test_352, t_356, fn__4293);
    t_357 = temper.is_string_index(temper.string_indexof(s__624, 'SELECT * FROM users WHERE name ='));
    fn__4292 = function()
      return temper.concat('structure intact: ', s__624);
    end;
    temper.test_assert(test_352, t_357, fn__4292);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsUserSuppliedTableNameWithMetacharacters__977 = function()
  temper.test('safeIdentifier rejects user-supplied table name with metacharacters', function(test_358)
    local attack__626, didBubble__627, local_359, local_360, local_361, fn__4289;
    attack__626 = 'users; DROP TABLE users; --';
    local_359, local_360, local_361 = temper.pcall(function()
      safeIdentifier('users; DROP TABLE users; --');
      didBubble__627 = false;
    end);
    if local_359 then
    else
      didBubble__627 = true;
    end
    fn__4289 = function()
      return 'metacharacter-containing name must be rejected at construction';
    end;
    temper.test_assert(test_358, didBubble__627, fn__4289);
    return nil;
  end);
end;
Test_.test_safeIdentifierAcceptsValidNames__978 = function()
  temper.test('safeIdentifier accepts valid names', function(test_363)
    local t_364, id__665, local_365, local_366, local_367, t_369, fn__4284;
    local_365, local_366, local_367 = temper.pcall(function()
      t_364 = safeIdentifier('user_name');
      id__665 = t_364;
    end);
    if local_365 then
    else
      id__665 = temper.bubble();
    end
    t_369 = temper.str_eq(id__665.sqlValue, 'user_name');
    fn__4284 = function()
      return 'value should round-trip';
    end;
    temper.test_assert(test_363, t_369, fn__4284);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsEmptyString__979 = function()
  temper.test('safeIdentifier rejects empty string', function(test_370)
    local didBubble__667, local_371, local_372, local_373, fn__4281;
    local_371, local_372, local_373 = temper.pcall(function()
      safeIdentifier('');
      didBubble__667 = false;
    end);
    if local_371 then
    else
      didBubble__667 = true;
    end
    fn__4281 = function()
      return 'empty string should bubble';
    end;
    temper.test_assert(test_370, didBubble__667, fn__4281);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsLeadingDigit__980 = function()
  temper.test('safeIdentifier rejects leading digit', function(test_375)
    local didBubble__669, local_376, local_377, local_378, fn__4278;
    local_376, local_377, local_378 = temper.pcall(function()
      safeIdentifier('1col');
      didBubble__669 = false;
    end);
    if local_376 then
    else
      didBubble__669 = true;
    end
    fn__4278 = function()
      return 'leading digit should bubble';
    end;
    temper.test_assert(test_375, didBubble__669, fn__4278);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsSqlMetacharacters__981 = function()
  temper.test('safeIdentifier rejects SQL metacharacters', function(test_380)
    local cases__671, fn__4275;
    cases__671 = temper.listof('name); DROP TABLE', "col'", 'a b', 'a-b', 'a.b', 'a;b');
    fn__4275 = function(c__672)
      local didBubble__673, local_381, local_382, local_383, fn__4272;
      local_381, local_382, local_383 = temper.pcall(function()
        safeIdentifier(c__672);
        didBubble__673 = false;
      end);
      if local_381 then
      else
        didBubble__673 = true;
      end
      fn__4272 = function()
        return temper.concat('should reject: ', c__672);
      end;
      temper.test_assert(test_380, didBubble__673, fn__4272);
      return nil;
    end;
    temper.list_foreach(cases__671, fn__4275);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupFound__982 = function()
  temper.test('TableDef field lookup - found', function(test_385)
    local t_386, t_387, t_388, t_389, t_390, t_391, t_392, local_393, local_394, local_395, local_397, local_398, local_399, t_401, t_402, local_403, local_404, local_405, t_407, t_408, td__675, f__676, local_409, local_410, local_411, t_413, fn__4261;
    local_393, local_394, local_395 = temper.pcall(function()
      t_386 = safeIdentifier('users');
      t_387 = t_386;
    end);
    if local_393 then
    else
      t_387 = temper.bubble();
    end
    local_397, local_398, local_399 = temper.pcall(function()
      t_388 = safeIdentifier('name');
      t_389 = t_388;
    end);
    if local_397 then
    else
      t_389 = temper.bubble();
    end
    t_401 = StringField();
    t_402 = FieldDef(t_389, t_401, false);
    local_403, local_404, local_405 = temper.pcall(function()
      t_390 = safeIdentifier('age');
      t_391 = t_390;
    end);
    if local_403 then
    else
      t_391 = temper.bubble();
    end
    t_407 = IntField();
    t_408 = FieldDef(t_391, t_407, false);
    td__675 = TableDef(t_387, temper.listof(t_402, t_408));
    local_409, local_410, local_411 = temper.pcall(function()
      t_392 = td__675:field('age');
      f__676 = t_392;
    end);
    if local_409 then
    else
      f__676 = temper.bubble();
    end
    t_413 = temper.str_eq(f__676.name.sqlValue, 'age');
    fn__4261 = function()
      return 'should find age field';
    end;
    temper.test_assert(test_385, t_413, fn__4261);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupNotFoundBubbles__983 = function()
  temper.test('TableDef field lookup - not found bubbles', function(test_414)
    local t_415, t_416, t_417, t_418, local_419, local_420, local_421, local_423, local_424, local_425, t_427, t_428, td__678, didBubble__679, local_429, local_430, local_431, fn__4255;
    local_419, local_420, local_421 = temper.pcall(function()
      t_415 = safeIdentifier('users');
      t_416 = t_415;
    end);
    if local_419 then
    else
      t_416 = temper.bubble();
    end
    local_423, local_424, local_425 = temper.pcall(function()
      t_417 = safeIdentifier('name');
      t_418 = t_417;
    end);
    if local_423 then
    else
      t_418 = temper.bubble();
    end
    t_427 = StringField();
    t_428 = FieldDef(t_418, t_427, false);
    td__678 = TableDef(t_416, temper.listof(t_428));
    local_429, local_430, local_431 = temper.pcall(function()
      td__678:field('nonexistent');
      didBubble__679 = false;
    end);
    if local_429 then
    else
      didBubble__679 = true;
    end
    fn__4255 = function()
      return 'unknown field should bubble';
    end;
    temper.test_assert(test_414, didBubble__679, fn__4255);
    return nil;
  end);
end;
Test_.test_fieldDefNullableFlag__984 = function()
  temper.test('FieldDef nullable flag', function(test_433)
    local t_434, t_435, t_436, t_437, local_438, local_439, local_440, t_442, required__681, local_443, local_444, local_445, t_447, optional__682, t_448, fn__4243, t_449, fn__4242;
    local_438, local_439, local_440 = temper.pcall(function()
      t_434 = safeIdentifier('email');
      t_435 = t_434;
    end);
    if local_438 then
    else
      t_435 = temper.bubble();
    end
    t_442 = StringField();
    required__681 = FieldDef(t_435, t_442, false);
    local_443, local_444, local_445 = temper.pcall(function()
      t_436 = safeIdentifier('bio');
      t_437 = t_436;
    end);
    if local_443 then
    else
      t_437 = temper.bubble();
    end
    t_447 = StringField();
    optional__682 = FieldDef(t_437, t_447, true);
    t_448 = not required__681.nullable;
    fn__4243 = function()
      return 'required field should not be nullable';
    end;
    temper.test_assert(test_433, t_448, fn__4243);
    t_449 = optional__682.nullable;
    fn__4242 = function()
      return 'optional field should be nullable';
    end;
    temper.test_assert(test_433, t_449, fn__4242);
    return nil;
  end);
end;
Test_.test_stringEscaping__985 = function()
  temper.test('string escaping', function(test_450)
    local build__808, buildWrong__809, actual_452, t_453, fn__4231, bobbyTables__814, actual_454, t_455, fn__4230, fn__4229;
    build__808 = function(name__810)
      local t_451;
      t_451 = SqlBuilder();
      t_451:appendSafe('select * from hi where name = ');
      t_451:appendString(name__810);
      return t_451.accumulated:toString();
    end;
    buildWrong__809 = function(name__812)
      return temper.concat("select * from hi where name = '", name__812, "'");
    end;
    actual_452 = build__808('world');
    t_453 = temper.str_eq(actual_452, "select * from hi where name = 'world'");
    fn__4231 = function()
      return temper.concat('expected build("world") == (', "select * from hi where name = 'world'", ') not (', actual_452, ')');
    end;
    temper.test_assert(test_450, t_453, fn__4231);
    bobbyTables__814 = "Robert'); drop table hi;--";
    actual_454 = build__808("Robert'); drop table hi;--");
    t_455 = temper.str_eq(actual_454, "select * from hi where name = 'Robert''); drop table hi;--'");
    fn__4230 = function()
      return temper.concat('expected build(bobbyTables) == (', "select * from hi where name = 'Robert''); drop table hi;--'", ') not (', actual_454, ')');
    end;
    temper.test_assert(test_450, t_455, fn__4230);
    fn__4229 = function()
      return "expected buildWrong(bobbyTables) == (select * from hi where name = 'Robert'); drop table hi;--') not (select * from hi where name = 'Robert'); drop table hi;--')";
    end;
    temper.test_assert(test_450, true, fn__4229);
    return nil;
  end);
end;
Test_.test_stringEdgeCases__993 = function()
  temper.test('string edge cases', function(test_456)
    local t_457, actual_458, t_459, fn__4191, t_460, actual_461, t_462, fn__4190, t_463, actual_464, t_465, fn__4189, t_466, actual_467, t_468, fn__4188;
    t_457 = SqlBuilder();
    t_457:appendSafe('v = ');
    t_457:appendString('');
    actual_458 = t_457.accumulated:toString();
    t_459 = temper.str_eq(actual_458, "v = ''");
    fn__4191 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "").toString() == (', "v = ''", ') not (', actual_458, ')');
    end;
    temper.test_assert(test_456, t_459, fn__4191);
    t_460 = SqlBuilder();
    t_460:appendSafe('v = ');
    t_460:appendString("a''b");
    actual_461 = t_460.accumulated:toString();
    t_462 = temper.str_eq(actual_461, "v = 'a''''b'");
    fn__4190 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v = \", \\interpolate, \"a''b\").toString() == (", "v = 'a''''b'", ') not (', actual_461, ')');
    end;
    temper.test_assert(test_456, t_462, fn__4190);
    t_463 = SqlBuilder();
    t_463:appendSafe('v = ');
    t_463:appendString('Hello \xe4\xb8\x96\xe7\x95\x8c');
    actual_464 = t_463.accumulated:toString();
    t_465 = temper.str_eq(actual_464, "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'");
    fn__4189 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Hello \xe4\xb8\x96\xe7\x95\x8c").toString() == (', "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'", ') not (', actual_464, ')');
    end;
    temper.test_assert(test_456, t_465, fn__4189);
    t_466 = SqlBuilder();
    t_466:appendSafe('v = ');
    t_466:appendString('Line1\nLine2');
    actual_467 = t_466.accumulated:toString();
    t_468 = temper.str_eq(actual_467, "v = 'Line1\nLine2'");
    fn__4188 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Line1\\nLine2").toString() == (', "v = 'Line1\nLine2'", ') not (', actual_467, ')');
    end;
    temper.test_assert(test_456, t_468, fn__4188);
    return nil;
  end);
end;
Test_.test_numbersAndBooleans__1006 = function()
  temper.test('numbers and booleans', function(test_469)
    local t_470, t_471, actual_472, t_473, fn__4162, date__817, local_474, local_475, local_476, t_478, actual_479, t_480, fn__4161;
    t_471 = SqlBuilder();
    t_471:appendSafe('select ');
    t_471:appendInt32(42);
    t_471:appendSafe(', ');
    t_471:appendInt64(temper.int64_constructor(43));
    t_471:appendSafe(', ');
    t_471:appendFloat64(19.99);
    t_471:appendSafe(', ');
    t_471:appendBoolean(true);
    t_471:appendSafe(', ');
    t_471:appendBoolean(false);
    actual_472 = t_471.accumulated:toString();
    t_473 = temper.str_eq(actual_472, 'select 42, 43, 19.99, TRUE, FALSE');
    fn__4162 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, 42, ", ", \\interpolate, 43, ", ", \\interpolate, 19.99, ", ", \\interpolate, true, ", ", \\interpolate, false).toString() == (', 'select 42, 43, 19.99, TRUE, FALSE', ') not (', actual_472, ')');
    end;
    temper.test_assert(test_469, t_473, fn__4162);
    local_474, local_475, local_476 = temper.pcall(function()
      t_470 = temper.date_constructor(2024, 12, 25);
      date__817 = t_470;
    end);
    if local_474 then
    else
      date__817 = temper.bubble();
    end
    t_478 = SqlBuilder();
    t_478:appendSafe('insert into t values (');
    t_478:appendDate(date__817);
    t_478:appendSafe(')');
    actual_479 = t_478.accumulated:toString();
    t_480 = temper.str_eq(actual_479, "insert into t values ('2024-12-25')");
    fn__4161 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "insert into t values (", \\interpolate, date, ")").toString() == (', "insert into t values ('2024-12-25')", ') not (', actual_479, ')');
    end;
    temper.test_assert(test_469, t_480, fn__4161);
    return nil;
  end);
end;
Test_.test_lists__1013 = function()
  temper.test('lists', function(test_481)
    local t_482, t_483, t_484, t_485, t_486, actual_487, t_488, fn__4106, t_489, actual_490, t_491, fn__4105, t_492, actual_493, t_494, fn__4104, t_495, actual_496, t_497, fn__4103, t_498, actual_499, t_500, fn__4102, local_501, local_502, local_503, local_505, local_506, local_507, dates__819, t_509, actual_510, t_511, fn__4101;
    t_486 = SqlBuilder();
    t_486:appendSafe('v IN (');
    t_486:appendStringList(temper.listof('a', 'b', "c'd"));
    t_486:appendSafe(')');
    actual_487 = t_486.accumulated:toString();
    t_488 = temper.str_eq(actual_487, "v IN ('a', 'b', 'c''d')");
    fn__4106 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v IN (\", \\interpolate, list(\"a\", \"b\", \"c'd\"), \")\").toString() == (", "v IN ('a', 'b', 'c''d')", ') not (', actual_487, ')');
    end;
    temper.test_assert(test_481, t_488, fn__4106);
    t_489 = SqlBuilder();
    t_489:appendSafe('v IN (');
    t_489:appendInt32List(temper.listof(1, 2, 3));
    t_489:appendSafe(')');
    actual_490 = t_489.accumulated:toString();
    t_491 = temper.str_eq(actual_490, 'v IN (1, 2, 3)');
    fn__4105 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2, 3), ")").toString() == (', 'v IN (1, 2, 3)', ') not (', actual_490, ')');
    end;
    temper.test_assert(test_481, t_491, fn__4105);
    t_492 = SqlBuilder();
    t_492:appendSafe('v IN (');
    t_492:appendInt64List(temper.listof(temper.int64_constructor(1), temper.int64_constructor(2)));
    t_492:appendSafe(')');
    actual_493 = t_492.accumulated:toString();
    t_494 = temper.str_eq(actual_493, 'v IN (1, 2)');
    fn__4104 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2), ")").toString() == (', 'v IN (1, 2)', ') not (', actual_493, ')');
    end;
    temper.test_assert(test_481, t_494, fn__4104);
    t_495 = SqlBuilder();
    t_495:appendSafe('v IN (');
    t_495:appendFloat64List(temper.listof(1.0, 2.0));
    t_495:appendSafe(')');
    actual_496 = t_495.accumulated:toString();
    t_497 = temper.str_eq(actual_496, 'v IN (1.0, 2.0)');
    fn__4103 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1.0, 2.0), ")").toString() == (', 'v IN (1.0, 2.0)', ') not (', actual_496, ')');
    end;
    temper.test_assert(test_481, t_497, fn__4103);
    t_498 = SqlBuilder();
    t_498:appendSafe('v IN (');
    t_498:appendBooleanList(temper.listof(true, false));
    t_498:appendSafe(')');
    actual_499 = t_498.accumulated:toString();
    t_500 = temper.str_eq(actual_499, 'v IN (TRUE, FALSE)');
    fn__4102 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(true, false), ")").toString() == (', 'v IN (TRUE, FALSE)', ') not (', actual_499, ')');
    end;
    temper.test_assert(test_481, t_500, fn__4102);
    local_501, local_502, local_503 = temper.pcall(function()
      t_482 = temper.date_constructor(2024, 1, 1);
      t_483 = t_482;
    end);
    if local_501 then
    else
      t_483 = temper.bubble();
    end
    local_505, local_506, local_507 = temper.pcall(function()
      t_484 = temper.date_constructor(2024, 12, 25);
      t_485 = t_484;
    end);
    if local_505 then
    else
      t_485 = temper.bubble();
    end
    dates__819 = temper.listof(t_483, t_485);
    t_509 = SqlBuilder();
    t_509:appendSafe('v IN (');
    t_509:appendDateList(dates__819);
    t_509:appendSafe(')');
    actual_510 = t_509.accumulated:toString();
    t_511 = temper.str_eq(actual_510, "v IN ('2024-01-01', '2024-12-25')");
    fn__4101 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, dates, ")").toString() == (', "v IN ('2024-01-01', '2024-12-25')", ') not (', actual_510, ')');
    end;
    temper.test_assert(test_481, t_511, fn__4101);
    return nil;
  end);
end;
Test_.test_sqlFloat64_naNRendersAsNull__1032 = function()
  temper.test('SqlFloat64 NaN renders as NULL', function(test_512)
    local nan__821, t_513, actual_514, t_515, fn__4092;
    nan__821 = temper.fdiv(0.0, 0.0);
    t_513 = SqlBuilder();
    t_513:appendSafe('v = ');
    t_513:appendFloat64(nan__821);
    actual_514 = t_513.accumulated:toString();
    t_515 = temper.str_eq(actual_514, 'v = NULL');
    fn__4092 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, nan).toString() == (', 'v = NULL', ') not (', actual_514, ')');
    end;
    temper.test_assert(test_512, t_515, fn__4092);
    return nil;
  end);
end;
Test_.test_sqlFloat64_infinityRendersAsNull__1036 = function()
  temper.test('SqlFloat64 Infinity renders as NULL', function(test_516)
    local inf__823, t_517, actual_518, t_519, fn__4083;
    inf__823 = temper.fdiv(1.0, 0.0);
    t_517 = SqlBuilder();
    t_517:appendSafe('v = ');
    t_517:appendFloat64(inf__823);
    actual_518 = t_517.accumulated:toString();
    t_519 = temper.str_eq(actual_518, 'v = NULL');
    fn__4083 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, inf).toString() == (', 'v = NULL', ') not (', actual_518, ')');
    end;
    temper.test_assert(test_516, t_519, fn__4083);
    return nil;
  end);
end;
Test_.test_sqlFloat64_negativeInfinityRendersAsNull__1040 = function()
  temper.test('SqlFloat64 negative Infinity renders as NULL', function(test_520)
    local ninf__825, t_521, actual_522, t_523, fn__4074;
    ninf__825 = temper.fdiv(-1.0, 0.0);
    t_521 = SqlBuilder();
    t_521:appendSafe('v = ');
    t_521:appendFloat64(ninf__825);
    actual_522 = t_521.accumulated:toString();
    t_523 = temper.str_eq(actual_522, 'v = NULL');
    fn__4074 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, ninf).toString() == (', 'v = NULL', ') not (', actual_522, ')');
    end;
    temper.test_assert(test_520, t_523, fn__4074);
    return nil;
  end);
end;
Test_.test_sqlFloat64_normalValuesStillWork__1044 = function()
  temper.test('SqlFloat64 normal values still work', function(test_524)
    local t_525, actual_526, t_527, fn__4049, t_528, actual_529, t_530, fn__4048, t_531, actual_532, t_533, fn__4047;
    t_525 = SqlBuilder();
    t_525:appendSafe('v = ');
    t_525:appendFloat64(3.14);
    actual_526 = t_525.accumulated:toString();
    t_527 = temper.str_eq(actual_526, 'v = 3.14');
    fn__4049 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 3.14).toString() == (', 'v = 3.14', ') not (', actual_526, ')');
    end;
    temper.test_assert(test_524, t_527, fn__4049);
    t_528 = SqlBuilder();
    t_528:appendSafe('v = ');
    t_528:appendFloat64(0.0);
    actual_529 = t_528.accumulated:toString();
    t_530 = temper.str_eq(actual_529, 'v = 0.0');
    fn__4048 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 0.0).toString() == (', 'v = 0.0', ') not (', actual_529, ')');
    end;
    temper.test_assert(test_524, t_530, fn__4048);
    t_531 = SqlBuilder();
    t_531:appendSafe('v = ');
    t_531:appendFloat64(-42.5);
    actual_532 = t_531.accumulated:toString();
    t_533 = temper.str_eq(actual_532, 'v = -42.5');
    fn__4047 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, -42.5).toString() == (', 'v = -42.5', ') not (', actual_532, ')');
    end;
    temper.test_assert(test_524, t_533, fn__4047);
    return nil;
  end);
end;
Test_.test_sqlDateRendersWithQuotes__1054 = function()
  temper.test('SqlDate renders with quotes', function(test_534)
    local t_535, d__828, local_536, local_537, local_538, t_540, actual_541, t_542, fn__4038;
    local_536, local_537, local_538 = temper.pcall(function()
      t_535 = temper.date_constructor(2024, 6, 15);
      d__828 = t_535;
    end);
    if local_536 then
    else
      d__828 = temper.bubble();
    end
    t_540 = SqlBuilder();
    t_540:appendSafe('v = ');
    t_540:appendDate(d__828);
    actual_541 = t_540.accumulated:toString();
    t_542 = temper.str_eq(actual_541, "v = '2024-06-15'");
    fn__4038 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, d).toString() == (', "v = '2024-06-15'", ') not (', actual_541, ')');
    end;
    temper.test_assert(test_534, t_542, fn__4038);
    return nil;
  end);
end;
Test_.test_nesting__1058 = function()
  temper.test('nesting', function(test_543)
    local name__830, t_544, condition__831, t_545, actual_546, t_547, fn__4006, t_548, actual_549, t_550, fn__4005, parts__832, t_551, actual_552, t_553, fn__4004;
    name__830 = 'Someone';
    t_544 = SqlBuilder();
    t_544:appendSafe('where p.last_name = ');
    t_544:appendString('Someone');
    condition__831 = t_544.accumulated;
    t_545 = SqlBuilder();
    t_545:appendSafe('select p.id from person p ');
    t_545:appendFragment(condition__831);
    actual_546 = t_545.accumulated:toString();
    t_547 = temper.str_eq(actual_546, "select p.id from person p where p.last_name = 'Someone'");
    fn__4006 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_546, ')');
    end;
    temper.test_assert(test_543, t_547, fn__4006);
    t_548 = SqlBuilder();
    t_548:appendSafe('select p.id from person p ');
    t_548:appendPart(condition__831:toSource());
    actual_549 = t_548.accumulated:toString();
    t_550 = temper.str_eq(actual_549, "select p.id from person p where p.last_name = 'Someone'");
    fn__4005 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition.toSource()).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_549, ')');
    end;
    temper.test_assert(test_543, t_550, fn__4005);
    parts__832 = temper.listof(SqlString("a'b"), SqlInt32(3));
    t_551 = SqlBuilder();
    t_551:appendSafe('select ');
    t_551:appendPartList(parts__832);
    actual_552 = t_551.accumulated:toString();
    t_553 = temper.str_eq(actual_552, "select 'a''b', 3");
    fn__4004 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, parts).toString() == (', "select 'a''b', 3", ') not (', actual_552, ')');
    end;
    temper.test_assert(test_543, t_553, fn__4004);
    return nil;
  end);
end;
exports = {};
local_555.LuaUnit.run(local_554({'--pattern', '^Test_%.', local_554(arg)}));
return exports;
