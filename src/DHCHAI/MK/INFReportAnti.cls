/// 抗生素信息
Class DHCHAI.MK.INFReportAnti Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 医嘱ID
Property ArcimID As %String(TRUNCATE = 1);

/// 医嘱名称
Property ArcimDesc As %String(TRUNCATE = 1);

/// 开始日期
Property StartDate As %Date;

/// 开始时间
Property StartTime As %Time;

/// 结束日期
Property EndDate As %Date;

/// 结束时间
Property EndTime As %Time;

/// 剂量
Property DoseQty As %String(TRUNCATE = 1);

/// 剂量单位 指向CT_UOM
Property DoseUnit As %String(TRUNCATE = 1);

/// 频次 指向PHC_Freq
Property PhcFreq As %String(TRUNCATE = 1);

/// 用途
Property MedUsePurpose As DHCHAI.MK.INFDictionary;

/// 给药途径
Property AdminRoute As DHCHAI.MK.INFDictionary;

/// 目的
Property MedPurpose As DHCHAI.MK.INFDictionary;

/// 治疗用药方式
Property TreatmentMode As DHCHAI.MK.INFDictionary;

/// 预防用药指征
Property PreMedIndicat As DHCHAI.MK.INFDictionary;

/// 预防用药效果
Property PreMedEffect As DHCHAI.MK.INFDictionary;

/// 联合用药
Property CombinedMed As DHCHAI.MK.INFDictionary;

/// 术前用药时间(分钟)
Property PreMedTime As %String(TRUNCATE = 1);

/// 术后用药天数(天)
Property PostMedDays As %String(TRUNCATE = 1);

Storage Default
{
<Data name="INFReportAntiState">
<Value name="1">
<Value>ArcimID</Value>
</Value>
<Value name="2">
<Value>ArcimDesc</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>StartTime</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
<Value name="7">
<Value>DoseQty</Value>
</Value>
<Value name="8">
<Value>DoseUnit</Value>
</Value>
<Value name="9">
<Value>PhcFreq</Value>
</Value>
<Value name="10">
<Value>MedUsePurpose</Value>
</Value>
<Value name="11">
<Value>AdminRoute</Value>
</Value>
<Value name="12">
<Value>MedPurpose</Value>
</Value>
<Value name="13">
<Value>TreatmentMode</Value>
</Value>
<Value name="14">
<Value>PreMedIndicat</Value>
</Value>
<Value name="15">
<Value>PreMedEffect</Value>
</Value>
<Value name="16">
<Value>CombinedMed</Value>
</Value>
<Value name="17">
<Value>PreMedTime</Value>
</Value>
<Value name="18">
<Value>PostMedDays</Value>
</Value>
</Data>
<State>INFReportAntiState</State>
<StreamLocation>^DHCHAI.MK.INFReportAntiS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
