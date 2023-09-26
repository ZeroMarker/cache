Class web.DHCENS.STBLL.DICT.METHOD.CTDoseUnit Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—11-10
/// Description：剂量单位字典信息
/// Table：CT_UOM
/// Input： 
/// Return：剂量单位字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDoseUnit).CTDoseUnit("")
ClassMethod CTDoseUnit(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set success=0	
	set RowId=0 f  set RowId=$O(^CT("UOM",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTDoseUnit).%New()
	.set Str=$g(^CT("UOM",RowId))
	.set Obj.CTDUCode=$p(Str,"^",1)
	.set Obj.CTDUDesc=$p(Str,"^",2)
	.set Obj.CTDUCodesystemCode="CT_DoseUnit"
	.set Obj.CTDURemarks=""
	.set Obj.CTDUStatus="1"
	.set Obj.CTDUUpdateUserCode="无"
	.d body.doseUnits.Insert(Obj)
	.set count=body.doseUnits.Count()
	.if count>200 d
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set soapObj.Timeout="60"
	..set tSC=soapObj.SaveManagerDataInfo("CT_DoseUnit",stream)
	..d body.doseUnits.Clear()
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set Count=body.doseUnits.Count()
	if (Count>0){	
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
		set tSC=soapObj.SaveManagerDataInfo("CT_DoseUnit",stream)
		d body.doseUnits.Clear()
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.s success=-1
	}
	if success'=0 {
		s RetStr="-1^失败"
	}
	else{
		s RetStr="0^成功"
	}
	Quit RetStr
Exception
	Quit "-1^"_$ze
}

}
