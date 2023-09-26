Class web.DHCENS.STBLL.DICT.METHOD.CTDiagnoseType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：诊断类型字典信息
/// Table： MRC_DiagnosType
/// Input： 
/// Return：诊断类型字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDiagnoseType).CTDiagnoseType("")
ClassMethod CTDiagnoseType(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set diagTypeId="0"  for  set diagTypeId=$o(^MRC("DTYP",diagTypeId)) 	q:diagTypeId=""  d
	.Quit:((diagTypeId'=input)&&(input'=""))
	.set obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTDiagnoseType).%New()
	.set obj.CTDTCode=$P(^MRC("DTYP",diagTypeId),"^",1)
	.set obj.CTDTCodesystemCode="CT_DiagnoseType"
	.set obj.CTDTDesc=$P(^MRC("DTYP",diagTypeId),"^",2)
	.set obj.CTDTRemarks=""
	.set obj.CTDTStatus="1"
	.set obj.CTDTUpdateUserCode="无"
	.d body.diagnoseTypes.Insert(obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_DiagnoseType",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
