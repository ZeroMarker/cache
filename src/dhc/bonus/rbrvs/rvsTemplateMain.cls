/// rbrvs模板主表
Class dhc.bonus.rbrvs.rvsTemplateMain Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = rvsTemplateMainID ]
{

/// 模板编码
Property templateCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 模板名称
Property templateName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 消耗用时权重
Property useMinuteRate As %Library.Float [ SqlColumnNumber = 4 ];

/// 承担风险权重
Property workRiskRate As %Library.Float [ SqlColumnNumber = 5 ];

/// 技术难度权重
Property techDifficultyRate As %Library.Float [ SqlColumnNumber = 6 ];

/// 工作消耗权重
Property workCostRate As %Library.Float [ SqlColumnNumber = 7 ];

/// 模板说明
Property tempDesc As %Library.String [ SqlColumnNumber = 8 ];

/// 创建人员
Property createUser As %Library.String [ SqlColumnNumber = 9 ];

/// 创建日期
Property createDate As %Library.String [ SqlColumnNumber = 10 ];

/// 是否启用 0:未启用，1：启用
Property isUse As %Library.Integer [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="rvsTemplateMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>templateCode</Value>
</Value>
<Value name="3">
<Value>templateName</Value>
</Value>
<Value name="4">
<Value>useMinuteRate</Value>
</Value>
<Value name="5">
<Value>workRiskRate</Value>
</Value>
<Value name="6">
<Value>techDifficultyRate</Value>
</Value>
<Value name="7">
<Value>workCostRate</Value>
</Value>
<Value name="8">
<Value>tempDesc</Value>
</Value>
<Value name="9">
<Value>createUser</Value>
</Value>
<Value name="10">
<Value>createDate</Value>
</Value>
<Value name="11">
<Value>isUse</Value>
</Value>
</Data>
<DataLocation>^dhcbsrvsTemplateMainD</DataLocation>
<DefaultData>rvsTemplateMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsrvsTemplateMainD</IdLocation>
<IndexLocation>^dhcbsrvsTemplateMainI</IndexLocation>
<StreamLocation>^dhcbsrvsTemplateMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
