/// Desc:		病例标签表
/// Creator:	Candy
/// CreateDate:	2014-11-18
Class EMRinstance.Favorites.FavTagInformation Extends (%Persistent, %XML.Adaptor)
{

/// 标签ID 指向EMRinstance.Favorites.FavTag
Property TagID As %Integer;

/// 病例ID 指向EMRinstance.Favorites.FavInformation
Property InformationID As %Integer;

Index IdxTagID On TagID;

Index IdxTagInfoID On (TagID, InformationID);

Index IdxInfoIDTag On (InformationID, TagID);

Storage Default
{
<Data name="FavTagInformationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TagID</Value>
</Value>
<Value name="3">
<Value>InformationID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRF.FavTagInformationD</DataLocation>
<DefaultData>FavTagInformationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRF.FavTagInformationD</IdLocation>
<IndexLocation>^DHCEMRF.FavTagInformationI</IndexLocation>
<StreamLocation>^DHCEMRF.FavTagInformationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
