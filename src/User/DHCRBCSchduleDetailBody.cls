Class User.DHCRBCSchduleDetailBody Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHCRBC_SchduleDetailBody ]
{

Property SchduleDetailRowid As %String [ Required ];

Property BodyRowid As %String [ Required ];

Property BodyCode As %String;

Index IndexDetailBody On (SchduleDetailRowid As AlphaUp, BodyRowid As AlphaUp);

Storage Default
{
<Data name="DHCRBCSchduleDetailBodyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchduleDetailRowid</Value>
</Value>
<Value name="3">
<Value>BodyRowid</Value>
</Value>
<Value name="4">
<Value>BodyCode</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBCSchduleDetailBodyD</DataLocation>
<DefaultData>DHCRBCSchduleDetailBodyDefaultData</DefaultData>
<IdLocation>^User.DHCRBCSchduleDetailBodyD</IdLocation>
<IndexLocation>^User.DHCRBCSchduleDetailBodyI</IndexLocation>
<StreamLocation>^User.DHCRBCSchduleDetailBodyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
