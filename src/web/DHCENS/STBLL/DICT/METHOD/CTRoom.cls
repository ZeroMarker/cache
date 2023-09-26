Class web.DHCENS.STBLL.DICT.METHOD.CTRoom Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：房间字典信息
/// Table：pac_room
/// Input： 
/// Return：房间信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTRoom).CTCTRoom("")
ClassMethod CTCTRoom(input As %String) As %String
{
	set $zt="Exception"
	set success="0"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set roomId="0" for  set roomId=$o(^PAROOM(roomId)) q:roomId=""  d
	.Quit:((roomId'=input)&&(input'=""))
	.set roomInfo=$g(^PAROOM(roomId))
	.set roomObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTRoom).%New()
	.set roomObj.CTRCode=$p(roomInfo,"^",1)
	.set roomObj.CTRDesc=$p(roomInfo,"^",2)
	.set roomObj.CTRCodesystemCode="CT_Room"
	.set hospId=$o(^CT("HOSP","0"))
	.set hospCode=$p(^CT("HOSP",hospId),"^",1)
	.set roomObj.CTRHosCode=hospCode
	.set roomObj.CTRRemarks="无"
	.set roomObj.CTRStatus="1"
	.set roomObj.CTRUpdateUserCode="无"
	.d body.rooms.Insert(roomObj)
	.Quit:input'=""
	.s count=body.rooms.Count() 
	.if count>200 d
	..set soapObj.Timeout="60"
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set tSC=soapObj.SaveManagerDataInfo("CT_Room",stream)
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	..d body.rooms.Clear()
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	if (count>0){
		set request.body=body
		d request.XMLExportToStream(.stream)
		set tSC=soapObj.SaveManagerDataInfo("CT_Room",stream)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.set success=-1
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
