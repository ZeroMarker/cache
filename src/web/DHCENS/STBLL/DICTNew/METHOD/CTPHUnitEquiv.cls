Class web.DHCENS.STBLL.DICTNew.METHOD.CTPHUnitEquiv Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：药品等效单位字典信息
/// Table：PHC_FormDoseEquiv 
/// Input： 
/// Return：药品等效单位字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHUnitEquiv).GetCTPHUnitEquiv("1||1||1").Read()
ClassMethod GetCTPHUnitEquiv(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTPHUnitEquivByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回药品等效单位字典密文流
/// Table：PHC_FormDoseEquiv 
/// Input： Array集合
/// Return：药品等效单位字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHUnitEquiv).GetCTPHUnitEquivByID()
ClassMethod GetCTPHUnitEquivByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set PHCDRowid=$p(rowid,"||",1),PHCDFSubId=$p(rowid,"||",2),PHCDFEqId=$p(rowid,"||",3)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPHUnitEquiv).%New()
		set Str=$g(^PHCD(PHCDRowid,"DF",PHCDFSubId,"EQ",PHCDFEqId))
		set Obj.CTUELinkId=PHCDRowid_"||"_PHCDFSubId
		set UomDr=$p(Str,"^",1)
		;set:UomDr'="" Obj.CTUEUnitCode=$p($g(^CT("UOM",UomDr)),"^",1)
		set Obj.CTUEUnitCode=UomDr
		set Obj.CTUEEqQty=$p(Str,"^",2)
		set Obj.CTUEDefaultQty=$p(Str,"^",3)
		set Obj.CTUECodesystemCode="CT_PHUnitEquiv"
		set Obj.CTUERemarks=""
		set Obj.CTUEStatus="1"
		set Obj.CTUEUpdateUserCode="无"
		d ListInfo.CTPHUnitEquiv.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPHUnitEquiv",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PHUnitEquiv",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送药品等效单位字典
/// Table：PHC_FormDoseEquiv 
/// Input： 
/// Return：药品等效单位字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHUnitEquiv).SendCTPHUnitEquiv("")
ClassMethod SendCTPHUnitEquiv(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s phcdid=0 f  s rowid=$o(^PHCD(phcdid)) q:phcdid=""  d
	.s subid=0  f  s subid=$o(^PHCD(rowid,"DF",subid)) q:subid=""  d
	..s eqid=0  f  s eqid=$o(^PHCD(rowid,"DF",subid,"EQ",eqid)) q:eqid=""  d
	...s rowid=phcdid_"||"_subid_"||"_eqid
	...d plist.SetAt(rowid,count)
	...s count=count+1
	...if count>100 d
	....set Instream=..GetCTPHUnitEquivByID(plist)
	....set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	....set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHUnitEquiv",tSC)
	....d tSC.OutputToDevice()
	....d Instream.Clear()
	....s count=1
	....d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPHUnitEquivByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHUnitEquiv",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
