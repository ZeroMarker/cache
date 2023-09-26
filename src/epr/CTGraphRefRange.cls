Class epr.CTGraphRefRange Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "GREFCode";

Parameter SQLDESCRIPTION = "GREFDesc";

Parameter SQLROWID = "ID";

Property GREFCode As %Library.String(COLLATION = "ALPHAUP", TRUNCATE = 1) [ Required ];

Property GREFDesc As %Library.String(TRUNCATE = 1);

Property GREFXAxisIncrement As %Library.String(TRUNCATE = 1);

Index UniqueCodeIndex On GREFCode [ Unique ];

Index UniqueDescriptionIndex On GREFDesc [ Unique ];

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String = "")
{
}

Storage Default
{
<Data name="CTGraphRefRangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GREFCode</Value>
</Value>
<Value name="3">
<Value>GREFDesc</Value>
</Value>
<Value name="4">
<Value>GREFXCoordinate</Value>
</Value>
<Value name="5">
<Value>GREFYCoordinate</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>GREFXAxisIncrement</Value>
</Value>
</Data>
<DataLocation>^epr.CTGraphRefRangeD</DataLocation>
<DefaultData>CTGraphRefRangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTGraphRefRangeD</IdLocation>
<IndexLocation>^epr.CTGraphRefRangeI</IndexLocation>
<StreamLocation>^epr.CTGraphRefRangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
