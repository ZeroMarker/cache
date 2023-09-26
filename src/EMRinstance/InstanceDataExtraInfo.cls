/// Desc:       实例数据表关联信息
/// CreateDate: 2020-8-17
Class EMRinstance.InstanceDataExtraInfo Extends %Persistent
{

Index IdxMain On InstanceID [ Unique ];

/// 病历ID
Property InstanceID As %String(TRUNCATE = 1);

/// 病历的另起页状态，0不是另起页，1是另起页
Property PageBreak As %String;

Storage Default
{
<Data name="InstanceDataExtraInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>PageBreak</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.InstanceDataExtraInfoD</DataLocation>
<DefaultData>InstanceDataExtraInfoDefaultData</DefaultData>
<IdLocation>^DHCEMRI.InstanceDataExtraInfoD</IdLocation>
<IndexLocation>^DHCEMRI.InstanceDataExtraInfoI</IndexLocation>
<StreamLocation>^DHCEMRI.InstanceDataExtraInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
