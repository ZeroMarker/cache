Class DHCWL.DM.Function.Agg.Sum Extends AggInterface
{

Property IsNewDim As %Boolean [ Private ];

Property Result As %Double [ Private ];

Method %OnNew(initVal = "") As %Status [ Private, ServerOnly = 1 ]
{
  s ..IsNewDim=0
  s ..Result=0
  q $$$OK
}

Method Eval(metricList As %List = "") As %DataType
{
	if (..IsNewDim){
	  s sum=..Result
	  s ..IsNewDim=0
	  s ..Result=0
	  q sum
	}
	if '$lv(metricList) q 0
	s len=$ll(metricList),sum=0
	f i=1:1:len{
      s sum=sum+$lg(metricList,i,0)
	}
	s ..Result=..Result+sum
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
<Data name="SumState">
<Subscript>"Sum"</Subscript>
<Value name="1">
<Value>IsNewDim</Value>
</Value>
<Value name="2">
<Value>Result</Value>
</Value>
</Data>
<State>SumState</State>
<Type>%Storage.Serial</Type>
}

}
