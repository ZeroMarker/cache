/// 名称: DHCMed.NINF.Srv.InfReportMedApp
/// 描述: 器械相关 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-09-13
Class DHCMed.NINF.Srv.InfReportMedApp Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 器械类型
Property MedAppType As DHCMed.NINF.Srv.Dictionary;

/// 置管日期
Property IntubateDate As %Date;

/// 置管时间
Property IntubateTime As %Time;

/// 拔管日期
Property ExtubateDate As %Date;

/// 拔管时间
Property ExtubateTime As %Time;

Storage Default
{
<Data name="InfReportMedAppState">
<Value name="1">
<Value>ExtubateDate</Value>
</Value>
<Value name="2">
<Value>ExtubateTime</Value>
</Value>
<Value name="3">
<Value>IntubateDate</Value>
</Value>
<Value name="4">
<Value>IntubateTime</Value>
</Value>
<Value name="5">
<Value>MedAppType</Value>
</Value>
<Value name="6">
<Value>InfectionDate</Value>
</Value>
</Data>
<State>InfReportMedAppState</State>
<StreamLocation>^DHCMed.NINF4A7.InfReportMed5D0S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
