Class web.DHCENS.STBLL.DICT.METHOD.CTOrderStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：医嘱状态字典信息
/// Table：oec_ordercategory
/// Input： 
/// Return：医嘱状态字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTOrderStatus).CTOrderStatus("")
ClassMethod CTOrderStatus(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^OEC("OSTAT",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTOrderStatus).%New()
	.set Str=$g(^OEC("OSTAT",RowId))
	.set Obj.CTOSCode=$p(Str,"^",1)
	.set Obj.CTOSDesc=$p(Str,"^",2)
	.set Obj.CTOSCodesystemCode="CT_OrderStatus"
	.set Obj.CTOSRemarks=""
	.set Obj.CTOSStatus="1"
	.set Obj.CTOSUpdateUserCode="无"
	.d body.orderStatuss.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_OrderStatus",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
