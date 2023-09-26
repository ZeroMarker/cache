/// 名称:DHCMed.DTH.ChildRepStatus
/// 描述: 5岁以下儿童死亡报告状态表
/// 编写者：wangCS
/// 编写日期: 2011-07-18
Class DHCMed.DTH.ChildRepStatus Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.DTH.ChildRep [ Cardinality = parent, Inverse = ChildCDRReportStatus ];

/// 状态
Property StatusDR As DHCMed.SS.Dictionary;

/// 操作日期
Property OpeDate As %Date;

/// 操作时间
Property OpeTime As %Time;

/// 操作人员
Property OpeUserDR As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator:          wangCS
/// CreateDate:       2011-07-19
/// OperationTable:   DHCMed.DTH.ChildRepStatus
/// Input:            separete：分割符
/// Output:           ParRef^StatusDR^OpeDate^OpeTime^OpeUserDR^ResumeText
/// Description:      将对象格式化为字符串
Method ToString(separate As %String) As %String
{
	if ($g(separate)="")
	{
		set separate=..#SEPARATE
	}
	set return=..%Id()_separate
	set return=return_..StatusDR_separate
	set return=return_..OpeDate_separate
	set return=return_..OpeTime_separate
	set return=return_..OpeUserDR_separate
	set return=return_..ResumeText
	quit return
}

/// Creator:          wangCS
/// CreateDate:       2011-07-19
/// OperationTable:   HCMed.DM.CDRReportStatus
/// Input:            id:rowId
/// Output:           HCMed.DM.CDRReportStatus 对象
/// Description:      根据id得到HCMed.DM.CDRReportStatus对象
ClassMethod GetObjById(argId As %String) As DHCMed.DTH.ChildRepStatus
{
	New (argId)
	set return=""
	Set obj=##Class(DHCMed.DTH.ChildRepStatus).%OpenId(argId)
	If $IsObject(obj){
		Set return=obj
		Do obj.%Close()
	}
	Quit return
}

/// Creator:          wangCS
/// CreateDate:       2011-07-19
/// OperationTable:  HCMed.DM.CDRReportStatus
/// Input:            id:rowId,
///                   separate:分割符
/// Output:           HCMed.DM.CDRReportStatus 对象内容拼凑的字符串
/// Description:      根据id得到对象内容的字符串
ClassMethod GetStringById(id As %String, separate As %String) As %String
{
	new (id,separate)
	set return=""
	if ($g(separate)=""){
		set separate=..#SEPARATE
	}
	set obj=..GetObjById(+id)
	if $IsObject(obj){
		set return=obj.ToString($g(separate))
	}
	quit return
}

ClassMethod Save(instr As %String, separate As %String) As %String
{
	new (instr,separate)
	set return=0
	if ($g(separate)=""){
		set separate=..#SEPARATE
	}
	set parRef=$p($g(instr),separate,1)
	quit:(parRef="")&('##Class(DHCMed.DTH.ChildRep).%ExistsId(+parRef))
	set parObj=##Class(DHCMed.DTH.ChildRep).%OpenId(+parRef)
	;ParRef^StatusDR^OpeDate^OpeTime^OpeUserDR^ResumeText
	set statusDr=$p($g(instr),separate,2)
	set opeDate=$p($g(instr),separate,3)
	set opeTime=$p($g(instr),separate,4)
	set opeUserDr=$p($g(instr),separate,5)
	set resumeText=$p($g(instr),separate,6)
	set obj=##Class(DHCMed.DTH.ChildRepStatus).%New()
	set obj.ParRef=parRef
	set obj.StatusDR=statusDr
	set obj.OpeDate=opeDate
	set obj.OpeTime=opeTime
	set obj.OpeUserDR=opeUserDr
	set obj.ResumeText=resumeText
	set retVal=obj.%Save()
	if ($System.Status.IsError(retVal)){
		do $System.OBJ.DisplayError(retVal)
		set return=-1
	}else{
		set return=0
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
<Value>OpeDate</Value>
</Value>
<Value name="3">
<Value>OpeTime</Value>
</Value>
<Value name="4">
<Value>OpeUserDR</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>StatusDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildCDRReportStatus")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildCDRReportStatus")</IdLocation>
<IndexLocation>^DHCMed.DTHi("CREP")</IndexLocation>
<StreamLocation>^DHCMed.DTH.ChildRepStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
