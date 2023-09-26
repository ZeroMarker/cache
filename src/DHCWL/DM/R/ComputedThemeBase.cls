Class DHCWL.DM.R.ComputedThemeBase Extends %RegisteredObject
{

Property ResultSetName As %String;

Property FromThemPath As %String;

Property DimList As %ListOfObjects;

Property MetricList As %ListOfObjects;

Property IndexMap [ MultiDimensional ];

Property mask As %String [ Private ];

Method %OnNew(resultSetName) As %Status [ Private, ServerOnly = 1 ]
{
	s ..ResultSetName=resultSetName
	s ..DimList=##class(%ListOfObjects).%New()
	s ..MetricList=##class(%ListOfObjects).%New()
	s ..mask=$i(^DHCWL.DM.T.GlobalSN("THEME"))
	q $$$OK
}

Method GetDim(code) As ComputedThemeDims
{
  s code=$zcvt(code,"U")
  q:(code="")||('$d(..IndexMap(0,"NI",code))) ""
  s id=$o(..IndexMap(0,"NI",code,""))
  q ..DimList.GetAt(id)
}

Method GetMetric(code) As ComputedThemeMetrics
{
  s code=$zcvt(code,"U")
  q:(code="")||('$d(..IndexMap(1,"NI",code))) ""
  s id=$o(..IndexMap(1,"NI",code,""))
  q ..MetricList.GetAt(id)
}

Method GetDimById(id) As ComputedThemeDims
{
	q ..DimList.GetAt(id)
}

Method AddDim(name, dimStructList As %List, dimIndex As %Integer) As ComputedThemeDims
{
	s name2=$zcvt(name,"U")
	if ($d(..IndexMap(0,"NI",name2))) {
	  s id=$o(..IndexMap(0,"NI",name2,""))
	  q ..DimList.GetAt(id)
	}
	s dims=##class(ComputedThemeDims).%New(name,dimStructList,..DimList.Count()+1,dimIndex)
	d ..DimList.Insert(dims)
	s ..IndexMap(0,"NI",name2,..DimList.Count())=""
	q dims
}

Method AddMetric(name, metricStruct As %List) As ComputedThemeMetrics
{
	s name2=$zcvt(name,"U")
	if ($d(..IndexMap(1,"NI",name2))) {
	  s id=$o(..IndexMap(1,"NI",name2,""))
	  q ..MetricList.GetAt(id)
	}
	s metric=##class(ComputedThemeMetrics).%New(name,metricStruct,..MetricList.Count()+1)
	d ..MetricList.Insert(metric)
	s ..IndexMap(1,"NI",name2,..MetricList.Count())=""
	q metric
}

Method Mask() As %String
{
	q ..mask
}

Method ToString() As %String
{
  s json= "{""path"":"""_..GetPath()_""",""dims"":["
  s len=..DimList.Count()
  f i=1:1:len{
	s obj=..DimList.GetAt(i)
	s:i>1 json=json_","
	s json=json_"{""code"":"""_obj.Code_""",""sn"":"_obj.SerialNumber  _",""linkPath"":"""_obj.ProExpression_"""}"
  }
  s json=json_"],""metrics"":["
  s len=..MetricList.Count()
  f i=1:1:len{
	s obj=..MetricList.GetAt(i)
	s:i>1 json=json_","
	s json=json_"{""code"":"""_obj.Code_""",""sn"":"_obj.SerialNumber _"}"
  }
  s json=json_"]}"
  q json
}

Method GetPath() As %String
{
	q ..ResultSetName_" computed from "_..FromThemPath
}

Method GetMetricStructMap(metric = "") As %List
{
	s metric2=$zcvt(metric,"U")
	if ((metric'="")&&($d(..IndexMap(1,"NI",metric2)))){
	  s id=$o(..IndexMap(1,"NI",metric2,""))
	  s mobj=..MetricList.GetAt(id)
	  q:mobj="" $lb()
	  s struct=mobj.StructList
	  s mobj=""
	  q struct
	}
	s list=$lb()
	s len=..MetricList.Count(),j=0
	f i=1:1:len{
	  s mobj=..MetricList.GetAt(i)
	  continue:mobj=""
	  s j=j+1
	  s $list(list,j)=$lg(mobj.StructList,1),$list(list,j+1)=$lg(mobj.StructList,2)
	  s $list(list,j+2)=$lg(mobj.StructList,3),$list(list,j+3)=$lg(mobj.StructList,4)
	  s j=j+3
	}
	q list
}

Method GetMetricStruct(themeMetricCode = "") As %List
{
	q ..GetMetricStructMap(themeMetricCode)
}

Method GetDimStruct(themeDimCode = "") As %List
{
	s themeDimCode2=$zcvt(themeDimCode,"U")
	if ((themeDimCode'="")&&($d(..IndexMap(0,"NI",themeDimCode2)))){
	  s id=$o(..IndexMap(0,"NI",themeDimCode2,""))
	  s obj=..DimList.GetAt(id)
	  q:obj="" $lb()
	  s struct=obj.DimStructList
	  s obj=""
	  q struct
	}
	s list=$lb()
	s len=..DimList.Count(),j=0
	f i=1:1:len{
	  s obj=..DimList.GetAt(i)
	  continue:obj=""
	  s j=j+1
	  s $list(list,j)=$lg(obj.DimStructList,1),$list(list,j+1)=$lg(obj.DimStructList,2)
	  s $list(list,j+2)=$lg(obj.DimStructList,3),$list(list,j+3)=$lg(obj.DimStructList,4)
	  s j=j+3
	}
	q list
}

}
