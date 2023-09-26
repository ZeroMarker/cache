Class web.DHCENS.STBLL.DICT.METHOD.CTTarCate Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTTarCate).CTTarCate()

ClassMethod CTTarCate(input As %String) As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set SuccessFlag="0"
	set rowid="0" f  set rowid=$o(^DHCTarC("CC",rowid)) q:rowid=""  d
	.Quit:((rowid'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTTarCate).%New()
	.set insObj.CTCCCode=$p($g(^DHCTarC("CC",rowid)),"^",1)
	.set insObj.CTCCDesc=$p($g(^DHCTarC("CC",rowid)),"^",2)
	.set insObj.CTCCCodesystemCode="CT_ChargeCategory"
	.set insObj.CTCCRemarks="无"
	.set insObj.CTCCStatus="1"
	.set insObj.CTCCUpdateUserCode="无"
	.set insObj.CTCCUpdateDate=$zd(+$h,3)
	.set insObj.CTCCUpdateTime=$zt($p($h,",",2))

	.d body.tarCates.Insert(insObj)
	.Quit:input'=""
	.set Count=body.tarCates.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_ChargeCategory",stream)
	..d body.tarCates.Clear()
	..set result=$p(tSC.Read(),"^",1)
	..if result'["<ResultCode>0</ResultCode>" d
	...set SuccessFlag=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set Count=body.tarCates.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_ChargeCategory",stream)
		d body.tarCates.Clear()
		set result=$p(tSC.Read(),"^",1)
		b ;
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
