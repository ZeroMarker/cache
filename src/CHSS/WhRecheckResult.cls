Class CHSS.WhRecheckResult Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = WhRecheckResult ]
{

/// WomanRowId
Property WomanRowId As CHSS.WomenBaseInfo;

/// 检查编号
Property RecheckRowId As CHSS.WhAntepartumRecheck;

/// 体检结论
Property CheckResult As CHSS.DictWomenCheckResult;

/// 高危妊娠情况
Property HighRiskInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 保健指导
Property Suggestion1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 营养分析与评价
Property NutritionAppraise As %String(MAXLEN = 100, TRUNCATE = 1);

/// 营养关注
Property NutritionSuggestion As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="WhRecheckResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FirstCheckRowId</Value>
</Value>
<Value name="3">
<Value>HighRiskInfo</Value>
</Value>
<Value name="4">
<Value>NutritionAppraise</Value>
</Value>
<Value name="5">
<Value>NutritionSuggestion</Value>
</Value>
<Value name="6">
<Value>Suggestion1</Value>
</Value>
<Value name="7">
<Value>WomanRowId</Value>
</Value>
<Value name="8">
<Value>CheckResult</Value>
</Value>
<Value name="9">
<Value>RecheckRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.WhRecheckResultD</DataLocation>
<DefaultData>WhRecheckResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WhRecheckResultD</IdLocation>
<IndexLocation>^CHSS.WhRecheckResultI</IndexLocation>
<StreamLocation>^CHSS.WhRecheckResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
