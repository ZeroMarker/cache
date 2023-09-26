/// d ##class(dhc.ca.cache.comm.XMLScrollCollData).Populate(10)
/// Set t = ##class(dhc.ca.cache.comm.XMLScrollCollData).%OpenId(5)
/// Do t.XMLExport()
/// Class dhc.ca.cache.comm.XMLScrollCollData Extends (%Persistent, %XML.Adaptor, %Populate) [ ClassType = persistent, Not ProcedureBlock ]
Class dhc.ca.cache.comm.XMLScrollCollData Extends (%SerialObject, %XML.Adaptor, %Populate) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "chart";

Property palette As %String(TRUNCATE = 1, XMLNAME = "palette", XMLPROJECTION = "ATTRIBUTE");

Property caption As %String(TRUNCATE = 1, XMLNAME = "caption", XMLPROJECTION = "ATTRIBUTE");

Property shownames As %String(TRUNCATE = 1, XMLNAME = "shownames", XMLPROJECTION = "ATTRIBUTE");

Property showvalues As %String(TRUNCATE = 1, XMLNAME = "showvalues", XMLPROJECTION = "ATTRIBUTE");

Property numberPrefix As %String(TRUNCATE = 1, XMLNAME = "numberPrefix", XMLPROJECTION = "ATTRIBUTE");

Property useRoundEdges As %String(TRUNCATE = 1, XMLNAME = "useRoundEdges", XMLPROJECTION = "ATTRIBUTE");

Property legendBorderAlpha As %String(TRUNCATE = 1, XMLNAME = "legendBorderAlpha", XMLPROJECTION = "ATTRIBUTE");

Property categories As %String(TRUNCATE = 1);

Storage Default
{
<Data name="XMLScrollCollDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>palette</Value>
</Value>
</Data>
<Data name="XMLScrollCollDataState">
<Subscript>"dhc.ca.cache.comm.XMLScrollCollData"</Subscript>
<Value name="1">
<Value>palette</Value>
</Value>
<Value name="2">
<Value>caption</Value>
</Value>
<Value name="3">
<Value>numberPrefix</Value>
</Value>
<Value name="4">
<Value>shownames</Value>
</Value>
<Value name="5">
<Value>showvalues</Value>
</Value>
<Value name="6">
<Value>legendBorderAlpha</Value>
</Value>
<Value name="7">
<Value>useRoundEdges</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>categories</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.XMLScrollCollDataD</DataLocation>
<DefaultData>XMLScrollCollDataDefaultData</DefaultData>
<IdLocation>^dhc.ca.c.XMLScrollCollDataD</IdLocation>
<IndexLocation>^dhc.ca.c.XMLScrollCollDataI</IndexLocation>
<State>XMLScrollCollDataState</State>
<StreamLocation>^dhc.ca.c.XMLScrollCollDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
