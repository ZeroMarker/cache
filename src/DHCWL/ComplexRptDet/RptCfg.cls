/// DHCWL_ComplexRptDet.RptCfg
/// d ##class(DHCWL.ComplexRptDet.RptCfg).%BuildIndices()
/// 报表的定义表
Class DHCWL.ComplexRptDet.RptCfg Extends %Persistent [ ClassType = persistent, SqlTableName = RptCfg ]
{

Parameter EXTENTSIZE = 250;

/// 代码
Property RptCode As %String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = Rpt_Code ];

/// 名称
Property RptName As %String(MAXLEN = 150) [ SqlColumnNumber = 3, SqlFieldName = Rpt_Name ];

/// 描述
Property RptDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = Rpt_Desc ];

/// 分类
Property RptFL As %String [ SqlColumnNumber = 5, SqlFieldName = Rpt_FL ];

/// 数据生成方式
Property RptDataType As %String [ SqlColumnNumber = 6, SqlFieldName = Rpt_DataType ];

/// 后台执行状态
Property RptExecState As %String [ SqlColumnNumber = 7, SqlFieldName = Rpt_ExecState ];

/// 进程号
Property RptPID As %String [ SqlColumnNumber = 8, SqlFieldName = Rpt_PID ];

/// 更新时间
Property RptUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Rpt_UpdateDate ];

/// 备注
Property RptRemark As %String [ SqlColumnNumber = 10, SqlFieldName = Rpt_Remark ];

Index RptCode On RptCode;

Index RptName On RptName;

Index RptFL On RptFL;

Index RptPID On RptPID;

ClassMethod DelRpt(rptID As %String) As %String
{
	s ret="ok"

	s sc=##class(DHCWL.ComplexRptDet.RptCfg).%DeleteId(rptID)
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
<Value name="8">
<Value>RptDataType</Value>
</Value>
<Value name="9">
<Value>RptExecState</Value>
</Value>
<Value name="10">
<Value>RptPID</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRptDet.RptCfgD</DataLocation>
<DefaultData>RptCfgDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCWL.ComplexRptDet.RptCfgD</IdLocation>
<IndexLocation>^DHCWL.ComplexRptDet.RptCfgI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRptDet.RptCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
