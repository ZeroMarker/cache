Class DHCWL.util.CodeUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod Encode(codeStr As %Text, encodeChars = ",") As %Text
{
}

/*
s id=$o(^DHCWL.MKPI.ExecuteCodeD(""))
s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(id)
w ##class(DHCWL.util.CodeUtil).HasProperty(obj,"ExcCodeSubType")

*/
ClassMethod HasProperty(insta As %Library.ObjectHandle, propertyname) As %Library.ObjectHandle
{
	n (insta,propertyname)
	;s id=$o(^DHCWL.MKPI.ExecuteCodeD(""))
	;s obj=##class(DHCWL.MKPI.ExecuteCode).%OpenId(id)
	;s insta=obj
	s obj=insta
	//w "type="_obj.ExcCodeSubType,!
	q:(insta="")||(propertyname="") 0
	q:propertyname=-1 0
	s v=""
	s $zt="Error"  ;"s v=##class(DHCWL.util.CodeUtil).Error()"
	x "  s v=obj."_propertyname
	if v="" s v=1
	q 1
Error
 	q 0
}

/*
*指标取数规则检查
*creator:wk
*创建日期：2016-03-14
*do ##class(DHCWL.util.CodeUtil).CheckKpiRuleList("lhcs0617:PatLoc^PatDoc")
*/
ClassMethod CheckKpiRuleList(inputRule As %String, ByRef dimList)
{
	n (inputRule,dimList)
	s kpiLen=$l(inputRule,",")
	k ^TEMPDHCWL($j)
	k dimList
	q:inputRule=""
	f i=1:1:kpiLen d       //将过滤规则中的指标、(区间)维度、(区间)维度属性保存到global中
	.s aKpiRule=$p(inputRule,",",i)
	.s kpiCode=$p(aKpiRule,":",1)
	.s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode)=1
	.s dimAndProRules=$p(aKpiRule,":",2)
	.q:$g(dimAndProRules)=""
	.s dAndPCnt=$l(dimAndProRules,"^")
	.f j=1:1:dAndPCnt d
	..s aDimAndPro=$p(dimAndProRules,"^",j)
	..s dimCode=$p(aDimAndPro,".",1)
	..i ($g(dimCode)'="") d
	...i ($f(dimCode,"$")'=2) d 	//常规维度及属性 
	....s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode)=1
	....s proCode=$p(aDimAndPro,".",2)
   	....i $g(proCode)'="" s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode,proCode)=1	
   	...e  d							//区间维度及属性
	....s ^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode)=1
	....s proCode=$p(aDimAndPro,".",2)
   	....i $g(proCode)'="" s ^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode,proCode)=1

	s kpiCode=""    //将不存在的指标、维度、维度属性放到list中
	for  s kpiCode=$o(^TEMPDHCWL($j,"inputRule","normalDim",kpiCode)) q:kpiCode=""  d
	.s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
	.if kpiId="" d
	..s dimList("kpiCode",kpiCode)=""
	.q:kpiId=""
	.s dimCode=""
	.for  s dimCode=$o(^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode)) q:dimCode=""  d
	..s UpDimCode=$SYSTEM.SQL.ALPHAUP(dimCode)
	..if '$d(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,UpDimCode)) d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:'$d(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,UpDimCode))
	..s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,UpDimCode,""))
	..if kpiDimId="" d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:kpiDimId=""
	..s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5,"")
	..if ((dimId="")||(dimId=" ")) d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:((dimId="")||(dimId=" "))
	..s proCode=""
	..for  s proCode=$o(^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode,proCode)) q:proCode=""  d
	...s UProCode=$SYSTEM.SQL.ALPHAUP(proCode)
	...if '$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,UProCode))  d
	....s dimList("proCode",kpiCode_"."_dimCode_"."_proCode)=""
	...q:'$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,UProCode))
	.s dimCode=""
	.for  s dimCode=$o(^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode)) q:dimCode=""  d
	..s RDimCode=$p(dimCode,"$",2)
	..if ((RDimCode="")||(RDimCode=" ")) d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:((RDimCode="")||(RDimCode=" "))
	..s RDimCode=$SYSTEM.SQL.ALPHAUP(RDimCode)
	..if ('$d(^DHCWL.MKPI.SectionI("SecCode",RDimCode))) d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:('$d(^DHCWL.MKPI.SectionI("SecCode",RDimCode)))
	..s dimId=$o(^DHCWL.MKPI.SectionI("SecCode",RDimCode,""))
	..s proCode=""
	..for  s proCode=$o(^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode,proCode)) q:proCode=""  d
	...s UProCode=$SYSTEM.SQL.ALPHAUP(proCode)
	...if '$d(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,UProCode)) d
	....s dimList("proCode",kpiCode_"."_dimCode_"."_proCode)=""
	...q:'$d(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,UProCode))
	...s ProDimId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,UProCode,""))
	...if '$d(^DHCWL.MKPI.SectionPropertyD(ProDimId)) d
	....s dimList("proCode",kpiCode_"."_dimCode_"."_proCode)=""
	...q:'$d(^DHCWL.MKPI.SectionPropertyD(ProDimId))
	...s ProDimExe=$lg(^DHCWL.MKPI.SectionPropertyD(ProDimId),5,"")
	...if (ProDimExe="")||(ProDimExe=$c(0)) d
	....s dimList("proCode",kpiCode_"."_dimCode_"."_proCode)=""
	...q:(ProDimExe="")||(ProDimExe=$c(0))
	k ^TEMPDHCWL($j)
	s kpiCode="",dimCode="",proCode="",kpis="",dims="",pros=""
	if $d(dimList("kpiCode")) d
	.for  s kpiCode=$o(dimList("kpiCode",kpiCode)) q:kpiCode=""  d
	..if kpis="" d
	...s kpis=kpiCode
	..else  d
	...s kpis=kpis_","_kpiCode
	if $d(dimList("dimCode")) d
	.for  s dimCode=$o(dimList("dimCode",dimCode)) q:dimCode=""  d
	..if dims="" d
	...s dims=dimCode
	..else  d
	...s dims=dims_","_dimCode
	if $d(dimList("proCode")) d
	.for  s proCode=$o(dimList("proCode",proCode)) q:proCode=""  d
	..if pros="" d
	...s pros=proCode
	..else  d
	...s pros=pros_","_proCode
	s dimList("kpiCode")=kpis
	s dimList("dimCode")=dims
	s dimList("proCode")=pros
	q
}

