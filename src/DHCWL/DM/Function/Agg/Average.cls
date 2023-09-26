Class DHCWL.DM.Function.Agg.Average Extends AggInterface
{

Property IsNewDim As %Boolean [ Private ];

Property Sum As %Double [ Private ];

Property Count As %Integer [ Private ];

Method %OnNew(initVal = "") As %Status [ Private, ServerOnly = 1 ]
{
  s ..IsNewDim=0
  s ..Sum=0
  s ..Count=0
  q $$$OK
}

Method Eval(metricList As %List = "") As %DataType
{
	if (..IsNewDim){
		s cnt=..Count,sum=..Sum
		if (cnt=0){
			s ..IsNewDim=0
	  	s ..Sum=0,..Count=0
			q 0
		}
	  s ..IsNewDim=0
	  s ..Sum=0,..Count=0
	  q sum/ cnt
	}
	if '$lv(metricList) q 0
	s len=$ll(metricList)
	s ts=0
	f i=1:1:len{
      s ts=ts+$lg(metricList,i,0)
	}
	s ..Sum=..Sum+ts
	s ..Count=..Count+len
	q 1
}

Method SetNewDim(isNewDim As %Boolean)
{
    s ..IsNewDim=isNewDim
}

Method SetInteralResult(isInteral As %Boolean)
{
}

Storage Default
{
<Data name="AverageState">
<Subscript>"Average"</Subscript>
<Value name="1">
<Value>IsNewDim</Value>
</Value>
<Value name="2">
<Value>Sum</Value>
</Value>
<Value name="3">
<Value>Count</Value>
</Value>
</Data>
<State>AverageState</State>
<Type>%Storage.Serial</Type>
}

}
