Class web.DHCENS.STBLL.DICTNew.METHOD.CTCountry Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：国籍字典信息
/// Table：CT_Country
/// Input： 
/// Return：国籍信息集合
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCountry).GetCTCountry("")
ClassMethod GetCTCountry(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTCountryByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：国籍字典信息
/// Table：CT_Country
/// Input： 
/// Return：国籍信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCountry).SendCTCountry("")
ClassMethod SendCTCountry(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("COU",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>20 d
	..set Instream=..GetCTCountryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Country",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCountryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Country",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTCountryByID(plist)
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：国籍字典信息
/// Table：CT_Country
/// Input： 
/// Return：国籍信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCountry).GetCTCountryByID("")
ClassMethod GetCTCountryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set couInfo=$g(^CT("COU",rowid))
		set couObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCountry).%New()
		set couObj.businessrowid=rowid
		set couObj.CTCCode=$p(couInfo,"^",1)
		set CTCDesc=$p(couInfo,"^",2)
		set CTCDesc=$tr(CTCDesc,$c(34),"")
		set couObj.CTCDesc=$p(couInfo,"^",2)
		set couObj.CTCCodesystemCode="CT_Country"
		set couObj.CTCRemarks="无"
		set couObj.CTCStatus="1"
		set couObj.CTCStartDate=$p(couInfo,"^",4)
		set couObj.CTCUpdateUserCode="无"
		d ListInfo.CTCountry.Insert(couObj)
		set count=ListInfo.CTCountry.Count()
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCountry",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Country",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：zhengchenghou
/// CreatDate：2018-06-04
/// Description：国家字典信息
/// Table：CT_Country
/// Input： 
/// Return：国家字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCountry).CTCountry("")
ClassMethod CTCountry(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set couId="0"  for  set couId=$o(^CT("COU",couId)) q:couId=""  d
	.Quit:((couId'=input)&&(input'=""))
	.set couInfo=$g(^CT("COU",couId))
	.set couObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCountry).%New()
	.set couObj.CTCCode=$p(couInfo,"^",1)
	.set CTCDesc=$p(couInfo,"^",2)
	.set CTCDesc=$tr(CTCDesc,$c(34),"")
	.set couObj.CTCDesc=$p(couInfo,"^",2)
	.set couObj.CTCCodesystemCode="CT_Country"
	.set couObj.CTCRemarks="无"
	.set couObj.CTCStatus="1"
	.set couObj.CTCStartDate=$p(couInfo,"^",4)
	.set couObj.CTCUpdateUserCode="无"
	.d ListInfo.CTCountry.Insert(couObj)
	.set count=ListInfo.CTCountry.Count()
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCountry",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Country",JsonString)
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
