Class web.DHCENS.STBLL.DICT.METHOD.CTResultStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：医嘱结果状态字典信息
/// Table：oec_resultstatus
/// Input： 
/// Return：医嘱结果状态信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTResultStatus).CTResultStatus("")
ClassMethod CTResultStatus(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^OEC("RESST",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTResultStatus).%New()
	.set Str=$g(^OEC("RESST",RowId))
	.set Obj.CTRSCode=$p(Str,"^",1)
	.set Obj.CTRSDesc=$p(Str,"^",2)
	.set Obj.CTRSCodesystemCode="CT_ResultStatus"
	.set Obj.CTRSRemarks=""
	.set Obj.CTRSStatus="1"
	.set Obj.CTRSUpdateUserCode="无"
	.d body.resultStatuss.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_ResultStatus",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
