Class epr.CTWorklistItemDef Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WITName";

Parameter SQLDESCRIPTION = "WITDesc";

Parameter SQLROWID = "ID";

Property WITComponentDR As websys.Component;

Property WITDefaultParamsDR As epr.WorklistItemParams;

Property WITDesc As %Library.String(TRUNCATE = 1) [ Required ];

Property WITName As %Library.String(TRUNCATE = 1) [ Required ];

Property WITParamComponentDR As websys.Component;

Property WITUrl As %Library.String(TRUNCATE = 1);

/// Index for property WITDesc
Index WITDescIndex On WITDesc;

/// Index for property WITName
Index WITNameIndex On WITName;

ClassMethod LookUpBrokerByName(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// KM 26-Apr-2001: Called From epr.Chart.websysSave
Query Find() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,WITName:%Library.String,WITDesc:%Library.String,WITUrl:%Library.String,WITComponentDR:%String")
{
SELECT ID, WITName, WITDesc, WITUrl, WITComponentDR
FROM CTWorklistItemDef
}

Query LookUpByName(name As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Component:%String")
{
SELECT WITName,ID,WITDesc,WITComponentDR->Name
FROM epr.CTWorklistItemDef
WHERE %ALPHAUP WITName %STARTSWITH %ALPHAUP :name
}

Storage Default
{
<Data name="CTWorklistItemDefClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="CTWorklistItemDefDefaultData">
<Value name="1">
<Value>ComponentDR</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Url</Value>
</Value>
<Value name="5">
<Value>WITComponentDR</Value>
</Value>
<Value name="6">
<Value>WITDesc</Value>
</Value>
<Value name="7">
<Value>WITName</Value>
</Value>
<Value name="8">
<Value>WITUrl</Value>
</Value>
<Value name="9">
<Value>WITClass</Value>
</Value>
<Value name="10">
<Value>WITDefaultParamsDR</Value>
</Value>
<Value name="11">
<Value>WITParamType</Value>
</Value>
<Value name="12">
<Value>WITParamComponentDR</Value>
</Value>
</Data>
<DataLocation>^epr.CTWorklistItemDefD</DataLocation>
<DefaultData>CTWorklistItemDefDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTWorklistItemDefD</IdLocation>
<IndexLocation>^epr.CTWorklistItemDefI</IndexLocation>
<StreamLocation>^epr.CTWorklistItemDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
