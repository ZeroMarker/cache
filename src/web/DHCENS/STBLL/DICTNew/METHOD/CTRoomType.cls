Class web.DHCENS.STBLL.DICTNew.METHOD.CTRoomType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：房间类型字典信息
/// Table：pac_roomType
/// Input： 
/// Return：房间类型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoomType).SendCTRoomType("")
ClassMethod SendCTRoomType(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PAC("ROOMT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTRoomTypeByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_RoomType",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTRoomTypeByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_RoomType",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTRoomTypeByID(plist)
#;	;do Instream.OutputToDevice()
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	b ;tsc
#;	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_RoomType",tSC)
#;	do tSC.OutputToDevice()
#;	do Instream.Clear()	
#;	;set stream=..GetHospitalByID(plist)	
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：房间类型字典信息
/// Table：pac_roomType
/// Input： 
/// Return：房间类型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoom).GetCTRoomTypeByID("")
ClassMethod GetCTRoomTypeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set roomInfo=$g(^PAC("ROOMT",rowid))
		set roomObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTRoomType).%New()
		set roomObj.businessrowid=rowid
		set roomObj.CTRTCode=$p(roomInfo,"^",1)
		set roomObj.CTRTDesc=$p(roomInfo,"^",2)
		set roomObj.CTRTCodesystemCode="CT_RoomType"
		set hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)
		set roomObj.CTRTHosCode=hospId ;hospCode
		set startdate=$p(roomInfo,"^",5)
		set:startdate="" startdate=61360
		set roomObj.CTRTStartDate=startdate
		set roomObj.CTRTRemarks="无"
		set roomObj.CTRTStatus="1"
		set roomObj.CTRTUpdateUserCode="无"
		d ListInfo.CTRoomType.Insert(roomObj)		
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTRoomType",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_RoomType",JsonString)
	Quit OutStream

Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// ODS根据ID导入字典
/// Creator：ZhangXinying
/// CreatDate：2018—11-06
/// Description：房间类型字典信息
/// Table：pac_roomType
/// Input： 
/// Return：房间类型信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoomType).GetCTRoomType("1").Read()
ClassMethod GetCTRoomType(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTRoomTypeByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
