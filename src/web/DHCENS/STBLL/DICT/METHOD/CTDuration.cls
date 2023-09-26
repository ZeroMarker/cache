Class web.DHCENS.STBLL.DICT.METHOD.CTDuration Extends (%Persistent, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：疗程字典字典信息
/// Table：phc_Duration
/// Input： 
/// Return：疗程字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICT.METHOD.CTDuration).CTDuration("")
ClassMethod CTDuration(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set RowId=0 f  set RowId=$O(^PHCDU(RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set Obj=##class(web.DHCENS.STBLL.DICT.MODEL.CTDuration).%New()
	.set Str=$g(^PHCDU(RowId))
	.set Obj.CTDCode=$p(Str,"^",1)
	.set Obj.CTDDesc=$p(Str,"^",3)
	.set Obj.CTDCodesystemCode="CT_Duration"
	.set Obj.CTDRemarks=""
	.set Obj.CTDStatus="1"
	.set Obj.CTDUpdateUserCode="无"
	.d body.durations.Insert(Obj)
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	set request.body=body
	d request.XMLExportToStream(.stream)
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set tSC=soapObj.SaveManagerDataInfo("CT_Duration",stream)
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

Storage Default
{
<Data name="CTDurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCENS.STBLLAF5.CTDurationD</DataLocation>
<DefaultData>CTDurationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCENS.STBLLAF5.CTDurationD</IdLocation>
<IndexLocation>^web.DHCENS.STBLLAF5.CTDurationI</IndexLocation>
<StreamLocation>^web.DHCENS.STBLLAF5.CTDurationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
