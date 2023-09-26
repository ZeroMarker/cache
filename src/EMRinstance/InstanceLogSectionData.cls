/// 名称:EMRinstance.InstanceLogSectionData
/// 描述:实例数据-实例数据操作日志表-存储病历打散的章节文本
/// 编写者：Lina
/// 编写日期: 2019-08-28
Class EMRinstance.InstanceLogSectionData Extends %Persistent
{

/// EMRinstance.InstanceLog表的ID
Property InstanceLogID As %String(TRUNCATE = 1);

/// EMRinstance.InstanceData表的ID
Property InstanceDataID As %String(TRUNCATE = 1);

Property Text As %GlobalCharacterStream(LOCATION = "^DHCEMRI.InstanceLogSectionDataS");

Storage Default
{
<Data name="InstanceLogSectionDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceLogID</Value>
</Value>
<Value name="3">
<Value>InstanceDataID</Value>
</Value>
<Value name="4">
<Value>Text</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.InstanceLogSectionDataD</DataLocation>
<DefaultData>InstanceLogSectionDataDefaultData</DefaultData>
<IdLocation>^DHCEMRI.InstanceLogSectionDataD</IdLocation>
<IndexLocation>^DHCEMRI.InstanceLogSectionDataI</IndexLocation>
<StreamLocation>^DHCEMRI.InstanceLogSectionDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
