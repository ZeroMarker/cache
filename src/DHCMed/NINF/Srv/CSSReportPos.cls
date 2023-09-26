/// 名称: DHCMed.NINF.Srv.CSSReportPos
/// 描述: 横断面调查 感染信息 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-11-30
Class DHCMed.NINF.Srv.CSSReportPos Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 感染部位
Property InfPos As DHCMed.NINF.Srv.Dictionary;

/// 病原学检验(病原体)
Property TestRst As list Of DHCMed.NINF.Srv.Dictionary;

Storage Default
{
<Data name="CSSReportPosState">
<Value name="1">
<Value>InfPos</Value>
</Value>
<Value name="2">
<Value>TestRst</Value>
</Value>
</Data>
<State>CSSReportPosState</State>
<StreamLocation>^DHCMed.NINF.Srv.CSSReportPosS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
