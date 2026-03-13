local temper = require('temper-core');
local safeIdentifier, TableDef, FieldDef, StringField, IntField, FloatField, BoolField, changeset, from, SqlBuilder, col, SqlInt32, SqlString, local_739, local_740, csid__398, userTable__399, sid__400, exports;
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
local_739 = (unpack or table.unpack);
local_740 = require('luaunit');
local_740.FAILURE_PREFIX = temper.test_failure_prefix;
Test_ = {};
csid__398 = function(name__543)
  local return__256, t_130, local_131, local_132, local_133;
  local_131, local_132, local_133 = temper.pcall(function()
    t_130 = safeIdentifier(name__543);
    return__256 = t_130;
  end);
  if local_131 then
  else
    return__256 = temper.bubble();
  end
  return return__256;
end;
userTable__399 = function()
  return TableDef(csid__398('users'), temper.listof(FieldDef(csid__398('name'), StringField(), false), FieldDef(csid__398('email'), StringField(), false), FieldDef(csid__398('age'), IntField(), true), FieldDef(csid__398('score'), FloatField(), true), FieldDef(csid__398('active'), BoolField(), true)));
end;
Test_.test_castWhitelistsAllowedFields__1178 = function()
  temper.test('cast whitelists allowed fields', function(test_135)
    local params__547, t_136, t_137, t_138, cs__548, t_139, fn__6941, t_140, fn__6940, t_141, fn__6939, t_142, fn__6938;
    params__547 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com'), temper.pair_constructor('admin', 'true')));
    t_136 = userTable__399();
    t_137 = csid__398('name');
    t_138 = csid__398('email');
    cs__548 = changeset(t_136, params__547):cast(temper.listof(t_137, t_138));
    t_139 = temper.mapped_has(cs__548.changes, 'name');
    fn__6941 = function()
      return 'name should be in changes';
    end;
    temper.test_assert(test_135, t_139, fn__6941);
    t_140 = temper.mapped_has(cs__548.changes, 'email');
    fn__6940 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_135, t_140, fn__6940);
    t_141 = not temper.mapped_has(cs__548.changes, 'admin');
    fn__6939 = function()
      return 'admin must be dropped (not in whitelist)';
    end;
    temper.test_assert(test_135, t_141, fn__6939);
    t_142 = cs__548.isValid;
    fn__6938 = function()
      return 'should still be valid';
    end;
    temper.test_assert(test_135, t_142, fn__6938);
    return nil;
  end);
end;
Test_.test_castIsReplacingNotAdditiveSecondCallResetsWhitelist__1179 = function()
  temper.test('cast is replacing not additive \xe2\x80\x94 second call resets whitelist', function(test_143)
    local params__550, t_144, t_145, cs__551, t_146, fn__6920, t_147, fn__6919;
    params__550 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'alice@example.com')));
    t_144 = userTable__399();
    t_145 = csid__398('name');
    cs__551 = changeset(t_144, params__550):cast(temper.listof(t_145)):cast(temper.listof(csid__398('email')));
    t_146 = not temper.mapped_has(cs__551.changes, 'name');
    fn__6920 = function()
      return 'name must be excluded by second cast';
    end;
    temper.test_assert(test_143, t_146, fn__6920);
    t_147 = temper.mapped_has(cs__551.changes, 'email');
    fn__6919 = function()
      return 'email should be present';
    end;
    temper.test_assert(test_143, t_147, fn__6919);
    return nil;
  end);
end;
Test_.test_castIgnoresEmptyStringValues__1180 = function()
  temper.test('cast ignores empty string values', function(test_148)
    local params__553, t_149, t_150, t_151, cs__554, t_152, fn__6902, t_153, fn__6901;
    params__553 = temper.map_constructor(temper.listof(temper.pair_constructor('name', ''), temper.pair_constructor('email', 'bob@example.com')));
    t_149 = userTable__399();
    t_150 = csid__398('name');
    t_151 = csid__398('email');
    cs__554 = changeset(t_149, params__553):cast(temper.listof(t_150, t_151));
    t_152 = not temper.mapped_has(cs__554.changes, 'name');
    fn__6902 = function()
      return 'empty name should not be in changes';
    end;
    temper.test_assert(test_148, t_152, fn__6902);
    t_153 = temper.mapped_has(cs__554.changes, 'email');
    fn__6901 = function()
      return 'email should be in changes';
    end;
    temper.test_assert(test_148, t_153, fn__6901);
    return nil;
  end);
end;
Test_.test_validateRequiredPassesWhenFieldPresent__1181 = function()
  temper.test('validateRequired passes when field present', function(test_154)
    local params__556, t_155, t_156, cs__557, t_157, fn__6885, t_158, fn__6884;
    params__556 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_155 = userTable__399();
    t_156 = csid__398('name');
    cs__557 = changeset(t_155, params__556):cast(temper.listof(t_156)):validateRequired(temper.listof(csid__398('name')));
    t_157 = cs__557.isValid;
    fn__6885 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_154, t_157, fn__6885);
    t_158 = (temper.list_length(cs__557.errors) == 0);
    fn__6884 = function()
      return 'no errors expected';
    end;
    temper.test_assert(test_154, t_158, fn__6884);
    return nil;
  end);
end;
Test_.test_validateRequiredFailsWhenFieldMissing__1182 = function()
  temper.test('validateRequired fails when field missing', function(test_159)
    local params__559, t_160, t_161, cs__560, t_162, fn__6862, t_163, fn__6861, t_164, fn__6860;
    params__559 = temper.map_constructor(temper.listof());
    t_160 = userTable__399();
    t_161 = csid__398('name');
    cs__560 = changeset(t_160, params__559):cast(temper.listof(t_161)):validateRequired(temper.listof(csid__398('name')));
    t_162 = not cs__560.isValid;
    fn__6862 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_159, t_162, fn__6862);
    t_163 = (temper.list_length(cs__560.errors) == 1);
    fn__6861 = function()
      return 'should have one error';
    end;
    temper.test_assert(test_159, t_163, fn__6861);
    t_164 = temper.str_eq((temper.list_get(cs__560.errors, 0)).field, 'name');
    fn__6860 = function()
      return 'error should name the field';
    end;
    temper.test_assert(test_159, t_164, fn__6860);
    return nil;
  end);
end;
Test_.test_validateLengthPassesWithinRange__1183 = function()
  temper.test('validateLength passes within range', function(test_165)
    local params__562, t_166, t_167, cs__563, t_168, fn__6849;
    params__562 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice')));
    t_166 = userTable__399();
    t_167 = csid__398('name');
    cs__563 = changeset(t_166, params__562):cast(temper.listof(t_167)):validateLength(csid__398('name'), 2, 50);
    t_168 = cs__563.isValid;
    fn__6849 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_165, t_168, fn__6849);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooShort__1184 = function()
  temper.test('validateLength fails when too short', function(test_169)
    local params__565, t_170, t_171, cs__566, t_172, fn__6837;
    params__565 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'A')));
    t_170 = userTable__399();
    t_171 = csid__398('name');
    cs__566 = changeset(t_170, params__565):cast(temper.listof(t_171)):validateLength(csid__398('name'), 2, 50);
    t_172 = not cs__566.isValid;
    fn__6837 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_169, t_172, fn__6837);
    return nil;
  end);
end;
Test_.test_validateLengthFailsWhenTooLong__1185 = function()
  temper.test('validateLength fails when too long', function(test_173)
    local params__568, t_174, t_175, cs__569, t_176, fn__6825;
    params__568 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')));
    t_174 = userTable__399();
    t_175 = csid__398('name');
    cs__569 = changeset(t_174, params__568):cast(temper.listof(t_175)):validateLength(csid__398('name'), 2, 10);
    t_176 = not cs__569.isValid;
    fn__6825 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_173, t_176, fn__6825);
    return nil;
  end);
end;
Test_.test_validateIntPassesForValidInteger__1186 = function()
  temper.test('validateInt passes for valid integer', function(test_177)
    local params__571, t_178, t_179, cs__572, t_180, fn__6814;
    params__571 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '30')));
    t_178 = userTable__399();
    t_179 = csid__398('age');
    cs__572 = changeset(t_178, params__571):cast(temper.listof(t_179)):validateInt(csid__398('age'));
    t_180 = cs__572.isValid;
    fn__6814 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_177, t_180, fn__6814);
    return nil;
  end);
end;
Test_.test_validateIntFailsForNonInteger__1187 = function()
  temper.test('validateInt fails for non-integer', function(test_181)
    local params__574, t_182, t_183, cs__575, t_184, fn__6802;
    params__574 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_182 = userTable__399();
    t_183 = csid__398('age');
    cs__575 = changeset(t_182, params__574):cast(temper.listof(t_183)):validateInt(csid__398('age'));
    t_184 = not cs__575.isValid;
    fn__6802 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_181, t_184, fn__6802);
    return nil;
  end);
end;
Test_.test_validateFloatPassesForValidFloat__1188 = function()
  temper.test('validateFloat passes for valid float', function(test_185)
    local params__577, t_186, t_187, cs__578, t_188, fn__6791;
    params__577 = temper.map_constructor(temper.listof(temper.pair_constructor('score', '9.5')));
    t_186 = userTable__399();
    t_187 = csid__398('score');
    cs__578 = changeset(t_186, params__577):cast(temper.listof(t_187)):validateFloat(csid__398('score'));
    t_188 = cs__578.isValid;
    fn__6791 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_185, t_188, fn__6791);
    return nil;
  end);
end;
Test_.test_validateInt64_passesForValid64_bitInteger__1189 = function()
  temper.test('validateInt64 passes for valid 64-bit integer', function(test_189)
    local params__580, t_190, t_191, cs__581, t_192, fn__6780;
    params__580 = temper.map_constructor(temper.listof(temper.pair_constructor('age', '9999999999')));
    t_190 = userTable__399();
    t_191 = csid__398('age');
    cs__581 = changeset(t_190, params__580):cast(temper.listof(t_191)):validateInt64(csid__398('age'));
    t_192 = cs__581.isValid;
    fn__6780 = function()
      return 'should be valid';
    end;
    temper.test_assert(test_189, t_192, fn__6780);
    return nil;
  end);
