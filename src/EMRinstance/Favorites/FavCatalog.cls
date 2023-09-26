/// Desc: 		收藏夹目录
/// Creator:	Candy
/// CreateDate:	2014-11-18
Class EMRinstance.Favorites.FavCatalog Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 描述
Property CataLogName As %String;

/// 目录类型 Private/Share
Property Type As %String;

/// 父节点
Property ParentID As %String;

/// 顺序
Property Sequence As %Integer;

/// 指向 EMRinstance.Favorites.FavUser 0为公共节点
Property FavUserID As %Integer;

Index IdxUserCataLogName On (FavUserID, ParentID, CataLogName);

Index IdxUserSequence On (FavUserID, ParentID, Sequence);

Index IdxFavUserID On FavUserID;

Storage Default
{
<Data name="FavCatalogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CataLogName</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>FavUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRF.FavCatalogD</DataLocation>
<DefaultData>FavCatalogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRF.FavCatalogD</IdLocation>
<IndexLocation>^DHCEMRF.FavCatalogI</IndexLocation>
<StreamLocation>^DHCEMRF.FavCatalogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
