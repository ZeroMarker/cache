Class web.DHCENS.STBLL.DICTNew.METHOD.CTRegistrationCat Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：挂号号别字典信息
/// Table：CT_RegistrationCat
/// Input： 
/// Return：挂号号别字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRegistrationCat).GetCTRegistrationCat("1")
ClassMethod GetCTRegistrationCat(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTRegistrationCatByID(pList)
	}
	w OutputStream.Read()
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：挂号号别字典信息
/// Table：CT_RegistrationCat
/// Input： 
/// Return：挂号号别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRegistrationCat).SendCTRegistrationCat("")
ClassMethod SendCTRegistrationCat(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^RBC("SESS",rowid)) Quit:rowid=""  d
#;	.do plist.SetAt(rowid,count)
#;	.set count=count+1
#;	set Instream=..GetCTRegistrationCatByID(plist)
#;	do Instream.Rewind()
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTRegistrationCatByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_RegistrationCat",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTRegistrationCatByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_RegistrationCat",tSC)
	

	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：挂号号别字典信息
/// Table：CT_RegistrationCat
/// Input： 
/// Return：挂号号别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRegistrationCat).GetCTRegistrationCatByID("")
ClassMethod GetCTRegistrationCatByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set registrationCatInfo=$g(^RBC("SESS",rowid))
		set registrationCatObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTRegistrationCat).%New()
		set registrationCatObj.businessrowid=rowid
		set registrationCatObj.CTRCCode=$p(registrationCatInfo,"^",1)
		set registrationCatObj.CTRCDesc=$p(registrationCatInfo,"^",2)
		set registrationCatObj.CTRCCodesystemCode="CT_RegistrationCat"
		set registrationCatObj.CTRCRemarks="无"
		set registrationCatObj.CTRCStatus="1"
		set registrationCatObj.CTRCStartDate=""
		set registrationCatObj.CTRCEndDate=""
		set registrationCatObj.CTRCUpdateUserCode="无"
		d ListInfo.CTRegistrationCat.Insert(registrationCatObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTRegistrationCat",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;w JsonString,!
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_RegistrationCat",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
