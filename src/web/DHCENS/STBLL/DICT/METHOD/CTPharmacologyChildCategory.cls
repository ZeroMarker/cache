Class web.DHCENS.STBLL.DICT.METHOD.CTPharmacologyChildCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—08-01
/// Description：药理学（子类）字典信息
/// Table：phc_subcat
/// Input： 
/// Return：药理学（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTPharmacologyChildCategory).CTPharmacologyChildCategory()
ClassMethod CTPharmacologyChildCategory(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^PHCC(RowId)) q:RowId=""  d
	.set Str=$g(^PHCC(RowId))
	.Quit:$p(Str,"^",1)=""
	.set subId=0 f  set subId=$O(^PHCC(RowId,"SC",subId)) q:subId=""  d
	..Quit:((RowId_"||"_subId'=input)&&(input'=""))
	..set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTPharmacologyChildCategory).%New()
	..set childStr=$g(^PHCC(RowId,"SC",subId))
	..Quit:$p(childStr,"^",1)=""
	..set Obj.CTSCode=$p(childStr,"^",1)
	..set Obj.CTSDesc=$p(childStr,"^",2)
	..set Obj.CTSCodesystemCode="CT_PharmacologyChildCategory"
	..set Obj.CTSRemarks=""
	..set Obj.CTSStatus="1"
	..set Obj.CTSUpdateUserCode="无"
	..set Obj.CTSPharmacologyCategoryCode=$p(Str,"^",1)
	..d body.childPharmaCategorys.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_PharmacologyChildCategory",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
