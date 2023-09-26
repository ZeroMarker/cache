Class web.DHCENS.STBLL.DICT.METHOD.CTFreq Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：药品频次字典信息
/// Table：PHC_Freq
/// Input： 
/// Return：药品频次字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTFreq).CTFreq("")
ClassMethod CTFreq(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	
	set RowId=0 f  set RowId=$O(^PHCFR(RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTFreq).%New()
	.set Str=$g(^PHCFR(RowId))
	.set Obj.CTFCode=$p(Str,"^",1)
	.set Obj.CTFDesc=$p(Str,"^",4)
	.set:Obj.CTFDesc="" Obj.CTFDesc=$p(Str,"^",3)
	.set Obj.CTFCodesystemCode="CT_Freq"
	.set Obj.CTFRemarks=""
	.set Obj.CTFStatus="1"
	.set Obj.CTFUpdateUserCode="无"
	.//时间点
	.s PHCDTRowId=0
	.s TmpTimePoint=""
	.f  set PHCDTRowId=$o(^PHCFR(RowId,"DT",PHCDTRowId)) q:PHCDTRowId=""  d
	..i TmpTimePoint=""  d
	...s TmpTimePoint=$zt($p($g(^PHCFR(RowId,"DT",PHCDTRowId)),"^"))
	..else  d
	...s TmpTimePoint=TmpTimePoint_"-"_$zt($p($g(^PHCFR(RowId,"DT",PHCDTRowId)),"^"))
	.set Obj.CTFTimePoint=TmpTimePoint
	.d body.freqs.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Freq",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

}
