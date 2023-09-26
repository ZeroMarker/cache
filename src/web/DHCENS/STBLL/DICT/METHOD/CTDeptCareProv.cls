Class web.DHCENS.STBLL.DICT.METHOD.CTDeptCareProv Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDeptCareProv).CTDeptCareProv("")

ClassMethod CTDeptCareProv(input As %String) As %String
{
	set SuccessFlag=0
	set $zt="Exception"	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set resRowId="0"  for  set resRowId=$o(^RB("RES",resRowId)) q:resRowId=""  d
	.Quit:((resRowId'=input)&&(input'=""))
	.set resourceInfo=$g(^RB("RES",resRowId))
	.set deptCareObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTDeptCareProv).%New()
	.set CareProvId=$p(resourceInfo,"^",2)
	.set:CareProvId'="" deptCareObj.CTDCPCareProvCode=$P($G(^CTPCP(CareProvId,1)),"^",1)
	.set DeptId=$p(resourceInfo,"^",1)
	.set:DeptId'="" deptCareObj.CTDCPDeptCode=$p($g(^CTLOC(DeptId)),"^",1)
	.set deptCareObj.CTDCPUpdateUserCode="无"
	.d body.deptCareProvs.Insert(deptCareObj)
	.Quit:input'=""	
	.set Count=body.deptCareProvs.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_DeptCareProv",stream)
	..d body.deptCareProvs.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...set SuccessFlag=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	
	set Count=body.deptCareProvs.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_DeptCareProv",stream)
		d body.deptCareProvs.Clear()
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.b ;?
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
