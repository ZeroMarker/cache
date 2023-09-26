/// 名称: DHCMed.NINF.Rep.AimReportPy
/// 描述: 目标性监测报告 病原体
/// 编写者：zhufei
/// 编写日期: 2012-06-29
Class DHCMed.NINF.Rep.AimReportPy Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 病原体
Property PathogenyID As %String(TRUNCATE = 1);

/// 病原体名称
Property PathogenyDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.NINF.Rep.AimReportPy).GetObj("","^")
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.NINF.Rep.AimReportPy
{
	New (aInput,aSeparate)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.AimReportPy).%New()
	If obj'="" Do obj.%Close()
	Set obj.PathogenyID=$p(aInput,aSeparate,1)
	Set obj.PathogenyDesc=$p(aInput,aSeparate,2)
	Set return=obj
	
	Quit return
}

Storage Default
{
<Data name="AimReportPyState">
<Value name="1">
<Value>PathogenyDesc</Value>
</Value>
<Value name="2">
<Value>PathogenyID</Value>
</Value>
</Data>
<State>AimReportPyState</State>
<StreamLocation>^DHCMed.NINF.Rep.AimReportPyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
