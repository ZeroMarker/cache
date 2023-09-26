/// 名称: DHCMed.NINF.Srv.InfReportLabPy
/// 描述: 感染监测 细菌培养 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-08
Class DHCMed.NINF.Srv.InfReportLabPy Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 病原体ID
Property PathogenyID As %String(TRUNCATE = 1);

/// 病原体名称
Property PathogenyDesc As %String(TRUNCATE = 1);

/// 病原体名称1
Property PathogenyDesc1 As %String(TRUNCATE = 1);

/// 药敏实验
Property DrugSenTest As list Of DHCMed.NINF.Srv.InfReportLabPyAnti;

Storage Default
{
<Data name="InfReportLabPyState">
<Value name="1">
<Value>DrugSenTest</Value>
</Value>
<Value name="2">
<Value>IsMultiResBac</Value>
</Value>
<Value name="3">
<Value>MultiResGroup</Value>
</Value>
<Value name="4">
<Value>PathogenyDesc</Value>
</Value>
<Value name="5">
<Value>PathogenyDesc1</Value>
</Value>
<Value name="6">
<Value>PathogenyID</Value>
</Value>
</Data>
<State>InfReportLabPyState</State>
<StreamLocation>^DHCMed.NINF4A7.InfReportLabPyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
