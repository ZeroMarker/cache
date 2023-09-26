/// DHCWL_ComplexRptDet.ColCfg
/// d ##class(DHCWL.ComplexRptDet.ColCfg).%BuildIndices()
/// 报表的配置条件表
Class DHCWL.ComplexRptDet.ColCfg Extends %Persistent [ ClassType = persistent, SqlTableName = ColCfg ]
{

/// 报表
Property RptDr As DHCWL.ComplexRptDet.RptCfg [ SqlColumnNumber = 2, SqlFieldName = RC_RptDr ];

/// 统计模式
Property Mode As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = RC_Mode ];

/// 统计内容
Property Content As %String [ SqlColumnNumber = 4, SqlFieldName = RC_Content ];

/// 列条件
Property ColExp As %String(MAXLEN = 250) [ SqlColumnNumber = 5, SqlFieldName = RC_ColExp ];

/// 过滤条件
Property FilterExp As %String(MAXLEN = 2500) [ SqlColumnNumber = 6, SqlFieldName = RC_FilterExp ];

/// 备注
Property Remark As %String [ SqlColumnNumber = 7, SqlFieldName = RC_Remark ];

Index RCRptDr On RptDr;

Index RCRptMode On Mode;

Storage Default
{
<Data name="ColCfgDefaultData">
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
<DataLocation>^DHCWL.ComplexRptDet.ColCfgD</DataLocation>
<DefaultData>ColCfgDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRptDet.ColCfgD</IdLocation>
<IndexLocation>^DHCWL.ComplexRptDet.ColCfgI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRptDet.ColCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
