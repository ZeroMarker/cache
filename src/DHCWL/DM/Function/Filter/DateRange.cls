Class DHCWL.DM.Function.Filter.DateRange Extends DHCWL.DM.Function.FunctionInterface
{

Property StartDateI As %Integer;

Property EndDateI As %Integer;

Property StepNum As %Integer;

Method %OnNew(params As %List) As %Status [ Private, ServerOnly = 1 ]
{
	s startDate=$lg(params,1)
	s endDate=$lg(params,2)
	s step=$lg(params,3,1)
	s ..StartDateI=$zdh(startDate,3)
	s ..EndDateI=$zdh(endDate,3)
	s ..StepNum=step
	q $$$OK
}

Method Eval() As %DataType
{
	s c=0,lb=$lb()
	f i=..StartDateI:..StepNum:..EndDateI d
	.s c=c+1
	.s $list(lb,c)=i
	q lb
}

Storage Default
{
<Data name="DateRangeState">
<Subscript>"DateRange"</Subscript>
<Value name="1">
<Value>StartDateI</Value>
</Value>
<Value name="2">
<Value>EndDateI</Value>
</Value>
<Value name="3">
<Value>StepNum</Value>
</Value>
</Data>
<State>DateRangeState</State>
<Type>%Storage.Serial</Type>
}

}
