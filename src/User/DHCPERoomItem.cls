Class User.DHCPERoomItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_RoomItem ]
{

Parameter ClassName = "User.DHCPERoomItem";

Relationship RITMParRef As User.DHCPERoom [ Cardinality = parent, Inverse = childRoomItem ];

Property RITMArcIM As %String [ SqlFieldName = RITM_ArcIM ];

Property RITMTime As %String [ SqlFieldName = RITM_Time ];

Index ItemIndex On (RITMParRef, RITMArcIM) [ Unique ];

Storage Default
{
<Data name="DHCPERoomItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RITMArcIM</Value>
</Value>
<Value name="3">
<Value>RITMTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("childRoomItem")</DataLocation>
<DefaultData>DHCPERoomItemDefaultData</DefaultData>
<IdLocation>^User.DHCPERoomC("childRoomItem")</IdLocation>
<IndexLocation>^User.DHCPERoomItemI</IndexLocation>
<StreamLocation>^User.DHCPERoomItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
