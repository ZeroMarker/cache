Import sqluser

/// creator:	yunhaibao
/// createdate: 2017-06-23
/// description:层级关系的药品信息关联
Class web.DHCST.DrugLink Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTDRUGMAINTAIN";

/// creator:	yunhaibao
/// createdate: 2017-06-23
/// description:化学通用名关联药学分类
/// input:      phcCatId(药学分类ID),chemicalId(化学通用名ID)
/// return:     +ret>0(成功)
/// w ##class(web.DHCST.DrugLink).ChemicalLinkPhcCat("15",3015)
ClassMethod ChemicalLinkPhcCat(phcCatId As %String, chemicalId As %String) As %String
{
	n (chemicalId,phcCatId)
	s chemicalId=+chemicalId
	s phcCatId=+phcCatId
	q:chemicalId=0 "-1^化学通用名ID为空"
	q:phcCatId=0 "-1^药学分类ID为空"
	s phcCatObj=##class(User.DHCPHCCat).%OpenId(phcCatId,0)
	q:phcCatObj="" "-1^药学分类不存在"
	s chemicalObj=##class(User.DHCPHChemical).%OpenId(chemicalId)
	q:chemicalObj="" "-1^化学通用名不存在"
	d chemicalObj.%Reload()
	s chemicalObj.PHCMPHCCDr=phcCatObj
	s sc=chemicalObj.%Save()
	i $$$ISERR(sc) d
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.DHCPHChemical",errinfo)
	q chemicalObj.%Id()
}

/// creator:	yunhaibao
/// createdate: 2017-06-28
/// description:处方通用名关联化学通用名
/// input:      chemicalId(化学通用名ID),genericId(处方通用名ID)
/// return:     +ret>0(成功)
/// w ##class(web.DHCST.DrugLink).GenericLinkChemical("15",3015)
ClassMethod GenericLinkChemical(chemicalId As %String, genericId As %String) As %String
{
	n (chemicalId,genericId)
	s chemicalId=+chemicalId
	s genericId=+genericId
	q:chemicalId=0 "-1^化学通用名ID为空"
	q:genericId=0 "-1^处方通用名ID为空"
	s genericObj=##class(User.DHCPhcGeneric).%OpenId(genericId,0)
	q:genericObj="" "-1^处方通用名不存在"
	s chemicalObj=##class(User.DHCPHChemical).%OpenId(chemicalId,0)
	q:chemicalObj="" "-1^化学通用名不存在"
	d genericObj.%Reload()
	s genericObj.PHCGEPHCMDr=chemicalObj
	s sc=genericObj.%Save()
	i $$$ISERR(sc) d
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.DHCPhcGeneric",errinfo)
	q chemicalObj.%Id()
}

/// creator:	yunhaibao
/// createdate: 2017-07-03
/// description:医嘱项关联处方通用名
/// input:      arcItmId(医嘱项ID),genericId(处方通用名ID)
/// return:     +ret>0(成功)
/// w ##class(web.DHCST.DrugLink).ArcItmLinkGeneric("41||1",28)
ClassMethod ArcItmLinkGeneric(arcItmId As %String, genericId As %String) As %String
{
	n (arcItmId,genericId)
	//s ^hlh($h)=$lb(arcItmId,genericId)
	s genericId=+genericId
	q:genericId=0 "-1^处方通用名ID为空"
	s genericObj=##class(User.PHCGeneric).%OpenId(genericId,0)
	q:genericObj="" "-1^处方通用名不存在"
	q:+arcItmId=0 "-1^医嘱项ID为空"
	s arcItmObj=##class(User.ARCItmMast).%OpenId(arcItmId,0)
	q:arcItmObj="" "-1^医嘱项不存在"
	ts
	s $ZT="Error^DHCSTERROR"
	s phcdObj=arcItmObj.ARCIMPHCDFDR.PHCDFPHCDParRef
	i phcdObj="" tro  q "-1^医嘱项与药学项无关联"
	d phcdObj.%Reload()
	s phcdObj.PHCDGenericDR=genericObj
	s sc=phcdObj.%Save()
	s errinfo=""
	i $$$ISERR(sc) d
	.tro
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.PHCDrgMast",errinfo)
	q:errinfo'="" "-1^"_errinfo
	d arcItmObj.%Reload()
	s arcItmObj.ARCIMGenericDR=genericObj
	s arcItmObj.ARCIMGenericDesc=genericObj.PHCGEName
	s sc=arcItmObj.%Save()
	i $$$ISERR(sc) d
	.tro
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.ARCItmMast",errinfo)
	q:errinfo'="" "-1^"_errinfo
	tc
	d ##class(web.DHCST.PHCGeneric).UpdatePhcForm(genericId)
	q +arcItmId
}

