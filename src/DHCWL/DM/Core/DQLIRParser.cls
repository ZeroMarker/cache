Class DHCWL.DM.Core.DQLIRParser Extends %RegisteredObject
{

Property ResultSetName As %String;

Property Children As %ListOfObjects;

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	s ..Children=##class(%ListOfObjects).%New()
	q $$$OK
}

ClassMethod SearchDown(node As DQLIRParser, resultSetName) As DQLIRParser
{
	q:node="" ""
	if node.ResultSetName=resultSetName q node
	s len=node.Children.Count()
	s result=""
	f i=1:1:len {
	  s result=..SearchDown(node.Children.GetAt(i),resultSetName)
	  q:result'=""
	}
	q result
}

Method Parse() As %Status
{
}

}
