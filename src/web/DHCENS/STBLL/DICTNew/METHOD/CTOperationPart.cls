Class web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPart Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: ZhangXinying
/// Description：推送手术部位信息
/// Table：OEC_BodySite
/// Input： 
/// Return：
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPart).SendCTOperationPart("")
ClassMethod SendCTOperationPart(input As %String = "") As %String
{
	set $zt="MsgErr"	
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^OEC("BODS",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTOperationPartByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationPart",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOperationPartByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationPart",tSC)

	q sc
MsgErr
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：OEC_BodySite
/// Input： 
/// Return：手术部位字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPart).GetCTOperationPart("19").Read()
ClassMethod GetCTOperationPart(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOperationPartByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：手术部位字典信息
/// Table：OEC_BodySite
/// Input： 手术部位字典字典
/// Return：手术部位字典字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPart).GetCTOperationPartByID("")
ClassMethod GetCTOperationPartByID(plist As %ArrayOfDataTypes) As %String
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		set operInfo=$g(^OEC("BODS",rowid))
		set obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOperationPart).%New()
		set obj.businessrowid=rowid
		set obj.CTOPCode=$p(operInfo,"^",1)
		set obj.CTOPDesc=$p(operInfo,"^",2)
		set obj.CTOPStatus="1"
		set obj.CTOPCodesystemCode="CT_OperationPart"
		d ListInfo.CTOperationPart.Insert(obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperationPart",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OperationPart",JsonString)
	Quit RtnStream
Err
	q "-1^"_$ze
}

}
