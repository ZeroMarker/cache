Class web.DHCENS.STBLL.DICTNew.METHOD.CTSCCarrier Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：根据rowid获取配送商字典信息，ODS用
/// Table：DHC_Carrier
/// Input： 
/// Return：配送商信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCCarrier).GetCTSCCarrier("53").Read()
ClassMethod GetCTSCCarrier(Input As %String) As %GlobalCharacterStream
{
	set $zt="MsgErr"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTSCCarrierByID(pList)
	}
	Quit OutputStream
	
MsgErr
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回配送商字典密文流
/// Table：DHC_Carrier
/// Input： Array集合
/// Return：配送商字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCCarrier).GetCTSCCarrierByID()
ClassMethod GetCTSCCarrierByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSCCarrier).%New()
		set Str=$g(^DHCCARR(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTSCCCode=$p(Str,"^",1)
		set Obj.CTSCCDesc=$p(Str,"^",2)
		set Obj.CTSCCCodesystemCode="CT_SCCarrier"
		set Obj.CTSCCType=$p(Str,"^",4)
		set Obj.CTSCCRemarks=""
		set Obj.CTSCCStatus="1"
		set Obj.CTSCCUpdateUserCode="无"
		d ListInfo.CTSCCarrier.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSCCarrier",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_SCCarrier",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送配送商信息字典
/// Table：
/// Input： 配送商信息字典
/// Return：配送商信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCCarrier).SendCTSCCarrier("")
ClassMethod SendCTSCCarrier(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^DHCCARR(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTSCCarrierByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SCCarrier",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTSCCarrierByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SCCarrier",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
