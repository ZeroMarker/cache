Class web.DHCENS.STBLL.DICT.METHOD.CTProvince Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：省字典信息
/// Table：CT_Province
/// Input： 
/// Return：省信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTProvince).CTProvince("")
ClassMethod CTProvince(input As %String) As %String
{
	set success=0
	set $zt="Exception"	
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set provId="0"  for  set provId=$o(^CT("PROV",provId)) q:provId=""  d
	.Quit:((provId'=input)&&(input'=""))
	.set provInfo=$g(^CT("PROV",provId))
	.set provObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTProvince).%New()
	.set provObj.CTPCode=$p(provInfo,"^",1)
	.set provObj.CTPDesc=$p(provInfo,"^",2)
	.set provObj.CTPCodesystemCode="CT_Province"
	.set provObj.CTPRemarks="无"
	.set provObj.CTPStatus="1"
	.set provObj.CTPUpdateUserCode="无"
	.Quit:input'=""	
	.d body.provinces.Insert(provObj)
	.set Count=body.provinces.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_Province",stream)
	..d body.provinces.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	
	set Count=body.provinces.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_Province",stream)
		d body.provinces.Clear()
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
