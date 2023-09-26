/// DHCWL_ComplexRpt.RptCfg
/// d ##class(DHCWL.ComplexRpt.RptCfg).%BuildIndices()
/// 报表的定义表
Class DHCWL.ComplexRpt.RptCfg Extends %Persistent [ ClassType = persistent, SqlTableName = RptCfg ]
{

/// 代码
Property RptCode As %String(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = Rpt_Code ];

/// 名称
Property RptName As %String(MAXLEN = 150) [ SqlColumnNumber = 3, SqlFieldName = Rpt_Name ];

/// 描述
Property RptDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = Rpt_Desc ];

/// 分类
Property RptFL As %String [ SqlColumnNumber = 5, SqlFieldName = Rpt_FL ];

/// 更新时间
Property RptUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Rpt_UpdateDate ];

/// 备注
Property RptRemark As %String [ SqlColumnNumber = 7, SqlFieldName = Rpt_Remark ];

Index RptCode On RptCode;

Index RptFL On RptFL;

ClassMethod DelRpt(rptID As %String) As %String
{
	s ret="ok"

	s sc=##class(DHCWL.ComplexRpt.RptCfg).%DeleteId(rptID)
		If $$$ISERR(sc) {
			s ret=$System.Status.GetErrorText(sc)
		}
		
	q ret
}

Storage Default
{
<Data name="RptCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptCode</Value>
</Value>
<Value name="3">
<Value>RptName</Value>
</Value>
<Value name="4">
<Value>RptDesc</Value>
</Value>
<Value name="5">
<Value>RptFL</Value>
</Value>
<Value name="6">
<Value>RptUpdateDate</Value>
</Value>
<Value name="7">
<Value>RptRemark</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRpt.RptCfgD</DataLocation>
<DefaultData>RptCfgDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRpt.RptCfgD</IdLocation>
<IndexLocation>^DHCWL.ComplexRpt.RptCfgI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRpt.RptCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
