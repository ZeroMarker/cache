Class CHSSWeb.P8ActiveAll Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ActiveAll() As %String
{
	w ##class(CHSSWeb.P8Active).ActiveAll()
	w ##class(CHSSWeb.P8Active2).ActiveAll()
	w ##class(CHSSWeb.P8Active3).ActiveAll()
	w ##class(CHSSWeb.P8Active4).ActiveAll()
	
	,!
	w ""
	,!
	w "P8所有激活已执行完毕"
	,!
	
	q ""
}

Storage Default
{
<Data name="P8ActiveAllDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.P8ActiveAllD</DataLocation>
<DefaultData>P8ActiveAllDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.P8ActiveAllD</IdLocation>
<IndexLocation>^CHSSWeb.P8ActiveAllI</IndexLocation>
<StreamLocation>^CHSSWeb.P8ActiveAllS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
