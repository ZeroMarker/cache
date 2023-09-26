Class web.DHCENS.STBLL.DICT.METHOD.CTBodyArea Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012-11-26
/// Description：查询HIS中检查部位字典信息
/// Table：DHCAppPart
/// Input： 
/// Return：检查部位字典
/// Others：w ##class(web.DHCENS.STBLL.DICT.METHOD.CTBodyArea).CTBodyArea("8629")
ClassMethod CTBodyArea(input As %String) As %String
{
	set success=0
	set $zt="Exception"	
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set bodyAreaId="0"  for  set bodyAreaId=$o(^DHCAPPART(bodyAreaId)) q:bodyAreaId=""  d
	.Quit:((bodyAreaId'=input)&&(input'=""))
	.set bodyAreaInfo=$g(^DHCAPPART(bodyAreaId))
	.set bedObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTBodyArea).%New()
	.set bedObj.CTBACode=$p(bodyAreaInfo,"^",1)
	.set bedObj.CTBADesc=$p(bodyAreaInfo,"^",1)
	.set bedObj.CTBACodesystemCode="CT_BodyArea"
	.set bedObj.CTBARemarks="无"
	.set bedObj.CTBAStatus="1"
	.set bedObj.CTBAUpdateDate=""
	.d body.bodyAreas.Insert(bedObj)
	.Quit:input'=""		
	.set Count=body.bodyAreas.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_BodyArea",stream)
	..d body.bodyAreas.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	
	set Count=body.bodyAreas.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_BodyArea",stream)
		d body.bodyAreas.Clear()
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.s success=-1
	}
	
	if success'=0 {
		s RetStr="-1^失败"
	}
	else{
		s RetStr="0^成功"
	}
	Quit RetStr
	
Exception
	Quit "-1^"_$ze
}

}
