Class DHCWL.Interface.Base.KpiRuleResolver Extends %RegisteredObject
{

/**
 * 
 * @author lihaihong
 * @date  2015/8/13
 *
 **/
Property kpiDimMap [ MultiDimensional ];

Property baseDimResolver As DHCWL.Interface.Base.DimRuleResolver;

Property usingCache As %Boolean;

Property CachedResolved [ MultiDimensional ];

//d ##class(DHCWL.Interface.Base.KpiRuleResolver).Test()

ClassMethod Test()
{
	s resolver=##class(DHCWL.Interface.Base.KpiRuleResolver).%New(1)
	w resolver.GetPropertyValue("OutPatientCount","$D.week",1326),!
	w resolver.GetPropertyNameValue("OutPatientCount","D.week",1326)
}

Method %OnNew(useCache As %Boolean = 0) As %Status
{
	s ..baseDimResolver=##class(DHCWL.Interface.Base.DimRuleResolver).%New()
	if $g(useCache,0) s ..usingCache=1  else  s ..usingCache=0
	q $$$OK
}

Method ResolveKpiDimPri(kpi) [ Private ]
{
	q:$d(..kpiDimMap(kpi)) kpi
	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpi,"DHCWL.MKPI.MKPI")
	q:((kpiId="")||('$d(^DHCWL.MKPI.MKPID(kpiId)))) ""
	s kpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(kpiId)
	q:kpiObj="" ""
	s kpiCode=kpiObj.MKPICode
	s kpiDimCode="" f  s kpiDimCode=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,kpiDimCode)) q:kpiDimCode=""  d
	.s id=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,kpiDimCode,""))
	.q:((id="")||('$d(^DHCWL.MKPI.MKPIDimensionsD(id))))
	.s kpiDimObj=##class(DHCWL.MKPI.MKPIDimensions).%OpenId(id)
	.q:kpiDimObj=""
	.s baseDimCode=kpiDimObj.MKPIDimDimDr.KDTCode
	.s ..kpiDimMap(kpiCode,kpiDimObj.MKPIDimCode)=baseDimCode
	q kpiCode
}

Method GetPropertyValue(kpi, kpiDimPro, sourceDimId)
{
	q:sourceDimId="" ""
	q:$p(kpiDimPro,".",2)="#" sourceDimId
	s kpiCode=..ResolveKpiDimPri(kpi)
	s kpiDim=$p(kpiDimPro,".",1)
	q:'$d(..kpiDimMap(kpiCode,kpiDim)) ""
	s baseDim=..kpiDimMap(kpiCode,kpiDim)_"."_$p(kpiDimPro,".",2)
	s value=$g(..CachedResolved(baseDim,sourceDimId))
	if value="" {
		s value=..baseDimResolver.GetPropertyValue(baseDim,sourceDimId)
		s:..usingCache=1 ..CachedResolved(baseDim,sourceDimId)=value
	}
	q value
}

Method GetPropertyNameValue(kpi, kpiDimPro, sourceDimId)
{
	q:sourceDimId="" ""
	q:$p(kpiDimPro,".",2)="#" sourceDimId
	s kpiCode=..ResolveKpiDimPri(kpi)
	s kpiDim=$p(kpiDimPro,".",1)
	q:'$d(..kpiDimMap(kpiCode,kpiDim)) ""
	s baseDim=..kpiDimMap(kpiCode,kpiDim)_"."_$p(kpiDimPro,".",2)
	q ..baseDimResolver.GetPropertyNameValue(baseDim,sourceDimId)
}

Method GetPropertyBaseDim(kpi, kpiDimPro)
{
	s kpiCode=..ResolveKpiDimPri(kpi)
	s kpiDim=$p(kpiDimPro,".",1)
	q:'$d(..kpiDimMap(kpiCode,kpiDim))
	q ..kpiDimMap(kpiCode,kpiDim)
}

}