end;
Test_.test_validateInt64_failsForNonInteger__1190 = function()
  temper.test('validateInt64 fails for non-integer', function(test_193)
    local params__583, t_194, t_195, cs__584, t_196, fn__6768;
    params__583 = temper.map_constructor(temper.listof(temper.pair_constructor('age', 'not-a-number')));
    t_194 = userTable__399();
    t_195 = csid__398('age');
    cs__584 = changeset(t_194, params__583):cast(temper.listof(t_195)):validateInt64(csid__398('age'));
    t_196 = not cs__584.isValid;
    fn__6768 = function()
      return 'should be invalid';
    end;
    temper.test_assert(test_193, t_196, fn__6768);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsTrue1_yesOn__1191 = function()
  temper.test('validateBool accepts true/1/yes/on', function(test_197)
    local fn__6765;
    fn__6765 = function(v__586)
      local params__587, t_198, t_199, cs__588, t_200, fn__6754;
      params__587 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__586)));
      t_198 = userTable__399();
      t_199 = csid__398('active');
      cs__588 = changeset(t_198, params__587):cast(temper.listof(t_199)):validateBool(csid__398('active'));
      t_200 = cs__588.isValid;
      fn__6754 = function()
        return temper.concat('should accept: ', v__586);
      end;
      temper.test_assert(test_197, t_200, fn__6754);
      return nil;
    end;
    temper.list_foreach(temper.listof('true', '1', 'yes', 'on'), fn__6765);
    return nil;
  end);
end;
Test_.test_validateBoolAcceptsFalse0_noOff__1192 = function()
  temper.test('validateBool accepts false/0/no/off', function(test_201)
    local fn__6751;
    fn__6751 = function(v__590)
      local params__591, t_202, t_203, cs__592, t_204, fn__6740;
      params__591 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__590)));
      t_202 = userTable__399();
      t_203 = csid__398('active');
      cs__592 = changeset(t_202, params__591):cast(temper.listof(t_203)):validateBool(csid__398('active'));
      t_204 = cs__592.isValid;
      fn__6740 = function()
        return temper.concat('should accept: ', v__590);
      end;
      temper.test_assert(test_201, t_204, fn__6740);
      return nil;
    end;
    temper.list_foreach(temper.listof('false', '0', 'no', 'off'), fn__6751);
    return nil;
  end);
end;
Test_.test_validateBoolRejectsAmbiguousValues__1193 = function()
  temper.test('validateBool rejects ambiguous values', function(test_205)
    local fn__6737;
    fn__6737 = function(v__594)
      local params__595, t_206, t_207, cs__596, t_208, fn__6725;
      params__595 = temper.map_constructor(temper.listof(temper.pair_constructor('active', v__594)));
      t_206 = userTable__399();
      t_207 = csid__398('active');
      cs__596 = changeset(t_206, params__595):cast(temper.listof(t_207)):validateBool(csid__398('active'));
      t_208 = not cs__596.isValid;
      fn__6725 = function()
        return temper.concat('should reject ambiguous: ', v__594);
      end;
      temper.test_assert(test_205, t_208, fn__6725);
      return nil;
    end;
    temper.list_foreach(temper.listof('TRUE', 'Yes', 'maybe', '2', 'enabled'), fn__6737);
    return nil;
  end);
end;
Test_.test_toInsertSqlEscapesBobbyTables__1194 = function()
  temper.test('toInsertSql escapes Bobby Tables', function(test_209)
    local t_210, params__598, t_211, t_212, t_213, cs__599, sqlFrag__600, local_214, local_215, local_216, s__601, t_218, fn__6709;
    params__598 = temper.map_constructor(temper.listof(temper.pair_constructor('name', "Robert'); DROP TABLE users;--"), temper.pair_constructor('email', 'bobby@evil.com')));
    t_211 = userTable__399();
    t_212 = csid__398('name');
    t_213 = csid__398('email');
    cs__599 = changeset(t_211, params__598):cast(temper.listof(t_212, t_213)):validateRequired(temper.listof(csid__398('name'), csid__398('email')));
    local_214, local_215, local_216 = temper.pcall(function()
      t_210 = cs__599:toInsertSql();
      sqlFrag__600 = t_210;
    end);
    if local_214 then
    else
      sqlFrag__600 = temper.bubble();
    end
    s__601 = sqlFrag__600:toString();
    t_218 = temper.is_string_index(temper.string_indexof(s__601, "''"));
    fn__6709 = function()
      return temper.concat('single quote must be doubled: ', s__601);
    end;
    temper.test_assert(test_209, t_218, fn__6709);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForStringField__1195 = function()
  temper.test('toInsertSql produces correct SQL for string field', function(test_219)
    local t_220, params__603, t_221, t_222, t_223, cs__604, sqlFrag__605, local_224, local_225, local_226, s__606, t_228, fn__6689, t_229, fn__6688;
    params__603 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Alice'), temper.pair_constructor('email', 'a@example.com')));
    t_221 = userTable__399();
    t_222 = csid__398('name');
    t_223 = csid__398('email');
    cs__604 = changeset(t_221, params__603):cast(temper.listof(t_222, t_223)):validateRequired(temper.listof(csid__398('name'), csid__398('email')));
    local_224, local_225, local_226 = temper.pcall(function()
      t_220 = cs__604:toInsertSql();
      sqlFrag__605 = t_220;
    end);
    if local_224 then
    else
      sqlFrag__605 = temper.bubble();
    end
    s__606 = sqlFrag__605:toString();
    t_228 = temper.is_string_index(temper.string_indexof(s__606, 'INSERT INTO users'));
    fn__6689 = function()
      return temper.concat('has INSERT INTO: ', s__606);
    end;
    temper.test_assert(test_219, t_228, fn__6689);
    t_229 = temper.is_string_index(temper.string_indexof(s__606, "'Alice'"));
    fn__6688 = function()
      return temper.concat('has quoted name: ', s__606);
    end;
    temper.test_assert(test_219, t_229, fn__6688);
    return nil;
  end);
end;
Test_.test_toInsertSqlProducesCorrectSqlForIntField__1196 = function()
  temper.test('toInsertSql produces correct SQL for int field', function(test_230)
    local t_231, params__608, t_232, t_233, t_234, t_235, cs__609, sqlFrag__610, local_236, local_237, local_238, s__611, t_240, fn__6670;
    params__608 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob'), temper.pair_constructor('email', 'b@example.com'), temper.pair_constructor('age', '25')));
    t_232 = userTable__399();
    t_233 = csid__398('name');
    t_234 = csid__398('email');
    t_235 = csid__398('age');
    cs__609 = changeset(t_232, params__608):cast(temper.listof(t_233, t_234, t_235)):validateRequired(temper.listof(csid__398('name'), csid__398('email')));
    local_236, local_237, local_238 = temper.pcall(function()
      t_231 = cs__609:toInsertSql();
      sqlFrag__610 = t_231;
    end);
    if local_236 then
    else
      sqlFrag__610 = temper.bubble();
    end
    s__611 = sqlFrag__610:toString();
    t_240 = temper.is_string_index(temper.string_indexof(s__611, '25'));
    fn__6670 = function()
      return temper.concat('age rendered unquoted: ', s__611);
    end;
    temper.test_assert(test_230, t_240, fn__6670);
    return nil;
  end);
end;
Test_.test_toInsertSqlBubblesOnInvalidChangeset__1197 = function()
  temper.test('toInsertSql bubbles on invalid changeset', function(test_241)
    local params__613, t_242, t_243, cs__614, didBubble__615, local_244, local_245, local_246, fn__6661;
    params__613 = temper.map_constructor(temper.listof());
    t_242 = userTable__399();
    t_243 = csid__398('name');
    cs__614 = changeset(t_242, params__613):cast(temper.listof(t_243)):validateRequired(temper.listof(csid__398('name')));
    local_244, local_245, local_246 = temper.pcall(function()
      cs__614:toInsertSql();
      didBubble__615 = false;
    end);
    if local_244 then
    else
      didBubble__615 = true;
    end
    fn__6661 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_241, didBubble__615, fn__6661);
    return nil;
  end);
end;
Test_.test_toInsertSqlEnforcesNonNullableFieldsIndependentlyOfIsValid__1198 = function()
  temper.test('toInsertSql enforces non-nullable fields independently of isValid', function(test_248)
    local strictTable__617, params__618, t_249, cs__619, t_250, fn__6643, didBubble__620, local_251, local_252, local_253, fn__6642;
    strictTable__617 = TableDef(csid__398('posts'), temper.listof(FieldDef(csid__398('title'), StringField(), false), FieldDef(csid__398('body'), StringField(), true)));
    params__618 = temper.map_constructor(temper.listof(temper.pair_constructor('body', 'hello')));
    t_249 = csid__398('body');
    cs__619 = changeset(strictTable__617, params__618):cast(temper.listof(t_249));
    t_250 = cs__619.isValid;
    fn__6643 = function()
      return 'changeset should appear valid (no explicit validation run)';
    end;
    temper.test_assert(test_248, t_250, fn__6643);
    local_251, local_252, local_253 = temper.pcall(function()
      cs__619:toInsertSql();
      didBubble__620 = false;
    end);
    if local_251 then
    else
      didBubble__620 = true;
    end
    fn__6642 = function()
      return 'toInsertSql should enforce nullable regardless of isValid';
    end;
    temper.test_assert(test_248, didBubble__620, fn__6642);
    return nil;
  end);
