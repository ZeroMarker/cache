Class web.DHCENS.STBLL.DICTNew.METHOD.CTDuration Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：疗程字典字典信息
/// Table：phc_Duration
/// Input： 
/// Return：疗程字典字典信息
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDuration).GetCTDuration("")
ClassMethod GetCTDuration(Input As %String) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTDurationByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：疗程字典字典信息
/// Table：phc_Duration
/// Input： 
/// Return：疗程字典字典信息
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDuration).SendCTDuration("")
ClassMethod SendCTDuration(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PHCDU(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	if plist.Count()>0{
		set Instream=..GetCTDurationByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Duration",tSC)
		do tSC.OutputToDevice()
	}
	q "1"
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：疗程字典字典信息
/// Table：phc_Duration
/// Input： 
/// Return：疗程字典字典信息
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDuration).GetCTDuration("")
ClassMethod GetCTDurationByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDuration).%New()
		set Str=$g(^PHCDU(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTDCode=$p(Str,"^",1)
		set Obj.CTDDesc=$p(Str,"^",3)
		set Obj.CTDCodesystemCode="CT_Duration"
		set Obj.CTDRemarks=""
		set Obj.CTDStatus="1"
		set Obj.CTDFactor=$p(Str,"^",2)
		set Obj.CTDUpdateUserCode="无"
		d ListInfo.CTDuration.Insert(Obj)
	}

	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDuration",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Duration",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
