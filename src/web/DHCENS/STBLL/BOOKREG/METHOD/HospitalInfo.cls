Class web.DHCENS.STBLL.BOOKREG.METHOD.HospitalInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.HospitalInfo).SendHospitalInfo("")
ClassMethod SendHospitalInfo(Input As %String) As %String
{
	s $ztrap="ErrorMsg"
	s request=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Request).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s request.header=header
	s body=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Body).%New()
	s hosListObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.HospitalInfoList).%New()
	
	s HospitalCode="HNSRM"
	s HospitalName="河南省人民医院"
	s HospitalLevel="三级甲等"
	s HospitalGegion="金水区"
	s HospitalAddress=""
	s HospitalTel=""
	s HospitalWebsite=""
	s HospitalBriefInfo=""
	s MaxOrderAppNum=""
	s OrderApptStartDate=""
	s OrderApptEndDate=""
	s StopTakeNumTimeAM=""
	s StopTakeNumPM=""
	
	s soap=##class(web.DHCENS.STBLL.BOOKREG.SOAP.PUB0001Soap).%New()
	s hosObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.HospitalInfo).%New()
	s hosObj.TradeCode="T004"
	s hosObj.HospitalId=HospitalCode
	s hosObj.HospitalName=HospitalName
	s hosObj.Addr=HospitalAddress
	s hosObj.Tel=HospitalTel
	s hosObj.WebSite=HospitalWebsite
	s hosObj.HospLevel=""
	s hosObj.HospArea=HospitalGegion
	s hosObj.Desc=HospitalBriefInfo
	s hosObj.MaxRegDays=MaxOrderAppNum
	s hosObj.StartRegTime=OrderApptStartDate
	s hosObj.StopRegTime=OrderApptEndDate
	s hosObj.StopBookTimeM=StopTakeNumTimeAM
	s hosObj.StopBookTimeA=StopTakeNumPM
	d hosListObj.HospitalInfo.Insert(hosObj)
	s body.hospitalInfos=hosListObj
	s request.body=body
	d request.XMLExportToStream(.stream)
	s soap.Timeout="60"
	;b ;lyh 1
	s ret=soap.SaveDictInfo("MES0003",stream)
	q ret.Read()
ErrorMsg
	q "-1^"_$ze
}

}