end;
Test_.test_toUpdateSqlProducesCorrectSql__1199 = function()
  temper.test('toUpdateSql produces correct SQL', function(test_255)
    local t_256, params__622, t_257, t_258, cs__623, sqlFrag__624, local_259, local_260, local_261, s__625, t_263, fn__6630;
    params__622 = temper.map_constructor(temper.listof(temper.pair_constructor('name', 'Bob')));
    t_257 = userTable__399();
    t_258 = csid__398('name');
    cs__623 = changeset(t_257, params__622):cast(temper.listof(t_258)):validateRequired(temper.listof(csid__398('name')));
    local_259, local_260, local_261 = temper.pcall(function()
      t_256 = cs__623:toUpdateSql(42);
      sqlFrag__624 = t_256;
    end);
    if local_259 then
    else
      sqlFrag__624 = temper.bubble();
    end
    s__625 = sqlFrag__624:toString();
    t_263 = temper.str_eq(s__625, "UPDATE users SET name = 'Bob' WHERE id = 42");
    fn__6630 = function()
      return temper.concat('got: ', s__625);
    end;
    temper.test_assert(test_255, t_263, fn__6630);
    return nil;
  end);
end;
Test_.test_toUpdateSqlBubblesOnInvalidChangeset__1200 = function()
  temper.test('toUpdateSql bubbles on invalid changeset', function(test_264)
    local params__627, t_265, t_266, cs__628, didBubble__629, local_267, local_268, local_269, fn__6621;
    params__627 = temper.map_constructor(temper.listof());
    t_265 = userTable__399();
    t_266 = csid__398('name');
    cs__628 = changeset(t_265, params__627):cast(temper.listof(t_266)):validateRequired(temper.listof(csid__398('name')));
    local_267, local_268, local_269 = temper.pcall(function()
      cs__628:toUpdateSql(1);
      didBubble__629 = false;
    end);
    if local_267 then
    else
      didBubble__629 = true;
    end
    fn__6621 = function()
      return 'invalid changeset should bubble';
    end;
    temper.test_assert(test_264, didBubble__629, fn__6621);
    return nil;
  end);
end;
sid__400 = function(name__791)
  local return__319, t_271, local_272, local_273, local_274;
  local_272, local_273, local_274 = temper.pcall(function()
    t_271 = safeIdentifier(name__791);
    return__319 = t_271;
  end);
  if local_272 then
  else
    return__319 = temper.bubble();
  end
  return return__319;
end;
Test_.test_bareFromProducesSelect__1237 = function()
  temper.test('bare from produces SELECT *', function(test_276)
    local q__794, t_277, fn__6439;
    q__794 = from(sid__400('users'));
    t_277 = temper.str_eq(q__794:toSql():toString(), 'SELECT * FROM users');
    fn__6439 = function()
      return 'bare query';
    end;
    temper.test_assert(test_276, t_277, fn__6439);
    return nil;
  end);
