/// 名称:EMRinstance.PlantToothTreatment
/// 描述:种植牙疗程表
/// 编写者：liuyunfei
/// 编写日期: 2020-08-03
Class EMRinstance.PlantToothTreatment Extends %Persistent
{

/// 疗程ID
Property TreatmentID As %String;

/// 疗程名称
Property Name As %String(MAXLEN = 256);

/// 疗程描述
Property Description As %String(MAXLEN = 32767);

/// 实例ID
Property InstanceId As %String(MAXLEN = 256);

/// 就诊号
Property EpisodeId As %String(MAXLEN = 256);

Property PatientId As %String;

/// 创建疗程时间
Property DataTime As %String;

/// 创建疗程用户ID
Property UserID As %String;

/// 是否可用
Property IsActive As %String;

Index IdxPatientId On PatientId;

Storage Default
{
<Data name="PlantToothTreatmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>InstanceId</Value>
</Value>
<Value name="5">
<Value>EpisodeId</Value>
</Value>
<Value name="6">
<Value>PatientID</Value>
</Value>
<Value name="7">
<Value>DataTime</Value>
</Value>
<Value name="8">
<Value>UserID</Value>
</Value>
<Value name="9">
<Value>TreatmentID</Value>
</Value>
<Value name="10">
<Value>IsShow</Value>
</Value>
<Value name="11">
<Value>PatientId</Value>
</Value>
<Value name="12">
<Value>IsActive</Value>
</Value>
<Value name="13">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.PlantToothTD</DataLocation>
<DefaultData>PlantToothTreatmentDefaultData</DefaultData>
<IdLocation>^DHCEMRI.PlantToothTD</IdLocation>
<IndexLocation>^DHCEMRI.PlantToothTI</IndexLocation>
<StreamLocation>^DHCEMRI.PlantToothTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
