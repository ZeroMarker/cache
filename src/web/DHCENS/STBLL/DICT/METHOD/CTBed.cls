Class web.DHCENS.STBLL.DICT.METHOD.CTBed Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012-11-26
/// Description：查询HIS中床位字典信息
/// Table：pac_bed
/// Input： 床位字典
/// Return：床位字典
/// Others：w ##class(web.DHCENS.STBLL.DICT.METHOD.CTBed).CTBed("")
ClassMethod CTBed(input As %String) As %String
{
	set success=0
	set $zt="Exception"	
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set wardId="0"  for  set wardId=$o(^PAWARD(wardId)) q:wardId=""  d
	.set bedId="0"  for  set bedId=$o(^PAWARD(wardId,"BED",bedId)) q:bedId=""  d
	..Quit:((wardId_"||"_bedId'=input)&&(input'=""))
	..set bedInfo=$g(^PAWARD(wardId,"BED",bedId))
	..set bedObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTBed).%New()
	..set bedObj.CTBCode=$p(bedInfo,"^",1)
	..set bedObj.CTBDesc=$p(bedInfo,"^",1)
	..set bedObj.CTBCodesystemCode="CT_Bed"
	..set locId=$p($g(^PAWARD(wardId)),"^",5)
	..Quit:locId=""
	..set hospId=$p(^CTLOC(locId),"^",22)
	..set:hospId="" hospId=$o(^CT("HOSP","0"))
	..set hospCode=$p(^CT("HOSP",hospId),"^",1)	
	..set bedObj.CTBHosCode=hospCode
	..set roomId=$p(bedInfo,"^",3)
	..set bedObj.CTBRoomCode=$p($g(^PAROOM(roomId)),"^",1)
	..set bedObj.CTBRemarks="无"
	..set bedObj.CTBStatus="1"
	..set bedObj.CTBUpdateUserCode="无"
	..set bedObj.CTBWardCode=$p($g(^PAWARD(wardId)),"^",1)
	..set bedTyId=$p(bedInfo,"^",2)
	..set:bedTyId="" bedTyId="3"
	..set bedObj.CTBBedType=$p($g(^PAC("BEDTP",bedTyId)),"^",1)
	..d body.beds.Insert(bedObj)
	..Quit:input'=""	
	..set Count=body.beds.Count()
	..if Count>200 d
	...set request.body=body
	...d request.XMLExportToStream(.stream)
	...set soapObj.Timeout="60"
	...set tSC=soapObj.SaveManagerDataInfo("CT_Bed",stream)
	...d body.beds.Clear()
	...set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	...if resultCode'=0 d
	....s success=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	
	set Count=body.beds.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_Bed",stream)
		d body.beds.Clear()
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
