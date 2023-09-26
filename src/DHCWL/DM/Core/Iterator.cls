Class DHCWL.DM.Core.Iterator Extends %RegisteredObject
{

Property MetaDims As %List;

Property MetaMetrics As %List;

Property Part As %String;

Property Index As %Integer;

Property CubeMask As %String;

Property Init As %Boolean;

Property DateDims [ MultiDimensional ];

Property MetricLen As %Integer;

Property DimLen As %Integer;

Property ProSNMap [ MultiDimensional ];

Property PartDimIndexMap [ MultiDimensional ];

Property DimTotalRows As %Integer;

Property TotalRows As %Integer;

Property CurPivot As %Integer [ Private ];

Property SortStruct [ MultiDimensional ];

Property SortCCM As %String;

Property MetricDataInfo [ MultiDimensional ];

Property CanNext As %Boolean;

/// 0: CQL中无sort表达式
/// 1: CQL中有sort表达式但是在sort中无度量明细字段
/// 2: CQL中有sort表达式且在sort中有度量明细字段
Property InteType As %Integer;

Property ComputedThemeBase As DHCWL.DM.R.ComputedThemeBase;

Method %OnNew(cubeMask, metaDims As %List, metaMetrics As %List = "", ByRef sortStructMap, ByRef metricDataInfo, parComputedThemeBase As DHCWL.DM.R.ComputedThemeBase, hasSortFlag As %Boolean = 0, metricDitailInSortFlag As %Boolean = 0) As %Status [ Private, ServerOnly = 1 ]
{
	s ..MetaMetrics=$g(metaMetrics,$lb())
	s metaMetrics=..MetaMetrics
	s ..MetricLen=$ll(metaMetrics)
	s:(($ll(metaMetrics)=1)&&($lg(metaMetrics,1,"")="")) ..MetricLen=0
	s ..Part=""
	s ..Index=""
	s ..Init=1
	s ..CubeMask=cubeMask
	s ..CurPivot=0
	s ..ComputedThemeBase=parComputedThemeBase
	s len=$ll(metaDims)
	s lb=$lb()
	f i=1:1:len {
	  s st=$lg(metaDims,i)
	  if $lg(st,2)=91 {
		s ..DateDims(i)=""
	  }
	  s $list(lb,i)=$lg(st,1)
	}
	if (hasSortFlag=0){
		s ..InteType=0
	}elseif (hasSortFlag=1) && (metricDitailInSortFlag=0){
		s ..InteType=1
		s ..SortCCM=sortStructMap_"S"
	}elseif (hasSortFlag=1) && (metricDitailInSortFlag=1){
		s ..InteType=2
		s ..SortCCM=sortStructMap_"S"
	}
	s ..DimLen=len
	s ..MetaDims=lb
	m ..SortStruct=sortStructMap
	m ..MetricDataInfo=metricDataInfo
	s ..CanNext=1
	q $$$OK
}

Method OnExecute()
{
	s sum=0,psum=1
	if (..InteType=0){
		s part="" f{
		  s part=$o(^||TEMPCMPDCUBEDD(..CubeMask,part))
		  q:part=""
		  s i=$o(^||TEMPCMPDCUBEDD(..CubeMask,part,""),-1)
		  s ..PartDimIndexMap(part,"S")=psum
		  s sum=sum+$g(i,0)
		  s psum=psum+$g(i,0)
		  s ..PartDimIndexMap(part,"E")=psum
		}
		s ..DimTotalRows=sum
	}elseif (..InteType=1){
		s ..DimTotalRows=$g(^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM),0)
	}elseif (..InteType=2){
		/*s part="" f{
		  s part=$o(^||TEMPCMPDCUBEDD(..CubeMask,part))
		  q:part=""
		  s i=$o(^||TEMPCMPDCUBEDD(..CubeMask,part,""),-1)
		  s ..PartDimIndexMap(part,"S")=psum
		  s sum=sum+$g(i,0)
		  s psum=psum+$g(i,0)
		  s ..PartDimIndexMap(part,"E")=psum
		}
		s ..DimTotalRows=sum
		*/
		m sortStruct=..SortStruct
		s ccm=..CubeMask
		s ..InteType=0
		s iteRowId=0
		while(..HasNext()){
			s iteRowId=iteRowId+1
			s drow=..CurDims()
			s metrics=..CurMetrics()
			s partInd=..Part
			s cid=..Index
			s sindex="" f{
				s sindex=$o(sortStruct(1,sindex))
				q:sindex=""
				s ft=sortStruct(1,sindex,"FT")
				s fi=sortStruct(1,sindex,"FI")
				if ft="D"{
					s sfv=$lg(drow,fi,$c(0))
					s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sfv,0))
					s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sfv,0,partInd,cid,scount)=iteRowId
				}elseif ft="M"{
					s sfv=$lg(metrics,fi,0)
					s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sfv,0))
					s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sfv,0,partInd,cid,scount)=iteRowId
				}elseif ft="MD"{
					s sfv=$lg(metrics,fi,0)
					s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sfv,0))
					//s scount=$i(^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sfv,0,partInd,cid))
					s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sfv,0,partInd,cid,scount)=iteRowId
				}
				s sindex2=$o(sortStruct(1,sindex))
				if sindex2'=""{
				  s fi2=sortStruct(1,sindex2,"FI")
				  s ft2=sortStruct(1,sindex2,"FT")
				  if ft2="D"{
						s sfv2=$lg(drow,fi2,$c(0))
				  }else{
						s sfv2=$lg(metrics,fi2,0)
				  }
					s ^||TEMPCMPDCUBEDI(ccm,sortStruct,sindex,sfv,1,sfv2,partInd,cid)=""
				}
			}
			s ^||TEMPCMPDCUBEDI(ccm,sortStruct,0,iteRowId)=metrics
		}
		d ##class(PhysicalExecutor).SortResolve(.sortStruct,ccm,"I")
		d ..Rewind()
		s ..InteType=2
		s ..DimTotalRows=$g(^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM),0)
	}
}

