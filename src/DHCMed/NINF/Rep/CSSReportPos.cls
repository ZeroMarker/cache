/// 名称: DHCMed.NINF.Rep.CSSReportPos
/// 描述: 横断面调查 感染信息
/// 编写者：zhufei
/// 编写日期: 2013-07-23
Class DHCMed.NINF.Rep.CSSReportPos Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 感染分类(社区感染/医院感染)("NINFCSSRepInfType")
Property InfType As DHCMed.SS.Dictionary;

/// 感染部位("NINFCSSRepInfPos")
Property InfPos As DHCMed.SS.Dictionary;

/// 病原学检验(病原体)
Property TestRst As list Of DHCMed.NINF.Rep.CSSReportPosPy;

Storage Default
{
<Data name="CSSReportPosState">
<Value name="1">
<Value>InfPos</Value>
</Value>
<Value name="2">
<Value>TestRst</Value>
</Value>
<Value name="3">
<Value>InfType</Value>
</Value>
</Data>
<State>CSSReportPosState</State>
<StreamLocation>^DHCMed.NINF.Rep.CSSReportPosS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
