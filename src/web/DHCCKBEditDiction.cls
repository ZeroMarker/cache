Import sqluser

/// SHY
Class web.DHCCKBEditDiction Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据id/名称 获取字典的数据类型-判断是否tree
/// Shy
/// input:
/// output:
/// debugger: w ##class(web.DHCCKBEditDiction).GetDicDataType(106)
ClassMethod GetDicDataType(dicID) As %String
{
	n (dicID)

    // 获取数据类型	
	s dataTypeDr=##class(web.DHCCKBCommon).GetDataType()
	s dataTypeId=..GetDataType(dataTypeDr,dicID)
	s dataTypeCode="",dataTypeLinkDr=""
	s:dataTypeId'="" dataTypeLinkDr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,dataTypeId,""))
	s dataType="data"  //空类型返回data
	i dataTypeLinkDr'="" s dataType=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dataTypeLinkDr)),4)
	i dataType'="" s dataTypeCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataType)),2)
	s:dataTypeCode="" dataTypeCode="data" 
	q dataTypeCode
}

/// Description:获取数据类型的ID,由于实体等的附加属性关联的是附加属性里的数据类型等，需要单独取出判断
/// w ##class(web.DHCCKBEditDiction).GetDataType(47,79)
ClassMethod GetDataType(dataTypeDr, dicID)
{
	n (dataTypeDr,dicID)
	
	s AttrCodeId="",RetTypeId=""
	for  s AttrCodeId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,AttrCodeId))  Q:(AttrCodeId="")||(RetTypeId'="")  d
	.s:AttrCodeId=dataTypeDr RetTypeId=AttrCodeId
	.Q:RetTypeId'=""
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)
	.s:LinkId=dataTypeDr RetTypeId=AttrCodeId
	Q RetTypeId
}

/// Description:	获取实体下的实例(tree结构,treegrid)
/// Creator:		sunhuiyong 
/// CreateDate:		2019-12-27	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBEditDiction).GetTreeJson("","106","青霉素")
ClassMethod GetTreeJson(q As %String = "", parref As %String, desc As %String) As %String
{
	n (q,parref,desc)
	
	s input=$zcvt(q,"U")
	i parref="" w "[]"
	q:parref="" ""
	
	w "["
	s count=0
	s dicID=""  f  s dicID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:+dicID=0
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicCode = $tr(dicCode,$c(10),"")
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s dicDesc = $tr(dicDesc,$c(10),"")
	.q:dicDesc'[desc
	.s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStart(dicID,dicDesc,dicCode)
	.s subID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dicID,""))
	.i subID'="" d
	..w ",""children"":"
	..D ..GetTreeJson(input,dicID)   ///是否有叶子节点
	.w "}"
	.//q:(input'="")&(dicDesc'[input)&(pinDicDesc'[input)&(dicCode'[input)
	
	w "]"
	
	q ""
}

}
