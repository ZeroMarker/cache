Class web.DHCENS.STBLL.DICT.METHOD.CTRelation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：患者关系类型字典信息
/// Table：CT_Relation
/// Input： 
/// Return：患者关系类型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTRelation).CTRelation("")
ClassMethod CTRelation(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()

	set RowId=0 f  set RowId=$O(^CT("RLT",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTRelation).%New()
	.set Str=$g(^CT("RLT",RowId))
	.set Obj.CTRCode=$p(Str,"^",1)
	.set Obj.CTRDesc=$p(Str,"^",2)
	.set Obj.CTRCodesystemCode="CT_Relation"
	.set Obj.CTRRemarks=""
	.set Obj.CTRStatus="1"
	.set Obj.CTRUpdateUserCode="无"
	.d body.relations.Insert(Obj)

	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Relation",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
