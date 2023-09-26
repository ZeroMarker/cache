Class DHCWL.CommonUtil.FilterUtil Extends %RegisteredObject
{

ClassMethod EqualIgNull(a, b)
{
	 
	if (b="") q 1
	q a=b
}

ClassMethod EqualNull(a, b)
{
	 
	q:b="" 1
	q a=b
}

ClassMethod EqualCase(a, b)
{
	 
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
	q a=b
}

ClassMethod EqualCaseNull(a, b)
{
	 
	q:b="" 1
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
	q a=b
}

ClassMethod FirstLike(a, b) As %Boolean
{
	 
    s ind=$f(a,b)
    q (ind-$l(b)-1)=0
}

ClassMethod EndWith(a, b) As %Boolean
{
	 
	s ind=$f(a,b)
	q $l(a)=(ind-1)
}

ClassMethod FirstLikeNull(a, b) As %Boolean
{
	 
	q:b="" 1
    s ind=$f(a,b)
    q (ind-$l(b)-1)=0
}

ClassMethod EndWithNull(a, b) As %Boolean
{
	 
	q:b="" 1
	s ind=$f(a,b)
	q $l(a)=(ind-1)
}

ClassMethod FirstLikeCase(a, b) As %Boolean
{
	 
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
    s ind=$f(a,b)
    q (ind-$l(b)-1)=0
}

ClassMethod EndWithCase(a, b) As %Boolean
{
	 
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
	s ind=$f(a,b)
	q $l(a)=(ind-1)
}

ClassMethod FirstLikeNullCase(a, b) As %Boolean
{
	 
	q:b="" 1
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
    s ind=$f(a,b)
    q (ind-$l(b)-1)=0
}

ClassMethod EndWithCaseNull(a, b) As %Boolean
{
	 
	q:b="" 1
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
	s ind=$f(a,b)
	q $l(a)=(ind-1)
}

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:： 忽略大小写的LIKE
/// Table：       
/// Input：        a:操作数1,b:操作数2
/// Output：       
/// Return：       1:a包含b;0:a不包含b
/// Others：       w 
/// 	W ##class(DHCWL.CommonUtil.FilterUtil).LikeCase("BCD","E")
ClassMethod LikeCase(a, b) As %Boolean
{
	s a=$zcvt(a,"U"),b=$zcvt(b,"U")
    s ind=$f(a,b)
    q (ind>0)
}

}
