Class web.DHCENS.STBLL.DICT.METHOD.CTTarSubCate Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTTarSubCate).CTTarSubCate("")

ClassMethod CTTarSubCate(input As %String) As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set SuccessFlag="0"
	set rowid="0" f  set rowid=$o(^DHCTarC("SC",rowid)) q:rowid=""  d
	.Quit:((rowid'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTTarSubCate).%New()
	.set insObj.CTCCCCode=$p($g(^DHCTarC("SC",rowid)),"^",1)
	.set insObj.CTCCCDesc=$p($g(^DHCTarC("SC",rowid)),"^",2)
	.set tarCateRowid=$p($g(^DHCTarC("SC",rowid)),"^",3)
	.set:tarCateRowid'="" insObj.CTCCCParentCode=$p($g(^DHCTarC("CC",tarCateRowid)),"^",1)
	.set insObj.CTCCCCodesystemCode="CT_ChargeChildCategory"
	.set insObj.CTCCCRemarks="无"
	.set insObj.CTCCCStatus="1"
	.set insObj.CTCCCUpdateDate="无"
	.set insObj.CTCCCUpdateUserCode="无"
	.set insObj.CTCCCUpdateDate=$zd(+$h,3)
	.set insObj.CTCCCUpdateTime=$zt($p($h,",",2))

	.d body.tarSubCates.Insert(insObj)
	.Quit:input'=""
	.set Count=body.tarSubCates.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_ChargeChildCategory",stream)
	..d body.tarSubCates.Clear()
	..set result=$p(tSC.Read(),"^",1)
	..if result'["<ResultCode>0</ResultCode>" d
	...set SuccessFlag=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set Count=body.tarSubCates.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_ChargeChildCategory",stream)
		d body.tarSubCates.Clear()
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
