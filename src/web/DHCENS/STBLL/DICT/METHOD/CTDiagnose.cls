Class web.DHCENS.STBLL.DICT.METHOD.CTDiagnose Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：诊断字典信息
/// Table：MRC_ICDDx
/// Input： 
/// Return：诊断信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDiagnose).CTDiagnose("")
ClassMethod CTDiagnose(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set SuccessFlag=0
	set diagId="0" f  set diagId=$o(^MRC("ID",diagId)) q:diagId=""  d
	.Quit:((diagId'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTDiagnose).%New()
	.set insObj.CTDCode=$p($g(^MRC("ID",diagId)),"^",1)
	.set insObj.CTDDesc=$p($g(^MRC("ID",diagId)),"^",2)
	.set CTDICDCode=$p($g(^MRC("ID",diagId)),"^",4)
	.set CTDICDCode=$tr(CTDICDCode,$c(34),"")
	.set insObj.CTDICDCode=CTDICDCode
	.set insObj.CTDCodesystemCode="CT_Diagnose"
	.set insObj.CTDStatus="1"
	.set insObj.CTDUpdateUserCode="无"	
	.d body.diagnoses.Insert(insObj)
	.Quit:input'=""	
	.set Count=body.diagnoses.Count()
	.if Count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_Diagnose",stream)
	..d body.diagnoses.Clear()
	..set result=$p(tSC,"^",1)
	..if result'=1 d
	...set SuccessFlag=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	
	set Count=body.diagnoses.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_Diagnose",stream)
		d body.diagnoses.Clear()
		set result=$p(tSC,"^",1)
		if result'=1 d
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
