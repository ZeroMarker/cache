Class web.find1 Extends %Persistent
{

Query keydown() As %Query(ROWSPEC = "")
{
}

ClassMethod keydownExecute(ByRef qHandle As %Binary) As %Status
{
	Quit $$$OK
}

ClassMethod keydownClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = keydownExecute ]
{
	Quit $$$OK
}

ClassMethod keydownFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = keydownExecute ]
{
	Quit $$$OK
}

Storage Default
{
<Data name="find1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.find1D</DataLocation>
<DefaultData>find1DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.find1D</IdLocation>
<IndexLocation>^web.find1I</IndexLocation>
<StreamLocation>^web.find1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
