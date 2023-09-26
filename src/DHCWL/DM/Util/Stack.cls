Class DHCWL.DM.Util.Stack Extends %RegisteredObject
{

Property arrMap [ MultiDimensional ];

Method Push(value)
{
	s ..arrMap=$g(..arrMap,0)+1
	s i=..arrMap
	s ..arrMap(i)=value
}

Method Pop()
{
	s i=$g(..arrMap,0)
	q:i<1 ""
	s ..arrMap=i-1
	q ..arrMap(i)
}

Method Peek()
{
	s i=$g(..arrMap,0)
	q:i<1 ""
	q ..arrMap(i)
}

Method Size() As %Integer
{
	q $g(..arrMap,0)
}

Method Clear()
{
	s ..arrMap=0
}

}
