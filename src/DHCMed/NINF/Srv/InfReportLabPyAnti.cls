/// 名称: DHCMed.NINF.Srv.InfReportLabPyAnti
/// 描述: 感染监测 药敏结果 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-08
Class DHCMed.NINF.Srv.InfReportLabPyAnti Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 抗生素ID
Property AntibioticsID As %String(TRUNCATE = 1);

/// 抗生素名称
Property AntibioticsDesc As %String(TRUNCATE = 1);

/// 抗生素名称1
Property AntibioticsDesc1 As %String(TRUNCATE = 1);

/// 药敏结果
Property SenTestRst As DHCMed.NINF.Srv.Dictionary;

Storage Default
{
<Data name="InfReportLabPyAntiState">
<Value name="1">
<Value>AntibioticsDesc</Value>
</Value>
<Value name="2">
<Value>AntibioticsDesc1</Value>
</Value>
<Value name="3">
<Value>AntibioticsID</Value>
</Value>
<Value name="4">
<Value>SenTestRst</Value>
</Value>
</Data>
<State>InfReportLabPyAntiState</State>
<StreamLocation>^DHCMed.NINF4A7.InfReportLab6FDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
