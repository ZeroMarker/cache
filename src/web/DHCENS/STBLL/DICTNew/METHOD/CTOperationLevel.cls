Class web.DHCENS.STBLL.DICTNew.METHOD.CTOperationLevel Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: ZhangXinying
/// Description：推送手术级别信息
/// Table：ORC_OperationCategory
/// Input： 
/// Return：
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationLevel).SendCTOperationLevel("")
ClassMethod SendCTOperationLevel(input As %String = "") As %String
{
	set $zt="MsgErr"	
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s sc=""
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^ORC("CATEG",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>200 d
	..set Instream=..GetCTOperationLevelByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationLevel",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOperationLevelByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationLevel",tSC)

	q sc
MsgErr
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：ORC_OperationCategory
/// Input： 
/// Return：手术级别字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationLevel).GetCTOperationLevel("19").Read()
ClassMethod GetCTOperationLevel(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOperationLevelByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：手术级别字典信息
/// Table：
/// Input： 
/// Return：手术级别字典字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationLevel).GetCTOperationLevelByID("")
ClassMethod GetCTOperationLevelByID(plist As %ArrayOfDataTypes) As %String
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		set operInfo=$g(^ORC("CATEG",rowid))
		set operationObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOperationLevel).%New()
		set operationObj.businessrowid=rowid
		set operationObj.CTOLCode=$P(operInfo,"^",1)
		set operationObj.CTOLDesc=$P(operInfo,"^",2)
		set operationObj.CTOLUpdateUserCode="1"
		set operationObj.CTOLStatus="1"
		set operationObj.CTOLCodesystemCode="CT_OperationLevel"
		d ListInfo.CTOperationLevel.Insert(operationObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperationLevel",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OperationLevel",JsonString)
	Quit RtnStream
Err
	q "-1^"_$ze
}

}
