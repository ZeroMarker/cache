Class web.DHCENS.STBLL.DICT.METHOD.CTSpecimen Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：检验标本字典信息
/// Table：
/// Input： dbo.BT_Specimen
/// Return：检验标本字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTSpecimen).CTSpecimen("")
ClassMethod CTSpecimen(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^dbo.BTSpecimenD(RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTSpecimen).%New()
	.set Str=$g(^dbo.BTSpecimenD(RowId))
	.set Obj.CTSCode=$lg(Str,2)
	.set Obj.CTSDesc=$lg(Str,3)
	.set Obj.CTSCodesystemCode="CT_Specimen"
	.set Obj.CTSRemarks=""
	.set Obj.CTSStatus="1"
	.set Obj.CTSUpdateUserCode="无"
	.d body.specimens.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Specimen",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2013-02-18
/// Description：标本字典信息
/// Table：CT_Specimen
/// Input： 
/// Return：标本字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTSpecimen).CTSpecimenInfo("")
ClassMethod CTSpecimenInfo(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	s SpecCode=0
	f  s SpecCode=$O(^TTAB("SPEC",SpecCode)) q:SpecCode=""  d
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTSpecimen).%New()
	.set Str=$g(^TTAB("SPEC",SpecCode))
	.set Obj.CTSCode=SpecCode
	.set CTSDesc=$p(Str,"\",1)
	.set:CTSDesc="" CTSDesc="-"
	.set Obj.CTSDesc=CTSDesc
	.set Obj.CTSCodesystemCode="CT_Specimen"
	.set Obj.CTSRemarks=""
	.set Obj.CTSStatus="1"
	.set Obj.CTSUpdateUserCode="无"
	.d body.specimens.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Specimen",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