Method GetDimMeta() As %List
{
    q ..MetaDims
}

Method GetMetricMeta() As %List
{
	s meta=..MetaMetrics
	q:meta="" $lb()
	q meta
}

Method GetDimDataType(dim) As %Integer
{
	s obj=..ComputedThemeBase.GetDim(dim)
	s ty=12
	s:obj'="" ty=obj.GetJDBCTypeCodeNum()
	s obj=""
	q ty
}

Method GetMetricDataType(metric) As %Integer
{
	s obj=..ComputedThemeBase.GetMetric(metric)
	s ty=8
	s:obj'="" ty=obj.GetJDBCTypeCodeNum()
	s obj=""
	q ty
}

Method Rewind() As %Status
{
	s ..Part=""
	s ..Index=""
	s ..Init=1
	s ..CurPivot=0
	f i=1:1:..MetricLen{
		s ..MetricDataInfo(i,"SS")=0
		s ..MetricDataInfo(i,"SSI")=1
	}
	q $$$OK
}

Method HasNext() As %Boolean
{
	if (..InteType=0) {
		q:..CanNext=0 1
		if ..Init=1{
	    s ..Init=0
	    s ..Part=$o(^||TEMPCMPDCUBEDD(..CubeMask,""))
	    q:..Part="" 0
	    s ..Index=$o(^||TEMPCMPDCUBEDD(..CubeMask,..Part,""))
	  }else{
	    if ..Index=""{
	      s ..Part=$o(^||TEMPCMPDCUBEDD(..CubeMask,..Part))
	      q:..Part="" 0
	      s ..Index=$o(^||TEMPCMPDCUBEDD(..CubeMask,..Part,""))
	    }else{
	      s ..Index=$o(^||TEMPCMPDCUBEDD(..CubeMask,..Part,..Index))
	    }
	  }
	  s:..Index'="" ..CurPivot=..CurPivot+1
	  q ..Index'=""
	}elseif (..InteType=1){
		q:..CanNext=0 1
		i ..CurPivot<..DimTotalRows{
			s ..CurPivot=..CurPivot+1
			q 1
		}
		q 0
	}elseif (..InteType=2){
		i (..CurPivot<..DimTotalRows){
			s ..CurPivot=..CurPivot+1
			q 1
		}
		q 0
	}
}

Method GetRowCount() As %Integer [ CodeMode = expression ]
{
..DimTotalRows
}

Method CurIndex() As %Integer [ CodeMode = expression ]
{
..CurPivot
}

