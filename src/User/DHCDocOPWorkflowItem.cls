Class User.DHCDocOPWorkflowItem Extends %Persistent [ SqlTableName = DHCDoc_OPWorkflowItem ]
{

Index IndexCode On (CatDR, Code) [ Unique ];

Index IndexName On (CatDR, Name) [ Unique ];

Index IndexSequece On (CatDR, Sequece) [ Unique ];

Property CatDR As DHCDocOPWorkflow [ Required, SqlColumnNumber = 2 ];

Property Code As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property Name As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4 ];

Property ClickEvent As %String(MAXLEN = 10000, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property Express As %String(MAXLEN = 10000, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property Link As %String(MAXLEN = 10000, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Property Sequece As %Integer [ SqlColumnNumber = 8 ];

Property Active As %Boolean [ SqlColumnNumber = 9 ];

Property XRefresh As %Boolean [ SqlColumnNumber = 10 ];

Property PreLineClass As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

Property UserAddDR As SSUser [ SqlColumnNumber = 12 ];

Property AddDate As %Date [ SqlColumnNumber = 13 ];

Property AddTime As %Time [ SqlColumnNumber = 14 ];

Property UpdateDate As %Date [ SqlColumnNumber = 15 ];

Property UpdateTime As %Time [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="DHCDocOPWorkflowItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CatDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>ClickEvent</Value>
</Value>
<Value name="6">
<Value>Express</Value>
</Value>
<Value name="7">
<Value>Link</Value>
</Value>
<Value name="8">
<Value>Sequece</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>XRefresh</Value>
</Value>
<Value name="11">
<Value>PreLineClass</Value>
</Value>
<Value name="12">
<Value>UserAddDR</Value>
</Value>
<Value name="13">
<Value>AddDate</Value>
</Value>
<Value name="14">
<Value>AddTime</Value>
</Value>
<Value name="15">
<Value>UpdateDate</Value>
</Value>
<Value name="16">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocOPWorkflowItemD</DataLocation>
<DefaultData>DHCDocOPWorkflowItemDefaultData</DefaultData>
<IdLocation>^User.DHCDocOPWorkflowItemD</IdLocation>
<IndexLocation>^User.DHCDocOPWorkflowItemI</IndexLocation>
<StreamLocation>^User.DHCDocOPWorkflowItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
