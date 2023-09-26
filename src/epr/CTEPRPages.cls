Class epr.CTEPRPages Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property AllowAddition As %Library.Boolean;

Property Description As %String(TRUNCATE = 1);

Property EditComponentDR As websys.Component;

Property ListComponentDR As websys.Component;

Property URL As %String(TRUNCATE = 1);

Property IsHistoryPage As %Boolean;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "Description";

Parameter SQLROWID = "ID";

/// by wuqk 2011-06-01
Method URLSet(val As %Library.String) As %Library.Status
{
}

ClassMethod LookUpClose(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFetch ]
{
}

ClassMethod LookUpFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = LookUpExecute ]
{
}

ClassMethod LookUpExecute(ByRef QHandle As %Library.Binary, desc As %String, IsHistory As %String) As %Library.Status
{
}

/// by wuqk 2011-06-01
Query LookUp(desc As %String, IsHistory As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

Storage Default
{
<Data name="CTEPRPagesDefaultData">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>URL</Value>
</Value>
<Value name="3">
<Value>EditComponent</Value>
</Value>
<Value name="4">
<Value>AllowAddition</Value>
</Value>
<Value name="5">
<Value>EditComponentDR</Value>
</Value>
<Value name="6">
<Value>ListComponentDR</Value>
</Value>
<Value name="7">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="8">
<Value>IsHistoryPage</Value>
</Value>
</Data>
<DataLocation>^ooCTEPRPagesD</DataLocation>
<DefaultData>CTEPRPagesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ooCTEPRPagesD</IdLocation>
<IndexLocation>^ooCTEPRPagesI</IndexLocation>
<StreamLocation>^epr.CTEPRPagesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
