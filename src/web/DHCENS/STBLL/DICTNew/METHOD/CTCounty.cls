Class web.DHCENS.STBLL.DICTNew.METHOD.CTCounty Extends (%RegisteredObject, %XML.Adaptor)
{

/// MDM初始化批量导入字典
/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：区县字典信息
/// Table：CT_CityArea
/// Input： 
/// Return：区县字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCounty).GetCTCounty("")
ClassMethod GetCTCounty(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTCountyByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// MDM初始化批量导入字典
/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：区县字典信息
/// Table：CT_CityArea
/// Input： 
/// Return：区县字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCounty).SendCTCounty("")
ClassMethod SendCTCounty(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("CITAREA",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 do
	..set Instream=..GetCTCountyByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_County",tSC)
	..do tSC.OutputToDevice()
	..do Instream.Clear()
	..set count=1
	..do plist.Clear()

	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCountyByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_County",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：区县字典信息集合
/// Table：CT_CityArea
/// Input： 
/// Return：区县字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCounty).GetCTCityByID("")
ClassMethod GetCTCountyByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCounty).%New()
		set Obj.businessrowid=rowid
		set Str=$g(^CT("CITAREA",rowid))
		set Obj.CTCCode=$p(Str,"^",1)
		set Obj.CTCDesc=$p(Str,"^",2)
		set cityDr=$p(Str,"^",3)
		if cityDr'="" d
		.set cityInfo=$g(^CT("CIT",cityDr)) 
		.set Obj.CTCCCode=cityDr  //$p(cityInfo,"^",1)
		set Obj.CTCCodesystemCode="CT_County"
		set Obj.CTCStatus="1"
		set Obj.CTCStartDate=$p(Str,"^",4)
		set Obj.CTCRemarks="无"
		set Obj.CTCUpdateUserCode="-"
		d ListInfo.CTCounty.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCounty",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_County",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
