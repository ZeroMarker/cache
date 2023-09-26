Class EMRinstance.PastHistory Extends %Persistent
{

/// 患者ID
Property PatientID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 创建日期
Property CreatDate As %Date;

/// 创建时间
Property CreatTime As %Time;

/// 创建人
Property CreatUserID As %String(TRUNCATE = 1);

/// 创建人科室
Property CreatDeptID As %String(TRUNCATE = 1);

/// 修改日期
Property ModifyDate As %Date;

/// 修改时间
Property ModifyTime As %Time;

/// 修改人
Property ModifyUserID As %String(TRUNCATE = 1);

/// 修改人科室
Property ModifyDeptID As %String(TRUNCATE = 1);

/// 疾病史+用药史+手术史+输血史  内容
Property DMOB As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 疾病史内容
Property Disease As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 用药史内容
Property Medication As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 手术史内容
Property Operation As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 输血史内容
Property BloodTransfusion As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 过敏史内容
Property Allergy As %String(MAXLEN = 10000, TRUNCATE = 1);

Index IdxEpisode On EpisodeID [ Unique ];

Index IdxPatientIDEpisode On (PatientID, EpisodeID) [ Unique ];

Storage Default
{
<Data name="PastHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>CreatDate</Value>
</Value>
<Value name="5">
<Value>CreatTime</Value>
</Value>
<Value name="6">
<Value>CreatUserID</Value>
</Value>
<Value name="7">
<Value>CreatDept</Value>
</Value>
<Value name="8">
<Value>ModifyDate</Value>
</Value>
<Value name="9">
<Value>ModifyTime</Value>
</Value>
<Value name="10">
<Value>ModifyUserID</Value>
</Value>
<Value name="11">
<Value>ModifyDept</Value>
</Value>
<Value name="12">
<Value>DMOB</Value>
</Value>
<Value name="13">
<Value>Disease</Value>
</Value>
<Value name="14">
<Value>Medication</Value>
</Value>
<Value name="15">
<Value>Operation</Value>
</Value>
<Value name="16">
<Value>BloodTransfusion</Value>
</Value>
<Value name="17">
<Value>Allergy</Value>
</Value>
<Value name="18">
<Value>CreatDeptID</Value>
</Value>
<Value name="19">
<Value>ModifyDeptID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.PastHistoryD</DataLocation>
<DefaultData>PastHistoryDefaultData</DefaultData>
<IdLocation>^DHCEMRI.PastHistoryD</IdLocation>
<IndexLocation>^DHCEMRI.PastHistoryI</IndexLocation>
<StreamLocation>^DHCEMRI.PastHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
