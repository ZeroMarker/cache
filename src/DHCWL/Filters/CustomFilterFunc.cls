Class DHCWL.Filters.CustomFilterFunc Extends %RegisteredObject [ Not ProcedureBlock ]
{

//w ##class(DHCWL.Filters.CustomFilterFunc).EndWith("abcdefg","fg")

ClassMethod EqualIgNull(a, b)
{
	n (a,b)
	if (b="") q 1
	q a=b
}

ClassMethod EqualNull(a, b)
{
	n (a,b)
	q:b="" 1
	q a=b
}

ClassMethod EqualCase(a, b)
{
	n (a,b)
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
	q a=b
}

ClassMethod EqualCaseNull(a, b)
{
	n (a,b)
	q:b="" 1
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
	q a=b
}

ClassMethod FirstLike(a, b) As %Boolean
{
	n (a,b)
    s ind=$f(a,b)
    q (ind-$l(b)-1)=0
}

ClassMethod EndWith(a, b) As %Boolean
{
	n (a,b)
	s ind=$f(a,b)
	q $l(a)=(ind-1)
}

ClassMethod FirstLikeNull(a, b) As %Boolean
{
	n (a,b)
	q:b="" 1
    s ind=$f(a,b)
    q (ind-$l(b)-1)=0
}

ClassMethod EndWithNull(a, b) As %Boolean
{
	n (a,b)
	q:b="" 1
	s ind=$f(a,b)
	q $l(a)=(ind-1)
}

ClassMethod FirstLikeCase(a, b) As %Boolean
{
	n (a,b)
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
    s ind=$f(a,b)
    q (ind-$l(b)-1)=0
}

ClassMethod EndWithCase(a, b) As %Boolean
{
	n (a,b)
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
	s ind=$f(a,b)
	q $l(a)=(ind-1)
}

ClassMethod FirstLikeNullCase(a, b) As %Boolean
{
	n (a,b)
	q:b="" 1
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
    s ind=$f(a,b)
    q (ind-$l(b)-1)=0
}

ClassMethod EndWithCaseNull(a, b) As %Boolean
{
	n (a,b)
	q:b="" 1
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
	s ind=$f(a,b)
	q $l(a)=(ind-1)
}

}
