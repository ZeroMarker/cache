Class web.DHCENS.STBLL.DICTNew.METHOD.CTRoom Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：根据rowid获取房间字典信息，ODS用
/// Table：pac_room
/// Input： 
/// Return：房间信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoom).GetCTRoom("29").Read()
ClassMethod GetCTRoom(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTRoomByID(pList)
	}
	Quit OutputStream
	
MsgErr
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回房间字典密文流
/// Table：pac_room
/// Input： Array集合
/// Return：房间字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoom).GetCTRoomByID()
ClassMethod GetCTRoomByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		set roomInfo=$g(^PAROOM(rowid))
		set roomObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTRoom).%New()
		set roomObj.businessrowid=rowid
		set roomObj.CTRCode=$p(roomInfo,"^",1)
		set roomObj.CTRDesc=$p(roomInfo,"^",2)
		set roomObj.CTRTypeCode=$p(roomInfo,"^",3)
		set roomObj.CTRCodesystemCode="CT_Room"
		set hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)
		set roomObj.CTRHosCode=hospId //hospCode
		set roomObj.CTRStartDate=$p(roomInfo,"^",8)
		set roomObj.CTREndDate=$p(roomInfo,"^",9)
		set roomObj.CTRRemarks="无"
		set roomObj.CTRStatus="1"
		set roomObj.CTRUpdateUserCode="无"
		set roomTypeDr=$p(roomInfo,"^",3)
		set:roomTypeDr'="" roomObj.CTRTypeCode=roomTypeDr //$p($g(^PAC("ROOMT",roomTypeDr)),"^",1)
		d ListInfo.CTRoom.Insert(roomObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTRoom",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Room",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：查询房间信息字典
/// Table：
/// Input： 房间信息字典
/// Return：房间信息字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoom).SendCTRoom("")
ClassMethod SendCTRoom(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^PAROOM(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTRoomByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Room",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTRoomByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Room",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
