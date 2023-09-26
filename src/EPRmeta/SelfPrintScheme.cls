Class EPRmeta.SelfPrintScheme Extends %Persistent [ ProcedureBlock ]
{

Property SchemeName As %String [ SqlColumnNumber = 2 ];

Property SchemeDesc As %String [ SqlColumnNumber = 3 ];

Property PrintItems As %String(MAXLEN = 2000) [ SqlColumnNumber = 4 ];

Property CreateDate As %String [ SqlColumnNumber = 5 ];

Property CreateTime As %String [ SqlColumnNumber = 6 ];

Property CreateUserID As %String [ SqlColumnNumber = 7 ];

Property ModifyDate As %String [ SqlColumnNumber = 8 ];

Property ModifyTime As %String [ SqlColumnNumber = 9 ];

Property ModifyUserID As %String [ SqlColumnNumber = 10 ];

Index IdxOnSchemeName On SchemeName [ Unique ];

Storage Default
{
<Data name="SelfPrintSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeName</Value>
</Value>
<Value name="3">
<Value>SchemeDesc</Value>
</Value>
<Value name="4">
<Value>PrintItems</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>CreateUserID</Value>
</Value>
<Value name="8">
<Value>ModifyDate</Value>
</Value>
<Value name="9">
<Value>ModifyTime</Value>
</Value>
<Value name="10">
<Value>ModifyUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.SelfPrintSchemeD</DataLocation>
<DefaultData>SelfPrintSchemeDefaultData</DefaultData>
<IdLocation>^DHCEPRM.SelfPrintSchemeD</IdLocation>
<IndexLocation>^DHCEPRM.SelfPrintSchemeI</IndexLocation>
<StreamLocation>^DHCEPRM.SelfPrintSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
