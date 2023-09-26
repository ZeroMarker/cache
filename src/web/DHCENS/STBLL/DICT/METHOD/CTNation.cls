Class web.DHCENS.STBLL.DICT.METHOD.CTNation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：民族字典信息
/// Table：CT_Nation
/// Input： 
/// Return：民族信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICT.METHOD.CTNation).CTNation("")
ClassMethod CTNation(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set natId="0"  for  set natId=$o(^CT("NAT",natId)) q:natId=""  d
	.Quit:((natId'=input)&&(input'=""))
	.set natInfo=$g(^CT("NAT",natId))
	.set natObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTNation).%New()
	.set natObj.CTNCode=$p(natInfo,"^",1)
	.set natObj.CTNDesc=$p(natInfo,"^",2)
	.set natObj.CTNCodesystemCode="CT_Nation"
	.set natObj.CTNRemarks="无"
	.set natObj.CTNStatus="1"
	.set natObj.CTNUpdateUserCode="无"
	.d body.nations.Insert(natObj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Nation",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
