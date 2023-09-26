Class web.DHCENS.STBLL.DICT.METHOD.CTCountry Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：国家字典信息
/// Table：CT_Country
/// Input： 
/// Return：国家字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTCountry).CTCountry("")
ClassMethod CTCountry(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set couId="0"  for  set couId=$o(^CT("COU",couId)) q:couId=""  d
	.Quit:((couId'=input)&&(input'=""))
	.set couInfo=$g(^CT("COU",couId))
	.set couObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTCountry).%New()
	.set couObj.CTCCode=$p(couInfo,"^",1)
	.set CTCDesc=$p(couInfo,"^",2)
	.set CTCDesc=$tr(CTCDesc,$c(34),"")
	.set couObj.CTCDesc=$p(couInfo,"^",2)
	.set couObj.CTCCodesystemCode="CT_Country"
	.set couObj.CTCRemarks="无"
	.set couObj.CTCStatus="1"
	.set couObj.CTCUpdateUserCode="无"
	.d body.countrys.Insert(couObj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Country",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
