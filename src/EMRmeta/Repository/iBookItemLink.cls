/// 名称:EMRmeta.Repository.iBookkBNodeLink
/// 描述:联机文献外部关联
Class EMRmeta.Repository.iBookItemLink Extends %Persistent
{

Index IdxLinkItemID On (LinkItemType, LinkItemID);

Index IdxiBookIDItemID On (iBookID, LinkItemType, LinkItemID);

/// 关联节点ID
Property LinkItemID As %String;

/// 关联节点类型,KBNode/Template
Property LinkItemType As %String;

/// 关联节点名称
Property LinkItemDesc As %String;

/// 联机文献ID
Property iBookID As %String;

/// 联机文献标题
Property iBookTitle As %String;

Storage Default
{
<Data name="iBookItemLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LinkItemID</Value>
</Value>
<Value name="3">
<Value>LinkItemType</Value>
</Value>
<Value name="4">
<Value>LinkItemDesc</Value>
</Value>
<Value name="5">
<Value>iBookID</Value>
</Value>
<Value name="6">
<Value>iBookTitle</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.iBookItemLinkD</DataLocation>
<DefaultData>iBookItemLinkDefaultData</DefaultData>
<IdLocation>^DHCEMRM.iBookItemLinkD</IdLocation>
<IndexLocation>^DHCEMRM.iBookItemLinkI</IndexLocation>
<StreamLocation>^DHCEMRM.iBookItemLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
