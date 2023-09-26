Class User.DHCANOPSafety Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ANOPS_RowId, SqlTableName = DHC_AN_OPSafety ]
{

Parameter EXTENTSIZE = 250;

/// ANOPS_OPADr
/// opaId
Property ANOPSOPADr As User.DHCANOPArrange [ SqlColumnNumber = 2, SqlFieldName = ANOPS_OPADr ];

/// ANOPS_PatName
/// 病人姓名
Property ANOPSPatName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ANOPS_PatName ];

/// ANOPS_Surgeon
/// 主刀医生 串？
Property ANOPSSurgeon As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ANOPS_Surgeon ];

/// ANOPS_AnDoc
/// 麻醉医生
Property ANOPSAnDoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ANOPS_AnDoc ];

/// ANOPS_OpNurse
/// 手术护士
Property ANOPSOpNurse As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ANOPS_OpNurse ];

/// ANOPS_Type
/// 类型
Property ANOPSType As %String(DISPLAYLIST = ",Surgeon,AN,OP", MAXLEN = 4, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",S,A,O") [ SqlColumnNumber = 7, SqlFieldName = ANOPS_Type ];

/// ANOPS_Audit
/// 是否审核完成
Property ANOPSAudit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ANOPS_Audit ];

/// ANOPS_Mode
/// 手术方式
Property ANOPSMode As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ANOPS_Mode ];

/// ANOPS_Position
/// 手术部位
Property ANOPSPosition As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ANOPS_Position ];

/// ANOPS_OpAgree
/// 手术知情同意
Property ANOPSOpAgree As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ANOPS_OpAgree ];

/// ANOPS_AnAgree
/// 麻醉知情同意
Property ANOPSAnAgree As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ANOPS_AnAgree ];

/// ANOPS_AnCheckComplete
/// 麻醉安全检查
Property ANOPSAnCheckComplete As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ANOPS_AnCheckComplete ];

/// ANOPS_Oximetry
/// 血氧监测
Property ANOPSOximetry As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ANOPS_Oximetry ];

/// ANOPS_Allergies
/// 患者过敏史
Property ANOPSAllergies As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ANOPS_Allergies ];

/// ANOPS_AirwayDisorders
/// 气道障碍/呼吸支持
Property ANOPSAirwayDisorders As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ANOPS_AirwayDisorders ];

/// ANOPS_VenousChannels
/// 静脉通道
Property ANOPSVenousChannels As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ANOPS_VenousChannels ];

/// ANOPS_SkinIntegrity
/// 皮肤完整性
Property ANOPSSkinIntegrity As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ANOPS_SkinIntegrity ];

/// ANOPS_AutologousBlood
/// 自体血
Property ANOPSAutologousBlood As %String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ANOPS_AutologousBlood ];

/// ANOPS_AllogeneicBlood
/// 异体血
Property ANOPSAllogeneicBlood As %String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = ANOPS_AllogeneicBlood ];

/// ANOPS_Prosthesis
/// 假体
Property ANOPSProsthesis As %String(TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = ANOPS_Prosthesis ];

/// ANOPS_Implants
/// 植入物
Property ANOPSImplants As %String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = ANOPS_Implants ];

/// ANOPS_Metal
/// 金属
Property ANOPSMetal As %String(TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = ANOPS_Metal ];

/// ANOPS_Other
/// 其他
Property ANOPSOther As %String(TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = ANOPS_Other ];

/// ANOPS_SurgicalRisk
/// 手术风险
Property ANOPSSurgicalRisk As %String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = ANOPS_SurgicalRisk ];

/// ANOPS_SurgeonStatement
/// 手术医生陈述
Property ANOPSSurgeonStatement As %String(TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = ANOPS_SurgeonStatement ];

/// ANOPS_AnDocStatement
/// 麻醉医生陈述
Property ANOPSAnDocStatement As %String(TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = ANOPS_AnDocStatement ];

/// ANOPS_OpNurseStatement
/// 手术护士陈述
Property ANOPSOpNurseStatement As %String(TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = ANOPS_OpNurseStatement ];

/// ANOPS_Antibiotic
/// 抗生素
Property ANOPSAntibiotic As %String(TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = ANOPS_Antibiotic ];

