Class epr.CTTextTranslation Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TRNCode";

Parameter SQLDESCRIPTION = "TRNDesc";

Parameter SQLROWID = "ID";

Property TRNCode As %String(TRUNCATE = 1) [ Required ];

Property TRNDesc As %String(TRUNCATE = 1);

Property TRNDesc2 As %String(TRUNCATE = 1);

Query Find(Desc1 As %String, Desc2 As %String) As %SQLQuery
{
SELECT ID,TRNCode,TRNDesc,TRNDesc2 FROM CTTextTranslation 
WHERE (((%ALPHAUP TRNDesc %STARTSWITH %ALPHAUP :Desc1)OR(:Desc1 IS NULL)) AND ((%ALPHAUP TRNDesc2 %STARTSWITH %ALPHAUP :Desc2) OR (:Desc2 IS NULL)))
}

Storage Default
{
<Data name="CTTextTranslationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TRNCode</Value>
</Value>
<Value name="3">
<Value>TRNDesc</Value>
</Value>
<Value name="4">
<Value>TRNDesc2</Value>
</Value>
</Data>
<DataLocation>^epr.CTTextTranslationD</DataLocation>
<DefaultData>CTTextTranslationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTTextTranslationD</IdLocation>
<IndexLocation>^epr.CTTextTranslationI</IndexLocation>
<StreamLocation>^epr.CTTextTranslationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
