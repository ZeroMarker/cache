Class User.DHCPERoomIP Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_RoomIP ]
{

Parameter ClassName = "User.DHCPERoomIP";

Relationship RIParRef As User.DHCPERoom [ Cardinality = parent, Inverse = childIP ];

Property RIIP As %String [ SqlFieldName = RI_IP ];

Index IPIndex On RIIP [ Unique ];

Storage Default
{
<Data name="DHCPERoomIPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RIIP</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("childIP")</DataLocation>
<DefaultData>DHCPERoomIPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPERoomC("childIP")</IdLocation>
<IndexLocation>^User.DHCPERoomIPI</IndexLocation>
<StreamLocation>^User.DHCPERoomIPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
