/// 名称: DHCMed.NINF.Srv.InfReportICU
/// 描述: 重症监护 对外接口
/// 编写者：zhufei
/// 编写日期: 2013-01-15
Class DHCMed.NINF.Srv.InfReportICU Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 置管类型(中央导管、呼吸机、导尿管、NICU中央导管、NICU气管插管、NICU脐静脉)
Property IntubateType As DHCMed.NINF.Srv.Dictionary;

/// 置管日期
Property IntubateDate As %Date;

/// 置管时间
Property IntubateTime As %Time;

/// 拔管日期
Property ExtubateDate As %Date;

/// 拔管时间
Property ExtubateTime As %Time;

/// 置管地点
Property IntubatePlace As DHCMed.NINF.Srv.Dictionary;

/// 置管人员类型
Property IntubateUserType As DHCMed.NINF.Srv.Dictionary;

/// 置管人员 指向SS_User
Property IntubateUser As %String(TRUNCATE = 1);

/// 感染日期
Property InfDate As %Date;

/// 病原菌
Property InfPathogeny As list Of DHCMed.NINF.Srv.Dictionary;

/// 中央导管 置管方位
Property PICCIntubatePos As DHCMed.NINF.Srv.Dictionary;

/// 中央导管 置管内径
Property PICCIntubateSize As DHCMed.NINF.Srv.Dictionary;

/// 中央导管 导管类型
Property PICCIntubateType As DHCMed.NINF.Srv.Dictionary;

/// 中央导管 置管腔数
Property PICCIntubateNum As DHCMed.NINF.Srv.Dictionary;

/// 中央导管 置管部位
Property PICCIntubateRegion As DHCMed.NINF.Srv.Dictionary;

/// 中央导管 拔管原因
Property PICCExtubateReason As DHCMed.NINF.Srv.Dictionary;

/// 导尿管 尿袋类型
Property UCUrineBagType As DHCMed.NINF.Srv.Dictionary;

/// 呼吸机 气道类型
Property VAPIntubateType As DHCMed.NINF.Srv.Dictionary;

ClassMethod GetObject() As DHCMed.NINF.Srv.InfReportICU
{
	New
	Set obj=##Class(DHCMed.NINF.Srv.InfReportICU).%New()
	If obj'="" Do obj.%Close()
	Quit obj
}

Storage Default
{
<Data name="InfReportICUState">
<Value name="1">
<Value>ExtubateDate</Value>
</Value>
<Value name="2">
<Value>ExtubateTime</Value>
</Value>
<Value name="3">
<Value>InfDate</Value>
</Value>
<Value name="4">
<Value>InfPathogeny</Value>
</Value>
<Value name="5">
<Value>IntubateDate</Value>
</Value>
<Value name="6">
<Value>IntubatePlace</Value>
</Value>
<Value name="7">
<Value>IntubateTime</Value>
</Value>
<Value name="8">
<Value>IntubateType</Value>
</Value>
<Value name="9">
<Value>IntubateUser</Value>
</Value>
<Value name="10">
<Value>IntubateUserType</Value>
</Value>
<Value name="11">
<Value>PICCExtubateReason</Value>
</Value>
<Value name="12">
<Value>PICCIntubateNum</Value>
</Value>
<Value name="13">
<Value>PICCIntubatePos</Value>
</Value>
<Value name="14">
<Value>PICCIntubateRegion</Value>
</Value>
<Value name="15">
<Value>PICCIntubateSize</Value>
</Value>
<Value name="16">
<Value>PICCIntubateType</Value>
</Value>
<Value name="17">
<Value>UCUrineBagType</Value>
</Value>
<Value name="18">
<Value>VAPIntubateType</Value>
</Value>
</Data>
<State>InfReportICUState</State>
<StreamLocation>^DHCMed.NINF.Srv.InfReportICUS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