/*
*指标过滤规则检查
*creator:wk
*创建日期：2016-03-14
*do ##class(DHCWL.util.CodeUtil).CheckKpiFilterList("lhcs0617:([{PatLoc} = 67])",.dimList)
*/
ClassMethod CheckKpiFilterList(FilterRule As %String, ByRef dimList)
{
	n (FilterRule,dimList)
	s kpiLen=$l(FilterRule,",")
	k ^TEMPDHCWL($j)
	k dimList
	q:FilterRule=""
	f i=1:1:kpiLen d   //将过滤规则中的指标、(区间)维度、(区间)维度属性保存到global中
	.s aFilterRule=$p(FilterRule,",",i)
	.s kpiCode=$p(aFilterRule,":",1)
	.s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode)=1
	.s Filter=$p(aFilterRule,":",2)
	.s j=2
	.for  s NFilter=$p(Filter,"{",j)  q:NFilter=""  d
	..s dimPro=$p(NFilter,"}",1)
	..s dimCode=$p(dimPro,".",1)
	..i ($g(dimCode)'="") d
	...i ($f(dimCode,"$")'=2) d
	....s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode)=1
	....s proCode=$p(dimPro,".",2)
	....i $g(proCode)'="" s ^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode,proCode)=1
	...else  d
	....s ^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode)=1
	....s proCode=$p(dimPro,".",2)
   	....i $g(proCode)'="" s ^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode,proCode)=1
	..s j=j+1
	
	s kpiCode=""   //将不存在的指标、维度、维度属性放到list中
	for  s kpiCode=$o(^TEMPDHCWL($j,"inputRule","normalDim",kpiCode)) q:kpiCode=""  d
	.s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
	.if kpiId="" d
	..s dimList("kpiCode",kpiCode)=""
	.q:kpiId=""
	.s dimCode=""
	.for  s dimCode=$o(^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode)) q:dimCode=""  d
	..s UpDimCode=$SYSTEM.SQL.ALPHAUP(dimCode)
	..if '$d(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,UpDimCode)) d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:'$d(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,UpDimCode))
	..s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,UpDimCode,""))
	..if kpiDimId="" d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:kpiDimId=""
	..s dimId=$lg(^DHCWL.MKPI.MKPIDimensionsD(kpiDimId),5,"")
	..if ((dimId="")||(dimId=" ")) d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:((dimId="")||(dimId=" "))
	..s proCode=""
	..for  s proCode=$o(^TEMPDHCWL($j,"inputRule","normalDim",kpiCode,dimCode,proCode)) q:proCode=""  d
	...s UProCode=$SYSTEM.SQL.ALPHAUP(proCode)
	...if '$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,UProCode))  d
	....s dimList("proCode",kpiCode_"."_dimCode_"."_proCode)=""
	...q:'$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimId,UProCode))
	.s dimCode=""
	.for  s dimCode=$o(^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode)) q:dimCode=""  d
	..s RDimCode=$p(dimCode,"$",2)
	..if ((RDimCode="")||(RDimCode=" ")) d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:((RDimCode="")||(RDimCode=" "))
	..s RDimCode=$SYSTEM.SQL.ALPHAUP(RDimCode)
	..if ('$d(^DHCWL.MKPI.SectionI("SecCode",RDimCode))) d
	...s dimList("dimCode",kpiCode_"."_dimCode)=""
	..q:('$d(^DHCWL.MKPI.SectionI("SecCode",RDimCode)))
	..s dimId=$o(^DHCWL.MKPI.SectionI("SecCode",RDimCode,""))
	..s proCode=""
	..for  s proCode=$o(^TEMPDHCWL($j,"inputRule","secDim",kpiCode,dimCode,proCode)) q:proCode=""  d
	...s UProCode=$SYSTEM.SQL.ALPHAUP(proCode)
	...if '$d(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,UProCode)) d
	....s dimList("proCode",kpiCode_"."_dimCode_"."_proCode)=""
	...q:'$d(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,UProCode))
	...s ProDimId=$o(^DHCWL.MKPI.SectionPropertyI("SecDimCodeI",dimId,UProCode,""))
	...if '$d(^DHCWL.MKPI.SectionPropertyD(ProDimId)) d
	....s dimList("proCode",kpiCode_"."_dimCode_"."_proCode)=""
	...q:'$d(^DHCWL.MKPI.SectionPropertyD(ProDimId))
	...s ProDimExe=$lg(^DHCWL.MKPI.SectionPropertyD(ProDimId),5,"")
	...if (ProDimExe="")||(ProDimExe=$c(0)) d
	....s dimList("proCode",kpiCode_"."_dimCode_"."_proCode)=""
	...q:(ProDimExe="")||(ProDimExe=$c(0))
	k ^TEMPDHCWL($j)
	s kpiCode="",dimCode="",proCode="",kpis="",dims="",pros=""
	if $d(dimList("kpiCode")) d
	.for  s kpiCode=$o(dimList("kpiCode",kpiCode)) q:kpiCode=""  d
	..if kpis="" d
	...s kpis=kpiCode
	..else  d
	...s kpis=kpis_","_kpiCode
	if $d(dimList("dimCode")) d
	.for  s dimCode=$o(dimList("dimCode",dimCode)) q:dimCode=""  d
	..if dims="" d
	...s dims=dimCode
	..else  d
	...s dims=dims_","_dimCode
	if $d(dimList("proCode")) d
	.for  s proCode=$o(dimList("proCode",proCode)) q:proCode=""  d
	..if pros="" d
	...s pros=proCode
	..else  d
	...s pros=pros_","_proCode
	s dimList("kpiCode")=kpis
	s dimList("dimCode")=dims
	s dimList("proCode")=pros
	q
}

}
