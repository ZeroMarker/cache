Class web.DHCENS.STBLL.DICTNew.METHOD.CTOperation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: ZhangXinying
/// Description：推送手术字典信息
/// Table：ORC_Operation
/// Input： 
/// Return：
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperation).CTOperation("")
ClassMethod CTOperation(input As %String = "") As %String
{
	set $zt="MsgErr"
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set operRowId="0"  for  set operRowId=$o(^ORC("OPER",operRowId)) q:operRowId=""  d
	.Quit:((operRowId'=input)&&(input'=""))
	.set operInfo=$g(^ORC("OPER",operRowId))
	.set operationObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOperation).%New()
	.set operationObj.CTOCode=$P(operInfo,"^",1)
	.set operationObj.CTOCodesystemCode="CT_Operation"
	.set OperationName=$P(operInfo,"^",2)
	.set OperationName=$replace(OperationName,"，","#")
	.set OperationName=$replace(OperationName,",","#")
	.q:OperationName=""||operationObj.CTOCode=""
	.set operationObj.CTODesc=OperationName
	.set operationObj.CTOICDCode=$P(operInfo,"^",14)
	.set:operationObj.CTOICDCode="" operationObj.CTOICDCode=$P(operInfo,"^",21)
	.set StartDate=$P(operInfo,"^",5)
	.set:StartDate'="" operationObj.CTOStartDate=StartDate
	.set EndDate=$P(operInfo,"^",6)
	.set:EndDate'="" operationObj.CTOEndDate=EndDate
	.set operationObj.CTOUpdateUserCode="无"
	.set:$P(operInfo,"^",6)'="" operationObj.CTOStatus="0"
	.set:$P(operInfo,"^",6)="" operationObj.CTOStatus="1"
	.set OperationCategoryDR=$P(operInfo,"^",7)
	.set:OperationCategoryDR'="" operationObj.CTOLevelCode=$p(^ORC("CATEG",OperationCategoryDR),"^",1)
	.d ListInfo.CTOperation.Insert(operationObj)
	.set count=ListInfo.CTOperation.Count()
	.if count>100 d
	..d ListInfo.XMLExportToString(.String)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperation",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Operation",JsonString)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..d ListInfo.CTOperation.Clear()
	..set count=0
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	..else  d
	...s success=0

	if count>0 {
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperation",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Operation",JsonString)
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	if resultCode'=0 d
	.s success=-1
	else  d
	.s success=0
	}
	quit success
	
MsgErr
	Quit "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：推送手术字典信息
/// Table：ORC_Operation
/// Input： 
/// Return：
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperation).SendCTOperation("")
ClassMethod SendCTOperation(input As %String = "") As %String
{
	set $zt="MsgErr"	
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>20 d
	..set Instream=..GetCTOperationByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Operation",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOperationByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Operation",tSC)

	q
MsgErr
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：ORC_Operation
/// Input： 
/// Return：手术字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperation).GetCTOperation("1").Read()
ClassMethod GetCTOperation(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOperationByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：手术字典信息
/// Table：
/// Input： 手术字典字典
/// Return：手术字典字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperation).GetCTOperationByID("")
ClassMethod GetCTOperationByID(plist As %ArrayOfDataTypes) As %String
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		set operInfo=$g(^ORC("OPER",rowid))
		set operationObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOperation).%New()
		set operationObj.CTOCode=$P(operInfo,"^",1)
		set operationObj.businessrowid=rowid
		set operationObj.CTOCodesystemCode="CT_Operation"
		set OperationName=$P(operInfo,"^",2)
		set OperationName=$replace(OperationName,"，","#")
		set OperationName=$replace(OperationName,",","#")
		q:OperationName=""||operationObj.CTOCode=""
		set operationObj.CTODesc=OperationName
		set operationObj.CTOICDCode=$P(operInfo,"^",14)
		set:operationObj.CTOICDCode="" operationObj.CTOICDCode=$P(operInfo,"^",21)
		set StartDate=$P(operInfo,"^",5)
		set:StartDate'="" operationObj.CTOStartDate=StartDate
		set EndDate=$P(operInfo,"^",6)
		set:EndDate'="" operationObj.CTOEndDate=EndDate
		set operationObj.CTOUpdateUserCode="无"
		set:$P(operInfo,"^",6)'="" operationObj.CTOStatus="0"
		set:$P(operInfo,"^",6)="" operationObj.CTOStatus="1"
		set OperationCategoryDR=$P(operInfo,"^",7)
		set:OperationCategoryDR'="" operationObj.CTOLevelCode=OperationCategoryDR  //$p(^ORC("CATEG",OperationCategoryDR),"^",1)
		d ListInfo.CTOperation.Insert(operationObj)
		set count=ListInfo.CTOperation.Count()
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperation",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Operation",JsonString)
	Quit RtnStream
Err
	q "-1^"_$ze
}

}
