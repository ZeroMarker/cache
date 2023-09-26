Class DHCWL.DM.Function.DateConverter Extends %RegisteredObject
{

// w ##class(DHCWL.DM.Function.DateConverter).YM("2017-05-03")

ClassMethod YM(date As %String, ByRef result)
{
	;b ;2
	s result= $p(date,"-",1,2)
	q
}

}