Method CurDims() As %List
{
	if (..InteType=0){
		s dims=$g(^||TEMPCMPDCUBEDD(..CubeMask,..Part,..Index),"")
	}elseif (..InteType=1){
		s list=^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,..CurPivot)
	  s part=$lg(list,1)
	  s cid=$lg(list,2)
	  s dims=$g(^||TEMPCMPDCUBEDD(..CubeMask,part,cid),"")
	}elseif (..InteType=2){
	  s list=^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,..CurPivot)
	  s part=$lg(list,1)
	  s cid=$lg(list,2)
	  s dims=$g(^||TEMPCMPDCUBEDD(..CubeMask,part,cid),"")
	}
	b:dims="" ""
	s i="" f{
	  s i=$o(..DateDims(i))
	  q:i=""
	  s dv=+$lg(dims,i,0)
	  continue:dv=0
	  s $list(dims,i)=$zd(dv,3)
	}
	q dims
}

Method CurDimsMap(ByRef dimValueMap)
{
	k dimValueMap
	if (..InteType=0){
		s dims=$g(^||TEMPCMPDCUBEDD(..CubeMask,..Part,..Index),"")
	}elseif (..InteType=1){
		s list=^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,..CurPivot)
	  s part=$lg(list,1)
	  s cid=$lg(list,2)
	  s dims=$g(^||TEMPCMPDCUBEDD(..CubeMask,part,cid),"")
	}elseif (..InteType=2){
	  s list=^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,..CurPivot)
	  s part=$lg(list,1)
	  s cid=$lg(list,2)
	  s dims=$g(^||TEMPCMPDCUBEDD(..CubeMask,part,cid),"")
	}
	q:dims="" ""
	f i=1:1:..DimLen{
	  s dimValueMap($list(..MetaDims,i))=$lg(dims,i,"")
	}
	s i="" f{
	  s i=$o(..DateDims(i))
	  q:i=""
	  s dv=+$lg(dims,i,0)
	  continue:dv=0
	  s dimValueMap($list(..MetaDims,i))=$zd(dv,3)
	}
	q
}

Method CurMetrics() As %List
{
	s lb=$lb()
	if (..InteType=0){
		s part=..Part,cid=..Index
	}elseif (..InteType=1){
		s list=^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,..CurPivot)
	  s part=$lg(list,1)
	  s cid=$lg(list,2)
	}elseif (..InteType=2){
		s list=^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,..CurPivot)
	  s part=$lg(list,1)
	  s cid=$lg(list,2)
	  s itrowid=$lg(list,3)
	  s lb=^||TEMPCMPDCUBEDI(..CubeMask,..SortStruct,0,itrowid)
	}
	if (..InteType'=2){
		f i=1:1:..MetricLen{
		  if $d(..MetricDataInfo(i,"F")){
				s $list(lb,i)=$lg(^||TEMPCMPDCUBEDD(..CubeMask,part,cid,i,2,0),1)
		  }else{
				s mseg=$g(..MetricDataInfo(i,"SS"),0)
				s msegind=$g(..MetricDataInfo(i,"SSI"),1)
				s mlist=$g(^||TEMPCMPDCUBEDD(..CubeMask,part,cid,i,2,mseg),"")
				s mlistlen=$ll(mlist)
				if (msegind<=mlistlen){
				  s ..CanNext=0
				  s $list(lb,i)=$lg(mlist,msegind)
				  s ..MetricDataInfo(i,"SS")=mseg
				  s msegind=msegind+1
				  s ..MetricDataInfo(i,"SSI")=msegind
				  if (mlistlen<msegind){
						s mseg=$o(^||TEMPCMPDCUBEDD(..CubeMask,part,cid,i,2,mseg))
						if mseg=""{
						  s ..CanNext=1
						  s ..MetricDataInfo(i,"SS")=0
						  s ..MetricDataInfo(i,"SSI")=1
						}else{
						  s ..MetricDataInfo(i,"SS")=mseg
						  s ..MetricDataInfo(i,"SSI")=1
						}
				  }
				}else{
				  s mseg=$o(^||TEMPCMPDCUBEDD(..CubeMask,part,cid,i,2,mseg))
				  if mseg=""{
						s ..CanNext=1
						s ..MetricDataInfo(i,"SS")=0
						s ..MetricDataInfo(i,"SSI")=1
				  }else{
						s ..CanNext=0
						s msegind=1
						s mlist=^||TEMPCMPDCUBEDD(..CubeMask,part,cid,i,2,mseg)
						s $list(lb,i)=$lg(mlist,msegind)
						s ..MetricDataInfo(i,"SS")=mseg
						s ..MetricDataInfo(i,"SSI")=msegind+1
				  }
				}
		  }
		}
	}
	q lb
}

