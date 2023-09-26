Class web.DHCENS.STBLL.DICT.METHOD.CTHospital Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：医院字典信息
/// Table：CT_Hospital
/// Input： 
/// Return：医院字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTHospital).CTHospital("")
ClassMethod CTHospital(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set hospId="0"  for  set hospId=$o(^CT("HOSP",hospId)) q:hospId=""  d
	.Quit:((hospId'=input)&&(input'=""))
	.set hospInfo=$g(^CT("HOSP",hospId))
	.set hospObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTHospital).%New()
	.set hospObj.CTHCode=$p(hospInfo,"^",1)
	.set hospObj.CTHDesc=$p(hospInfo,"^",2)
	.set hospObj.CTHCodesystemCode="CT_Hospital"
	.set hospObj.CTHOrganizationCode="ORG0000005"
	.set hospObj.CTHRemarks="无"
	.set hospObj.CTHStatus="1"
	.set hospObj.CTHUpdateUserCode="无"
	.d body.hospitals.Insert(hospObj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Hospital",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
