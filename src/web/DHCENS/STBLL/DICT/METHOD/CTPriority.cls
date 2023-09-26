Class web.DHCENS.STBLL.DICT.METHOD.CTPriority Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：医嘱类型字典信息
/// Table：oec_Priority
/// Input： 
/// Return：医嘱类型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTPriority).CTPriority("")
ClassMethod CTPriority(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^OECPR(RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTPriority).%New()
	.set Str=$g(^OECPR(RowId))
	.set Obj.CTPCode=$p(Str,"^",1)
	.set Obj.CTPDesc=$p(Str,"^",2)
	.set Obj.CTPCodesystemCode="CT_Priority"
	.set Obj.CTPRemarks=""
	.set Obj.CTPStatus="1"
	.set Obj.CTPUpdateUserCode="无"
	.d body.priotitys.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Priority",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
