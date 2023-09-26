Class web.DHCENS.STBLL.DICT.METHOD.CTAllergyCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016-11-26
/// Description：过敏类型信息
/// Table： MRC_AllType
/// Input： 
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.DICT.METHOD.CTAllergyCategory).CTAllergyCategory("")
ClassMethod CTAllergyCategory(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set diagTypeId="0"  for  set diagTypeId=$o(^MRC("AT",diagTypeId)) 	q:diagTypeId=""  d
	.Quit:((diagTypeId'=input)&&(input'=""))
	.set obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTAllergyCategory).%New()
	.set obj.CTACCode=$P(^MRC("AT",diagTypeId),"^",1)
	.set obj.CTACCodesystemCode="CT_AllergyCategory"
	.set obj.CTACDesc=$P(^MRC("AT",diagTypeId),"^",2)
	.set obj.CTACRemarks=""
	.set obj.CTACStatus="1"
	.set obj.CTACUpdateUserCode="无"
	.d body.allergyCategorys.Insert(obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_AllergyCategory",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
