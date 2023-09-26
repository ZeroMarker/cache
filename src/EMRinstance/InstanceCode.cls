/// Desc:存储病历Code代码
/// Creator:Candy
/// CreateDate: 2016-6-19
Class EMRinstance.InstanceCode Extends (%Persistent, %XML.Adaptor)
{

Index IdxMain On (InstanceID, TitleCode) [ Unique ];

/// 实例数据ID 关联实例表 
Property InstanceID As %String;

/// 标题描述
Property TitleCode As %String;

Storage Default
{
<Data name="InstanceCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>TitleCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.InstanceCodeD</DataLocation>
<DefaultData>InstanceCodeDefaultData</DefaultData>
<IdLocation>^DHCEMRI.InstanceCodeD</IdLocation>
<IndexLocation>^DHCEMRI.InstanceCodeI</IndexLocation>
<StreamLocation>^DHCEMRI.InstanceCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
