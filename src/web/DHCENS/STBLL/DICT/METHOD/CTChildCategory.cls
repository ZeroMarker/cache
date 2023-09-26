Class web.DHCENS.STBLL.DICT.METHOD.CTChildCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—11-10
/// Description：医嘱类型（子类）字典信息
/// Table：arc_itemcat
/// Input： 
/// Return：医嘱类型（子类）字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTChildCategory).CTChildCategory("")
ClassMethod CTChildCategory(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	s RowId=0
	s StrOrderCategory=""
	f  s RowId=$O(^ARC("IC",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.s Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTChildCategory).%New()
	.s Str=$g(^ARC("IC",RowId))
	.s Obj.CTCCCode=$p(Str,"^",1)
	.s Obj.CTCCDesc=$p(Str,"^",2)
	.s OrderCategoryDr=$p(Str,"^",8)
	.s:OrderCategoryDr'="" StrOrderCategory=$g(^OEC("ORCAT",OrderCategoryDr)) d
	..s Obj.CTCCCategory=$p(StrOrderCategory,"^",1)
	.set Obj.CTCCCodesystemCode="CT_ChildCategory"
	.set Obj.CTCCStatus="1"
	.set Obj.CTCCUpdateUserCode="无"
	.d body.childCategorys.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body	
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_ChildCategory",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
