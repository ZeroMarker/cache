Class web.DHCENS.STBLL.DICT.METHOD.CTCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—11-10
/// Description：医嘱类型（大类）字典信息
/// Table：oec_ordercategory
/// Input： 
/// Return：医嘱类型（大类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTCategory).CTCategory("")
ClassMethod CTCategory(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()

	set RowId=0 f  set RowId=$O(^OEC("ORCAT",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTCategory).%New()
	.set Str=$g(^OEC("ORCAT",RowId))
	.set Obj.CTCCode=$p(Str,"^",1)
	.set Obj.CTCDesc=$p(Str,"^",2)
	.set Obj.CTCCodesystemCode="CT_Category"
	.set Obj.CTCRemarks=""
	.set Obj.CTCStatus="1"
	.set Obj.CTCUpdateUserCode="无"
	.d body.categorys.Insert(Obj)

	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Category",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
