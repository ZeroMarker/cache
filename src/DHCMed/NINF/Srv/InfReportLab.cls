/// 名称: DHCMed.NINF.Srv.InfReportLab
/// 描述: 感染监测 病原学检验 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-08
Class DHCMed.NINF.Srv.InfReportLab Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 检验标本
Property Specimen As DHCMed.NINF.Srv.Dictionary;

/// 感染部位
Property InfectionPos As DHCMed.NINF.Srv.Dictionary;

/// 送检日期
Property SubmissionDate As %String(TRUNCATE = 1);

/// 检验方法
Property AssayMethod As DHCMed.NINF.Srv.Dictionary;

/// 病原学检验
Property PathogenTest As DHCMed.NINF.Srv.Dictionary;

/// 检验结果(病原体+药敏实验)
Property TestResults As list Of DHCMed.NINF.Srv.InfReportLabPy;

ClassMethod GetObject() As DHCMed.NINF.Srv.InfReportLab
{
	New
	Set obj=##Class(DHCMed.NINF.Srv.InfReportLab).%New()
	If obj'="" Do obj.%Close()
	Quit obj
}

Storage Default
{
<Data name="InfReportLabState">
<Value name="1">
<Value>AssayMethod</Value>
</Value>
<Value name="2">
<Value>InfectionPos</Value>
</Value>
<Value name="3">
<Value>PathogenTest</Value>
</Value>
<Value name="4">
<Value>Specimen</Value>
</Value>
<Value name="5">
<Value>SubmissionDate</Value>
</Value>
<Value name="6">
<Value>TestResults</Value>
</Value>
</Data>
<State>InfReportLabState</State>
<StreamLocation>^DHCMed.NINF.Srv.InfReportLabS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
