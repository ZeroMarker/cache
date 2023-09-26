Class web.DHCENS.STBLL.DICT.METHOD.CTWard Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：病区字典信息
/// Table：
/// Input： pac_ward
/// Return：病区字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTWard).CTWard("")
ClassMethod CTWard(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set wardId="0"  for  set wardId=$o(^PAWARD(wardId)) q:wardId=""  d
	.Quit:wardId="BED_BedType_DR"
	.Quit:wardId="BED_Room_DR"
	.Quit:((wardId'=input)&&(input'=""))
	.set wardObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTWard).%New()
	.set wardInfo=$g(^PAWARD(wardId))
	.set wardObj.CTWCode=$p(wardInfo,"^",1)
	.set wardObj.CTWDesc=$p(wardInfo,"^",2)
	.set locId=$p(wardInfo,"^",5)
	.Quit:locId=""
	.set hospId=$p(^CTLOC(locId),"^",22)
	.set:hospId="" hospId=$o(^CT("HOSP","0"))
	.set hospCode=$p(^CT("HOSP",hospId),"^",1)
	.set wardObj.CTWCodesystemCode="CT_Ward"
	.set wardObj.CTWHosCode=hospCode
	.set wardObj.CTWRemarks="无"
	.set wardObj.CTWStatus="1"
	.set wardObj.CTWUpdateUserCode="无"
	.d body.wards.Insert(wardObj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Ward",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
