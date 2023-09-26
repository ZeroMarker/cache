/// Desc: 		收藏夹标签
/// Creator:	bianshuai
/// CreateDate:	2016-10-11
Class User.DHCPHFavTag Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 标签名称
Property TagName As %String;

/// 标签名称 指向User.DHCPHFavUser
Property FavUserID As %String;

/// 目录类型 Private/Share
Property Type As %String;

/// 顺序
Property Sequence As %Integer;

Index IdxTagName On TagName;

Index IdxFavUserID On FavUserID;

Index IdxUserIDSeq On (FavUserID, Sequence);

Storage Default
{
<Data name="FavTagDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TagName</Value>
</Value>
<Value name="3">
<Value>FavUserID</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCPHF.FavTagD</DataLocation>
<DefaultData>FavTagDefaultData</DefaultData>
<IdLocation>^DHCPHF.FavTagD</IdLocation>
<IndexLocation>^DHCPHF.FavTagI</IndexLocation>
<StreamLocation>^DHCPHF.FavTagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
