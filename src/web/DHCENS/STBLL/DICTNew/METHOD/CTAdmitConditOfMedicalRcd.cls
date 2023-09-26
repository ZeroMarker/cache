Class web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitConditOfMedicalRcd Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：入院病情-病案字典信息
/// Table：
/// Input： rowid^rowid^...
/// Return：入院病情-病案字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitConditOfMedicalRcd).GetCTAdmitConditOfMedicalRcd("1").Read()
ClassMethod GetCTAdmitConditOfMedicalRcd(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTAdmitConditOfMedicalRcdByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中入院病情-病案字典信息
/// Table：pac_bedType
/// Input： 
/// Return：入院病情-病案字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitConditOfMedicalRcd).SendCTAdmitConditOfMedicalRcd("")
ClassMethod SendCTAdmitConditOfMedicalRcd(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DWBC.MRRYBQD(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTAdmitConditOfMedicalRcdByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_AdmitConditOfMedicalRcd",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTAdmitConditOfMedicalRcdByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_AdmitConditOfMedicalRcd",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTAdmitConditOfMedicalRcdByID(plist)
#;	b ;plist
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中入院病情-病案字典信息
/// Table：pac_bedType
/// Input： 
/// Return：入院病情-病案字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitConditOfMedicalRcd).GetCTAdmitConditOfMedicalRcdByID("")
ClassMethod GetCTAdmitConditOfMedicalRcdByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set admitConditOfMedicalRcdInfo=$g(^DWBC.MRRYBQD(rowid))
		set admitConditOfMedicalRcdObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitConditOfMedicalRcd).%New()
		set admitConditOfMedicalRcdObj.CTACOMRCode=$lg(admitConditOfMedicalRcdInfo,2)
		Continue:$p(admitConditOfMedicalRcdInfo,"^",1)=""
		set admitConditOfMedicalRcdObj.businessrowid=rowid
		set admitConditOfMedicalRcdObj.CTACOMRDesc=$lg(admitConditOfMedicalRcdInfo,3)
		set admitConditOfMedicalRcdObj.CTACOMRCodesystemCode="CT_AdmitConditOfMedicalRcd"
		set hospCode=""
		set hospId=$o(^CT("HOSP","0"))
		set:hospId'="" hospCode=$p(^CT("HOSP",hospId),"^",1)
		set admitConditOfMedicalRcdObj.CTACOMRHosCode=hospCode
		set admitConditOfMedicalRcdObj.CTACOMRRemarks="无"
		set admitConditOfMedicalRcdObj.CTACOMRStatus="1"
		set StartDate=$p(admitConditOfMedicalRcdInfo,"^",8)
		set:StartDate="" StartDate=61360
		set admitConditOfMedicalRcdObj.CTACOMRStartDate=StartDate
		set admitConditOfMedicalRcdObj.CTACOMRUpdateUserCode="无"
		d ListInfo.CTAdmitConditOfMedicalRcd.Insert(admitConditOfMedicalRcdObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTAdmitConditOfMedicalRcd",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_AdmitConditOfMedicalRcd",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
