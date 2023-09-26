Include TRAK

IncludeGenerator TRAK

/// Generates a list of csp frame pages to be referenced for storing preferences for frame sizes in frameset tags.
Class epr.FramePreference Extends (%Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 58;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Code";

Parameter SQLDESCRIPTION = "Description";

Parameter SQLROWID = "ID";

Property Code As %String(MAXLEN = 999, TRUNCATE = 1);

Property Description As %String(MAXLEN = 999, TRUNCATE = 1);

Property DefaultSize As %String(MAXLEN = 999, TRUNCATE = 1);

Property DefaultBorder As %Boolean;

Index CodeIndex On Code [ Unique ];

/// convert the code to lowercase as these should be csp pages
Method CodeSet(val As %Library.String) As %Library.Status
{
}

ClassMethod AddItem(Code As %String, Description As %String, DefaultSize As %String, DefaultBorder As %Boolean = 1, AddOnlyIfNew As %Boolean = 0) As %String
{
}

/// modify frames description so that sites can have it in their own language
ClassMethod UpdateItem(Code As %String, Description As %String) As %String
{
}

/// run this method if changing default sizes,default description,etc with AddOnlyIfNew=0
/// screen epr.FramePreference.List calls this with AddOnlyIfNew=1
ClassMethod Generate(AddOnlyIfNew As %Boolean = 0)
{
}

ClassMethod FindPreferenceExecute(ByRef qHandle As %Binary, SSGroupID As %String = "") As %Status
{
}

ClassMethod FindPreferenceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreferenceExecute ]
{
}

ClassMethod FindPreferenceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreferenceFetch ]
{
}

/// by wuqk 2011-05-31
ClassMethod GetData(SiteCode As %Library.String, GroupID As %Library.String, pagecode As %Library.String, ByRef border As %Library.String = 1) As %String
{
}

ClassMethod ValidateSize(default As %Library.String, ByRef newpref As %Library.String = 1)
{
}

ClassMethod websysSavePreferences(compref As %String)
{
}

Query FindPreference(SSGroupID As %Library.String) As %Query(ROWSPEC = "FrameCode:%String,FrameDesc:%String,FrameSizes:%String,FrameBorder:%Boolean,PrefType:%String,DefaultSizes:%String")
{
}

Storage Default
{
<Data name="FramePreferenceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>DefaultSize</Value>
</Value>
<Value name="5">
<Value>DefaultBorder</Value>
</Value>
</Data>
<DataLocation>^epr.FramePreferenceD</DataLocation>
<DefaultData>FramePreferenceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.FramePreferenceD</IdLocation>
<IndexLocation>^epr.FramePreferenceI</IndexLocation>
<StreamLocation>^epr.FramePreferenceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
