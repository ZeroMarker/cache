/// 名称: DHCMed.NINF.Srv.InfReportInfPos
/// 描述: 感染监测 感染信息 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-08
Class DHCMed.NINF.Srv.InfReportInfPos Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 感染部位
Property InfPos As DHCMed.NINF.Srv.Dictionary;

/// 感染日期
Property InfDate As %String(TRUNCATE = 1);

/// 感染诊断
Property InfDiag As DHCMed.NINF.Srv.Dictionary;

/// 侵入性操作
Property InfPosOpr As list Of DHCMed.NINF.Srv.Dictionary;

/// 感染结束日期 Add By LiYang 2013-05-18
Property InfEndDate As %String;

/// 感染转归 Add By LiYang 2013-05-19
Property InfEndResult As DHCMed.NINF.Srv.Dictionary;

Storage Default
{
<Data name="InfReportInfPosState">
<Value name="1">
<Value>InfDate</Value>
</Value>
<Value name="2">
<Value>InfDiag</Value>
</Value>
<Value name="3">
<Value>InfPos</Value>
</Value>
<Value name="4">
<Value>InfPosOpr</Value>
</Value>
<Value name="5">
<Value>InfEndDate</Value>
</Value>
<Value name="6">
<Value>InfEndResult</Value>
</Value>
</Data>
<State>InfReportInfPosState</State>
<StreamLocation>^DHCMed.NINF4A7.InfReportInf5E8S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
