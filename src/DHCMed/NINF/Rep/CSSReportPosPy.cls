/// 名称: DHCMed.NINF.Rep.CSSReportPosPy
/// 描述: 横断面调查 感染部位对应病原体
/// 编写者：zhufei
/// 编写日期: 2013-07-23
Class DHCMed.NINF.Rep.CSSReportPosPy Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 病原体ID
Property PathogenyID As DHCMed.NINF.Dic.Pathogeny;

/// 病原体
Property PathogenyDesc As %String(TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 病原学检验 病原体
/// Table：       DHCMed.NINF.Rep.CSSReportPosPy
/// Input：       DHCMed.NINF.Rep.CSSReportPosPy.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.CSSReportPosPy).GetObj()
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.NINF.Rep.CSSReportPosPy
{
	New (aInput,aSeparate)
	Set return=""
	Quit:(aInput="")||(aSeparate="") return
	
	Set obj=##Class(DHCMed.NINF.Rep.CSSReportPosPy).%New()
	If obj'="" Do obj.%Close()
	
	Set PathogenyID=$p(aInput,aSeparate,1)
	Set PathogenyDesc=$p(aInput,aSeparate,2)
	Quit:PathogenyDesc="" return
	
	Set obj.PathogenyID=PathogenyID
	Set obj.PathogenyDesc=PathogenyDesc
	Set return=obj
	Quit return
}

Storage Default
{
<Data name="CSSReportPosPyState">
<Value name="1">
<Value>PathogenyID</Value>
</Value>
<Value name="2">
<Value>PathogenyDesc</Value>
</Value>
<Value name="3">
<Value>DrugSenTest</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Py")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Py")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"LabPy")</IndexLocation>
<State>CSSReportPosPyState</State>
<StreamLocation>^DHCMed.NINF493.CSSReportPosPyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
