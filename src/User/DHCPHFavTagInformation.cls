/// Desc:		病例标签表
/// Creator:	bianshuai
/// CreateDate:	2016-10-11
Class User.DHCPHFavTagInformation Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 标签ID 指向User.DHCPHFavTag
Property TagID As %Integer;

/// 病例ID 指向User.DHCPHFavInformation
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
<DataLocation>^DHCPHF.FavTagInformationD</DataLocation>
<DefaultData>FavTagInformationDefaultData</DefaultData>
<IdLocation>^DHCPHF.FavTagInformationD</IdLocation>
<IndexLocation>^DHCPHF.FavTagInformationI</IndexLocation>
<StreamLocation>^DHCPHF.FavTagInformationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
