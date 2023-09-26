/// 名称: DHCMed.NINF.Rep.InfReportICUPy
/// 描述: 重症监护 病原体
/// 编写者：zhufei
/// 编写日期: 2012-12-26
Class DHCMed.NINF.Rep.InfReportICUPy Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 病原体
Property PathogenyID As %String(TRUNCATE = 1);

/// 病原体名称
Property PathogenyDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.NINF.Rep.InfReportICUPy).GetObj("","^")
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.NINF.Rep.InfReportICUPy
{
	New (aInput,aSeparate)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportICUPy).%New()
	If obj'="" Do obj.%Close()
	Set obj.PathogenyID=$p(aInput,aSeparate,1)
	Set obj.PathogenyDesc=$p(aInput,aSeparate,2)
	Set return=obj
	
	Quit return
}

Storage Default
{
<Data name="InfReportICUPyState">
<Value name="1">
<Value>PathogenyDesc</Value>
</Value>
<Value name="2">
<Value>PathogenyID</Value>
</Value>
</Data>
<State>InfReportICUPyState</State>
<StreamLocation>^DHCMed.NINF493.InfReportICUPyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
