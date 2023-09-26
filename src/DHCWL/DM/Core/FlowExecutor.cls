/// Creator：      lihaihong
/// CreatDate：    20170602
/// Description：   Flow的执行器
Class DHCWL.DM.Core.FlowExecutor Extends %RegisteredObject
{

Property Ite As Iterator [ Private ];

Property Flow As Flow;

Property DimSIMap [ MultiDimensional ];

Property MetricSIMap [ MultiDimensional ];

Property FCubeMask As %String;

Property FDimMask As %String;

Property CubeDayPart As DHCWL.DM.T.CubeDSPart;

Method %OnNew(irp As InternalResolvedParser, flow As Flow) As %Status [ Private, ServerOnly = 1 ]
{
	s cubeMask=irp.Parent.GetComputedCube().Mask()
	s metaDims=irp.Parent.GetMetaDims()
	s metaMetrics=irp.Parent.GetMetaMetrics()
	s ..Ite=##class(Iterator).%New(cubeMask,metaDims,metaMetrics)
	s ..Flow=flow
	s metaDims=irp.GetMetaDims()
	s metaMetrics=irp.GetMetaMetrics()
	f i=1:1:$ll(metaDims){
	  s ..DimSIMap($list($list(metaDims,i),1))=i
	}
	f i=1:1:$ll(metaMetrics){
	  s ..MetricSIMap($list(metaMetrics,i))=i
	}
	s ..FCubeMask=irp.GetComputedCube().Mask()
	m tmp=irp.dimsShowInd
	s ..FDimMask=tmp
	k tmp
	s ..CubeDayPart=##class(DHCWL.DM.T.CubeDSPart).TouchPart(..FCubeMask,0)
	q $$$OK
}

Method Execute() As %Status
{
	while (..Ite.HasNext()){
	  k map,map2
	  d ..Ite.CurDimMap(.map)
	  d ..Ite.CurMetricMap(.map)
	  m map2=map
	  if (..Flow.Flowing(.map,.map2)=0){
	  }else{
		s dimRow=$lb(),metricRow=$lb()
		s pro="" f{
		  s pro=$o(..DimSIMap(pro))
		  q:pro=""
		  s $list(dimRow,..DimSIMap(pro))=map2(pro)	
		}
		s pro="" f{
		  s pro=$o(..MetricSIMap(pro))
		  q:pro=""
		  s $list(metricRow,..MetricSIMap(pro))=map2(pro)	
		}
	    d ##class(PhysicalExecutor).UpsertRow(..FCubeMask,..FDimMask,0,dimRow,metricRow)
	  }
	}
	q $$$OK
}

}