/// creator:	yunhaibao
/// createdate: 2017-07-14
/// description:库存项关联医嘱项
/// input:      incItmId(库存项ID),arcItmId(医嘱项ID)
/// return:     +ret>0(成功)
/// w ##class(web.DHCST.DrugLink).IncItmLinkArcItm("9685","14651||1")
ClassMethod IncItmLinkArcItm(incItmId As %String, arcItmId As %String) As %String
{
	n (incItmId,arcItmId)
	s arcItmId=arcItmId
	s incItmId=+incItmId
	s incItmObj=##class(User.INCItm).%OpenId(incItmId,0)
	q:'incItmObj "-1^库存项不存在"
	s arcItmObj=##class(User.ARCItmMast).%OpenId(arcItmId,0)
	q:'incItmObj "-1^医嘱项不存在"
	s genericObj=arcItmObj.ARCIMGenericDR
	q:'genericObj "-1^医嘱项尚未关联处方通用名"
	d incItmObj.%Reload()
	s incItmObj.INCIOriginalARCIMDR=arcItmObj
	s sc=incItmObj.%Save()
	s errCode=""
	i $$$ISERR(sc) d
	.s errinfo=$System.Status.GetErrorText(sc)
	.s errinfo=$tr(errinfo,"^","")
	.d ErrorRecord^DHCSTERROR(..#AppName,"User.INCItm",errinfo)
	.s errCode="-1^关联失败,"_errinfo
	q:errCode'="" errCode
	d ##class(web.DHCST.INCITM).UpdArcimFromInc(incItmId)
	q incItmObj.%Id()
}

/// creator:	yunhaibao
/// createdate: 2017-06-23
/// description:化学通用名是否存在关联关系
/// input:      chemicalId(化学通用名ID)
/// return:     +ret=""(不存在关联关系)
/// w ##class(web.DHCST.DrugLink).CheckChemicalLink(3020)
ClassMethod CheckChemicalLink(chemicalId As %String) As %String
{
	n (chemicalId)
	s chemicalId=+chemicalId 
	q:chemicalId=0 "-1^化学通用名ID为空"
	s dhcGeneId=$o(^PHCGE("GE",0,"PHCM",chemicalId,""))
	q:dhcGeneId="" ""
	q:'$d(^PHCGE("GE",dhcGeneId)) ""
	s phcGeneDesc=$p($g(^PHCGE("GE",dhcGeneId)),"^",2)
	q "-1^已关联处方通用名:"_phcGeneDesc
}

/// creator:	yunhaibao
/// createdate: 2017-07-13
/// description:药学分类是否存在关联关系
/// input:      phcCatId(药学分类ID)
/// return:     +ret=""(不存在关联关系)
/// w ##class(web.DHCST.DrugLink).CheckPhcCatLink(14)
ClassMethod CheckPhcCatLink(phcCatId As %String) As %String
{
	n (phcCatId)
	s phcCatId=+phcCatId 
	q:phcCatId=0 "-1^药学分类ID为空"
	s chemicalDesc=""
	s chemicalId=$o(^DHCPHCMi("PHCC",phcCatId,""))
	i chemicalId'="" s chemicalDesc=$p($g(^DHCPHCM(chemicalId)),"^",2)
	q:chemicalDesc'="" "-1^已关联化学通用名:"_chemicalDesc
	
	s hospDr=$p(^DHCPHCC(phcCatId),"^",5)
	s rowId=""
	f  s rowId=$o(^DHCPHCC(0,"PARCAT",hospDr,phcCatId,rowId))  q:(rowId="")||(chemicalDesc'="")  d
	.s chemicalDesc=..CheckPhcCatLink(rowId)
    q chemicalDesc
}

/// creator:	yunhaibao
/// createdate: 2017-07-14
/// description:处方通用名是否存在关联关系
/// input:      genericId(处方通用名ID)
/// return:     +ret=""(不存在关联关系)
/// w ##class(web.DHCST.DrugLink).CheckGenericLink(3)
ClassMethod CheckGenericLink(genericId As %String) As %String
{
	n (genericId)
	s genericId=+genericId 
	q:genericId=0 "-1^处方通用名ID为空"
	s genericObj=##class(User.DHCPhcGeneric).%OpenId(genericId,0)
	q:genericObj="" "-1^处方通用名不存在"	
	s arcItmId=$o(^ARCIM(0,"Gener",genericId,""))
	s arcItmObj=##class(User.ARCItmMast).%OpenId(arcItmId_"||"_1,0)
	i arcItmObj d
	.s arcItmDesc=arcItmObj.ARCIMDesc
	e  s arcItmDesc=""
	q:arcItmDesc'="" "-1^已关联医嘱项:"_arcItmDesc
	q 0
}

}
