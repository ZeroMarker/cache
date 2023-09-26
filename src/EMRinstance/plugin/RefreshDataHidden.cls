/// 名称:EMRinstance.plugin.RefreshDataHidden
/// 描述:存储不需要显示的同步数据
/// 编写者：liuyunfei
/// 编写日期: 2020-12-24
Class EMRinstance.plugin.RefreshDataHidden Extends %Persistent
{

/// 病历InstanceID
Property InstanceID As %String;

/// Code
Property Code As %String(MAXLEN = 1024);

Index IdxInstanceID On InstanceID;

Storage Default
{
<Data name="RefreshDataHiddenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.plugin.RefreshDataHD</DataLocation>
<DefaultData>RefreshDataHiddenDefaultData</DefaultData>
<IdLocation>^DHCEMRI.plugin.RefreshDataHD</IdLocation>
<IndexLocation>^DHCEMRI.plugin.RefreshDataHI</IndexLocation>
<StreamLocation>^DHCEMRI.plugin.RefreshDataHS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
