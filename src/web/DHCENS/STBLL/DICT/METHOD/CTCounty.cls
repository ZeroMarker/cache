Class web.DHCENS.STBLL.DICT.METHOD.CTCounty Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：区县字典信息
/// Table：CT_CityArea
/// Input： 
/// Return：区县字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTCounty).CTCounty("")
ClassMethod CTCounty(input As %String) As %String
{
	set $zt="Exception"
	set success=0
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	s citAreaId=0 f  s citAreaId=$O(^CT("CITAREA",citAreaId)) q:citAreaId=""  d
	.Quit:((citAreaId'=input)&&(input'=""))
	.s Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTCounty).%New()
	.s Str=$g(^CT("CITAREA",citAreaId))
	.s Obj.CTCCode=$p(Str,"^",1)
	.s Obj.CTCDesc=$p(Str,"^",2)
	.s cityDr=$p(Str,"^",3)
	.i cityDr'="" d
	..set cityInfo=$g(^CT("CIT",cityDr)) 
	..set Obj.CTCCCode=$p(cityInfo,"^",1)
	.set Obj.CTCCodesystemCode="CT_County"
	.set Obj.CTCStatus="1"
	.set Obj.CTCRemarks="无"
	.set Obj.CTCUpdateUserCode="-"
	.d body.countys.Insert(Obj)
	.set count=body.countys.Count()
	.if count>200 d
	..set request.body=body	
	..d request.XMLExportToStream(.stream)
	..set tSC=soapObj.SaveManagerDataInfo("CT_County",stream)
	..d body.countys.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set Count=body.countys.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_County",stream)
		d body.countys.Clear()
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
