Class epr.FunctionPreferences Extends (%Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

Property appKey As %String;

Property appSubKey As %String;

Property Description As %String(MAXLEN = "");

Index appKeyIndex On appKey;

Index appSubKeyIndex On appSubKey;

/// no longer called from epr.FunctionPreferences.List, Generate field
/// Now run at SSWCONVERT
/// new preferences should have appKey = FUNCTION
ClassMethod Generate()
{
}

ClassMethod AddItem(appKey As %String, appSubKey As %String, Description As %String)
{
}

/// returns a listbuild containing the fields associated with the preference
/// allitems needs to stay in this order... new items should be appended
ClassMethod AllItem(appKey As %String, appSubKey As %String) As %Library.String
{
}

/// get the captions from the relevant component so they display on the list
ClassMethod ComponentMessages(appKey As %String, appSubKey As %String) As %Library.String
{
}

/// cjb 16/02/2007 61903
ClassMethod ReturnSelected(appKey As %String, appSubKey As %String) As %Library.String
{
}

ClassMethod Save() [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod ListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListFetch ]
{
}

/// Default implementation of LookUp Query.
/// ClassMethod ListExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status 
/// [ PlaceAfter = GetIdFromCodeOrDescription ]
ClassMethod ListExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod ListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListExecute ]
{
}

Query List() As %Library.Query(CONTAINID = 0, ROWSPEC = "code:%String,caption:%String,selected:%Boolean")
{
}

Query FindFunctionPreferences() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,appKey:%String,appSubKey:%String,Description:%String")
{
SELECT ID,appKey,appSubKey,Description FROM epr.FunctionPreferences
ORDER BY Description
}

Storage Default
{
<Data name="FunctionPreferencesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>appKey</Value>
</Value>
<Value name="3">
<Value>appSubKey</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^epr.FunctionPreferencesD</DataLocation>
<DefaultData>FunctionPreferencesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.FunctionPreferencesD</IdLocation>
<IndexLocation>^epr.FunctionPreferencesI</IndexLocation>
<StreamLocation>^epr.FunctionPreferencesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
