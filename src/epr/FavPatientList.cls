Class epr.FavPatientList Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "Name";

Parameter SQLROWID = "ID";

Property Name As %String(TRUNCATE = 1);

Property DefaultList As %Boolean [ InitialExpression = 0 ];

Property Patients As array Of %String(TRUNCATE = 1);

Property UserDR As User.SSUser;

Index UserIndex On UserDR;

ClassMethod GetDefaultList(UserID As %String = "") As %String
{
}

ClassMethod CreateDefaultList(UserID As %String = "") As %String
{
}

Query LookUpByUserID(desc As %String, UserID As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String")
{
SELECT Name,ID
FROM epr.FavPatientList
WHERE ((UserDR->SSUSR_RowId = :UserID)
AND (%ALPHAUP Name %STARTSWITH %ALPHAUP :desc))
}

ClassMethod LookUpBrokerByUserID(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", UserID As %String = "") As %Boolean
{
}

ClassMethod websysSaveList(compref As %String, id As %String)
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

/// ab 25.09.03 - adds a patient to a favourites list
ClassMethod AddEpsToList(ListID As %String = "", PatientIDs As %String = "") As %Boolean
{
}

/// ab 26.09.03 - removes a patient from a favourites list
ClassMethod RemEpsFromList(ListID As %String = "", PatientID As %String = "")
{
}

/// ab 26.09.03 - returns a delimited string of patients from a favourites list
ClassMethod GetEpsList(ListID As %String = "", delim As %String = "") As %String
{
}

Storage Default
{
<Data name="FavPatientListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DefaultList</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>UserDR</Value>
</Value>
</Data>
<Data name="Patients">
<Attribute>Patients</Attribute>
<Structure>subnode</Structure>
<Subscript>"Patients"</Subscript>
</Data>
<DataLocation>^epr.FavPatientListD</DataLocation>
<DefaultData>FavPatientListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.FavPatientListD</IdLocation>
<IndexLocation>^epr.FavPatientListI</IndexLocation>
<StreamLocation>^epr.FavPatientListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
