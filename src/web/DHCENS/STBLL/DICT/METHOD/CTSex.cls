Class web.DHCENS.STBLL.DICT.METHOD.CTSex Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：性别字典信息
/// Table：ct_Sex
/// Input： 
/// Return：性别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTSex).CTSex("")
ClassMethod CTSex(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set sexId="0"  for  set sexId=$o(^CT("SEX",sexId)) q:sexId=""  d
	.Quit:((sexId'=input)&&(input'=""))
	.set sexInfo=$g(^CT("SEX",sexId))
	.set sexObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTSex).%New()
	.set sexObj.CTSCode=$p(sexInfo,"^",1)
	.set sexObj.CTSDesc=$p(sexInfo,"^",2)
	.set sexObj.CTSCodesystemCode="CT_Sex"
	.set sexObj.CTSRemarks="无"
	.set sexObj.CTSStatus="1"
	.set sexObj.CTSUpdateUserCode="无"
	.d body.sexs.Insert(sexObj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Sex",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
