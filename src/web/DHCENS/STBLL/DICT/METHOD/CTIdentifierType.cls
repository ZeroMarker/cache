Class web.DHCENS.STBLL.DICT.METHOD.CTIdentifierType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—09-30
/// Description：证件类型字典信息
/// Table：pac_cardtype
/// Input： 
/// Return：证件类型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTIdentifierType).CTIdentifierType("")
ClassMethod CTIdentifierType(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()

	set RowId=0 f  set RowId=$O(^PAC("CARD",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTIdentifierType).%New()
	.set Str=$g(^PAC("CARD",RowId))
	.set Obj.CTITCode=$p(Str,"^",1)
	.set Obj.CTITDesc=$p(Str,"^",2)
	.set Obj.CTITCodesystemCode="CT_IdentifierType"
	.set Obj.CTITRemarks=""
	.set Obj.CTITStatus="1"
	.set Obj.CTITUpdateUserCode="无"
	.d body.identifierTypes.Insert(Obj)

	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_IdentifierType",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
