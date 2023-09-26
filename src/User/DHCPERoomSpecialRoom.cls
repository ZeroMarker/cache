Class User.DHCPERoomSpecialRoom Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_RoomSpecialRoom ]
{

Parameter ClassName = "User.DHCPERoomSpecialRoom";

Relationship RSRParRef As User.DHCPERoom [ Cardinality = parent, Inverse = childSpecialRoom ];

Property RSRRoomID As %String [ SqlFieldName = RSR_RoomID ];

Index RoomIDIndex On (RSRParRef, RSRRoomID) [ Unique ];

Index RSRRoomIDIndex On RSRRoomID;

Storage Default
{
<Data name="DHCPERoomSpecialRoomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RSRRoomID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("childSpecialRoom")</DataLocation>
<DefaultData>DHCPERoomSpecialRoomDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPERoomC("childSpecialRoom")</IdLocation>
<IndexLocation>^User.DHCPERoomSpecialRoomI</IndexLocation>
<StreamLocation>^User.DHCPERoomSpecialRoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
