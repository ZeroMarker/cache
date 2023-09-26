Class web.DHCENS.STBLL.DICTNew.METHOD.CTPostCode Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-06
/// Table：CT_Zip
/// Input： 
/// Return：邮编信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPostCode).CTPostCode("")
ClassMethod CTPostCode(input As %String = "") As %String
{
	set success=0
	set $zt="Exception"	
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set zipId="0"  for  set zipId=$o(^CT("ZIP",zipId)) q:zipId=""  d
	.Quit:((zipId'=input)&&(input'=""))
	.set zipInfo=$g(^CT("ZIP",zipId))
	.set zipObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPostCode).%New()
	.set zipObj.CTPCode=$p(zipInfo,"^",1)
	.set zipObj.CTPDesc=$p(zipInfo,"^",2)
	.set zipObj.CTPCodesystemCode="CT_Postcode"
	.set RegionDr=$p(zipInfo,"^",3),CountryDr=""
	.set:RegionDr'="" CountryDr=$p($g(^CT("RG",RegionDr)),"^",3)
	.set:CountryDr'="" zipObj.CTPCountryCode=$p($g(^CT("COU",CountryDr)),"^",1)
	.set ProvDr=$p(zipInfo,"^",4) 
	.set:ProvDr'="" zipObj.CTPProvinceCode=$p($g(^CT("PROV",ProvDr)),"^",1)
	.set CityDr=$p(zipInfo,"^",6)
	.set:CityDr'="" zipObj.CTPCityCode=$p($g(^CT("CIT",CityDr)),"^",1)
	.set CityAreaDr=$p(zipInfo,"^",7)
	.set:CityAreaDr'="" zipObj.CTPCountyCode=$p($g(^CT("CITAREA",CityAreaDr)),"^",1)
	.set zipObj.CTPRemarks="无"
	.set zipObj.CTPStatus="1"
	.set zipObj.CTPUpdateUserCode="无"
	.set FromDate=$p(zipInfo,"^",15)
	.set:FromDate'="" zipObj.CTPStartDate=$zd(FromDate,3)
	.set hospId=$o(^CT("HOSP","0"))
	.set hospCode=$p(^CT("HOSP",hospId),"^",1)	
	.set zipObj.CTPHosCode=hospCode
	.Quit:input'=""	
	.d ListInfo.CTPostCode.Insert(Obj)
	.set count=ListInfo.CTPostCode.Count()
	.if count>100 d
	..d ListInfo.XMLExportToString(.String)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPostcode",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Postcode",JsonString)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..d ListInfo.CTPostCode.Clear()
	..set count=0
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode=0 d
	...set success=0
	..else  d
	...set success=-1
	if count>0 {
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPostCode",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Postcode",JsonString)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode=0 d
		.set success=0
		else  d
		.set success=-1
	}
	quit success
	
Exception
	Quit "-1^"_$ze
}

/// Description：邮编字典信息
/// Table：CT_zip
/// Input： 
/// Return：邮编信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPostCode).GetCTPostCode("1").Read()
ClassMethod GetCTPostCode(Input As %String = "") As %GlobalCharacterStream
{
	set success=0
	set $zt="Exception"	
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTPostCodeByID(pList)
	}
	Quit OutputStream
	
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回邮编字典密文流
/// Table：CT_Zip
/// Input： Array集合
/// Return：邮编字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPostCode).GetCTPostCodeByID()
ClassMethod GetCTPostCodeByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set zipInfo=$g(^CT("ZIP",rowid))
		set zipObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPostCode).%New()
		set zipObj.businessrowid=rowid
		set zipObj.CTPCode=$p(zipInfo,"^",1)
		set zipObj.CTPDesc=$p(zipInfo,"^",2)
		set zipObj.CTPCodesystemCode="CT_Postcode"
		set RegionDr=$p(zipInfo,"^",3),CountryDr=""
		set:RegionDr'="" CountryDr=$p($g(^CT("RG",RegionDr)),"^",3)
		//set:CountryDr'="" zipObj.CTPCountryCode=$p($g(^CT("COU",CountryDr)),"^",1)
		set:CountryDr'="" zipObj.CTPCountryCode=CountryDr
		set ProvDr=$p(zipInfo,"^",4)
		//set:ProvDr'="" zipObj.CTPProvinceCode=$p($g(^CT("PROV",ProvDr)),"^",1)
		set:ProvDr'="" zipObj.CTPProvinceCode=ProvDr
		set CityDr=$p(zipInfo,"^",6)
		//set:CityDr'="" zipObj.CTPCityCode=$p($g(^CT("CIT",CityDr)),"^",1)
		set:CityDr'="" zipObj.CTPCityCode=CityDr
		set CityAreaDr=$p(zipInfo,"^",7)
		//set:CityAreaDr'="" zipObj.CTPCountyCode=$p($g(^CT("CITAREA",CityAreaDr)),"^",1)
		set:CityAreaDr'="" zipObj.CTPCountyCode=CityAreaDr
		set zipObj.CTPRemarks="无"
		set zipObj.CTPStatus="1"
		set zipObj.CTPUpdateUserCode="无"
		set FromDate=$p(zipInfo,"^",15)
		set:FromDate'="" zipObj.CTPStartDate=$zd(FromDate,3)
		set:zipObj.CTPStartDate="" zipObj.CTPStartDate="2008-01-01"
		set hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)	
		d ListInfo.CTPostCode.Insert(zipObj)
	}
	d ListInfo.XMLExportToString(.String)
	;w String,!
	//b ;;;11111
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPostCode",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	;w JsonString,!
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Postcode",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送邮编信息字典
/// Table：CT_Zip
/// Input： 
/// Return：邮编信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPostCode).SendCTPostCode("")
ClassMethod SendCTPostCode(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1,sum=0
	s rowid=0 f  s rowid=$o(^CT("ZIP",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>20 d
	..set Instream=..GetCTPostCodeByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Postcode",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPostCodeByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Postcode",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
