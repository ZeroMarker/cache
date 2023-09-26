Class User.DHCRBCBookParam Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHCRBC_BookParam ]
{

Property ArcItmMastRowid As %String [ Required ];

Property BodyRowid As %String [ Required ];

Property BodyCode As %String;

Property AppointMethodID As %String [ Required ];

Property IsEmpty As %String;

Property ExamTime As %String;

Index IndexItemBody On (ArcItmMastRowid As Exact, BodyRowid As AlphaUp);

Relationship BPChild As User.DHCRBCBookParamSG [ Cardinality = children, Inverse = BPParref ];

Storage Default
{
<Data name="DHCRBCBookParamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArcItmMastRowid</Value>
</Value>
<Value name="3">
<Value>BodyRowid</Value>
</Value>
<Value name="4">
<Value>BodyCode</Value>
</Value>
<Value name="5">
<Value>AppointMethodID</Value>
</Value>
<Value name="6">
<Value>IsEmpty</Value>
</Value>
<Value name="7">
<Value>ExamTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBCBookParamD</DataLocation>
<DefaultData>DHCRBCBookParamDefaultData</DefaultData>
<IdLocation>^User.DHCRBCBookParamD</IdLocation>
<IndexLocation>^User.DHCRBCBookParamI</IndexLocation>
<StreamLocation>^User.DHCRBCBookParamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