Method CurMetricsMap(ByRef metricValueMap)
{
	k metricValueMap
	if (..InteType=0){
		s part=..Part,cid=..Index
	}elseif (..InteType=1){
		s list=^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,..CurPivot)
	  s part=$lg(list,1)
	  s cid=$lg(list,2)
	}elseif (..InteType=2){
		s list=^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,..CurPivot)
	  s part=$lg(list,1)
	  s cid=$lg(list,2)
	}
	f i=1:1:..MetricLen{
	  s metricValueMap($list(..MetaMetrics,i))=$lg(^||TEMPCMPDCUBEDD(..CubeMask,part,cid,i,2,0),1)
	}
	q
}

Method DimsAt(pivot As %Integer) As %List
{
	d ..ComputePivotIndex(pivot,.ppart,.pindex)
	q:($g(ppart,"")="")||($g(pindex,"")="") ""
	q:'$d(^||TEMPCMPDCUBEDD(..CubeMask,ppart,pindex)) ""
	s dims=$g(^||TEMPCMPDCUBEDD(..CubeMask,ppart,pindex),"")
	s i="" f{
	  s i=$o(..DateDims(i))
	  q:i=""
	  s dv=+$lg(dims,i,0)
	  continue:dv=0
	  s $list(dims,i)=$zd(dv,3)
	}
	q dims
}

Method DimsAtMap(pivot As %Integer, ByRef dimValueMap)
{
	d ..ComputePivotIndex(pivot,.ppart,.pindex)
	q:($g(ppart,"")="")||($g(pindex,"")="")
	q:'$d(^||TEMPCMPDCUBEDD(..CubeMask,ppart,pindex))
	s dims=$g(^||TEMPCMPDCUBEDD(..CubeMask,ppart,pindex),"")
	q:dims=""
	;k dimValueMap
	f i=1:1:..DimLen{
	  s dimValueMap($list(..MetaDims,i))=$lg(dims,i,"")
	}
	s i="" f{
	  s i=$o(..DateDims(i))
	  q:i=""
	  s dv=+$lg(dims,i,0)
	  continue:dv=0
	  s dimValueMap($list(..MetaDims,i))=$zd(dv,3)
	}
	q
}

Method MetricsAt(pivot As %Integer) As %List
{
	d ..ComputePivotIndex(pivot,.ppart,.pindex)
	q:($g(ppart,"")="")||($g(pindex,"")="") ""
	q:'$d(^||TEMPCMPDCUBEDD(..CubeMask,ppart,pindex)) ""
	s lb=$lb()
	f i=1:1:..MetricLen{
	  s $list(lb,i)=$lg(^||TEMPCMPDCUBEDD(..CubeMask,ppart,pindex,(i),2,0),1)
	}
	q lb
}

Method MetricsAtMap(pivot As %Integer, ByRef metricValueMap)
{
	d ..ComputePivotIndex(pivot,.ppart,.pindex)
	q:($g(ppart,"")="")||($g(pindex,"")="")
	;k metricValueMap
	f i=1:1:..MetricLen{
	  s metricValueMap($list(..MetaMetrics,i))=$lg(^||TEMPCMPDCUBEDD(..CubeMask,ppart,pindex,(i),2,0),1)
	}
	q
}

Method ComputePivotIndex(pivot As %Integer, ByRef pivotPart, ByRef pivotIndex)
{
	if (..InteType=0){
		s part="" f{
	    s part=$o(..PartDimIndexMap(part))
	    q:part=""
	    if (..PartDimIndexMap(part,"S")<=pivot) && (pivot<..PartDimIndexMap(part,"E")){
	      s pivotPart=part
	      s pivotIndex=pivot-..PartDimIndexMap(part,"S")+1
	      q
	    }
	  }
	}elseif (..InteType=1){
		if '$d(^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,pivot)){
			s pivotPart="",pivotIndex=""
			q  
	  }
	  s pivotPart=$lg(^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,pivot),1)
	  s pivotIndex=$lg(^||TEMPCMPDCUBEDI(..CubeMask,..SortCCM,pivot),2)
	}elseif (..InteType=2){
		
	}
}

}
