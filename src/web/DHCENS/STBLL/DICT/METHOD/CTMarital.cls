Class web.DHCENS.STBLL.DICT.METHOD.CTMarital Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：婚姻类型字典信息
/// Table：CT_Marital
/// Input： 
/// Return：婚姻类型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTMarital).CTMarital("")
ClassMethod CTMarital(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set maritalId="0"  for  set maritalId=$o(^CT("MAR",maritalId)) q:maritalId=""  d
	.Quit:((maritalId'=input)&&(input'=""))
	.set maritalInfo=$g(^CT("MAR",maritalId))
	.set maritalObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTMarital).%New()
	.set maritalObj.CTMCode=$p(maritalInfo,"^",1)
	.set maritalObj.CTMDesc=$p(maritalInfo,"^",2)
	.set maritalObj.CTMCodesystemCode="CT_Marital"
	.set maritalObj.CTMRemarks="无"
	.set maritalObj.CTMStatus="1"
	.set maritalObj.CTMUpdateUserCode="无"
	.d body.maritals.Insert(maritalObj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Marital",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
