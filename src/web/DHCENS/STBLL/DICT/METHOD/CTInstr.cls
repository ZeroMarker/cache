Class web.DHCENS.STBLL.DICT.METHOD.CTInstr Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：用药途径字典信息
/// Table：PHC_Instruc
/// Input： 
/// Return：用药途径字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTInstr).CTInstr("")
ClassMethod CTInstr(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^PHCIN(RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTInstr).%New()
	.set Str=$g(^PHCIN(RowId))
	.set Obj.CTICode=$p(Str,"^",1)
	.set Obj.CTIDesc=$p(Str,"^",2)
	.set Obj.CTICodesystemCode="CT_Instr"
	.set Obj.CTIRemarks=""
	.set Obj.CTIStatus="1"
	.set Obj.CTIUpdateUserCode="无"
	.d body.instrs.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Instr",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
