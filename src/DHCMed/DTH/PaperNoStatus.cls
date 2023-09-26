/// 名称: DHCMed.DTH.PaperNoStatus
/// 描述: 死亡证明书纸单号状态表
/// 编写者：yhb
/// 编写日期: 2014-06-19
Class DHCMed.DTH.PaperNoStatus Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParrefRaperNo As DHCMed.DTH.PaperNo [ Cardinality = parent, Inverse = ChildPaperNoStatus ];

/// 状态
Property StatusDR As DHCMed.SS.Dictionary;

/// 操作日期
Property OpeDate As %Date;

/// 操作时间
Property OpeTime As %Time;

/// 科室 CT_Loc
Property OpeLocDR As %String(TRUNCATE = 1);

/// 操作人员
Property OpeUserDR As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator:yhb
/// CreateDate:2014-06-19
/// Description:得到DHCMed.DTH.PaperNoStatus对象
/// Input: id   DHCMed.DTH.PaperNoStatus rowId
/// Output:DHCMed.DTH.PaperNoStatus 对象
ClassMethod GetObjById(id As %String) As DHCMed.DTH.PaperNoStatus
{
	new (id)
	set return=""
	set obj=##Class(DHCMed.DTH.PaperNoStatus).%OpenId(id)
	if $IsObject(obj){
		set return=obj
		do obj.%Close()
	}
	quit return
}

Storage Default
{
<Data name="PaperNoStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusDR</Value>
</Value>
<Value name="3">
<Value>OpeDate</Value>
</Value>
<Value name="4">
<Value>OpeTime</Value>
</Value>
<Value name="5">
<Value>OpeLocDR</Value>
</Value>
<Value name="6">
<Value>OpeUserDR</Value>
</Value>
<Value name="7">
<Value>BehindPaperNo</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildPaperNoStatus")</DataLocation>
<DefaultData>PaperNoStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildPaperNoStatus")</IdLocation>
<IndexLocation>^DHCMed.DTHi("PAPERNO")("ChildPaperNoStatus")</IndexLocation>
<StreamLocation>^DHCMed.DTH.PaperNoStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
