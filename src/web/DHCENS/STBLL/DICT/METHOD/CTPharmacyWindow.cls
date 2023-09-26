Class web.DHCENS.STBLL.DICT.METHOD.CTPharmacyWindow Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTPharmacyWindow).PharmacyWindow()

/// 药方窗口字典
ClassMethod PharmacyWindow() As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set SuccessFlag="0"
	set rowid="0" f  set rowid=$o(^DHCPHWIN(rowid)) q:rowid=""  d
	.set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTPharmacyWindow).%New()
	.set insObj.CTPWWindowCode=rowid
	.set insObj.CTPWWindowDesc=$p($g(^DHCPHWIN(rowid)),"^",1)
	.set insObj.CTPWStatus=$p($g(^DHCPHWIN(rowid)),"^",3)
	.set insObj.CTPWCodesystemCode="CT_PharmacyWindow"
	.set phlocDr=$p($g(^DHCPHWIN(rowid)),"^",2)
	.if phlocDr'="" d 
	..s ctlocDr=$p($g(^DHCPHLOC(phlocDr)),"^",1)
	..if ctlocDr'="" d
	...s insObj.CTPWDeptCode=$p($g(^CTLOC(ctlocDr)),"^",1)
	...s insObj.CTPWDeptDesc=$p($g(^CTLOC(ctlocDr)),"^",2)
	
	.set insObj.CTPWRemarks="无"
	.set insObj.CTPWStatus="1"
	.set insObj.CTPWUpdateUserCode="无"
	.set insObj.CTPWUpdateDate=$zd(+$h,3)
	.set insObj.CTPWUpdateTime=$zt($p($h,",",2))

	.d body.pharmacyWindows.Insert(insObj)
	.set Count=body.pharmacyWindows.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_PharmacyWindow",stream)
	..d body.pharmacyWindows.Clear()
	..set result=$p(tSC.Read(),"^",1)
	..if result'["<ResultCode>0</ResultCode>" d
	...set SuccessFlag=-1
	
	set Count=body.pharmacyWindows.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_PharmacyWindow",stream)
		d body.pharmacyWindows.Clear()
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
