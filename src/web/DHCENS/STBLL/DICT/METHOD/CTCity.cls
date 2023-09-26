Class web.DHCENS.STBLL.DICT.METHOD.CTCity Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：市内字典信息
/// Table：CT_City
/// Input： 
/// Return：市内字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTCity).CTCity("")
ClassMethod CTCity(input As %String) As %String
{
	set $zt="Exception"
	set success=0
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	s citId=0 f  s citId=$O(^CT("CIT",citId)) q:citId=""  d
	.Quit:((citId'=input)&&(input'=""))
	.s Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTCity).%New()
	.s Str=$g(^CT("CIT",citId))
	.s Obj.CTCCode=$p(Str,"^",1)
	.s Obj.CTCDesc=$p(Str,"^",2)
	.s provDr=$p(Str,"^",4)
	.s provCode=""
	.i provDr'="" d
	..set provInfo=$g(^CT("PROV",provDr)) 
	..set Obj.CTCPCode=$p(provInfo,"^",1)
	.set Obj.CTCCodesystemCode="CT_City"
	.set Obj.CTCStatus="1"
	.set Obj.CTCUpdateUserCode="无"
	.d body.citys.Insert(Obj)
	.set count=body.citys.Count()
	.if count>200 d
	..set request.body=body	
	..d request.XMLExportToStream(.stream)
	..set tSC=soapObj.SaveManagerDataInfo("CT_City",stream)
	..d body.citys.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set Count=body.citys.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_City",stream)
		d body.citys.Clear()
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
