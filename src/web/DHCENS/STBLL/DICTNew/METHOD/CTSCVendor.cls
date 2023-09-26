Class web.DHCENS.STBLL.DICTNew.METHOD.CTSCVendor Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：供应商字典信息
/// Table：APC_Vendor
/// Input： 
/// Return：供应字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCVendor).GetCTAPCVendor("1").Read()
ClassMethod GetCTAPCVendor(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTSCVendorByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回供应商字典密文流
/// Table：APC_Vendor
/// Input： Array集合
/// Return：供应商字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCVendor).GetCTSCVendorByID()
ClassMethod GetCTSCVendorByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSCVendor).%New()
		set Obj.businessrowid=rowid
		set Str=$g(^APC("APCVM",rowid))
		set Obj.CTSCVCode=$p(Str,"^",2)
		set Obj.CTSCVDesc=$p(Str,"^",3)
		set Obj.CTSCVCodesystemCode="CT_SCVendor"
		set Obj.CTSCVRemarks=""
		set Obj.CTSCVStatus="1"
		set Obj.CTSCVUpdateUserCode="无"
		d ListInfo.CTSCVendor.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSCVendor",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_SCVendor",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送供应商信息字典
/// Table：
/// Input： 供应商信息字典
/// Return：供应商信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCVendor).SendCTSCVendor("")
ClassMethod SendCTSCVendor(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^APC("APCVM",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTSCVendorByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SCVendor",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTSCVendorByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SCVendor",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
