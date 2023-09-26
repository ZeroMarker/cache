/// d ##class(DHCWL.PerMis.RptType).%BuildIndices()
Class DHCWL.PerMis.RptType Extends %Persistent
{

Property TypeName As %String(COLLATION = "EXACT");

Property ExcCode As %String(COLLATION = "EXACT", MAXLEN = 150);

Index InxTypeName On TypeName;

Storage Default
{
<Data name="RptTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeName</Value>
</Value>
<Value name="3">
<Value>ExcCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.PerMis.RptTypeD</DataLocation>
<DefaultData>RptTypeDefaultData</DefaultData>
<IdLocation>^DHCWL.PerMis.RptTypeD</IdLocation>
<IndexLocation>^DHCWL.PerMis.RptTypeI</IndexLocation>
<StreamLocation>^DHCWL.PerMis.RptTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
