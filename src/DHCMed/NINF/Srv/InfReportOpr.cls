/// 名称: DHCMed.NINF.Srv.InfReportOpr
/// 描述: 感染监测 手术信息 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-08-08
Class DHCMed.NINF.Srv.InfReportOpr Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 手术ID 指向ORC_Operation
Property OperationID As %String(TRUNCATE = 1);

/// 手术ICD
Property OperationICD As %String(TRUNCATE = 1);

/// 手术名称
Property OperationDesc As %String(TRUNCATE = 1);

/// 开始日期
Property OperStartDate As %String(TRUNCATE = 1);

/// 开始时间
Property OperStartTime As %String(TRUNCATE = 1);

/// 结束日期
Property OperEndDate As %String(TRUNCATE = 1);

/// 结束时间
Property OperEndTime As %String(TRUNCATE = 1);

/// 手术医生
Property OperDoc As DHCMed.NINF.Srv.Dictionary;

/// 手术类型
Property OperationType As DHCMed.NINF.Srv.Dictionary;

/// 麻醉方式
Property Anesthesia As DHCMed.NINF.Srv.Dictionary;

/// 切口类型
Property CuteType As DHCMed.NINF.Srv.Dictionary;

/// 愈合情况
Property CuteHealing As DHCMed.NINF.Srv.Dictionary;

/// 切口感染
Property CuteInfFlag As DHCMed.NINF.Srv.Dictionary;

/// 手术感染类型
Property OperInfType As DHCMed.NINF.Srv.Dictionary;

/// 引起院内感染
Property InHospInfFlag As DHCMed.NINF.Srv.Dictionary;

/// ASA(麻醉)评分
Property ASAScore As DHCMed.NINF.Srv.Dictionary;

/// 术前外周WBC计数(×10^9/L)
Property PreoperWBC As %String;

/// 切口个数
Property CuteNumber As %String;

/// 使用窥镜
Property EndoscopeFlag As DHCMed.NINF.Srv.Dictionary;

/// 植入物
Property ImplantFlag As DHCMed.NINF.Srv.Dictionary;

/// 术前口服抗生素肠道准备
Property PreoperAntiFlag As DHCMed.NINF.Srv.Dictionary;

/// 失血
Property BloodLossFlag As DHCMed.NINF.Srv.Dictionary;

/// 失血量(MLS)
Property BloodLoss As %String;

/// 输血
Property BloodTransFlag As DHCMed.NINF.Srv.Dictionary;

/// 输血量(MLS)
Property BloodTrans As %String;

/// 术后并发症
Property PostoperComps As list Of DHCMed.NINF.Srv.Dictionary;

Storage Default
{
<Data name="InfReportOprState">
<Value name="1">
<Value>Anesthesia</Value>
</Value>
<Value name="2">
<Value>CuteHealing</Value>
</Value>
<Value name="3">
<Value>CuteInfFlag</Value>
</Value>
<Value name="4">
<Value>CuteType</Value>
</Value>
<Value name="5">
<Value>InHospInfFlag</Value>
</Value>
<Value name="6">
<Value>OperDoc</Value>
</Value>
<Value name="7">
<Value>OperEndDate</Value>
</Value>
<Value name="8">
<Value>OperEndTime</Value>
</Value>
<Value name="9">
<Value>OperInfType</Value>
</Value>
<Value name="10">
<Value>OperStartDate</Value>
</Value>
<Value name="11">
<Value>OperStartTime</Value>
</Value>
<Value name="12">
<Value>OperationDesc</Value>
</Value>
<Value name="13">
<Value>OperationICD</Value>
</Value>
<Value name="14">
<Value>OperationID</Value>
</Value>
<Value name="15">
<Value>OperationType</Value>
</Value>
<Value name="16">
<Value>ASAScore</Value>
</Value>
<Value name="17">
<Value>PreoperWBC</Value>
</Value>
<Value name="18">
<Value>CuteNumber</Value>
</Value>
<Value name="19">
<Value>EndoscopeFlag</Value>
</Value>
<Value name="20">
<Value>ImplantFlag</Value>
</Value>
<Value name="21">
<Value>PreoperAntiFlag</Value>
</Value>
<Value name="22">
<Value>BloodLossFlag</Value>
</Value>
<Value name="23">
<Value>BloodLoss</Value>
</Value>
<Value name="24">
<Value>BloodTransFlag</Value>
</Value>
<Value name="25">
<Value>BloodTrans</Value>
</Value>
<Value name="26">
<Value>PostoperComps</Value>
</Value>
</Data>
<State>InfReportOprState</State>
<StreamLocation>^DHCMed.NINF.Srv.InfReportOprS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
