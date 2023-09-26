Class web.DHCENS.STBLL.DICTNew.METHOD.CTProvince Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：省字典信息
/// Table：CT_Province
/// Input： 
/// Return：省字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTProvince).GetCTProvince("")
ClassMethod GetCTProvince(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTProvinceByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：省字典信息
/// Table：CT_Province
/// Input： 
/// Return：省信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTProvince).SendCTProvince("")
ClassMethod SendCTProvince(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("PROV",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>20 d
	..set Instream=..GetCTProvinceByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Province",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTProvinceByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Province",tSC)
	
	q "0" ;
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：省字典信息
/// Table：CT_Province
/// Input： 
/// Return：省信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTProvince).GetCTProvinceByID("")
ClassMethod GetCTProvinceByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set provInfo=$g(^CT("PROV",rowid))
		set provObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTProvince).%New()
		set provObj.businessrowid=rowid
		set provObj.CTPCode=$p(provInfo,"^",1)
		set provObj.CTPDesc=$p(provInfo,"^",2)
		set provObj.CTPCodesystemCode="CT_Province"
		set provObj.CTPRemarks="无"
		set provObj.CTPStartDate=$p(provInfo,"^",4)
		set:provObj.CTPStartDate="" provObj.CTPStartDate="2008-01-01"
		set provObj.CTPEndDate=$p(provInfo,"^",5)
		set provObj.CTPStatus="1"
		set provObj.CTPUpdateUserCode="无"	
		d ListInfo.CTProvince.Insert(provObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTProvince",.Jsonobj)

	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Province",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：zhengchenghou	
/// CreatDate：2018-06-04
/// Description：省字典信息
/// Table：CT_Province
/// Input： 
/// Return：省信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTProvince).CTProvince("")
ClassMethod CTProvince(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set provId="0"  for  set provId=$o(^CT("PROV",provId)) q:provId=""  d
	.Quit:((provId'=input)&&(input'=""))
	.set provInfo=$g(^CT("PROV",provId))
	.set provObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTProvince).%New()
	.set provObj.CTPCode=$p(provInfo,"^",1)
	.set provObj.CTPDesc=$p(provInfo,"^",2)
	.set provObj.CTPCodesystemCode="CT_Province"
	.set provObj.CTPRemarks="无"
	.set provObj.CTPStartDate=$p(provInfo,"^",4)
	.set provObj.CTPEndDate=$p(provInfo,"^",5)
	.set provObj.CTPStatus="1"
	.set provObj.CTPUpdateUserCode="无"
	.;Quit:input'=""	
	.d ListInfo.CTProvince.Insert(provObj)
	.set count=ListInfo.CTProvince.Count()
	.if count>10 d
	..d ListInfo.XMLExportToString(.String)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTProvince",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Province",JsonString)
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode=0 d
	...set success=0
	...d ListInfo.CTProvince.Clear()
	...set count=0
	..else  d
	...set success=-1
	if count>0
	{
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTProvince",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Province",JsonString)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode=0 d
		.set success=0
		else  d
		.set success=-1
	}
	quit success
MsgErr
	quit "-1"_$ze
}

}
