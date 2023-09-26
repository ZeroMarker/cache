/// 名称:DHCMed.DTH.ReportStatus
/// 描述: 报告状态记录表
/// 编写者：wangCS
/// 编写日期: 2011-07-18
Class DHCMed.DTH.ReportStatus Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.DTH.Report [ Cardinality = parent, Inverse = ChildReportStatus ];

/// 状态
Property StatusDR As DHCMed.SS.Dictionary;

/// 操作日期
Property OpeDate As %Date;

/// 操作时间
Property OpeTime As %Time;

/// 操作人员
Property OpeUserDR As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(MAXLEN = 200, TRUNCATE = 1);

/// w ##Class(DHCMed.DTH.ReportStatus).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCMed.DTH.ReportStatus
{
	new (aId)
	set return=""
	quit:aId="" return
	set obj=##class(DHCMed.DTH.ReportStatus).%OpenId(aId)
	if $IsObject(obj) {
		set return=obj
		do obj.%Close()
	}
	quit return
}

Storage Default
{
<Data name="Status">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OpeDate</Value>
</Value>
<Value name="3">
<Value>OpeTime</Value>
</Value>
<Value name="4">
<Value>StatusDR</Value>
</Value>
<Value name="5">
<Value>OpeUserDR</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Status")</DataLocation>
<DefaultData>Status</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Status")</IdLocation>
<IndexLocation>^DHCMed.DTHi("REP")("Status")</IndexLocation>
<StreamLocation>^DHCMed.DTH.ReportStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
