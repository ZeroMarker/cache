Class web.DHCENS.STBLL.DICT.METHOD.CTDoseForms Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：剂型字典信息
/// Table：phc_form
/// Input： 
/// Return：剂型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDoseForms).CTDoseForms("")
ClassMethod CTDoseForms(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^PHCF(RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTDoseForms).%New()
	.set Str=$g(^PHCF(RowId))
	.set Obj.CTDFCode=$p(Str,"^",1)
	.set Obj.CTDFDesc=$p(Str,"^",2)
	.set Obj.CTDFCodesystemCode="CT_DoseForms"
	.set Obj.CTDFRemarks=""
	.set Obj.CTDFStatus="1"
	.set Obj.CTDFUpdateUserCode="无"
	.d body.doseFormss.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_DoseForms",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
