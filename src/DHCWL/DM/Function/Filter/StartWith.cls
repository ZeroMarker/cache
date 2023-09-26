Class DHCWL.DM.Function.Filter.StartWith Extends DHCWL.DM.Function.FunctionInterface
{

Property StartStr As %String;

Property SSLen As %Integer;

Method %OnNew(startStrPara As %List) As %Status [ Private, ServerOnly = 1 ]
{
	s ..StartStr=$lg(startStrPara,1,"")
	s ..SSLen=$l(..StartStr)+1
	q $$$OK
}

Method Eval(runtimeParams As %List) As %DataType
{
	q:'$lv(runtimeParams) 0
	q $F($list(runtimeParams,1),..StartStr)=..SSLen
}

Storage Default
{
<Data name="StartWithState">
<Subscript>"StartWith"</Subscript>
<Value name="1">
<Value>StartStr</Value>
</Value>
<Value name="2">
<Value>SSLen</Value>
</Value>
</Data>
<State>StartWithState</State>
<StreamLocation>^DHCWL.DM.FunctioEF54.StartWithS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
