Class web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPosition Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: ZhangXinying
/// Description：推送手术体位信息
/// Table：ORC_OperPosition
/// Input： 
/// Return：
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPosition).SendCTOperationPosition("")
ClassMethod SendCTOperationPosition(input As %String = "") As %String
{
	set $zt="MsgErr"	
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^ORC("OPPOS",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTOperationPositionByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationPosition",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOperationPositionByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationPosition",tSC)

	q sc
MsgErr
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：ORC_OperPosition
/// Input： 
/// Return：手术体位字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPosition).GetCTOperationPosition("1").Read()
ClassMethod GetCTOperationPosition(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOperationPositionByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：手术体位字典信息
/// Table：ORC_OperPosition
/// Input：
/// Return：手术体位字典字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPosition).GetCTOperationPositionByID("")
ClassMethod GetCTOperationPositionByID(plist As %ArrayOfDataTypes) As %String
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		set operInfo=$g(^ORC("OPPOS",rowid))
		set obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOperationPosition).%New()
		set obj.businessrowid=rowid
		set obj.CTOPCode=$p(operInfo,"^",1)
		set obj.CTOPDesc=$p(operInfo,"^",2)
		set obj.CTOPStatus="1"
		set obj.CTOPCodesystemCode="CT_OperationPosition"
		d ListInfo.CTOperationPosition.Insert(obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperationPosition",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OperationPosition",JsonString)
	Quit RtnStream
Err
	q "-1^"_$ze
}

}