end;
Test_.test_selectRestrictsColumns__1238 = function()
  temper.test('select restricts columns', function(test_278)
    local t_279, t_280, t_281, q__796, t_282, fn__6429;
    t_279 = sid__400('users');
    t_280 = sid__400('id');
    t_281 = sid__400('name');
    q__796 = from(t_279):select(temper.listof(t_280, t_281));
    t_282 = temper.str_eq(q__796:toSql():toString(), 'SELECT id, name FROM users');
    fn__6429 = function()
      return 'select columns';
    end;
    temper.test_assert(test_278, t_282, fn__6429);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithIntValue__1239 = function()
  temper.test('where adds condition with int value', function(test_283)
    local t_284, t_285, t_286, q__798, t_287, fn__6417;
    t_284 = sid__400('users');
    t_285 = SqlBuilder();
    t_285:appendSafe('age > ');
    t_285:appendInt32(18);
    t_286 = t_285.accumulated;
    q__798 = from(t_284):where(t_286);
    t_287 = temper.str_eq(q__798:toSql():toString(), 'SELECT * FROM users WHERE age > 18');
    fn__6417 = function()
      return 'where int';
    end;
    temper.test_assert(test_283, t_287, fn__6417);
    return nil;
  end);
end;
Test_.test_whereAddsConditionWithBoolValue__1241 = function()
  temper.test('where adds condition with bool value', function(test_288)
    local t_289, t_290, t_291, q__800, t_292, fn__6405;
    t_289 = sid__400('users');
    t_290 = SqlBuilder();
    t_290:appendSafe('active = ');
    t_290:appendBoolean(true);
    t_291 = t_290.accumulated;
    q__800 = from(t_289):where(t_291);
    t_292 = temper.str_eq(q__800:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE');
    fn__6405 = function()
      return 'where bool';
    end;
    temper.test_assert(test_288, t_292, fn__6405);
    return nil;
  end);
end;
Test_.test_chainedWhereUsesAnd__1243 = function()
  temper.test('chained where uses AND', function(test_293)
    local t_294, t_295, t_296, t_297, t_298, q__802, t_299, fn__6388;
    t_294 = sid__400('users');
    t_295 = SqlBuilder();
    t_295:appendSafe('age > ');
    t_295:appendInt32(18);
    t_296 = t_295.accumulated;
    t_297 = from(t_294):where(t_296);
    t_298 = SqlBuilder();
    t_298:appendSafe('active = ');
    t_298:appendBoolean(true);
    q__802 = t_297:where(t_298.accumulated);
    t_299 = temper.str_eq(q__802:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE');
    fn__6388 = function()
      return 'chained where';
    end;
    temper.test_assert(test_293, t_299, fn__6388);
    return nil;
  end);
end;
Test_.test_orderByAsc__1246 = function()
  temper.test('orderBy ASC', function(test_300)
    local t_301, t_302, q__804, t_303, fn__6379;
    t_301 = sid__400('users');
    t_302 = sid__400('name');
    q__804 = from(t_301):orderBy(t_302, true);
    t_303 = temper.str_eq(q__804:toSql():toString(), 'SELECT * FROM users ORDER BY name ASC');
    fn__6379 = function()
      return 'order asc';
    end;
    temper.test_assert(test_300, t_303, fn__6379);
    return nil;
  end);
end;
Test_.test_orderByDesc__1247 = function()
  temper.test('orderBy DESC', function(test_304)
    local t_305, t_306, q__806, t_307, fn__6370;
    t_305 = sid__400('users');
    t_306 = sid__400('created_at');
    q__806 = from(t_305):orderBy(t_306, false);
    t_307 = temper.str_eq(q__806:toSql():toString(), 'SELECT * FROM users ORDER BY created_at DESC');
    fn__6370 = function()
      return 'order desc';
    end;
    temper.test_assert(test_304, t_307, fn__6370);
    return nil;
  end);
end;
Test_.test_limitAndOffset__1248 = function()
  temper.test('limit and offset', function(test_308)
    local t_309, t_310, q__808, local_311, local_312, local_313, t_315, fn__6363;
    local_311, local_312, local_313 = temper.pcall(function()
      t_309 = from(sid__400('users')):limit(10);
      t_310 = t_309:offset(20);
      q__808 = t_310;
    end);
    if local_311 then
    else
      q__808 = temper.bubble();
    end
    t_315 = temper.str_eq(q__808:toSql():toString(), 'SELECT * FROM users LIMIT 10 OFFSET 20');
    fn__6363 = function()
      return 'limit/offset';
    end;
    temper.test_assert(test_308, t_315, fn__6363);
    return nil;
  end);
end;
Test_.test_limitBubblesOnNegative__1249 = function()
  temper.test('limit bubbles on negative', function(test_316)
    local didBubble__810, local_317, local_318, local_319, fn__6359;
    local_317, local_318, local_319 = temper.pcall(function()
      from(sid__400('users')):limit(-1);
      didBubble__810 = false;
    end);
    if local_317 then
    else
      didBubble__810 = true;
    end
    fn__6359 = function()
      return 'negative limit should bubble';
    end;
    temper.test_assert(test_316, didBubble__810, fn__6359);
    return nil;
  end);
end;
Test_.test_offsetBubblesOnNegative__1250 = function()
  temper.test('offset bubbles on negative', function(test_321)
    local didBubble__812, local_322, local_323, local_324, fn__6355;
    local_322, local_323, local_324 = temper.pcall(function()
      from(sid__400('users')):offset(-1);
      didBubble__812 = false;
    end);
    if local_322 then
    else
      didBubble__812 = true;
    end
    fn__6355 = function()
      return 'negative offset should bubble';
    end;
    temper.test_assert(test_321, didBubble__812, fn__6355);
    return nil;
  end);
end;
Test_.test_complexComposedQuery__1251 = function()
  temper.test('complex composed query', function(test_326)
    local t_327, t_328, t_329, t_330, t_331, t_332, t_333, t_334, t_335, t_336, minAge__814, q__815, local_337, local_338, local_339, t_341, fn__6332;
    minAge__814 = 21;
    local_337, local_338, local_339 = temper.pcall(function()
      t_327 = sid__400('users');
      t_328 = sid__400('id');
      t_329 = sid__400('name');
      t_330 = sid__400('email');
      t_331 = from(t_327):select(temper.listof(t_328, t_329, t_330));
      t_332 = SqlBuilder();
      t_332:appendSafe('age >= ');
      t_332:appendInt32(21);
      t_333 = t_331:where(t_332.accumulated);
      t_334 = SqlBuilder();
      t_334:appendSafe('active = ');
      t_334:appendBoolean(true);
      t_335 = t_333:where(t_334.accumulated):orderBy(sid__400('name'), true):limit(25);
      t_336 = t_335:offset(0);
      q__815 = t_336;
    end);
    if local_337 then
    else
      q__815 = temper.bubble();
    end
    t_341 = temper.str_eq(q__815:toSql():toString(), 'SELECT id, name, email FROM users WHERE age >= 21 AND active = TRUE ORDER BY name ASC LIMIT 25 OFFSET 0');
    fn__6332 = function()
      return 'complex query';
    end;
    temper.test_assert(test_326, t_341, fn__6332);
    return nil;
  end);
end;
Test_.test_safeToSqlAppliesDefaultLimitWhenNoneSet__1254 = function()
  temper.test('safeToSql applies default limit when none set', function(test_342)
    local t_343, t_344, q__817, local_345, local_346, local_347, s__818, t_349, fn__6326;
    q__817 = from(sid__400('users'));
    local_345, local_346, local_347 = temper.pcall(function()
      t_343 = q__817:safeToSql(100);
      t_344 = t_343;
    end);
    if local_345 then
    else
      t_344 = temper.bubble();
    end
    s__818 = t_344:toString();
    t_349 = temper.str_eq(s__818, 'SELECT * FROM users LIMIT 100');
    fn__6326 = function()
      return temper.concat('should have limit: ', s__818);
    end;
    temper.test_assert(test_342, t_349, fn__6326);
    return nil;
  end);
end;
Test_.test_safeToSqlRespectsExplicitLimit__1255 = function()
  temper.test('safeToSql respects explicit limit', function(test_350)
    local t_351, t_352, t_353, q__820, local_354, local_355, local_356, local_358, local_359, local_360, s__821, t_362, fn__6320;
    local_354, local_355, local_356 = temper.pcall(function()
      t_351 = from(sid__400('users')):limit(5);
      q__820 = t_351;
    end);
    if local_354 then
    else
      q__820 = temper.bubble();
    end
    local_358, local_359, local_360 = temper.pcall(function()
      t_352 = q__820:safeToSql(100);
      t_353 = t_352;
    end);
    if local_358 then
    else
      t_353 = temper.bubble();
    end
    s__821 = t_353:toString();
    t_362 = temper.str_eq(s__821, 'SELECT * FROM users LIMIT 5');
    fn__6320 = function()
      return temper.concat('explicit limit preserved: ', s__821);
    end;
    temper.test_assert(test_350, t_362, fn__6320);
    return nil;
  end);
end;
Test_.test_safeToSqlBubblesOnNegativeDefaultLimit__1256 = function()
  temper.test('safeToSql bubbles on negative defaultLimit', function(test_363)
    local didBubble__823, local_364, local_365, local_366, fn__6316;
    local_364, local_365, local_366 = temper.pcall(function()
      from(sid__400('users')):safeToSql(-1);
      didBubble__823 = false;
    end);
    if local_364 then
    else
      didBubble__823 = true;
    end
    fn__6316 = function()
      return 'negative defaultLimit should bubble';
    end;
    temper.test_assert(test_363, didBubble__823, fn__6316);
    return nil;
  end);
end;
Test_.test_whereWithInjectionAttemptInStringValueIsEscaped__1257 = function()
  temper.test('where with injection attempt in string value is escaped', function(test_368)
    local evil__825, t_369, t_370, t_371, q__826, s__827, t_372, fn__6299, t_373, fn__6298;
    evil__825 = "'; DROP TABLE users; --";
    t_369 = sid__400('users');
    t_370 = SqlBuilder();
    t_370:appendSafe('name = ');
    t_370:appendString("'; DROP TABLE users; --");
    t_371 = t_370.accumulated;
    q__826 = from(t_369):where(t_371);
    s__827 = q__826:toSql():toString();
    t_372 = temper.is_string_index(temper.string_indexof(s__827, "''"));
    fn__6299 = function()
      return temper.concat('quotes must be doubled: ', s__827);
    end;
    temper.test_assert(test_368, t_372, fn__6299);
    t_373 = temper.is_string_index(temper.string_indexof(s__827, 'SELECT * FROM users WHERE name ='));
    fn__6298 = function()
      return temper.concat('structure intact: ', s__827);
    end;
    temper.test_assert(test_368, t_373, fn__6298);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsUserSuppliedTableNameWithMetacharacters__1259 = function()
  temper.test('safeIdentifier rejects user-supplied table name with metacharacters', function(test_374)
    local attack__829, didBubble__830, local_375, local_376, local_377, fn__6295;
    attack__829 = 'users; DROP TABLE users; --';
    local_375, local_376, local_377 = temper.pcall(function()
      safeIdentifier('users; DROP TABLE users; --');
      didBubble__830 = false;
    end);
    if local_375 then
    else
      didBubble__830 = true;
    end
    fn__6295 = function()
      return 'metacharacter-containing name must be rejected at construction';
    end;
    temper.test_assert(test_374, didBubble__830, fn__6295);
    return nil;
  end);
end;
Test_.test_innerJoinProducesInnerJoin__1260 = function()
  temper.test('innerJoin produces INNER JOIN', function(test_379)
    local t_380, t_381, t_382, t_383, q__832, t_384, fn__6283;
    t_380 = sid__400('users');
    t_381 = sid__400('orders');
    t_382 = SqlBuilder();
    t_382:appendSafe('users.id = orders.user_id');
    t_383 = t_382.accumulated;
    q__832 = from(t_380):innerJoin(t_381, t_383);
    t_384 = temper.str_eq(q__832:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id');
    fn__6283 = function()
      return 'inner join';
    end;
    temper.test_assert(test_379, t_384, fn__6283);
    return nil;
  end);
end;
Test_.test_leftJoinProducesLeftJoin__1262 = function()
  temper.test('leftJoin produces LEFT JOIN', function(test_385)
    local t_386, t_387, t_388, t_389, q__834, t_390, fn__6271;
    t_386 = sid__400('users');
    t_387 = sid__400('profiles');
    t_388 = SqlBuilder();
    t_388:appendSafe('users.id = profiles.user_id');
    t_389 = t_388.accumulated;
    q__834 = from(t_386):leftJoin(t_387, t_389);
    t_390 = temper.str_eq(q__834:toSql():toString(), 'SELECT * FROM users LEFT JOIN profiles ON users.id = profiles.user_id');
    fn__6271 = function()
      return 'left join';
    end;
    temper.test_assert(test_385, t_390, fn__6271);
    return nil;
  end);
end;
Test_.test_rightJoinProducesRightJoin__1264 = function()
  temper.test('rightJoin produces RIGHT JOIN', function(test_391)
    local t_392, t_393, t_394, t_395, q__836, t_396, fn__6259;
    t_392 = sid__400('orders');
    t_393 = sid__400('users');
    t_394 = SqlBuilder();
    t_394:appendSafe('orders.user_id = users.id');
    t_395 = t_394.accumulated;
    q__836 = from(t_392):rightJoin(t_393, t_395);
    t_396 = temper.str_eq(q__836:toSql():toString(), 'SELECT * FROM orders RIGHT JOIN users ON orders.user_id = users.id');
    fn__6259 = function()
      return 'right join';
    end;
    temper.test_assert(test_391, t_396, fn__6259);
    return nil;
  end);
end;
Test_.test_fullJoinProducesFullOuterJoin__1266 = function()
  temper.test('fullJoin produces FULL OUTER JOIN', function(test_397)
    local t_398, t_399, t_400, t_401, q__838, t_402, fn__6247;
    t_398 = sid__400('users');
    t_399 = sid__400('orders');
    t_400 = SqlBuilder();
    t_400:appendSafe('users.id = orders.user_id');
    t_401 = t_400.accumulated;
    q__838 = from(t_398):fullJoin(t_399, t_401);
    t_402 = temper.str_eq(q__838:toSql():toString(), 'SELECT * FROM users FULL OUTER JOIN orders ON users.id = orders.user_id');
    fn__6247 = function()
      return 'full join';
    end;
    temper.test_assert(test_397, t_402, fn__6247);
    return nil;
  end);
end;
Test_.test_chainedJoins__1268 = function()
  temper.test('chained joins', function(test_403)
    local t_404, t_405, t_406, t_407, t_408, t_409, t_410, q__840, t_411, fn__6230;
    t_404 = sid__400('users');
    t_405 = sid__400('orders');
    t_406 = SqlBuilder();
    t_406:appendSafe('users.id = orders.user_id');
    t_407 = t_406.accumulated;
    t_408 = from(t_404):innerJoin(t_405, t_407);
    t_409 = sid__400('profiles');
    t_410 = SqlBuilder();
    t_410:appendSafe('users.id = profiles.user_id');
    q__840 = t_408:leftJoin(t_409, t_410.accumulated);
    t_411 = temper.str_eq(q__840:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id LEFT JOIN profiles ON users.id = profiles.user_id');
    fn__6230 = function()
      return 'chained joins';
    end;
    temper.test_assert(test_403, t_411, fn__6230);
    return nil;
  end);
end;
Test_.test_joinWithWhereAndOrderBy__1271 = function()
  temper.test('join with where and orderBy', function(test_412)
    local t_413, t_414, t_415, t_416, t_417, t_418, t_419, q__842, local_420, local_421, local_422, t_424, fn__6211;
    local_420, local_421, local_422 = temper.pcall(function()
      t_413 = sid__400('users');
      t_414 = sid__400('orders');
      t_415 = SqlBuilder();
      t_415:appendSafe('users.id = orders.user_id');
      t_416 = t_415.accumulated;
      t_417 = from(t_413):innerJoin(t_414, t_416);
      t_418 = SqlBuilder();
      t_418:appendSafe('orders.total > ');
      t_418:appendInt32(100);
      t_419 = t_417:where(t_418.accumulated):orderBy(sid__400('name'), true):limit(10);
      q__842 = t_419;
    end);
    if local_420 then
    else
      q__842 = temper.bubble();
    end
    t_424 = temper.str_eq(q__842:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id WHERE orders.total > 100 ORDER BY name ASC LIMIT 10');
    fn__6211 = function()
      return 'join with where/order/limit';
    end;
    temper.test_assert(test_412, t_424, fn__6211);
    return nil;
  end);
end;
Test_.test_colHelperProducesQualifiedReference__1274 = function()
  temper.test('col helper produces qualified reference', function(test_425)
    local c__844, t_426, fn__6203;
    c__844 = col(sid__400('users'), sid__400('id'));
    t_426 = temper.str_eq(c__844:toString(), 'users.id');
    fn__6203 = function()
      return 'col helper';
    end;
    temper.test_assert(test_425, t_426, fn__6203);
    return nil;
  end);
end;
Test_.test_joinWithColHelper__1275 = function()
  temper.test('join with col helper', function(test_427)
    local onCond__846, b__847, t_428, t_429, t_430, q__848, t_431, fn__6183;
    onCond__846 = col(sid__400('users'), sid__400('id'));
    b__847 = SqlBuilder();
    b__847:appendFragment(onCond__846);
    b__847:appendSafe(' = ');
    b__847:appendFragment(col(sid__400('orders'), sid__400('user_id')));
    t_428 = sid__400('users');
    t_429 = sid__400('orders');
    t_430 = b__847.accumulated;
    q__848 = from(t_428):innerJoin(t_429, t_430);
    t_431 = temper.str_eq(q__848:toSql():toString(), 'SELECT * FROM users INNER JOIN orders ON users.id = orders.user_id');
    fn__6183 = function()
      return 'join with col';
    end;
    temper.test_assert(test_427, t_431, fn__6183);
    return nil;
  end);
end;
Test_.test_orWhereBasic__1276 = function()
  temper.test('orWhere basic', function(test_432)
    local t_433, t_434, t_435, q__850, t_436, fn__6171;
    t_433 = sid__400('users');
    t_434 = SqlBuilder();
    t_434:appendSafe('status = ');
    t_434:appendString('active');
    t_435 = t_434.accumulated;
    q__850 = from(t_433):orWhere(t_435);
    t_436 = temper.str_eq(q__850:toSql():toString(), "SELECT * FROM users WHERE status = 'active'");
    fn__6171 = function()
      return 'orWhere basic';
    end;
    temper.test_assert(test_432, t_436, fn__6171);
    return nil;
  end);
end;
Test_.test_whereThenOrWhere__1278 = function()
  temper.test('where then orWhere', function(test_437)
    local t_438, t_439, t_440, t_441, t_442, q__852, t_443, fn__6154;
    t_438 = sid__400('users');
    t_439 = SqlBuilder();
    t_439:appendSafe('age > ');
    t_439:appendInt32(18);
    t_440 = t_439.accumulated;
    t_441 = from(t_438):where(t_440);
    t_442 = SqlBuilder();
    t_442:appendSafe('vip = ');
    t_442:appendBoolean(true);
    q__852 = t_441:orWhere(t_442.accumulated);
    t_443 = temper.str_eq(q__852:toSql():toString(), 'SELECT * FROM users WHERE age > 18 OR vip = TRUE');
    fn__6154 = function()
      return 'where then orWhere';
    end;
    temper.test_assert(test_437, t_443, fn__6154);
    return nil;
  end);
end;
Test_.test_multipleOrWhere__1281 = function()
  temper.test('multiple orWhere', function(test_444)
    local t_445, t_446, t_447, t_448, t_449, t_450, t_451, q__854, t_452, fn__6132;
    t_445 = sid__400('users');
    t_446 = SqlBuilder();
    t_446:appendSafe('active = ');
    t_446:appendBoolean(true);
    t_447 = t_446.accumulated;
    t_448 = from(t_445):where(t_447);
    t_449 = SqlBuilder();
    t_449:appendSafe('role = ');
    t_449:appendString('admin');
    t_450 = t_448:orWhere(t_449.accumulated);
    t_451 = SqlBuilder();
    t_451:appendSafe('role = ');
    t_451:appendString('moderator');
    q__854 = t_450:orWhere(t_451.accumulated);
    t_452 = temper.str_eq(q__854:toSql():toString(), "SELECT * FROM users WHERE active = TRUE OR role = 'admin' OR role = 'moderator'");
    fn__6132 = function()
      return 'multiple orWhere';
    end;
    temper.test_assert(test_444, t_452, fn__6132);
    return nil;
  end);
end;
Test_.test_mixedWhereAndOrWhere__1285 = function()
  temper.test('mixed where and orWhere', function(test_453)
    local t_454, t_455, t_456, t_457, t_458, t_459, t_460, q__856, t_461, fn__6110;
    t_454 = sid__400('users');
    t_455 = SqlBuilder();
    t_455:appendSafe('age > ');
    t_455:appendInt32(18);
    t_456 = t_455.accumulated;
    t_457 = from(t_454):where(t_456);
    t_458 = SqlBuilder();
    t_458:appendSafe('active = ');
    t_458:appendBoolean(true);
    t_459 = t_457:where(t_458.accumulated);
    t_460 = SqlBuilder();
    t_460:appendSafe('vip = ');
    t_460:appendBoolean(true);
    q__856 = t_459:orWhere(t_460.accumulated);
    t_461 = temper.str_eq(q__856:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND active = TRUE OR vip = TRUE');
    fn__6110 = function()
      return 'mixed where and orWhere';
    end;
    temper.test_assert(test_453, t_461, fn__6110);
    return nil;
  end);
end;
Test_.test_whereNull__1289 = function()
  temper.test('whereNull', function(test_462)
    local t_463, t_464, q__858, t_465, fn__6101;
    t_463 = sid__400('users');
    t_464 = sid__400('deleted_at');
    q__858 = from(t_463):whereNull(t_464);
    t_465 = temper.str_eq(q__858:toSql():toString(), 'SELECT * FROM users WHERE deleted_at IS NULL');
    fn__6101 = function()
      return 'whereNull';
    end;
    temper.test_assert(test_462, t_465, fn__6101);
    return nil;
  end);
end;
Test_.test_whereNotNull__1290 = function()
  temper.test('whereNotNull', function(test_466)
    local t_467, t_468, q__860, t_469, fn__6092;
    t_467 = sid__400('users');
    t_468 = sid__400('email');
    q__860 = from(t_467):whereNotNull(t_468);
    t_469 = temper.str_eq(q__860:toSql():toString(), 'SELECT * FROM users WHERE email IS NOT NULL');
    fn__6092 = function()
      return 'whereNotNull';
    end;
    temper.test_assert(test_466, t_469, fn__6092);
    return nil;
  end);
end;
Test_.test_whereNullChainedWithWhere__1291 = function()
  temper.test('whereNull chained with where', function(test_470)
    local t_471, t_472, t_473, q__862, t_474, fn__6078;
    t_471 = sid__400('users');
    t_472 = SqlBuilder();
    t_472:appendSafe('active = ');
    t_472:appendBoolean(true);
    t_473 = t_472.accumulated;
    q__862 = from(t_471):where(t_473):whereNull(sid__400('deleted_at'));
    t_474 = temper.str_eq(q__862:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE AND deleted_at IS NULL');
    fn__6078 = function()
      return 'whereNull chained';
    end;
    temper.test_assert(test_470, t_474, fn__6078);
    return nil;
  end);
end;
Test_.test_whereNotNullChainedWithOrWhere__1293 = function()
  temper.test('whereNotNull chained with orWhere', function(test_475)
    local t_476, t_477, t_478, t_479, q__864, t_480, fn__6064;
    t_476 = sid__400('users');
    t_477 = sid__400('deleted_at');
    t_478 = from(t_476):whereNull(t_477);
    t_479 = SqlBuilder();
    t_479:appendSafe('role = ');
    t_479:appendString('admin');
    q__864 = t_478:orWhere(t_479.accumulated);
    t_480 = temper.str_eq(q__864:toSql():toString(), "SELECT * FROM users WHERE deleted_at IS NULL OR role = 'admin'");
    fn__6064 = function()
      return 'whereNotNull with orWhere';
    end;
    temper.test_assert(test_475, t_480, fn__6064);
    return nil;
  end);
end;
Test_.test_whereInWithIntValues__1295 = function()
  temper.test('whereIn with int values', function(test_481)
    local t_482, t_483, t_484, t_485, t_486, q__866, t_487, fn__6052;
    t_482 = sid__400('users');
    t_483 = sid__400('id');
    t_484 = SqlInt32(1);
    t_485 = SqlInt32(2);
    t_486 = SqlInt32(3);
    q__866 = from(t_482):whereIn(t_483, temper.listof(t_484, t_485, t_486));
    t_487 = temper.str_eq(q__866:toSql():toString(), 'SELECT * FROM users WHERE id IN (1, 2, 3)');
    fn__6052 = function()
      return 'whereIn ints';
    end;
    temper.test_assert(test_481, t_487, fn__6052);
    return nil;
  end);
end;
Test_.test_whereInWithStringValuesEscaping__1296 = function()
  temper.test('whereIn with string values escaping', function(test_488)
    local t_489, t_490, t_491, t_492, q__868, t_493, fn__6041;
    t_489 = sid__400('users');
    t_490 = sid__400('name');
    t_491 = SqlString('Alice');
    t_492 = SqlString("Bob's");
    q__868 = from(t_489):whereIn(t_490, temper.listof(t_491, t_492));
    t_493 = temper.str_eq(q__868:toSql():toString(), "SELECT * FROM users WHERE name IN ('Alice', 'Bob''s')");
    fn__6041 = function()
      return 'whereIn strings';
    end;
    temper.test_assert(test_488, t_493, fn__6041);
    return nil;
  end);
end;
Test_.test_whereInWithEmptyListProduces1_0__1297 = function()
  temper.test('whereIn with empty list produces 1=0', function(test_494)
    local t_495, t_496, q__870, t_497, fn__6032;
    t_495 = sid__400('users');
    t_496 = sid__400('id');
    q__870 = from(t_495):whereIn(t_496, temper.listof());
    t_497 = temper.str_eq(q__870:toSql():toString(), 'SELECT * FROM users WHERE 1 = 0');
    fn__6032 = function()
      return 'whereIn empty';
    end;
    temper.test_assert(test_494, t_497, fn__6032);
    return nil;
  end);
end;
Test_.test_whereInChained__1298 = function()
  temper.test('whereIn chained', function(test_498)
    local t_499, t_500, t_501, q__872, t_502, fn__6016;
    t_499 = sid__400('users');
    t_500 = SqlBuilder();
    t_500:appendSafe('active = ');
    t_500:appendBoolean(true);
    t_501 = t_500.accumulated;
    q__872 = from(t_499):where(t_501):whereIn(sid__400('role'), temper.listof(SqlString('admin'), SqlString('user')));
    t_502 = temper.str_eq(q__872:toSql():toString(), "SELECT * FROM users WHERE active = TRUE AND role IN ('admin', 'user')");
    fn__6016 = function()
      return 'whereIn chained';
    end;
    temper.test_assert(test_498, t_502, fn__6016);
    return nil;
  end);
end;
Test_.test_whereInSingleElement__1300 = function()
  temper.test('whereIn single element', function(test_503)
    local t_504, t_505, t_506, q__874, t_507, fn__6006;
    t_504 = sid__400('users');
    t_505 = sid__400('id');
    t_506 = SqlInt32(42);
    q__874 = from(t_504):whereIn(t_505, temper.listof(t_506));
    t_507 = temper.str_eq(q__874:toSql():toString(), 'SELECT * FROM users WHERE id IN (42)');
    fn__6006 = function()
      return 'whereIn single';
    end;
    temper.test_assert(test_503, t_507, fn__6006);
    return nil;
  end);
end;
Test_.test_whereNotBasic__1301 = function()
  temper.test('whereNot basic', function(test_508)
    local t_509, t_510, t_511, q__876, t_512, fn__5994;
    t_509 = sid__400('users');
    t_510 = SqlBuilder();
    t_510:appendSafe('active = ');
    t_510:appendBoolean(true);
    t_511 = t_510.accumulated;
    q__876 = from(t_509):whereNot(t_511);
    t_512 = temper.str_eq(q__876:toSql():toString(), 'SELECT * FROM users WHERE NOT (active = TRUE)');
    fn__5994 = function()
      return 'whereNot';
    end;
    temper.test_assert(test_508, t_512, fn__5994);
    return nil;
  end);
end;
Test_.test_whereNotChained__1303 = function()
  temper.test('whereNot chained', function(test_513)
    local t_514, t_515, t_516, t_517, t_518, q__878, t_519, fn__5977;
    t_514 = sid__400('users');
    t_515 = SqlBuilder();
    t_515:appendSafe('age > ');
    t_515:appendInt32(18);
    t_516 = t_515.accumulated;
    t_517 = from(t_514):where(t_516);
    t_518 = SqlBuilder();
    t_518:appendSafe('banned = ');
    t_518:appendBoolean(true);
    q__878 = t_517:whereNot(t_518.accumulated);
    t_519 = temper.str_eq(q__878:toSql():toString(), 'SELECT * FROM users WHERE age > 18 AND NOT (banned = TRUE)');
    fn__5977 = function()
      return 'whereNot chained';
    end;
    temper.test_assert(test_513, t_519, fn__5977);
    return nil;
  end);
end;
Test_.test_whereBetweenIntegers__1306 = function()
  temper.test('whereBetween integers', function(test_520)
    local t_521, t_522, t_523, t_524, q__880, t_525, fn__5966;
    t_521 = sid__400('users');
    t_522 = sid__400('age');
    t_523 = SqlInt32(18);
    t_524 = SqlInt32(65);
    q__880 = from(t_521):whereBetween(t_522, t_523, t_524);
    t_525 = temper.str_eq(q__880:toSql():toString(), 'SELECT * FROM users WHERE age BETWEEN 18 AND 65');
    fn__5966 = function()
      return 'whereBetween ints';
    end;
    temper.test_assert(test_520, t_525, fn__5966);
    return nil;
  end);
end;
Test_.test_whereBetweenChained__1307 = function()
  temper.test('whereBetween chained', function(test_526)
    local t_527, t_528, t_529, q__882, t_530, fn__5950;
    t_527 = sid__400('users');
    t_528 = SqlBuilder();
    t_528:appendSafe('active = ');
    t_528:appendBoolean(true);
    t_529 = t_528.accumulated;
    q__882 = from(t_527):where(t_529):whereBetween(sid__400('age'), SqlInt32(21), SqlInt32(30));
    t_530 = temper.str_eq(q__882:toSql():toString(), 'SELECT * FROM users WHERE active = TRUE AND age BETWEEN 21 AND 30');
    fn__5950 = function()
      return 'whereBetween chained';
    end;
    temper.test_assert(test_526, t_530, fn__5950);
    return nil;
  end);
end;
Test_.test_whereLikeBasic__1309 = function()
  temper.test('whereLike basic', function(test_531)
    local t_532, t_533, q__884, t_534, fn__5941;
    t_532 = sid__400('users');
    t_533 = sid__400('name');
    q__884 = from(t_532):whereLike(t_533, 'John%');
    t_534 = temper.str_eq(q__884:toSql():toString(), "SELECT * FROM users WHERE name LIKE 'John%'");
    fn__5941 = function()
      return 'whereLike';
    end;
    temper.test_assert(test_531, t_534, fn__5941);
    return nil;
  end);
end;
Test_.test_whereIlikeBasic__1310 = function()
  temper.test('whereILike basic', function(test_535)
    local t_536, t_537, q__886, t_538, fn__5932;
    t_536 = sid__400('users');
    t_537 = sid__400('email');
    q__886 = from(t_536):whereILike(t_537, '%@gmail.com');
    t_538 = temper.str_eq(q__886:toSql():toString(), "SELECT * FROM users WHERE email ILIKE '%@gmail.com'");
    fn__5932 = function()
      return 'whereILike';
    end;
    temper.test_assert(test_535, t_538, fn__5932);
    return nil;
  end);
end;
Test_.test_whereLikeWithInjectionAttempt__1311 = function()
  temper.test('whereLike with injection attempt', function(test_539)
    local t_540, t_541, q__888, s__889, t_542, fn__5918, t_543, fn__5917;
    t_540 = sid__400('users');
    t_541 = sid__400('name');
    q__888 = from(t_540):whereLike(t_541, "'; DROP TABLE users; --");
    s__889 = q__888:toSql():toString();
    t_542 = temper.is_string_index(temper.string_indexof(s__889, "''"));
    fn__5918 = function()
      return temper.concat('like injection escaped: ', s__889);
    end;
    temper.test_assert(test_539, t_542, fn__5918);
    t_543 = temper.is_string_index(temper.string_indexof(s__889, 'LIKE'));
    fn__5917 = function()
      return temper.concat('like structure intact: ', s__889);
    end;
    temper.test_assert(test_539, t_543, fn__5917);
    return nil;
  end);
end;
Test_.test_whereLikeWildcardPatterns__1312 = function()
  temper.test('whereLike wildcard patterns', function(test_544)
    local t_545, t_546, q__891, t_547, fn__5908;
    t_545 = sid__400('users');
    t_546 = sid__400('name');
    q__891 = from(t_545):whereLike(t_546, '%son%');
    t_547 = temper.str_eq(q__891:toSql():toString(), "SELECT * FROM users WHERE name LIKE '%son%'");
    fn__5908 = function()
      return 'whereLike wildcard';
    end;
    temper.test_assert(test_544, t_547, fn__5908);
    return nil;
  end);
end;
Test_.test_safeIdentifierAcceptsValidNames__1313 = function()
  temper.test('safeIdentifier accepts valid names', function(test_548)
    local t_549, id__929, local_550, local_551, local_552, t_554, fn__5903;
    local_550, local_551, local_552 = temper.pcall(function()
      t_549 = safeIdentifier('user_name');
      id__929 = t_549;
    end);
    if local_550 then
    else
      id__929 = temper.bubble();
    end
    t_554 = temper.str_eq(id__929.sqlValue, 'user_name');
    fn__5903 = function()
      return 'value should round-trip';
    end;
    temper.test_assert(test_548, t_554, fn__5903);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsEmptyString__1314 = function()
  temper.test('safeIdentifier rejects empty string', function(test_555)
    local didBubble__931, local_556, local_557, local_558, fn__5900;
    local_556, local_557, local_558 = temper.pcall(function()
      safeIdentifier('');
      didBubble__931 = false;
    end);
    if local_556 then
    else
      didBubble__931 = true;
    end
    fn__5900 = function()
      return 'empty string should bubble';
    end;
    temper.test_assert(test_555, didBubble__931, fn__5900);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsLeadingDigit__1315 = function()
  temper.test('safeIdentifier rejects leading digit', function(test_560)
    local didBubble__933, local_561, local_562, local_563, fn__5897;
    local_561, local_562, local_563 = temper.pcall(function()
      safeIdentifier('1col');
      didBubble__933 = false;
    end);
    if local_561 then
    else
      didBubble__933 = true;
    end
    fn__5897 = function()
      return 'leading digit should bubble';
    end;
    temper.test_assert(test_560, didBubble__933, fn__5897);
    return nil;
  end);
end;
Test_.test_safeIdentifierRejectsSqlMetacharacters__1316 = function()
  temper.test('safeIdentifier rejects SQL metacharacters', function(test_565)
    local cases__935, fn__5894;
    cases__935 = temper.listof('name); DROP TABLE', "col'", 'a b', 'a-b', 'a.b', 'a;b');
    fn__5894 = function(c__936)
      local didBubble__937, local_566, local_567, local_568, fn__5891;
      local_566, local_567, local_568 = temper.pcall(function()
        safeIdentifier(c__936);
        didBubble__937 = false;
      end);
      if local_566 then
      else
        didBubble__937 = true;
      end
      fn__5891 = function()
        return temper.concat('should reject: ', c__936);
      end;
      temper.test_assert(test_565, didBubble__937, fn__5891);
      return nil;
    end;
    temper.list_foreach(cases__935, fn__5894);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupFound__1317 = function()
  temper.test('TableDef field lookup - found', function(test_570)
    local t_571, t_572, t_573, t_574, t_575, t_576, t_577, local_578, local_579, local_580, local_582, local_583, local_584, t_586, t_587, local_588, local_589, local_590, t_592, t_593, td__939, f__940, local_594, local_595, local_596, t_598, fn__5880;
    local_578, local_579, local_580 = temper.pcall(function()
      t_571 = safeIdentifier('users');
      t_572 = t_571;
    end);
    if local_578 then
    else
      t_572 = temper.bubble();
    end
    local_582, local_583, local_584 = temper.pcall(function()
      t_573 = safeIdentifier('name');
      t_574 = t_573;
    end);
    if local_582 then
    else
      t_574 = temper.bubble();
    end
    t_586 = StringField();
    t_587 = FieldDef(t_574, t_586, false);
    local_588, local_589, local_590 = temper.pcall(function()
      t_575 = safeIdentifier('age');
      t_576 = t_575;
    end);
    if local_588 then
    else
      t_576 = temper.bubble();
    end
    t_592 = IntField();
    t_593 = FieldDef(t_576, t_592, false);
    td__939 = TableDef(t_572, temper.listof(t_587, t_593));
    local_594, local_595, local_596 = temper.pcall(function()
      t_577 = td__939:field('age');
      f__940 = t_577;
    end);
    if local_594 then
    else
      f__940 = temper.bubble();
    end
    t_598 = temper.str_eq(f__940.name.sqlValue, 'age');
    fn__5880 = function()
      return 'should find age field';
    end;
    temper.test_assert(test_570, t_598, fn__5880);
    return nil;
  end);
end;
Test_.test_tableDefFieldLookupNotFoundBubbles__1318 = function()
  temper.test('TableDef field lookup - not found bubbles', function(test_599)
    local t_600, t_601, t_602, t_603, local_604, local_605, local_606, local_608, local_609, local_610, t_612, t_613, td__942, didBubble__943, local_614, local_615, local_616, fn__5874;
    local_604, local_605, local_606 = temper.pcall(function()
      t_600 = safeIdentifier('users');
      t_601 = t_600;
    end);
    if local_604 then
    else
      t_601 = temper.bubble();
    end
    local_608, local_609, local_610 = temper.pcall(function()
      t_602 = safeIdentifier('name');
      t_603 = t_602;
    end);
    if local_608 then
    else
      t_603 = temper.bubble();
    end
    t_612 = StringField();
    t_613 = FieldDef(t_603, t_612, false);
    td__942 = TableDef(t_601, temper.listof(t_613));
    local_614, local_615, local_616 = temper.pcall(function()
      td__942:field('nonexistent');
      didBubble__943 = false;
    end);
    if local_614 then
    else
      didBubble__943 = true;
    end
    fn__5874 = function()
      return 'unknown field should bubble';
    end;
    temper.test_assert(test_599, didBubble__943, fn__5874);
    return nil;
  end);
end;
Test_.test_fieldDefNullableFlag__1319 = function()
  temper.test('FieldDef nullable flag', function(test_618)
    local t_619, t_620, t_621, t_622, local_623, local_624, local_625, t_627, required__945, local_628, local_629, local_630, t_632, optional__946, t_633, fn__5862, t_634, fn__5861;
    local_623, local_624, local_625 = temper.pcall(function()
      t_619 = safeIdentifier('email');
      t_620 = t_619;
    end);
    if local_623 then
    else
      t_620 = temper.bubble();
    end
    t_627 = StringField();
    required__945 = FieldDef(t_620, t_627, false);
    local_628, local_629, local_630 = temper.pcall(function()
      t_621 = safeIdentifier('bio');
      t_622 = t_621;
    end);
    if local_628 then
    else
      t_622 = temper.bubble();
    end
    t_632 = StringField();
    optional__946 = FieldDef(t_622, t_632, true);
    t_633 = not required__945.nullable;
    fn__5862 = function()
      return 'required field should not be nullable';
    end;
    temper.test_assert(test_618, t_633, fn__5862);
    t_634 = optional__946.nullable;
    fn__5861 = function()
      return 'optional field should be nullable';
    end;
    temper.test_assert(test_618, t_634, fn__5861);
    return nil;
  end);
end;
Test_.test_stringEscaping__1320 = function()
  temper.test('string escaping', function(test_635)
    local build__1072, buildWrong__1073, actual_637, t_638, fn__5850, bobbyTables__1078, actual_639, t_640, fn__5849, fn__5848;
    build__1072 = function(name__1074)
      local t_636;
      t_636 = SqlBuilder();
      t_636:appendSafe('select * from hi where name = ');
      t_636:appendString(name__1074);
      return t_636.accumulated:toString();
    end;
    buildWrong__1073 = function(name__1076)
      return temper.concat("select * from hi where name = '", name__1076, "'");
    end;
    actual_637 = build__1072('world');
    t_638 = temper.str_eq(actual_637, "select * from hi where name = 'world'");
    fn__5850 = function()
      return temper.concat('expected build("world") == (', "select * from hi where name = 'world'", ') not (', actual_637, ')');
    end;
    temper.test_assert(test_635, t_638, fn__5850);
    bobbyTables__1078 = "Robert'); drop table hi;--";
    actual_639 = build__1072("Robert'); drop table hi;--");
    t_640 = temper.str_eq(actual_639, "select * from hi where name = 'Robert''); drop table hi;--'");
    fn__5849 = function()
      return temper.concat('expected build(bobbyTables) == (', "select * from hi where name = 'Robert''); drop table hi;--'", ') not (', actual_639, ')');
    end;
    temper.test_assert(test_635, t_640, fn__5849);
    fn__5848 = function()
      return "expected buildWrong(bobbyTables) == (select * from hi where name = 'Robert'); drop table hi;--') not (select * from hi where name = 'Robert'); drop table hi;--')";
    end;
    temper.test_assert(test_635, true, fn__5848);
    return nil;
  end);
end;
Test_.test_stringEdgeCases__1328 = function()
  temper.test('string edge cases', function(test_641)
    local t_642, actual_643, t_644, fn__5810, t_645, actual_646, t_647, fn__5809, t_648, actual_649, t_650, fn__5808, t_651, actual_652, t_653, fn__5807;
    t_642 = SqlBuilder();
    t_642:appendSafe('v = ');
    t_642:appendString('');
    actual_643 = t_642.accumulated:toString();
    t_644 = temper.str_eq(actual_643, "v = ''");
    fn__5810 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "").toString() == (', "v = ''", ') not (', actual_643, ')');
    end;
    temper.test_assert(test_641, t_644, fn__5810);
    t_645 = SqlBuilder();
    t_645:appendSafe('v = ');
    t_645:appendString("a''b");
    actual_646 = t_645.accumulated:toString();
    t_647 = temper.str_eq(actual_646, "v = 'a''''b'");
    fn__5809 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v = \", \\interpolate, \"a''b\").toString() == (", "v = 'a''''b'", ') not (', actual_646, ')');
    end;
    temper.test_assert(test_641, t_647, fn__5809);
    t_648 = SqlBuilder();
    t_648:appendSafe('v = ');
    t_648:appendString('Hello \xe4\xb8\x96\xe7\x95\x8c');
    actual_649 = t_648.accumulated:toString();
    t_650 = temper.str_eq(actual_649, "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'");
    fn__5808 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Hello \xe4\xb8\x96\xe7\x95\x8c").toString() == (', "v = 'Hello \xe4\xb8\x96\xe7\x95\x8c'", ') not (', actual_649, ')');
    end;
    temper.test_assert(test_641, t_650, fn__5808);
    t_651 = SqlBuilder();
    t_651:appendSafe('v = ');
    t_651:appendString('Line1\nLine2');
    actual_652 = t_651.accumulated:toString();
    t_653 = temper.str_eq(actual_652, "v = 'Line1\nLine2'");
    fn__5807 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, "Line1\\nLine2").toString() == (', "v = 'Line1\nLine2'", ') not (', actual_652, ')');
    end;
    temper.test_assert(test_641, t_653, fn__5807);
    return nil;
  end);
end;
Test_.test_numbersAndBooleans__1341 = function()
  temper.test('numbers and booleans', function(test_654)
    local t_655, t_656, actual_657, t_658, fn__5781, date__1081, local_659, local_660, local_661, t_663, actual_664, t_665, fn__5780;
    t_656 = SqlBuilder();
    t_656:appendSafe('select ');
    t_656:appendInt32(42);
    t_656:appendSafe(', ');
    t_656:appendInt64(temper.int64_constructor(43));
    t_656:appendSafe(', ');
    t_656:appendFloat64(19.99);
    t_656:appendSafe(', ');
    t_656:appendBoolean(true);
    t_656:appendSafe(', ');
    t_656:appendBoolean(false);
    actual_657 = t_656.accumulated:toString();
    t_658 = temper.str_eq(actual_657, 'select 42, 43, 19.99, TRUE, FALSE');
    fn__5781 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, 42, ", ", \\interpolate, 43, ", ", \\interpolate, 19.99, ", ", \\interpolate, true, ", ", \\interpolate, false).toString() == (', 'select 42, 43, 19.99, TRUE, FALSE', ') not (', actual_657, ')');
    end;
    temper.test_assert(test_654, t_658, fn__5781);
    local_659, local_660, local_661 = temper.pcall(function()
      t_655 = temper.date_constructor(2024, 12, 25);
      date__1081 = t_655;
    end);
    if local_659 then
    else
      date__1081 = temper.bubble();
    end
    t_663 = SqlBuilder();
    t_663:appendSafe('insert into t values (');
    t_663:appendDate(date__1081);
    t_663:appendSafe(')');
    actual_664 = t_663.accumulated:toString();
    t_665 = temper.str_eq(actual_664, "insert into t values ('2024-12-25')");
    fn__5780 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "insert into t values (", \\interpolate, date, ")").toString() == (', "insert into t values ('2024-12-25')", ') not (', actual_664, ')');
    end;
    temper.test_assert(test_654, t_665, fn__5780);
    return nil;
  end);
end;
Test_.test_lists__1348 = function()
  temper.test('lists', function(test_666)
    local t_667, t_668, t_669, t_670, t_671, actual_672, t_673, fn__5725, t_674, actual_675, t_676, fn__5724, t_677, actual_678, t_679, fn__5723, t_680, actual_681, t_682, fn__5722, t_683, actual_684, t_685, fn__5721, local_686, local_687, local_688, local_690, local_691, local_692, dates__1083, t_694, actual_695, t_696, fn__5720;
    t_671 = SqlBuilder();
    t_671:appendSafe('v IN (');
    t_671:appendStringList(temper.listof('a', 'b', "c'd"));
    t_671:appendSafe(')');
    actual_672 = t_671.accumulated:toString();
    t_673 = temper.str_eq(actual_672, "v IN ('a', 'b', 'c''d')");
    fn__5725 = function()
      return temper.concat("expected stringExpr(`-work//src/`.sql, true, \"v IN (\", \\interpolate, list(\"a\", \"b\", \"c'd\"), \")\").toString() == (", "v IN ('a', 'b', 'c''d')", ') not (', actual_672, ')');
    end;
    temper.test_assert(test_666, t_673, fn__5725);
    t_674 = SqlBuilder();
    t_674:appendSafe('v IN (');
    t_674:appendInt32List(temper.listof(1, 2, 3));
    t_674:appendSafe(')');
    actual_675 = t_674.accumulated:toString();
    t_676 = temper.str_eq(actual_675, 'v IN (1, 2, 3)');
    fn__5724 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2, 3), ")").toString() == (', 'v IN (1, 2, 3)', ') not (', actual_675, ')');
    end;
    temper.test_assert(test_666, t_676, fn__5724);
    t_677 = SqlBuilder();
    t_677:appendSafe('v IN (');
    t_677:appendInt64List(temper.listof(temper.int64_constructor(1), temper.int64_constructor(2)));
    t_677:appendSafe(')');
    actual_678 = t_677.accumulated:toString();
    t_679 = temper.str_eq(actual_678, 'v IN (1, 2)');
    fn__5723 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1, 2), ")").toString() == (', 'v IN (1, 2)', ') not (', actual_678, ')');
    end;
    temper.test_assert(test_666, t_679, fn__5723);
    t_680 = SqlBuilder();
    t_680:appendSafe('v IN (');
    t_680:appendFloat64List(temper.listof(1.0, 2.0));
    t_680:appendSafe(')');
    actual_681 = t_680.accumulated:toString();
    t_682 = temper.str_eq(actual_681, 'v IN (1.0, 2.0)');
    fn__5722 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(1.0, 2.0), ")").toString() == (', 'v IN (1.0, 2.0)', ') not (', actual_681, ')');
    end;
    temper.test_assert(test_666, t_682, fn__5722);
    t_683 = SqlBuilder();
    t_683:appendSafe('v IN (');
    t_683:appendBooleanList(temper.listof(true, false));
    t_683:appendSafe(')');
    actual_684 = t_683.accumulated:toString();
    t_685 = temper.str_eq(actual_684, 'v IN (TRUE, FALSE)');
    fn__5721 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, list(true, false), ")").toString() == (', 'v IN (TRUE, FALSE)', ') not (', actual_684, ')');
    end;
    temper.test_assert(test_666, t_685, fn__5721);
    local_686, local_687, local_688 = temper.pcall(function()
      t_667 = temper.date_constructor(2024, 1, 1);
      t_668 = t_667;
    end);
    if local_686 then
    else
      t_668 = temper.bubble();
    end
    local_690, local_691, local_692 = temper.pcall(function()
      t_669 = temper.date_constructor(2024, 12, 25);
      t_670 = t_669;
    end);
    if local_690 then
    else
      t_670 = temper.bubble();
    end
    dates__1083 = temper.listof(t_668, t_670);
    t_694 = SqlBuilder();
    t_694:appendSafe('v IN (');
    t_694:appendDateList(dates__1083);
    t_694:appendSafe(')');
    actual_695 = t_694.accumulated:toString();
    t_696 = temper.str_eq(actual_695, "v IN ('2024-01-01', '2024-12-25')");
    fn__5720 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v IN (", \\interpolate, dates, ")").toString() == (', "v IN ('2024-01-01', '2024-12-25')", ') not (', actual_695, ')');
    end;
    temper.test_assert(test_666, t_696, fn__5720);
    return nil;
  end);
end;
Test_.test_sqlFloat64_naNRendersAsNull__1367 = function()
  temper.test('SqlFloat64 NaN renders as NULL', function(test_697)
    local nan__1085, t_698, actual_699, t_700, fn__5711;
    nan__1085 = temper.fdiv(0.0, 0.0);
    t_698 = SqlBuilder();
    t_698:appendSafe('v = ');
    t_698:appendFloat64(nan__1085);
    actual_699 = t_698.accumulated:toString();
    t_700 = temper.str_eq(actual_699, 'v = NULL');
    fn__5711 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, nan).toString() == (', 'v = NULL', ') not (', actual_699, ')');
    end;
    temper.test_assert(test_697, t_700, fn__5711);
    return nil;
  end);
