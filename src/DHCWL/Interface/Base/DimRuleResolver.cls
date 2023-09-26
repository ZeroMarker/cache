Class DHCWL.Interface.Base.DimRuleResolver Extends %RegisteredObject
{

/**
 * 
 * @author lihaihong
 * @date  2015/8/13
 *
 **/
Property baseDimMap [ MultiDimensional ];

Property cachedResMV [ MultiDimensional ];

Property cacheFlag As %Boolean;

// d ##class(DHCWL.Interface.Base.DimRuleResolver).Test()

ClassMethod Test()
{
	s dimResolver=##class(DHCWL.Interface.Base.DimRuleResolver).%New()
	w dimResolver.GetPropertyValue("$D",1326)
	w dimResolver.GetPropertyValue("$D.Integer",1)
}

Method setCache(flag As %Boolean = 0)
{
	s ..cacheFlag=flag
}

Method GetPropertyValue(baseProperty, sourceId)
{
	q $p(..GetPropertyNameValue(baseProperty,sourceId),"=",2)
	s baseDim=$p(baseProperty,".",1)
	if ('$d(..baseDimMap(baseDim))){
		s baseProperty=..ResolveAllProPri(baseProperty)	
	}
	s baseDim=$p(baseProperty,".",1)
	s pro=$p(baseProperty,".",2)
	s:pro="" pro=$g(..baseDimMap(baseDim,"$"))
	q:pro="" sourceId
	s proObj=$g(..baseDimMap(baseDim,pro))
	q:proObj="" sourceId
	s exeStr=proObj.ExcuteCode
	q:exeStr="" sourceDimId
	q $$Excute^DHCWL.ExcuteLineRoutine("$$"_exeStr,sourceId)
}

Method GetPropertyNameValue(baseProperty, sourceId)
{
	s baseDim=$p(baseProperty,".",1)
	s baseDim2=$p(baseProperty,".",1)
	if ('$d(..baseDimMap(baseDim))){
		s baseProperty=..ResolveAllProPri(baseProperty)	
	}
	if ($d(..cachedResMV(baseProperty,sourceId))) q ..cachedResMV(baseProperty,sourceId)
	s baseDim=$p(baseProperty,".",1)
	s pro=$p(baseProperty,".",2)
	//s sectionDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(baseDim,"DHCWL.MKPI.Section")
	/*s monthObj=##class(DHCWL.MKPI.Months).%OpenId(sourceId)
	s sectionFlag=monthObj.KPIMSectionFlag.SecCode
	if (baseDim'=sectionFlag)
	{
		q ""
	}*/
	if pro="" {
		s pro=$g(..baseDimMap(baseDim,"$"))
		if (baseDim2 ["$"){
			q:'$d(^DHCWL.MKPI.MonthsD(sourceId)) sourceId
			s monthObj=##class(DHCWL.MKPI.Months).%OpenId(sourceId)
			q baseDim2_"="_monthObj.KPIMDesc
		}
		q:pro="" baseDim2_"="
		s pro=pro.Code
	}
	q:pro="" baseDim2_"="
	s proObj=$g(..baseDimMap(baseDim,pro))
	q:proObj="" pro_"="
	s exeStr=proObj.ExcuteCode
	q:exeStr="" proObj.Code_"="
	//q proObj.Code_"="_$$Excute^DHCWL.ExcuteLineRoutine("$$"_exeStr,sourceId)
	s rv=$$Excute^DHCWL.ExcuteLineRoutine("$$"_exeStr,sourceId)
	s rv=proObj.Code_"="_rv
	if (..cacheFlag) s ..cachedResMV(baseProperty,sourceId)=rv
	q rv
}

Method ResolveAllProPri(baseDim) [ Private ]
{
	s baseDimPro=""
	s dimCode=$p(baseDim,".",1)
	s proCode=$p(baseDim,".",2)
	s secFlag=0
	s obj=""
	s dimId=""
	s proObj=""
	if ($e(dimCode,1)="$"){
		s secDimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode,"DHCWL.MKPI.Section")
		q:secDimId="" ""
		s secDimObj=##class(DHCWL.MKPI.Section).%OpenId(secDimId)
		q:secDimObj="" sourceId
		s secDimCode=secDimObj.SecCode
		s dimCode=secDimCode
		s obj=secDimObj
		s secFlag=1
		s dimId=secDimId
	}else{
		s dimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimCode,"DHCWL.MKPI.MKPIDimType")
		q:dimId="" ""
		s dimObj=##class(DHCWL.MKPI.MKPIDimType).%OpenId(dimId)
		q:dimObj="" ""
		s dimCode=dimObj.KDTCode
		s obj=dimObj
	}
	if proCode="" {
		if secFlag=1 {
			s proId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimDefPro",secDimId,"Y",""))
		}else{
			s proId=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimId,"Y",""))
		}
	}else{
		if secFlag=1 {
			s proId=##class(DHCWL.MKPI.SectionProperty).GetIdByCode(dimId_"||"_proCode)
		}else{
			s proId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(dimId_"||"_proCode,"DHCWL.MKPI.DimProperty")
		}
	}
	q:((proId="")&&(secFlag'=1)) ""
	if secFlag=1 {
		if proId="" {
			s ..baseDimMap(dimCode,"$")=""
		}else{
			s proObj=##class(DHCWL.MKPI.SectionProperty).%OpenId(proId)
			q:proObj="" ""
			s proCode=proObj.Code
			s secProCode="" f  s secProCode=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,secProCode)) q:secProCode=""  d
			.s id=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,secProCode,""))
			.q:((id="")||('$d(^DHCWL.MKPI.SectionPropertyD(id))))
			.s proObj2=##class(DHCWL.MKPI.SectionProperty).%OpenId(id)
			.q:proObj2=""
			.s ..baseDimMap(dimCode,proObj2.Code)=proObj2
			.i proObj2.DefaultFlag="Y" d
			..s ..baseDimMap(dimCode,"$")=proObj2
		}
		
	}else{
		s proObj=##class(DHCWL.MKPI.DimProperty).%OpenId(proId)
		q:proObj="" ""
		s proCode=proObj.Code
		s proCode2="" f  s proCode2=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,proCode2)) q:((proCode2=""))  d
		.s id=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,proCode2,""))
		.q:((id="")||('$d(^DHCWL.MKPI.DimPropertyD(id))))
		.s proObj2=##class(DHCWL.MKPI.DimProperty).%OpenId(id)
		.q:proObj2=""
		.s ..baseDimMap(dimCode,proObj2.Code)=proObj2
		.i proObj2.DefaultFlag="Y" d
		..s ..baseDimMap(dimCode,"$")=proObj2
		.;w dimCode_"."_proObj2.Code,!
	}
	
	q dimCode_"."_proCode
}

}
