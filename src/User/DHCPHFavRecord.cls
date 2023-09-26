/// Desc: 		收藏病历
/// creator:		Candy
/// CreateDate:	2014-11-18
Class User.DHCPHFavRecord Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 收藏病历ID
Property InstanceID As %String;

/// 就诊ID
Property EpisodeID As %String;

Relationship ParRef As User.DHCPHFavInformation [ Cardinality = parent, Inverse = FavInformation ];

/// 病历是否有效
Property IsActive As %String;

Index IdxParRef On ParRef;

Index IdxParRefEpisodeID On (ParRef, EpisodeID);

Index IdxParRefInstanceID On (ParRef, EpisodeID, InstanceID);

Index IdxInstanceIDParRef On (InstanceID, ParRef);

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
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FavInformation")</DataLocation>
<DefaultData>FavRecordDefaultData</DefaultData>
<IdLocation>{%%PARENT}("FavInformation")</IdLocation>
<IndexLocation>^DHCPHF.FavRecordI</IndexLocation>
<StreamLocation>^DHCPHF.FavRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