end;
Test_.test_sqlFloat64_infinityRendersAsNull__1371 = function()
  temper.test('SqlFloat64 Infinity renders as NULL', function(test_701)
    local inf__1087, t_702, actual_703, t_704, fn__5702;
    inf__1087 = temper.fdiv(1.0, 0.0);
    t_702 = SqlBuilder();
    t_702:appendSafe('v = ');
    t_702:appendFloat64(inf__1087);
    actual_703 = t_702.accumulated:toString();
    t_704 = temper.str_eq(actual_703, 'v = NULL');
    fn__5702 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, inf).toString() == (', 'v = NULL', ') not (', actual_703, ')');
    end;
    temper.test_assert(test_701, t_704, fn__5702);
    return nil;
  end);
end;
Test_.test_sqlFloat64_negativeInfinityRendersAsNull__1375 = function()
  temper.test('SqlFloat64 negative Infinity renders as NULL', function(test_705)
    local ninf__1089, t_706, actual_707, t_708, fn__5693;
    ninf__1089 = temper.fdiv(-1.0, 0.0);
    t_706 = SqlBuilder();
    t_706:appendSafe('v = ');
    t_706:appendFloat64(ninf__1089);
    actual_707 = t_706.accumulated:toString();
    t_708 = temper.str_eq(actual_707, 'v = NULL');
    fn__5693 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, ninf).toString() == (', 'v = NULL', ') not (', actual_707, ')');
    end;
    temper.test_assert(test_705, t_708, fn__5693);
    return nil;
  end);
