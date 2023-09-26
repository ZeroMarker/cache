/// Creator:谷雪萍
/// CreatDate:2022-08-03
/// Description：实施综合管理平台-字典对照-对接方中医诊断证型表
/// Table：CT_WDT_CDSS.ConCMDiseDict
Class CT.WDT.CDSS.ConCMDiseDict Extends (%Persistent, User.Abstract)
{

/// 代码
Property DiseaseCode As %String [ Required ];

/// 描述
Property DiseaseName As %String(MAXLEN = "") [ Required ];

/// 来源（住院/门诊/急诊）
Property Source As %String;

/// ICD代码
Property ICDCode As %String;

/// 医院
Property HospitalDR As CT.WDT.CDSS.CustomerHosp;

/// 备注
Property Remarks As %String;

/// 状态（未关联/已关联/已确认/已删除）
Property State As %String;

/// 创建时间（药品数据导入或者手动新增的时间）
Property CreateDate As %TimeStamp;

/// 创建人
Property CreateUser As %String;

/// 修改时间（对应的就是所有操作时间,包括删除,确认,关联,取消关联）
Property UpdateDate As %TimeStamp;

/// 修改人
Property UpdateUser As %String;

/// 开始日期	2021-9-3 阚延新 增加开始日期以及结束日期
Property StartDate As %Date;

/// 结束日期
Property EndDate As %Date;

/// 是否院方常用（1是，0否）
Property IsCommon As %Integer;

/// 疾病分类（中医/证型）
Property DiagnosisClass As %String;

Index StateDescIndex On (DiagnosisClass As Exact, State As Exact, DiseaseName As Exact);

Index HospCNIndex On (HospitalDR, DiagnosisClass As Exact, ICDCode As Exact, DiseaseCode As Exact, DiseaseName As Exact);

// Index HospCodeNameIndex On (HospitalDR, DiagnosisClass As Exact, DiseaseCode As Exact, DiseaseName As Exact);

Index HospStateIndex On (HospitalDR, DiagnosisClass As Exact, State As Exact);

Index CreateDateIndex On (HospitalDR, DiagnosisClass As Exact, CreateDate As Exact);

Index UpdateDateIndex On (HospitalDR, DiagnosisClass As Exact, UpdateDate As Exact);

Storage Default
{
<Data name="ConCMDiseDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseaseCode</Value>
</Value>
<Value name="3">
<Value>DiseaseName</Value>
</Value>
<Value name="4">
<Value>Source</Value>
</Value>
<Value name="5">
<Value>ICDCode</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
<Value name="8">
<Value>State</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateUser</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateUser</Value>
</Value>
<Value name="13">
<Value>StartDate</Value>
</Value>
<Value name="14">
<Value>EndDate</Value>
</Value>
<Value name="15">
<Value>IsCommon</Value>
</Value>
<Value name="16">
<Value>DiagnosisClass</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ConCMDiseDictD</DataLocation>
<DefaultData>ConCMDiseDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ConCMDiseDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ConCMDiseDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ConCMDiseDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
