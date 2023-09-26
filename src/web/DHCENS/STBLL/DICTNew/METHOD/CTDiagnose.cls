Class web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnose Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：zhengchenghou
/// CreatDate：2018-06-05
/// Description：诊断字典信息
/// Table：MRC_ICDDx
/// Input： 
/// Return：诊断信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnose).CTDiagnose("")
ClassMethod CTDiagnose(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set diagId="0" f  set diagId=$o(^MRC("ID",diagId)) q:diagId=""  d
	.;Quit:((diagId'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDiagnose).%New()
	.set insObj.CTDCode=$p($g(^MRC("ID",diagId)),"^",1)
	.set CTDDesc=$p($g(^MRC("ID",diagId)),"^",2)
	.set insObj.CTDDesc=$tr(CTDDesc,",","#")
	.set CTDICDCode=$p($g(^MRC("ID",diagId)),"^",4)
	.set CTDICDCode=$tr(CTDICDCode,$c(34),"")
	.set insObj.CTDICDCode=CTDICDCode
	.set sdate=$p($g(^MRC("ID",diagId)),"^",6)
	.set edate=$p($g(^MRC("ID",diagId)),"^",7)
	.set:sdate'="" insObj.CTDStartDate=sdate
	.set:edate'="" insObj.CTDEndDate=edate
	.set insObj.CTDCodesystemCode="CT_Diagnose"
	.set insObj.CTDStatus="1"
	.set insObj.CTDUpdateUserCode="无"
	.d ListInfo.CTDiagnose.Insert(insObj)
	.set count=ListInfo.CTDiagnose.Count()
	.if count>200 d
	..d ListInfo.XMLExportToString(.String)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDiagnose",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Diagnose",JsonString)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..d ListInfo.CTDiagnose.Clear()
	..set count=0
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode=0 d
	...set success=0
	..else  d
	...set success=-1
	if count>0
	{
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDiagnose",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Diagnose",JsonString)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode=0 d
		.set success=0
		else  d
		.set success=-1
	}
	quit success
MsgErr
	quit "-1"_$ze
}

/// Description：诊断字典信息
/// Table：MRC_ICDDx
/// Input： 
/// Return：诊断字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnose).GetCTDiagnose("1").Read()
ClassMethod GetCTDiagnose(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTDiagnoseByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回诊断字典密文流
/// Table：
/// Input： Array集合
/// Return：诊断字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnose).GetCTDiagnoseByID()
ClassMethod GetCTDiagnoseByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set diagId=plist.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDiagnose).%New()
		set insObj.CTDCode=$p($g(^MRC("ID",diagId)),"^",1)
		set insObj.businessrowid=diagId
		set CTDDesc=$p($g(^MRC("ID",diagId)),"^",2)
		set insObj.CTDDesc=$tr(CTDDesc,",","#")
		set CTDICDCode=$p($g(^MRC("ID",diagId)),"^",4)
		set CTDICDCode=$tr(CTDICDCode,$c(34),"")
		set insObj.CTDICDCode=CTDICDCode
		set sdate=$p($g(^MRC("ID",diagId)),"^",6)
		set edate=$p($g(^MRC("ID",diagId)),"^",7)
		set:sdate'="" insObj.CTDStartDate=sdate
		set:edate'="" insObj.CTDEndDate=edate
		set insObj.CTDCodesystemCode="CT_Diagnose"
		set insObj.CTDStatus="1"
		set insObj.CTDUpdateUserCode="无"
		d ListInfo.CTDiagnose.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDiagnose",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Diagnose",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送诊断字典
/// Table：
/// Input： 
/// Return：诊断字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnose).SendCTDiagnose("")
ClassMethod SendCTDiagnose(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^MRC("ID",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>0 d
	..set Instream=..GetCTDiagnoseByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Diagnose",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTDiagnoseByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Diagnose",tSC)
	
	q "0" ;sc
Err
	q "-1^"_$ze
}

}
