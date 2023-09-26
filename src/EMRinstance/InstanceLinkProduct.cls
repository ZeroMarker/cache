/// Desc:从其它产品组创建病历，关联表
/// Creator:Candy
/// CreateDate:2019-1-15
Class EMRinstance.InstanceLinkProduct Extends (%Persistent, %XML.Adaptor)
{

Index IdxMain On (FromType, FromCode, InstanceID) [ Unique ];

/// 实例ID
Property InstanceID As %String;

/// 来源
Property FromType As %String;

/// 代码
Property FromCode As %String;

/// 操作者
Property UserID As %String;

Index IdxInstanceID On InstanceID [ Unique ];

Storage Default
{
<Data name="InstanceLinkProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>FromType</Value>
</Value>
<Value name="4">
<Value>FromCode</Value>
</Value>
<Value name="5">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.LinkProductD</DataLocation>
<DefaultData>InstanceLinkProductDefaultData</DefaultData>
<IdLocation>^DHCEMRI.LinkProductD</IdLocation>
<IndexLocation>^DHCEMRI.LinkProductI</IndexLocation>
<StreamLocation>^DHCEMRI.LinkProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
