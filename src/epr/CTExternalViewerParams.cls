Class epr.CTExternalViewerParams Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 17;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Name";

Parameter SQLDESCRIPTION = "Name";

Parameter SQLROWID = "ID";

Property Name As %Library.String(COLLATION = "ALPHAUP", MAXLEN = "", SELECTIVITY = "", TRUNCATE = 1);

Property DatabaseElement As %Library.String(MAXLEN = "", SELECTIVITY = 1.5, TRUNCATE = 1);

Property ExternalViewerDR As epr.CTExternalViewer;

ClassMethod AddParameter(compref As %String, ParRef As %String = "")
{
}

ClassMethod websysSave(compref As %String, ParRef As %String)
{
}

Storage Default
{
<Data name="CTExternalViewerParamsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DatabaseElement</Value>
</Value>
<Value name="3">
<Value>ExternalViewerDR</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^epr.CTExternalViewerParamsD</DataLocation>
<DefaultData>CTExternalViewerParamsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTExternalViewerParamsD</IdLocation>
<IndexLocation>^epr.CTExternalViewerParamsI</IndexLocation>
<StreamLocation>^epr.CTExternalViewerParamsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
