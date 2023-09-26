/// 名称:DHCMed.DTH.RepNoStatus
/// 描述: 死亡报告编号状态表
/// 编写者：wangCS
/// 编写日期: 2011-07-19
Class DHCMed.DTH.RepNoStatus Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParrefReportNo As DHCMed.DTH.RepNo [ Cardinality = parent, Inverse = ChildReportNoStatus ];

/// 状态
Property StatusDR As DHCMed.SS.Dictionary;

/// 操作日期
Property OpeDate As %Date;

/// 操作时间
Property OpeTime As %Time;

/// 操作人员
Property OpeUserDR As %String(TRUNCATE = 1);

/// 接收人员
Property RecUserDR As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator:wangCS
/// CreateDate:2011-08-04
/// Description:得到DHCMed.DTH.RepNoStatus对象
/// Input: id   DHCMed.DTH.RepNoStatus rowId
/// Output:DHCMed.DTH.RepNoStatus 对象
ClassMethod GetObjById(id As %String) As DHCMed.DTH.RepNoStatus
{
	new (id)
	set return=""
	set obj=##Class(DHCMed.DTH.RepNoStatus).%OpenId(id)
	if $IsObject(obj){
		set return=obj
		do obj.%Close()
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DMNSStatusDR</Value>
</Value>
<Value name="3">
<Value>SStatusDR</Value>
</Value>
<Value name="4">
<Value>OpeDate</Value>
</Value>
<Value name="5">
<Value>OpeTime</Value>
</Value>
<Value name="6">
<Value>OpeUserDR</Value>
</Value>
<Value name="7">
<Value>RecUserDR</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
<Value name="9">
<Value>StatusDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Status")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Status")</IdLocation>
<IndexLocation>^DHCMed.DTHi("REPNO")("Status")</IndexLocation>
<StreamLocation>^DHCMed.DTH.RepNoStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
