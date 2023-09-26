Class DHCEPRSearch.META.SystemOption Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(MAXLEN = 1000, TRUNCATE = 1);

/// Visible:Null or "Y";  Invisible:"N"
Property IsVisible As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property OptionValue As %String(MAXLEN = 2000, TRUNCATE = 1);

Index IndexName On Name [ Unique ];

Storage Default
{
<Data name="SystemOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>IsVisible</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>OptionValue</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.META.SystemOptionD</DataLocation>
<DefaultData>SystemOptionDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.META.SystemOptionD</IdLocation>
<IndexLocation>^DHCEPRSearch.META.SystemOptionI</IndexLocation>
<StreamLocation>^DHCEPRSearch.META.SystemOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
