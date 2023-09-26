Class DHCWL.util.Stack Extends %RegisteredObject
{

Property stackArr As %Library.ListOfDataTypes;

/*
s stack=##class(DHCWL.util.Stack).Init()
w stack.Push("a")
w stack.Push("b")
w stack.Push("c")
w stack.Pop()
w stack.Pop()
w stack.Pop()
*/
ClassMethod Init() As DHCWL.util.Stack
{
	s stack=##class(DHCWL.util.Stack).%New()
	s stack.stackArr=##class(%Library.ListOfDataTypes).%New()
	q stack
}

Method Push(element) As %Status
{
	q ..stackArr.Insert(element)
}

Method Pop()
{
	if (..HasMore()){
		s ele= ..stackArr.GetAt(..stackArr.Count())
		d ..stackArr.RemoveAt(..stackArr.Count())
		q ele
	}else {
		q ""
	}
}

Method Peek()
{
	if (..HasMore()){
		q ..stackArr.GetAt(..stackArr.Count())
	}else {
		q ""
	}
}

Method HasMore() As %Status
{
	q ..stackArr.Count()>0
}

Method Size() As %Integer
{
	q ..stackArr.Count()
}

}
