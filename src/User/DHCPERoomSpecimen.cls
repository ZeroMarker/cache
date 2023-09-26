Class User.DHCPERoomSpecimen Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_RoomSpecimen ]
{

Parameter ClassName = "User.DHCPERoomSpecimen";

Relationship RSParRef As User.DHCPERoom [ Cardinality = parent, Inverse = childSpecimen ];

Property RSSpecimen As %String [ SqlFieldName = RS_Specimen ];

Index SpecimenIndex On (RSParRef, RSSpecimen) [ Unique ];

Storage Default
{
<Data name="DHCPERoomSpecimenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RSSpecimen</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("childSpecimen")</DataLocation>
<DefaultData>DHCPERoomSpecimenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPERoomC("childSpecimen")</IdLocation>
<IndexLocation>^User.DHCPERoomSpecimenI</IndexLocation>
<StreamLocation>^User.DHCPERoomSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
