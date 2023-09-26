Class web.DHCENS.STBLL.DICT.METHOD.CTPharmacologySmallCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—08-01
/// Description：药理学（小类）字典信息
/// Table：phc_minorsubcat
/// Input： 
/// Return：药理学（小类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTPharmacologySmallCategory).CTPharmacologySmallCategory("")
ClassMethod CTPharmacologySmallCategory(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^PHCC(RowId)) q:RowId=""  d
	.set Str=$g(^PHCC(RowId))
	.Quit:$p(Str,"^",1)=""
	.set subId=0 f  set subId=$O(^PHCC(RowId,"SC",subId)) q:subId=""  d
	..set childStr=$g(^PHCC(RowId,"SC",subId))
	..Quit:$p(childStr,"^",1)=""
	..set smallId=0 f  set smallId=$O(^PHCC(RowId,"SC",subId,"MIN",smallId)) q:smallId=""  d
	...Quit:((RowId_"||"_subId_"||"_smallId'=input)&&(input'=""))
	...set smallStr=^PHCC(RowId,"SC",subId,"MIN",smallId)
	...Quit:$p(smallStr,"^",1)=""	
	...set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTPharmacologySmallCategory).%New()
	...set Obj.CTMCode=$p(smallStr,"^",1)
	...set Obj.CTMDesc=$p(smallStr,"^",2)
	...set Obj.CTMCodesystemCode="CT_PharmacologySmallCategory"
	...set Obj.CTMRemarks=""
	...set Obj.CTMStatus="1"
	...set Obj.CTMUpdateUserCode="无"
	...set Obj.CTPharmaChildCategory=$p(childStr,"^",1)
	...d body.smallPharmaCategorys.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_PharmacologySmallCategory",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
