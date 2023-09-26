/// 名称:EMRinstance.PlantToothTreatment
/// 描述:种植牙疗程instanceId表
/// 编写者：liuyunfei
/// 编写日期: 2020-08-03
Class EMRinstance.PlantToothTreatmentInstanceId Extends %Persistent
{

/// 实例ID
Property InstanceId As %String;

/// 实例是否被删除1：没被删除；0：被删除
Property IsActive As %String;

/// 疗程ID
Property TreatmengId As %String;

Index IdxInstanceId On InstanceId;

Storage Default
{
<Data name="PlantToothTreatmentInstanceIdDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceId</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>TreatmengId</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.PlantToothTInsD</DataLocation>
<DefaultData>PlantToothTreatmentInstanceIdDefaultData</DefaultData>
<IdLocation>^DHCEMRI.PlantToothTInsD</IdLocation>
<IndexLocation>^DHCEMRI.PlantToothTInsI</IndexLocation>
<StreamLocation>^DHCEMRI.PlantToothTInsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
