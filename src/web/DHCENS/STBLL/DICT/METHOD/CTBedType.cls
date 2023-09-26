Class web.DHCENS.STBLL.DICT.METHOD.CTBedType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012-11-26
/// Description：查询HIS中床位类型字典信息
/// Table：pac_bed
/// Input： 床位类型字典
/// Return：床位类型字典
/// Others：w ##class(web.DHCENS.STBLL.DICT.METHOD.CTBedType).CTBedType("")
ClassMethod CTBedType(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set bedTyId="0"  for  set bedTyId=$o(^PAC("BEDTP",bedTyId)) q:bedTyId=""  d
	.Quit:((bedTyId'=input)&&(input'=""))
	.set bedTyInfo=$g(^PAC("BEDTP",bedTyId))
	.set bedObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTBedType).%New()
	.set bedObj.CTBTCode=$p(bedTyInfo,"^",1)
	.Quit:$p(bedTyInfo,"^",1)=""
	.set bedObj.CTBTDesc=$p(bedTyInfo,"^",2)
	.set bedObj.CTBTCodesystemCode="CT_BedType"
	.set hospCode=""
	.set hospId=$o(^CT("HOSP","0"))
	.set:hospId'="" hospCode=$p(^CT("HOSP",hospId),"^",1)
	.set bedObj.CTBTHosCode=hospCode
	.set bedObj.CTBTRemarks="无"
	.set bedObj.CTBTStatus="1"
	.set bedObj.CTBTUpdateUserCode="无"
	.d body.bedTypes.Insert(bedObj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_BedType",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
