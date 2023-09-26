Class User.FristXML Extends (%Persistent, %XML.Adaptor, %Populate) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// /Do ##class(User.FristXML).Populate(10)
/// /Set company = ##class(User.FristXML).%OpenId(1)
/// /Do company.XMLExport()
Parameter XMLNAME = "CompanyData";

Property City As %String(POPSPEC = "City()", TRUNCATE = 1);

Property Mission As %String(MAXLEN = 500, POPSPEC = "Mission()", TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property YearFounded As %Integer(POPSPEC = "Integer(1975,2000)");

Storage Default
{
<Data name="FristXMLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CompanyID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>City</Value>
</Value>
<Value name="5">
<Value>Mission</Value>
</Value>
<Value name="6">
<Value>YearFounded</Value>
</Value>
</Data>
<DataLocation>^User.FristXMLD</DataLocation>
<DefaultData>FristXMLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.FristXMLD</IdLocation>
<IndexLocation>^User.FristXMLI</IndexLocation>
<StreamLocation>^User.FristXMLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
