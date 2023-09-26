Class web.DHCENS.STBLL.DICT.METHOD.CTDischCondit Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：出院情况字典信息
/// Table：PAC_DischCondit
/// Input： 
/// Return：出院情况字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDischCondit).CTDischCondit("")
ClassMethod CTDischCondit(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()

	set RowId=0 f  set RowId=$O(^PAC("DISCON",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTDischCondit).%New()
	.set Str=$g(^PAC("DISCON",RowId))
	.set Obj.CTDCCode=$p(Str,"^",1)
	.set Obj.CTDCDesc=$p(Str,"^",2)
	.set Obj.CTDCCodesystemCode="CT_DischCondit"
	.set Obj.CTDCRemarks=""
	.set Obj.CTDCStatus="1"
	.set Obj.CTDCUpdateUserCode="无"
	.d body.dischCondits.Insert(Obj)

	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_DischCondit",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
