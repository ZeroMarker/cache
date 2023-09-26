Class web.DHCENS.STBLL.DICTNew.METHOD.CTTreatmentResult Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：治疗结果[病案]字典信息
/// Table：
/// Input： rowid^rowid^...
/// Return：治疗结果[病案]字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTreatmentResult).GetCTTreatmentResult("1").Read()
ClassMethod GetCTTreatmentResult(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTTreatmentResultByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中治疗结果[病案]字典信息
/// Table：pac_bedType
/// Input： 
/// Return：治疗结果[病案]字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTreatmentResult).SendCTTreatmentResult("")
ClassMethod SendCTTreatmentResult(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DWBC.MRZLJGD(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTTreatmentResultByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_TreatmentResult",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTTreatmentResultByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_TreatmentResult",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTTreatmentResultByID(plist)
#;	b ;plist
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中治疗结果[病案]字典信息
/// Table：pac_bedType
/// Input： 
/// Return：治疗结果[病案]字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTreatmentResult).GetCTTreatmentResultByID("")
ClassMethod GetCTTreatmentResultByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set treatmentResultInfo=$g(^DWBC.MRZLJGD(rowid))
		set treatmentResultObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTTreatmentResult).%New()
		set treatmentResultObj.businessrowid=rowid
		set treatmentResultObj.CTTRCode=$lg(treatmentResultInfo,2)
		Continue:$p(treatmentResultInfo,"^",1)=""
		set treatmentResultObj.CTTRDesc=$lg(treatmentResultInfo,3)
		set treatmentResultObj.CTTRCodesystemCode="CT_TreatmentResult"
		set hospCode=""
		set hospId=$o(^CT("HOSP","0"))
		set:hospId'="" hospCode=$p(^CT("HOSP",hospId),"^",1)
		set treatmentResultObj.CTTRHosCode=hospId //hospCode
		set treatmentResultObj.CTTRRemarks="无"
		set treatmentResultObj.CTTRStatus="1"
		set StartDate=$p(treatmentResultInfo,"^",8)
		set:StartDate="" StartDate=61360
		set treatmentResultObj.CTTRStartDate=StartDate
		set treatmentResultObj.CTTRUpdateUserCode="无"
		d ListInfo.CTTreatmentResult.Insert(treatmentResultObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTTreatmentResult",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_TreatmentResult",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
