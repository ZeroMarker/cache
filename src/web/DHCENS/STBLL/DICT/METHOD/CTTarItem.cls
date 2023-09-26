Class web.DHCENS.STBLL.DICT.METHOD.CTTarItem Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTTarItem).CTTarItem("")

ClassMethod CTTarItem(input As %String) As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set SuccessFlag="0"
	set rowid="0" f  set rowid=$o(^DHCTARI(rowid)) q:rowid=""  d
	.Quit:((rowid'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTTarItem).%New()
	.set insObj.CTCICode=$p($g(^DHCTARI(rowid)),"^",1)
	.set insObj.CTCIDesc=$p($g(^DHCTARI(rowid)),"^",2)
	.set tarCateSubRowid=$p($g(^DHCTARI(rowid)),"^",4)
	.set:tarCateSubRowid'="" insObj.CTCIChargeChildCode=$p($g(^DHCTarC("SC",tarCateSubRowid)),"^",1)
	.set insObj.CTCICodesystemCode="CT_ChargeItem"
	.set insObj.CTCIRemarks="无"
	.set insObj.CTCIStatus="1"
	.set insObj.CTCIUpdateUserCode="无"
	.set insObj.CTCIUpdateDate=$zd(+$h,3)
	.set insObj.CTCIUpdateTime=$zt($p($h,",",2))

	.d body.tarItems.Insert(insObj)
	.Quit:input'=""
	.set Count=body.tarItems.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_ChargeItem",stream)
	..d body.tarItems.Clear()
	..set result=$p(tSC.Read(),"^",1)
	..if result'["<ResultCode>0</ResultCode>" d
	...set SuccessFlag=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set Count=body.tarItems.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_ChargeItem",stream)
		d body.tarItems.Clear()
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
