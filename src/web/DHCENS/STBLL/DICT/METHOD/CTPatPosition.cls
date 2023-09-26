Class web.DHCENS.STBLL.DICT.METHOD.CTPatPosition Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTPatPosition).PatPosition("")

ClassMethod PatPosition(input As %String) As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set SuccessFlag="0"
	set rowid="0" f  set rowid=$o(^PAC("ADMREA",rowid)) q:rowid=""  d
	.Quit:((rowid'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTPatPosition).%New()
	.set insObj.CTPPCode=$p($g(^PAC("ADMREA",rowid)),"^",1)
	.set insObj.CTPPDesc=$p($g(^PAC("ADMREA",rowid)),"^",2)
	.set insObj.CTPPCodesystemCode="CT_PatientPosition"
	.set insObj.CTPPRemarks="无"
	.set insObj.CTPPStatus="1"
	.set insObj.CTPPUpdateUserCode="无"
	.set insObj.CTPPUpdateDate=$zd(+$h,3)
	.set insObj.CTPPUpdateTime=$zt($p($h,",",2))
	.d body.patPositions.Insert(insObj)
	.Quit:input'=""
	.set Count=body.patPositions.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_PatientPosition",stream)
	..d body.patPositions.Clear()
	..set result=$p(tSC.Read(),"^",1)
	..if result'["<ResultCode>0</ResultCode>" d
	...set SuccessFlag=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	
	set Count=body.patPositions.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_PatientPosition",stream)
		d body.patPositions.Clear()
		set result=$p(tSC.Read(),"^",1)
		if result'["<ResultCode>0</ResultCode>" d
		.set SuccessFlag=-1
	}
	if SuccessFlag'=0 {
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
