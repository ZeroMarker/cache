Class web.DHCENS.STBLL.DICT.METHOD.CTARCItmMast Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012-11-26
/// Description：查询HIS中医嘱项目信息
/// Table：ARC_ItmMast
/// Input： 医嘱项目字典
/// Return：医嘱项目信息
/// Others：w ##class(web.DHCENS.STBLL.DICT.METHOD.CTARCItmMast).CTARCItmMast("")
ClassMethod CTARCItmMast(input As %String) As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set sucessFlag=0
	set OrCatRowId="0" f  set OrCatRowId=$o(^OEC("ORCAT",OrCatRowId)) q:OrCatRowId=""  d
	.set ArcIcRowId="" f  set ArcIcRowId=$o(^ARC("IC",0,"OrdCat",OrCatRowId,ArcIcRowId)) q:ArcIcRowId=""  d 
	..set ArmSub=""  f  set ArmSub=$O(^ARCIM(0,"ARCIC_DR",ArcIcRowId,ArmSub)) q:ArmSub=""  d
	...set ArmVer=""  f  set ArmVer=$O(^ARCIM(0,"ARCIC_DR",ArcIcRowId,ArmSub,ArmVer))  q:ArmVer=""  d
	....Quit:((ArmSub_"||"_ArmVer'=input)&&(input'=""))
	....set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTARCItmMast).%New()
	....set insObj.CTARCIMCode=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",1)
	....set CTARCIMDesc=$tr($p($g(^ARCIM(ArmSub,ArmVer,1)),"^",2),"""","")
	....set CTARCIMDesc=$tr(CTARCIMDesc,$c(31),"")
	....set insObj.CTARCIMDesc=CTARCIMDesc
	....set insObj.CTARCIMChildCategory=$P($g(^ARC("IC",ArcIcRowId)),"^",1)
	....set insObj.CTARCIMCodesystemCode="CT_ARCItmMast"
	....set insObj.CTARCIMStatus="1"
	....set insObj.CTARCIMUpdateUserCode="无"
	....d body.arcItmMasts.Insert(insObj)
	....Quit:input'=""
	....set Count=body.arcItmMasts.Count()
	....if Count>200 d
	.....set request.body=body
	.....d request.XMLExportToStream(.stream)
	.....s tSC= soapObj.SaveManagerDataInfo("CT_ARCItmMast",stream)
	.....d body.arcItmMasts.Clear()
	.....set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	.....if resultCode'=0 d
	......s success=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
		
	set Count=body.arcItmMasts.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_ARCItmMast",stream)
		d body.arcItmMasts.Clear()
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.s success=-1
	}
	Quit sucessFlag
Exception
	q "-1^"_$ze
}

}