/// ANOPS_ImageData
/// 影像资料
Property ANOPSImageData As %String(TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = ANOPS_ImageData ];

/// ANOPS_OperName
/// 实施手术名称
Property ANOPSOperName As %String(TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = ANOPS_OperName ];

/// ANOPS_OpCount
/// 手术清点
Property ANOPSOpCount As %String(TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = ANOPS_OpCount ];

/// ANOPS_Specimen
/// 手术标本
Property ANOPSSpecimen As %String(TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = ANOPS_Specimen ];

/// ANOPS_Equipment
/// 仪器设备
Property ANOPSEquipment As %String(TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = ANOPS_Equipment ];

/// ANOPS_Whereabouts
/// 患者去向
Property ANOPSWhereabouts As %String(TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = ANOPS_Whereabouts ];

/// ANOPS_Piping
/// 管路
Property ANOPSPiping As %String(TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = ANOPS_Piping ];

Storage Default
{
<Data name="DHCANOPSafetyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ANOPSParref</Value>
</Value>
<Value name="3">
<Value>ANOPSPatName</Value>
</Value>
<Value name="4">
<Value>ANOPSSurgeon</Value>
</Value>
<Value name="5">
<Value>ANOPSAnDoc</Value>
</Value>
<Value name="6">
<Value>ANOPSOpNurse</Value>
</Value>
<Value name="7">
<Value>ANOPSType</Value>
</Value>
<Value name="8">
<Value>ANOPSOPADr</Value>
</Value>
<Value name="9">
<Value>ANOPSAudit</Value>
</Value>
<Value name="10">
<Value>ANOPSMode</Value>
</Value>
<Value name="11">
<Value>ANOPSPosition</Value>
</Value>
<Value name="12">
<Value>ANOPSOpAgree</Value>
</Value>
<Value name="13">
<Value>ANOPSAnAgree</Value>
</Value>
<Value name="14">
<Value>ANOPSAnCheckComplete</Value>
</Value>
<Value name="15">
<Value>ANOPSOximetry</Value>
</Value>
<Value name="16">
<Value>ANOPSAllergies</Value>
</Value>
<Value name="17">
<Value>ANOPSAirwayDisorders</Value>
</Value>
<Value name="18">
<Value>ANOPSVenousChannels</Value>
</Value>
<Value name="19">
<Value>ANOPSSkinIntegrity</Value>
</Value>
<Value name="20">
<Value>ANOPSAutologousBlood</Value>
</Value>
<Value name="21">
<Value>ANOPSAllogeneicBlood</Value>
</Value>
<Value name="22">
<Value>ANOPSProsthesis</Value>
</Value>
<Value name="23">
<Value>ANOPSImplants</Value>
</Value>
<Value name="24">
<Value>ANOPSMetal</Value>
</Value>
<Value name="25">
<Value>ANOPSOther</Value>
</Value>
<Value name="26">
<Value>ANOPSSurgicalRisk</Value>
</Value>
<Value name="27">
<Value>ANOPSSurgeonStatement</Value>
</Value>
<Value name="28">
<Value>ANOPSAnDocStatement</Value>
</Value>
<Value name="29">
<Value>ANOPSOpNurseStatement</Value>
</Value>
<Value name="30">
<Value>ANOPSAntibiotic</Value>
</Value>
<Value name="31">
<Value>ANOPSImageData</Value>
</Value>
<Value name="32">
<Value>ANOPSOperName</Value>
</Value>
<Value name="33">
<Value>ANOPSOpCount</Value>
</Value>
<Value name="34">
<Value>ANOPSSpecimen</Value>
</Value>
<Value name="35">
<Value>ANOPSEquipment</Value>
</Value>
<Value name="36">
<Value>ANOPSWhereabouts</Value>
</Value>
<Value name="37">
<Value>ANOPSPiping</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPSafetyD</DataLocation>
<DefaultData>DHCANOPSafetyDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCANOPSafetyD</IdLocation>
<IndexLocation>^User.DHCANOPSafetyI</IndexLocation>
<StreamLocation>^User.DHCANOPSafetyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
