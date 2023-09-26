Class User.DHCPERoomRoomPlace Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_RoomRoomPlace ]
{

Parameter ClassName = "User.DHCPERoomRoomPlace";

Relationship parrefRoom As User.DHCPERoom [ Cardinality = parent, Inverse = childRoomPlace ];

/// 诊室位置 指向User.DHCPERoomPlace.ID
Property RRPRoomPlace As %String [ SqlFieldName = RRP_RoomPlace ];

Index RoomPlaceIndex On (parrefRoom, RRPRoomPlace) [ Unique ];

Storage Default
{
<Data name="DHCPERoomRoomPlaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RRPRoomPlace</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("childRoomPlace")</DataLocation>
<DefaultData>DHCPERoomRoomPlaceDefaultData</DefaultData>
<IdLocation>^User.DHCPERoomC("childRoomPlace")</IdLocation>
<IndexLocation>^User.DHCPERoomRoomPlaceI</IndexLocation>
<StreamLocation>^User.DHCPERoomRoomPlaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
