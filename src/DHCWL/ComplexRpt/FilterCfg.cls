/// DHCWL_ComplexRpt.FilterCfg
/// 报表的查询条件表
Class DHCWL.ComplexRpt.FilterCfg Extends %Persistent [ ClassType = persistent, SqlTableName = FilterCfg ]
{

/// 报表
Property RptDr As %String [ SqlColumnNumber = 2, SqlFieldName = Filter_RptDr ];

/// 表达式
Property Expression As %String(MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = Filter_Expression ];

/// 备注
Property Remark As %String [ SqlColumnNumber = 4, SqlFieldName = Filter_Remark ];

Index FilterRpt On RptDr;

Storage Default
{
<Data name="FilterCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StCode</Value>
</Value>
<Value name="3">
<Value>StDesc</Value>
</Value>
<Value name="4">
<Value>StType</Value>
</Value>
<Value name="5">
<Value>RptDr</Value>
</Value>
<Value name="6">
<Value>Expression</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRpt.FilterCfgD</DataLocation>
<DefaultData>FilterCfgDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRpt.FilterCfgD</IdLocation>
<IndexLocation>^DHCWL.ComplexRpt.FilterCfgI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRpt.FilterCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
