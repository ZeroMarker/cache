Class web.DHCENS.STBLL.DICT.METHOD.CTSpec Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—09-01
/// Description：医护人员专长字典信息
/// Table：
/// Input： CT_Spec
/// Return：医护人员专长字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTSpec).CTSpec("")
ClassMethod CTSpec(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	// ^CT("SPC",{CTSPC_RowId}) 
	set RowId=0 f  set RowId=$O(^CT("SPC",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTSpec).%New()
	.set Str=$g(^CT("SPC",RowId))
	.set Obj.CTSPCCode=$p(Str,"^",1)
	.set Obj.CTSPCDesc=$p(Str,"^",2)
	.set Obj.CTSCodesystemCode="CT_Spec"
	.set Obj.CTSStatus="1"
	.set Obj.CTSUpdateUserCode="无"
	.d body.specs.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Spec",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
