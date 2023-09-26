/// DHCWL_ComplexRpt.RowsColCfg
/// d ##class(DHCWL.ComplexRpt.RowsColCfg).%BuildIndices()
/// d ##class(DHCWL.ComplexRpt.RowsColCfg).%PurgeIndices()
/// d ##class(DHCWL.ComplexRpt.RowsColCfg).%PurgeIndices($ListBuild("RCRptDr"))
/// d ##class(DHCWL.ComplexRpt.RowsColCfg).%BuildIndices($ListBuild("RCRptDr"))
/// 报表的配置条件表
Class DHCWL.ComplexRpt.RowsColCfg Extends %Persistent [ ClassType = persistent, SqlTableName = RowsColCfg ]
{

/// 报表
Property RptDr As DHCWL.ComplexRpt.RptCfg [ SqlColumnNumber = 2, SqlFieldName = RC_RptDr ];

/// 统计模式
Property Mode As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = RC_Mode ];

/// 统计内容
Property Content As %String(MAXLEN = 250) [ SqlColumnNumber = 4, SqlFieldName = RC_Content ];

/// 行条件
Property RowExp As %String(MAXLEN = 250) [ SqlColumnNumber = 5, SqlFieldName = RC_RowExp ];

/// 列条件
Property ColExp As %String(MAXLEN = 250) [ SqlColumnNumber = 6, SqlFieldName = RC_ColExp ];

/// 过滤条件
Property FilterExp As %String(MAXLEN = 2500) [ SqlColumnNumber = 7, SqlFieldName = RC_FilterExp ];

/// 备注
Property Remark As %String [ SqlColumnNumber = 8, SqlFieldName = RC_Remark ];

Index RCRptDr On RptDr;

Index RCRptMode On Mode;

Storage Default
{
<Data name="RowsColCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptDr</Value>
</Value>
<Value name="3">
<Value>Mode</Value>
</Value>
<Value name="4">
<Value>Content</Value>
</Value>
<Value name="5">
<Value>RowExp</Value>
</Value>
<Value name="6">
<Value>ColExp</Value>
</Value>
<Value name="7">
<Value>FilterExp</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRpt.RowsColCfgD</DataLocation>
<DefaultData>RowsColCfgDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRpt.RowsColCfgD</IdLocation>
<IndexLocation>^DHCWL.ComplexRpt.RowsColCfgI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRpt.RowsColCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
