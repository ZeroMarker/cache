Class epr.Task Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 8;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Code";

Parameter SQLDESCRIPTION = "Description";

Parameter SQLROWID = "ID";

Property Code As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property LinkComponent As websys.Component;

Property LinkExpression As websys.Expression;

Query TaskList(Code As %Library.String = "", Description As %Library.String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Description,Code,LinkComponent,LinkExpression")
{
SELECT ID, Description, Code, LinkComponent->Name, LinkExpression
FROM epr.Task
WHERE ((Description %STARTSWITH :Description) OR (:Description IS NULL))
AND ((Code %STARTSWITH :Code) OR (:Code IS NULL))
}

Storage Default
{
<Data name="TaskDefaultData">
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
<Value>LinkComponent</Value>
</Value>
<Value name="5">
<Value>LinkExpression</Value>
</Value>
</Data>
<DataLocation>^epr.TaskD</DataLocation>
<DefaultData>TaskDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.TaskD</IdLocation>
<IndexLocation>^epr.TaskI</IndexLocation>
<StreamLocation>^epr.TaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
