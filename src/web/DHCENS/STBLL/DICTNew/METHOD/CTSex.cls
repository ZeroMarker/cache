Class web.DHCENS.STBLL.DICTNew.METHOD.CTSex Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：性别字典信息
/// Table：CT_Sex
/// Input： 
/// Return：性别字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSex).GetCTSex("")
ClassMethod GetCTSex(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTSexByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：性别字典信息
/// Table：ct_Sex
/// Input： 
/// Return：性别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSex).SendCTSex("")
ClassMethod SendCTSex(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("SEX",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set Instream=..GetCTSexByID(plist)
	;w Instream.Read()
	;do Instream.Rewind()
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	;do tSC.OutputToDevice()
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Sex",tSC)
	do tSC.Rewind()
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：性别字典信息
/// Table：ct_Sex
/// Input： 
/// Return：性别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSex).GetCTSexByID("")
ClassMethod GetCTSexByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set sexInfo=$g(^CT("SEX",rowid))
		set sexObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSex).%New()
		set sexObj.businessrowid=rowid
		set sexObj.CTSCode=$p(sexInfo,"^",1)
		set sexObj.CTSDesc=$p(sexInfo,"^",2)
		set sexObj.CTSCodesystemCode="CT_Sex"
		set sexObj.CTSRemarks="无"
		set sexObj.CTSStatus="1"
		set sexObj.CTSStartDate=$p(sexInfo,"^",4)
		set sexObj.CTSEndDate=$p(sexInfo,"^",5)
		set sexObj.CTSUpdateUserCode="无"
		d ListInfo.CTSex.Insert(sexObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSex",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;w JsonString,!
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Sex",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：zhengchenghou
/// CreatDate：2018-06-04
/// Description：性别字典信息
/// Table：ct_Sex
/// Input： 
/// Return：性别信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSex).CTSex("")
ClassMethod CTSex(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set sexId="0"  for  set sexId=$o(^CT("SEX",sexId)) q:sexId=""  d
	.Quit:((sexId'=input)&&(input'=""))
	.set sexInfo=$g(^CT("SEX",sexId))
	.set sexObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSex).%New()
	.set sexObj.CTSCode=$p(sexInfo,"^",1)
	.set sexObj.CTSDesc=$p(sexInfo,"^",2)
	.set sexObj.CTSCodesystemCode="CT_Sex"
	.set sexObj.CTSRemarks="无"
	.set sexObj.CTSStatus="1"
	.set sexObj.CTSStartDate=$p(sexInfo,"^",4)
	.set sexObj.CTSEndDate=$p(sexInfo,"^",5)
	.set sexObj.CTSUpdateUserCode="无"
	.d ListInfo.CTSex.Insert(sexObj)
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSex",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Sex",JsonString)
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
