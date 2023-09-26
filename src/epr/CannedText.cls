/// similar to MRCNursingNoteCodes table
/// quick code substitution for long text
/// but ability to save against site/user/group etc
Class epr.CannedText Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 41;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Code";

Parameter SQLDESCRIPTION = "Text";

Parameter SQLROWID = "ID";

Index IndexReference On (ReferenceType, ReferenceID, Code) [ Unique ];

Index IndexCode On (Code, ReferenceType, ReferenceID);

Property Code As %String(TRUNCATE = 1) [ Required ];

/// this code is saved against referenced rowid for corresponding ReferenceType
/// if Reference Type ="User.SSUser" then ReferenceID is the SSUser rowid
Property ReferenceID As %String(TRUNCATE = 1) [ Required ];

/// this code is saved against type of: user/group/site etc
Property ReferenceType As %String(TRUNCATE = 1) [ Required ];

/// the long text
Property Text As list Of %String(MAXLEN = "", TRUNCATE = 0) [ Required ];

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
}

/// remove all spaces from code
Method CodeSet(val As %Library.String) As %Library.Status
{
}

ClassMethod GetData(Code As %String = "", UsrID As %String = "", GrpID As %String = "", HosID As %String = "", TrsID As %String = "", Site As %String = "", ByRef RefType As %String = "", ByRef RefID As %String = "") As %String
{
}

ClassMethod SetData(Code As %String, ReferenceType As %String, ReferenceID As %String, Data As %String) As %Status
{
}

ClassMethod KillData(Code As %String, ReferenceType As %String, ReferenceID As %String) As %Status
{
}

ClassMethod websysSaveSetup(compref) [ ProcedureBlock = 0 ]
{
}

ClassMethod websysDeleteSetup(compref) [ ProcedureBlock = 0 ]
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary) As %Status
{
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
{
}

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
}

Query Find() As %Query(ROWSPEC = "ID:%String:ID,Code:%String:Code,Text:%String:Text,ReferenceType:%String,ReferenceID:%String,ReferenceIDDesc:%String")
{
}

/// fldName is not used in the query, only in the broker, but pass anyway so params are matched
ClassMethod LookUpCodeExecute(ByRef qHandle As %Binary, val As %String = "", fldName As %String = "") As %Status
{
}

ClassMethod LookUpCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCodeExecute ]
{
}

ClassMethod LookUpCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpCodeExecute ]
{
}

Query LookUpCode(val As %String, fldName As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod LookUpCodeBroker(val As %Library.String = "", fldName As %String = "") As %Library.Boolean
{
}

Storage Default
{
<Data name="CannedTextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Text</Value>
</Value>
<Value name="4">
<Value>ReferenceID</Value>
</Value>
<Value name="5">
<Value>ReferenceType</Value>
</Value>
</Data>
<DataLocation>^epr.CannedTextD</DataLocation>
<DefaultData>CannedTextDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CannedTextD</IdLocation>
<IndexLocation>^epr.CannedTextI</IndexLocation>
<StreamLocation>^epr.CannedTextS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
