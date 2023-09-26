Class DHCWL.DM.Core.RealTimeThemeIRP Extends %RegisteredObject
{

Parameter DIMSTRUCTLISTUNIT = 4;

Property rtirp As InternalResolvedParser;

Property FetchTheme As DHCWL.DM.R.ComputedThemeBase;

Property FetchCube As DHCWL.DM.R.ComputedCubeBase;

Property DimSelect As %String;

Property MetricSelect As %String;

Method %OnNew(irp As InternalResolvedParser) As %Status [ Private, ServerOnly = 1 ]
{
  q:'irp.IsRealTimeData() $$$ERROR("Must be real time theme query")
  s ..rtirp=irp
  k dimMap
  i $d(irp.allUsingDimMetricMap("D")) {
    s code="" f {
	  s code=$o(irp.allUsingDimMetricMap("D",code)) 
	  q:code=""
	  s dimMap(code)=""
	}
  }
  i $d(irp.allUsingDimMetricMap("P")) {
	s code="" f {
	  s code=$o(irp.allUsingDimMetricMap("P",code)) 
	  q:code=""
	  s dimMap(code)=""
	}
  }
  i $d(irp.allUsingDimMetricMap("F")) {
    s code="" f {
	  s code=$o(irp.allUsingDimMetricMap("F",code)) 
	  q:code=""
	  s dimMap(code)=""
	}
  }
  i $d(irp.allUsingDimMetricMap("R")) {
    s code="" f {
	  s code=$o(irp.allUsingDimMetricMap("R",code)) 
	  q:code=""
	  s dimMap(code)=""
	}
  }
  s refTheme=irp.RefTheme
  s fetchTheme=##class(DHCWL.DM.R.ComputedThemeBase).%New(irp.ResultSetName_"/fetchTheme.t")
  s i=0,selectList=$lb()
  ;b ;1
  s code="" f {
    s code=$o(dimMap(code))
	q:code=""
	s i=i+1
	s $list(selectList,i)=code
	s dstruct=refTheme.GetDimStruct(code)
	d fetchTheme.AddDim(code,dstruct,3)
  }
  s ..DimSelect=$lts(selectList,", ")
  s afllen=..rtirp.AggFormattedList.Count()
  s selectList=$lb(),i=0
  f j=1:1:afllen{
    s af=..rtirp.AggFormattedList.GetAt(j)
	continue:((af="")||($d(dimMap(af))))
	s dimMap(af)=""
	s i=i+1
	s $list(selectList,i)=af
	d fetchTheme.AddMetric(af,$lb(af))
  }
  s ..MetricSelect=$lts(selectList,", ")
  s ..FetchTheme=fetchTheme
  s ..FetchCube=##class(DHCWL.DM.R.ComputedCubeBase).%New(fetchTheme)
  s fetchTheme=""
  q $$$OK
}

Method GetFetchDimStruct() As %List
{
  q ..FetchTheme.GetDimStruct()
}

Method GetFetchMetricStruct() As %List
{
  q ..FetchTheme.GetMetricStruct()
}

Method Close()
{
}

}
