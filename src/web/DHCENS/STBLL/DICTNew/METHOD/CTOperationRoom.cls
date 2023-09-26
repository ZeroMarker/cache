Class web.DHCENS.STBLL.DICTNew.METHOD.CTOperationRoom Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: haochenguang
/// Description：查询HIS中手术间字典信息
/// Table：DHC_ANC_OperRoom
/// Input： 手术间字典
/// Return：手术间字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationRoom).GetCTOperationRoom("8").Read()
ClassMethod GetCTOperationRoom(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOperationRoomByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送手术间字典信息
/// Table：DHC_ANC_OperRoom
/// Input： 
/// Return：
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationRoom).SendCTOperationRoom("")
ClassMethod SendCTOperationRoom(input As %String = "") As %String
{
	set $zt="MsgErr"	
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^DHCANC("OPRoom",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTOperationRoomByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationRoom",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOperationRoomByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationRoom",tSC)

	q sc
MsgErr
	Quit "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：手术间字典信息
/// Table：
/// Input： 
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationRoom).GetCTOperationRoomByID("")
ClassMethod GetCTOperationRoomByID(plist As %ArrayOfDataTypes) As %String
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		set oprInfo=$g(^DHCANC("OPRoom",rowid))
		set oprObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOperationRoom).%New()
		set oprObj.businessrowid=rowid
		s oprObj.CTORCode=$p(oprInfo,"^",1)
		//s oprObj.CTORCode=rowid
		s oprObj.CTORDesc=$p(oprInfo,"^",2)
		s oprObj.CTORCodesystemCode="CT_OperationRoom"
		s oprObj.CTORRemarks="无"
		s oprObj.CTORStatus="1"
		s oprObj.CTORUpdateUserCode="无"
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=$p(^CT("HOSP",hospId),"^",1)	
		s oprObj.CTORHosCode=hospId ;hospCode
		s oprObj.CTORUpdateDate=$zd(+$h,3)
		s oprObj.CTORUpdateTime=$zt($p($h,",",2))
		d ListInfo.CTOperationRoom.Insert(oprObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperationRoom",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OperationRoom",JsonString)
	Quit RtnStream
Err
	q "-1^"_$ze
}

}
