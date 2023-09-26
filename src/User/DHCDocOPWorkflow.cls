Class User.DHCDocOPWorkflow Extends %Persistent [ SqlTableName = DHCDoc_OPWorkflow ]
{

Index IndexName On Name [ Unique ];

Index IndexSequece On Sequece [ Unique ];

Property Name As %String [ Required, SqlColumnNumber = 2 ];

Property Sequece As %Integer [ SqlColumnNumber = 3 ];

Property UserAddDR As SSUser [ SqlColumnNumber = 4 ];

Property AddDate As %Date [ SqlColumnNumber = 5 ];

Property AddTime As %Time [ SqlColumnNumber = 6 ];

Property UpdateDate As %Date [ SqlColumnNumber = 7 ];

Property UpdateTime As %Time [ SqlColumnNumber = 8 ];

Property AuthHospIDs As %String(MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Property AuthLocIDs As %String(MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Property AuthGroupIDs As %String(MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="DHCDocOPWorkflowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Sequece</Value>
</Value>
<Value name="4">
<Value>UserAddDR</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>AuthHospIDs</Value>
</Value>
<Value name="10">
<Value>AuthLocIDs</Value>
</Value>
<Value name="11">
<Value>AuthGroupIDs</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocOPWorkflowD</DataLocation>
<DefaultData>DHCDocOPWorkflowDefaultData</DefaultData>
<IdLocation>^User.DHCDocOPWorkflowD</IdLocation>
<IndexLocation>^User.DHCDocOPWorkflowI</IndexLocation>
<StreamLocation>^User.DHCDocOPWorkflowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
