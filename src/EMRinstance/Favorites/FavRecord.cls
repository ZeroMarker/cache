/// Desc: 		收藏病历
/// creator:		Candy
/// CreateDate:	2014-11-18
Class EMRinstance.Favorites.FavRecord Extends (%Persistent, %XML.Adaptor)
{

/// 收藏病历ID
Property InstanceID As %String;

/// 就诊ID
Property EpisodeID As %String;

Relationship ParRef As EMRinstance.Favorites.FavInformation [ Cardinality = parent, Inverse = FavInformation ];

/// 病历是否有效
Property IsActive As %String;

Index IdxParRef On ParRef;

Index IdxParRefEpisodeID On (ParRef, EpisodeID);

Index IdxParRefInstanceID On (ParRef, EpisodeID, InstanceID);

Storage Default
{
<Data name="FavRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FavInformation")</DataLocation>
<DefaultData>FavRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FavInformation")</IdLocation>
<IndexLocation>^DHCEMRF.FavRecordI</IndexLocation>
<StreamLocation>^DHCEMRF.FavRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
