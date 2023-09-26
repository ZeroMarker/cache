/// 手术操作类型[病案]字典表
Class web.DHCENS.STBLL.DICTNew.METHOD.CTOperationType Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：手术操作类型[病案]字典信息
/// Table：
/// Input： rowid^rowid^...
/// Return：手术操作类型[病案]字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationType).GetCTOperationType("1").Read()
ClassMethod GetCTOperationType(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOperationTypeByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中手术操作类型[病案]字典信息
/// Table：pac_bedType
/// Input： 
/// Return：手术操作类型[病案]字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationType).SendCTOperationType("")
ClassMethod SendCTOperationType(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DWBC.MROperTypeD(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTOperationTypeByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationType",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOperationTypeByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OperationType",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTOperationTypeByID(plist)
#;	b ;plist
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中手术操作类型[病案]字典信息
/// Table：pac_bedType
/// Input： 
/// Return：手术操作类型[病案]字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationType).GetCTOperationTypeByID("")
ClassMethod GetCTOperationTypeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set operationTypeInfo=$g(^DWBC.MROperTypeD(rowid))
		set operationTypeObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOperationType).%New()
		set operationTypeObj.businessrowid=rowid
		set operationTypeObj.CTOTCode=$lg(operationTypeInfo,2)
		Continue:$p(operationTypeInfo,"^",1)=""
		set operationTypeObj.CTOTDesc=$lg(operationTypeInfo,3)
		set operationTypeObj.CTOTCodesystemCode="CT_OperationType"
		set hospCode=""
		set hospId=$o(^CT("HOSP","0"))
		set:hospId'="" hospCode=$p(^CT("HOSP",hospId),"^",1)
		set operationTypeObj.CTOTHosCode=hospId ;hospCode
		set operationTypeObj.CTOTRemarks="无"
		set operationTypeObj.CTOTStatus="1"
		set StartDate=$p(operationTypeInfo,"^",8)
		set:StartDate="" StartDate=61360
		set operationTypeObj.CTOTStartDate=StartDate
		set operationTypeObj.CTOTUpdateUserCode="无"
		d ListInfo.CTOperationType.Insert(operationTypeObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperationType",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OperationType",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：zhengchenghou	
/// CreatDate：2018-06-04
/// Description：查询HIS中手术操作类型[病案]字典信息
/// Table：pac_bed
/// Input： 
/// Return：手术操作类型[病案]字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationType).CTOperationType("")
ClassMethod CTOperationType(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set operationTypeId="0"  for  set operationTypeId=$o(^DWBC.MROperTypeD(operationTypeId)) q:operationTypeId=""  d
	.Quit:((operationTypeId'=input)&&(input'=""))
	.set operationTypeInfo=$g(^DWBC.MROperTypeD(operationTypeId))
	.set operationTypeObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOperationType).%New()
	.set operationTypeObj.CTOTCode=$lg(operationTypeInfo,2)
	.Quit:$p(operationTypeInfo,"^",1)=""
	.set operationTypeObj.CTOTDesc=$lg(operationTypeInfo,3)
	.set operationTypeObj.CTOTCodesystemCode="CT_OperationType"
	.set hospCode=""
	.set hospId=$o(^CT("HOSP","0"))
	.set:hospId'="" hospCode=$p(^CT("HOSP",hospId),"^",1)
	.set operationTypeObj.CTOTHosCode=hospCode
	.set operationTypeObj.CTOTRemarks="无"
	.set operationTypeObj.CTOTStatus="1"
	.set operationTypeObj.CTOTUpdateUserCode="无"
	.d ListInfo.CTOperationType.Insert(operationTypeObj)
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOperationType",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OperationType",JsonString)
	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	if resultCode=0 d
	.set success=0
	else  d
	.set success=-1
	quit success
MsgErr
	quit "-1"_$ze
}

}
