/// Desc:送病案室操作字典及相关操作
/// Creator:Donglulu
/// CreateDate:2020-9-10
Class EMRmeta.ConfirmAction Extends (%Persistent, User.Abstract)
{

/// 操作动作(Confirm:确认 Revoke:撤销 WithDraw:退回 Recall:召回)
Property ActionCode As %String(TRUNCATE = 1);

Property ActionName As %String(TRUNCATE = 1);

Index IdxActionCode On ActionCode [ Unique ];

Index IdxActionName On ActionName;

Storage Default
{
<Data name="ConfirmActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ConfirmActionD</DataLocation>
<DefaultData>ConfirmActionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ConfirmActionD</IdLocation>
<IndexLocation>^DHCEMRM.ConfirmActionI</IndexLocation>
<StreamLocation>^DHCEMRM.ConfirmActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