end;
Test_.test_sqlFloat64_normalValuesStillWork__1379 = function()
  temper.test('SqlFloat64 normal values still work', function(test_709)
    local t_710, actual_711, t_712, fn__5668, t_713, actual_714, t_715, fn__5667, t_716, actual_717, t_718, fn__5666;
    t_710 = SqlBuilder();
    t_710:appendSafe('v = ');
    t_710:appendFloat64(3.14);
    actual_711 = t_710.accumulated:toString();
    t_712 = temper.str_eq(actual_711, 'v = 3.14');
    fn__5668 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 3.14).toString() == (', 'v = 3.14', ') not (', actual_711, ')');
    end;
    temper.test_assert(test_709, t_712, fn__5668);
    t_713 = SqlBuilder();
    t_713:appendSafe('v = ');
    t_713:appendFloat64(0.0);
    actual_714 = t_713.accumulated:toString();
    t_715 = temper.str_eq(actual_714, 'v = 0.0');
    fn__5667 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, 0.0).toString() == (', 'v = 0.0', ') not (', actual_714, ')');
    end;
    temper.test_assert(test_709, t_715, fn__5667);
    t_716 = SqlBuilder();
    t_716:appendSafe('v = ');
    t_716:appendFloat64(-42.5);
    actual_717 = t_716.accumulated:toString();
    t_718 = temper.str_eq(actual_717, 'v = -42.5');
    fn__5666 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, -42.5).toString() == (', 'v = -42.5', ') not (', actual_717, ')');
    end;
    temper.test_assert(test_709, t_718, fn__5666);
    return nil;
  end);
