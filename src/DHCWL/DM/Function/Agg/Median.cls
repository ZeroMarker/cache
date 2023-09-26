Class DHCWL.DM.Function.Agg.Median Extends AggInterface
{

Property IsNewDim As %Boolean [ Private ];

Method %OnNew(initVal = "") As %Status [ Private, ServerOnly = 1 ]
{
  s ..IsNewDim=0
  k ^temp($j,"WLDMMEDIAN")
  q $$$OK
}

Method Eval(metricList As %List = "") As %DataType
{
	if (..IsNewDim){
	  s ..IsNewDim=0
	  s len=$g(^temp($j,"WLDMMEDIAN"),0)
	  s ei=len\2
	  i (len # 2)'=0 {
		s ei=ei+1
	  }
	  s i=0,result=0
	  s v="" f{
		s v=$o(^temp($j,"WLDMMEDIAN",v))
		q:v=""
		s i=i+1
		if i=ei{
		  s result=v 
		  i (len # 2)'=0{ 
		  }else{
			s result=result+$o(^temp($j,"WLDMMEDIAN",v))
			s result=result/2
		  }
		  q	
		}
	  }
	  k ^temp($j,"WLDMMEDIAN")
	  q result
	}
	if '$lv(metricList) q 0
	s len=$ll(metricList)
	f i=1:1:len{
	  s v=$lg(metricList,i,"")
      if v'="" {
	    s ^temp($j,"WLDMMEDIAN",v)=""
	    s vi=$i(^temp($j,"WLDMMEDIAN"))
      }
	}
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
<Data name="MedianState">
<Subscript>"Median"</Subscript>
<Value name="1">
<Value>IsNewDim</Value>
</Value>
</Data>
<State>MedianState</State>
<Type>%Storage.Serial</Type>
}

}
