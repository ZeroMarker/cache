Class DHCWL.DM.Function.Agg.Max Extends AggInterface
{

Property IsNewDim As %Boolean [ Private ];

Property Result As %Double [ Private ];

Property IsInitFlag As %Boolean [ Private ];

Method %OnNew(initVal = "") As %Status [ Private, ServerOnly = 1 ]
{
  s ..IsNewDim=0
  s ..Result=0
  s ..IsInitFlag=1
  q $$$OK
}

Method SetNewDim(isNewDim As %Boolean)
{
    s ..IsNewDim=isNewDim
}

Method Eval(metricList As %List = "") As %DataType
{
	if (..IsNewDim){
		s ..IsInitFlag=1
	  q ..Result
	}
	if '$lv(metricList) q 0
	if (..IsInitFlag){
		s ..Result=$lg(metricList,1)
		s ..IsInitFlag=0
	}
	s len=$ll(metricList),val=0,res=..Result
	f i=1:1:len{
		s val=$lg(metricList,i,0)
		if val>res{
			s res=val
		}
	}
	s ..Result=res
}

}