end;
Test_.test_sqlDateRendersWithQuotes__1389 = function()
  temper.test('SqlDate renders with quotes', function(test_719)
    local t_720, d__1092, local_721, local_722, local_723, t_725, actual_726, t_727, fn__5657;
    local_721, local_722, local_723 = temper.pcall(function()
      t_720 = temper.date_constructor(2024, 6, 15);
      d__1092 = t_720;
    end);
    if local_721 then
    else
      d__1092 = temper.bubble();
    end
    t_725 = SqlBuilder();
    t_725:appendSafe('v = ');
    t_725:appendDate(d__1092);
    actual_726 = t_725.accumulated:toString();
    t_727 = temper.str_eq(actual_726, "v = '2024-06-15'");
    fn__5657 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "v = ", \\interpolate, d).toString() == (', "v = '2024-06-15'", ') not (', actual_726, ')');
    end;
    temper.test_assert(test_719, t_727, fn__5657);
    return nil;
  end);
end;
Test_.test_nesting__1393 = function()
  temper.test('nesting', function(test_728)
    local name__1094, t_729, condition__1095, t_730, actual_731, t_732, fn__5625, t_733, actual_734, t_735, fn__5624, parts__1096, t_736, actual_737, t_738, fn__5623;
    name__1094 = 'Someone';
    t_729 = SqlBuilder();
    t_729:appendSafe('where p.last_name = ');
    t_729:appendString('Someone');
    condition__1095 = t_729.accumulated;
    t_730 = SqlBuilder();
    t_730:appendSafe('select p.id from person p ');
    t_730:appendFragment(condition__1095);
    actual_731 = t_730.accumulated:toString();
    t_732 = temper.str_eq(actual_731, "select p.id from person p where p.last_name = 'Someone'");
    fn__5625 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_731, ')');
    end;
    temper.test_assert(test_728, t_732, fn__5625);
    t_733 = SqlBuilder();
    t_733:appendSafe('select p.id from person p ');
    t_733:appendPart(condition__1095:toSource());
    actual_734 = t_733.accumulated:toString();
    t_735 = temper.str_eq(actual_734, "select p.id from person p where p.last_name = 'Someone'");
    fn__5624 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select p.id from person p ", \\interpolate, condition.toSource()).toString() == (', "select p.id from person p where p.last_name = 'Someone'", ') not (', actual_734, ')');
    end;
    temper.test_assert(test_728, t_735, fn__5624);
    parts__1096 = temper.listof(SqlString("a'b"), SqlInt32(3));
    t_736 = SqlBuilder();
    t_736:appendSafe('select ');
    t_736:appendPartList(parts__1096);
    actual_737 = t_736.accumulated:toString();
    t_738 = temper.str_eq(actual_737, "select 'a''b', 3");
    fn__5623 = function()
      return temper.concat('expected stringExpr(`-work//src/`.sql, true, "select ", \\interpolate, parts).toString() == (', "select 'a''b', 3", ') not (', actual_737, ')');
    end;
    temper.test_assert(test_728, t_738, fn__5623);
    return nil;
  end);
end;
exports = {};
local_740.LuaUnit.run(local_739({'--pattern', '^Test_%.', local_739(arg)}));
return exports;
