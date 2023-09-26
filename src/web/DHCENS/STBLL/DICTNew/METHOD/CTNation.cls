Class web.DHCENS.STBLL.DICTNew.METHOD.CTNation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：民族字典信息
/// Table：CT_Nation
/// Input： 
/// Return：民族信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTNation).GetCTNation("")
ClassMethod GetCTNation(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTNationByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：民族字典信息
/// Table：CT_Nation
/// Input： 
/// Return：民族信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTNation).SendCTNation("")
ClassMethod SendCTNation(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("NAT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>20 d
	..set Instream=..GetCTNationByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Nation",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTNationByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Nation",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTNationByID(plist)
#;	;do Instream.OutputToDevice()
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	do tSC.OutputToDevice()
#;
#;	
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：民族字典信息
/// Table：CT_Nation
/// Input： 
/// Return：民族信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTNation).GetCTNationByID("")
ClassMethod GetCTNationByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		Set natInfo=$g(^CT("NAT",rowid))
		set natObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTNation).%New()
		set natObj.businessrowid=rowid
		set natObj.CTNCode=$p(natInfo,"^",1)
		set natObj.CTNDesc=$p(natInfo,"^",2)
		set natObj.CTNCodesystemCode="CT_Nation"
		set natObj.CTNRemarks="无"
		set natObj.CTNStatus="1"
		set natObj.CTNUpdateUserCode="无"
		set natObj.CTNStartDate=61360
		d ListInfo.CTNation.Insert(natObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTNation",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Nation",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：WuXianPu
/// CreatDate：2015—07-20
/// Description：民族字典信息
/// Table：CT_Nation
/// Input： 
/// Return：民族信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTNation).CTNation("")
ClassMethod CTNation(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set natId="0"  for  set natId=$o(^CT("NAT",natId)) q:natId=""  d
	.Quit:((natId'=input)&&(input'=""))
	.set natInfo=$g(^CT("NAT",natId))
	.set natObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTNation).%New()
	.set natObj.CTNCode=$p(natInfo,"^",1)
	.set natObj.CTNDesc=$p(natInfo,"^",2)
	.set natObj.CTNCodesystemCode="CT_Nation"
	.set natObj.CTNRemarks="无"
	.set natObj.CTNStatus="1"
	.set natObj.CTNUpdateUserCode="无"
	.set natObj.CTNStartDate=61360
	.d ListInfo.CTNation.Insert(natObj)
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTNation",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Nation",JsonString)
	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	if resultCode=0 d
	.set success=0
	else  d
	.set success=-1
	quit success
	
MsgErr
	quit "-1"_$ze
}

}
