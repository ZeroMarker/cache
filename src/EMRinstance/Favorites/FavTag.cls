/// Desc: 		收藏夹标签
/// Creator:	Candy
/// CreateDate:	2014-11-18
Class EMRinstance.Favorites.FavTag Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 标签名称
Property TagName As %String;

/// 标签名称 指向EMRinstance.Favorites.FavUser
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
<Value>FavUserID</Value>
</Value>
<Value name="3">
<Value>TagName</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEMRF.FavTagD</DataLocation>
<DefaultData>FavTagDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRF.FavTagD</IdLocation>
<IndexLocation>^DHCEMRF.FavTagI</IndexLocation>
<StreamLocation>^DHCEMRF.FavTagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
