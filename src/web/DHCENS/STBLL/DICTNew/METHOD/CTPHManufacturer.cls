Class web.DHCENS.STBLL.DICTNew.METHOD.CTPHManufacturer Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：生产厂商字典信息
/// Table：PH_Manufacturer
/// Input： 
/// Return：生产厂商字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHManufacturer).GetCTPHManufacturer("428").Read()
ClassMethod GetCTPHManufacturer(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTPHManufacturerByID(pList)
	}
	Quit OutputStream
	
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回生产厂商字典密文流
/// Table：
/// Input： Array集合
/// Return：生产厂商字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHManufacturer).GetCTPHManufacturerByID()
ClassMethod GetCTPHManufacturerByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPHManufacturer).%New()
		set Str=$g(^PHMNF(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTSCMCode=$p(Str,"^",1)
		set Obj.CTSCMDesc=$p(Str,"^",2)
		set Obj.CTSCMCodesystemCode="CT_SCManufacturer"
		set Obj.CTSCMRemarks=""
		set Obj.CTSCMStatus="1"
		set Obj.CTSCMUpdateUserCode="无"
		d ListInfo.CTSCManufacturer.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSCManufacturer",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_SCManufacturer",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送生产厂商信息字典
/// Table：
/// Input： 生产厂商信息字典
/// Return：生产厂商信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHManufacturer).SendCTSCManufacturer("")
ClassMethod SendCTSCManufacturer(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^PHMNF(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTPHManufacturerByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SCManufacturer",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPHManufacturerByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SCManufacturer",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
