/// 名称:EMRinstance.plugin.RefreshBindData
/// 描述:存储病历InstanceID和是否显示绑定数据提示框状态
/// 编写者：DongLulu
/// 编写日期: 2016-06-13
Class EMRinstance.plugin.RefreshBindData Extends %Persistent
{

/// 病历InstanceID
Property InstanceID As %String;

/// 是否显示绑定数据提示框
Property SyncDialogVisible As %String;

Index IdxInstanceIDSyncDialogVisible On (InstanceID, SyncDialogVisible);

Index IdxInstanceID On InstanceID;

Storage Default
{
<Data name="RefreshBindDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>SyncDialogVisible</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.plugin.RefreshBindDataD</DataLocation>
<DefaultData>RefreshBindDataDefaultData</DefaultData>
<IdLocation>^DHCEMRI.plugin.RefreshBindDataD</IdLocation>
<IndexLocation>^DHCEMRI.plugin.RefreshBindDataI</IndexLocation>
<StreamLocation>^DHCEMRI.plugin.RefreshBindDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
