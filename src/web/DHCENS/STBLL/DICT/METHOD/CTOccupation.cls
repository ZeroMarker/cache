Class web.DHCENS.STBLL.DICT.METHOD.CTOccupation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：职业字典信息
/// Table：CT_Occupation
/// Input： 
/// Return：职业信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTOccupation).CTOccupation("")
ClassMethod CTOccupation(input As %String) As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set success=0
	set occId="0"  for  set occId=$o(^CT("OCC",occId)) q:occId=""  d
	.Quit:((occId'=input)&&(input'=""))
	.set occInfo=$g(^CT("OCC",occId))
	.set occObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTOccupation).%New()
	.set occObj.CTOCode=$p(occInfo,"^",1)
	.set occObj.CTODesc=$p(occInfo,"^",2)
	.set occObj.CTOCodesystemCode="CT_Occupation"
	.set occObj.CTORemarks="无"
	.set occObj.CTOStatus="1"
	.set occObj.CTOUpdateUserCode="无"
	.d body.occs.Insert(occObj)
	.set count=body.occs.Count()
	.if count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_Occupation",stream)
	..d body.occs.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set Count=body.occs.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_Occupation",stream)
		d body.occs.Clear()
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
