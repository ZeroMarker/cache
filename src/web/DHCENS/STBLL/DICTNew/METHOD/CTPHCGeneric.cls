Class web.DHCENS.STBLL.DICTNew.METHOD.CTPHCGeneric Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：药品通用名字典信息
/// Table：PHC_Generic
/// Input： 
/// Return：药品通用名字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCGeneric).GetCTPHCGeneric("533").Read()
ClassMethod GetCTPHCGeneric(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTPHCGenericByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回药品通用名字典密文流
/// Table：PHC_Generic
/// Input： Array集合
/// Return：药品通用名字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCTPHCGeneric).GetCTCTPHCGenericByID()
ClassMethod GetCTPHCGenericByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPHCGeneric).%New()
		set Str=$g(^PHCGE("GE",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTPHCGCode=$p(Str,"^",1)
		set Obj.CTPHCGDesc=$p(Str,"^",2)
		set Obj.CTPHCGCodesystemCode="CT_PHCGeneric"
		set Obj.CTPHCGRemarks=""
		set Obj.CTPHCGStatus="1"
		set Obj.CTPHCGUpdateUserCode="无"
		d ListInfo.CTPHCGeneric.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPHCGeneric",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PHCGeneric",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送药品通用名信息字典
/// Table：PHC_Generic
/// Input： 
/// Return：药品通用名信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCGeneric).SendCTPHCGeneric("")
ClassMethod SendCTPHCGeneric(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1,count1=0
	s rowid=0 f  s rowid=$o(^PHCGE("GE",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count1=count1+1
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTPHCGenericByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHCGeneric",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPHCGenericByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PHCGeneric",tSC)
	w count1,!
	q sc
Err
	q "-1^"_$ze
}

}
