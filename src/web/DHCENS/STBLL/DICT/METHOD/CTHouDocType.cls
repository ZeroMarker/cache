Class web.DHCENS.STBLL.DICT.METHOD.CTHouDocType Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTHouDocType).CTHouDocType()
ClassMethod CTHouDocType(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set cateId="0"  for  set cateId=$o(^DHCEPRM.EPRTemplateCategoryD(cateId)) q:cateId=""  d
	.Quit:((cateId'=input)&&(input'=""))
	.set cateInfo=$g(^DHCEPRM.EPRTemplateCategoryD(cateId))
	.set hoctyObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTHouDocType).%New()
	.set type=$lg(cateInfo,10)
	.Quit:type'="PrtTemplate"
	.set hoctyObj.CTHDTCode=$lg(cateInfo,17)
	.set hoctyObj.CTHDTDesc=$lg(cateInfo,8)
	.set hoctyObj.CTHDTCodeSystemCode="CT_HouDocType"
	.set hoctyObj.CTHDTRemarks="无"
	.set hoctyObj.CTHDTStatus="1"
	.set hoctyObj.CTHDTUpdateUserCode="无"
	.d body.houDocTypes.Insert(hoctyObj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("HSBMES0037",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
