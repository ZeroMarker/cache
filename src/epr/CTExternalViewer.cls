/// Code table defining external viewer types
Class epr.CTExternalViewer Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 129;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Code";

Parameter SQLDESCRIPTION = "Description";

Parameter SQLROWID = "ID";

Property Code As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property PACSSystem As %String(TRUNCATE = 1);

Property VirtualPath As %String(MAXLEN = 999, TRUNCATE = 1);

Property UserName As %String(TRUNCATE = 1);

Property UserValue As %String(TRUNCATE = 1);

Property Password As %String(TRUNCATE = 1);

Property PasswordValue As %String(TRUNCATE = 1);

Property ShowAlways As %String(TRUNCATE = 1);

Property CacheScript As %String(MAXLEN = "");

Property height As %Integer;

Property width As %Integer;

Property topLeftX As %Integer;

Property topLeftY As %Integer;

Property UseLoginUsr As %String(TRUNCATE = 1);

Property DoNotDisplayInResBanner As %String(TRUNCATE = 1);

Property ExeOrdersOnly As %String(TRUNCATE = 1);

Property StartingClass As %String(TRUNCATE = 1);

Property AETitle As %String(TRUNCATE = 1);

Index UniqueCodeIndex On Code [ Unique ];

ClassMethod ExternalViewerLink(OrderID As %Library.String = "", PatientID As %Library.String, EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetLink(EVID As %String, OrderID As %String, AccNo As %String, PatientID As %String, EpisodeID As %String) As %String
{
}

ClassMethod GetUserDefinedLink(ID As %String, EpisodeID As %String = "", OrdItemID As %String = "") As %String
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String = "")
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

Storage Default
{
<Data name="CTExternalViewerDefaultData">
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
<Value>PACSSystem</Value>
</Value>
<Value name="5">
<Value>VirtualPath</Value>
</Value>
<Value name="6">
<Value>Password</Value>
</Value>
<Value name="7">
<Value>UserName</Value>
</Value>
<Value name="8">
<Value>ShowAlways</Value>
</Value>
<Value name="9">
<Value>CacheScript</Value>
</Value>
<Value name="10">
<Value>height</Value>
</Value>
<Value name="11">
<Value>topLeftX</Value>
</Value>
<Value name="12">
<Value>topLeftY</Value>
</Value>
<Value name="13">
<Value>width</Value>
</Value>
<Value name="14">
<Value>DoNotDisplayInResBanner</Value>
</Value>
<Value name="15">
<Value>ExeOrdersOnly</Value>
</Value>
<Value name="16">
<Value>PasswordValue</Value>
</Value>
<Value name="17">
<Value>StartingClass</Value>
</Value>
<Value name="18">
<Value>UseLoginUsr</Value>
</Value>
<Value name="19">
<Value>UserValue</Value>
</Value>
<Value name="20">
<Value>AETitle</Value>
</Value>
</Data>
<DataLocation>^epr.CTExternalViewerD</DataLocation>
<DefaultData>CTExternalViewerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTExternalViewerD</IdLocation>
<IndexLocation>^epr.CTExternalViewerI</IndexLocation>
<StreamLocation>^epr.CTExternalViewerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
