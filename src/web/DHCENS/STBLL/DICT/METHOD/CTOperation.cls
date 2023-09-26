Class web.DHCENS.STBLL.DICT.METHOD.CTOperation Extends (%RegisteredObject, %XML.Adaptor)
{

// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTOperation).CTOperation()

ClassMethod CTOperation(input As %String) As %String
{
	set SuccessFlag=0
	set $zt="Exception"	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set operRowId="0"  for  set operRowId=$o(^ORC("OPER",operRowId)) q:operRowId=""  d
	.Quit:((operRowId'=input)&&(input'=""))
	.set operInfo=$g(^ORC("OPER",operRowId))
	.set operationObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTOperation).%New()
	.set operationObj.OperationCode=$P(operInfo,"^",1)
	.set operationObj.OperationName=$P(operInfo,"^",2)
	.set operationObj.CTOPUpdateUserCode="无"
	.set operationObj.CTOPStatus="1"
	.d body.operations.Insert(operationObj)	
	.Quit:input'=""
	.set Count=body.operations.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_Operation",stream)
	..d body.operations.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=1 d
	...set SuccessFlag=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set Count=body.operations.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_Operation",stream)
		d body.operations.Clear()
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=1 d
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
