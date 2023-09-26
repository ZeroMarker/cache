Class dhc.bonus.zhaowei.purelab Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others: w ##class(dhc.bonus.zhaowei.purelab).test()
ClassMethod test()
{
	w "test"
	d ..hello()
	q 0
}

/// others: w ##class(dhc.bonus.zhaowei.purelab).hello(5)
ClassMethod hello(it)
{
	n (it)
	s a=it,b=7
	i a=5 d
	.s a=6,b=8
	.w "this is do"
	.w b
	i a=6 d
	.s b=9
	.w "b"_b
	
	w "hello"
	w "a"_a,!,b
	q 0
}

/// others: w ##class(dhc.bonus.zhaowei.purelab).myfortry()
ClassMethod myfortry()
{
	
	for i=1:1:5
	{
	s w=i

	i i=3!i=2 s w=i*i

	w w,!}
	q ""
}

Storage Default
{
<StreamLocation>^dhc.bonus.zhaowei.purelabS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
