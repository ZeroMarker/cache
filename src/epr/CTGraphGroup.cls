/// Log 44734 - AI - 24-09-2004 : Class created.
/// NOTE: This class has "children" of type epr.CTGraphDefinition, but couldn't set up proper parent/child relationship as epr.CTGraphDefinition existed first.
Class epr.CTGraphGroup Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "GGRPCode";

Parameter SQLDESCRIPTION = "GGRPDesc";

Parameter SQLROWID = "ID";

Property GGRPCode As %Library.String(COLLATION = "ALPHAUP", TRUNCATE = 1) [ Required ];

Property GGRPDesc As %Library.String(TRUNCATE = 1);

Property GGRPSelectedGraphs As %Library.String(TRUNCATE = 1);

ClassMethod GetSelectedGraphs(groupid As %String = "") As %Library.String
{
}

ClassMethod websysSave(compref As %String, id As %String = "", selectedgraphs As %Library.String = "")
{
}

Storage Default
{
<Data name="CTGraphGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GGRPCode</Value>
</Value>
<Value name="3">
<Value>GGRPDesc</Value>
</Value>
<Value name="4">
<Value>GGRPSelectedGraphs</Value>
</Value>
</Data>
<DataLocation>^epr.CTGraphGroupD</DataLocation>
<DefaultData>CTGraphGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTGraphGroupD</IdLocation>
<IndexLocation>^epr.CTGraphGroupI</IndexLocation>
<StreamLocation>^epr.CTGraphGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
