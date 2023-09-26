Class DHCWL.DM.Function.Filter.Contain Extends DHCWL.DM.Function.FunctionInterface
{

Property arr [ MultiDimensional ];

Property emp;

Method %OnNew(startStrPara As %List) As %Status [ Private, ServerOnly = 1 ]
{
	s par=$lg(startStrPara,1,"")
	if $lv(par){
	  s len=$ll(par)
	  f i=1:1:len{
		s v=$lg(par,i,"")
		continue:v=""
		s ..arr(v)=""
	  }
	}else{
	  s ..arr(par)=""	
	}
	s ..emp=$c(0)
	q $$$OK
}

Method Eval(runtimeParams As %List) As %DataType
{
	s v=$lg(runtimeParams,1,"")
	q:v="" 0
	q $d(..arr(v))=1
}

Storage Default
{
<Data name="ContainState">
<Subscript>"Contain"</Subscript>
<Value name="1">
<Value>emp</Value>
</Value>
</Data>
<State>ContainState</State>
<Type>%Storage.Serial</Type>
}

}
