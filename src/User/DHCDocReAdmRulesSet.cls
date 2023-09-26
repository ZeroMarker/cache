Class User.DHCDocReAdmRulesSet Extends (%Persistent, User.Abstract)
{

/// 复诊规则名称
Property RARTitle As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RAR_Title ];

/// 复诊规则判断天数
Property RARJudgeDays As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RAR_JudgeDays ];

/// 复诊规则判断依据  DIA:按诊断判断 ADM:按就诊记录判断
Property RARJudgeBy As %Library.String(DISPLAYLIST = ",Diagnose,Adm", VALUELIST = ",DIA,ADM,") [ SqlColumnNumber = 4, SqlFieldName = RAR_JudgeBy ];

/// 复诊规则是否按主诊断 RARJudgeBy为DIA 时有效
Property RARJudgeByMainDiaFlag As %Library.String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N,") [ SqlColumnNumber = 5, SqlFieldName = RAR_JudgeByMainDiaFlag ];

/// 院区
Property RARHospDr As CTHospital [ SqlColumnNumber = 6, SqlFieldName = RAR_HospDr ];

/// 是否是默认规则
Property RARIsDefault As %Library.String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N,") [ SqlColumnNumber = 7, SqlFieldName = RAR_IsDefault ];

Storage Default
{
<Data name="DHCDocReAdmRulesSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RARTitle</Value>
</Value>
<Value name="3">
<Value>RARJudgeDays</Value>
</Value>
<Value name="4">
<Value>RARJudgeBy</Value>
</Value>
<Value name="5">
<Value>RARJudgeByMainDiaFlag</Value>
</Value>
<Value name="6">
<Value>RARHospDr</Value>
</Value>
<Value name="7">
<Value>RARIsDefault</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocReAdmRulesSetD</DataLocation>
<DefaultData>DHCDocReAdmRulesSetDefaultData</DefaultData>
<IdLocation>^User.DHCDocReAdmRulesSetD</IdLocation>
<IndexLocation>^User.DHCDocReAdmRulesSetI</IndexLocation>
<StreamLocation>^User.DHCDocReAdmRulesSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
