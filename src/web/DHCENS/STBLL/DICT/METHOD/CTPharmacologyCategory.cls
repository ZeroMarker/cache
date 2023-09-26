Class web.DHCENS.STBLL.DICT.METHOD.CTPharmacologyCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—08-01
/// Description：药理学（大类）字典信息
/// Table：phc_cat
/// Input： 
/// Return：药理学（大类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTPharmacologyCategory).CTPharmacologyCategory()
ClassMethod CTPharmacologyCategory(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^PHCC(RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTPharmacologyCategory).%New()
	.set Str=$g(^PHCC(RowId))
	.Quit:$p(Str,"^",1)=""
	.set Obj.CTCCode=$p(Str,"^",1)
	.set Obj.CTCDesc=$p(Str,"^",2)
	.set Obj.CTCCodesystemCode="CT_PharmacologyCategory"
	.set Obj.CTCRemarks=""
	.set Obj.CTCStatus="1"
	.set Obj.CTCUpdateUserCode="无"
	.d body.pharmaCategorys.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_PharmacologyCategory",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
