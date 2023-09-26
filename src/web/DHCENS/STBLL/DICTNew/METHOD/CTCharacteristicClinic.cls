Class web.DHCENS.STBLL.DICTNew.METHOD.CTCharacteristicClinic Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：排班特色门诊字典信息
/// Table：RBC_CharacteristicClinic
/// Input： rowid^rowid^...
/// Return：床位类型字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCharacteristicClinic).GetCTCharacteristicClinic("1").Read()
ClassMethod GetCTCharacteristicClinic(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTCharacteristicClinicByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中排班特色门诊字典信息
/// Table：RBC_CharacteristicClinic
/// Input： 
/// Return：排班特色门诊字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCharacteristicClinic).SendCTCharacteristicClinic("")
ClassMethod SendCTCharacteristicClinic(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^RBC("CHACLI",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>20 d
	..set Instream=..GetCTCharacteristicClinicByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CharacteristicClinic",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCharacteristicClinicByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CharacteristicClinic",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTCharacteristicClinicByID(plist)
#;	b ;plist
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中排班特色门诊字典信息
/// Table：RBC_CharacteristicClinic
/// Input： 
/// Return：排班特色门诊字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCharacteristicClinic).GetCTCharacteristicClinicByID("")
ClassMethod GetCTCharacteristicClinicByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set characteristicClinicInfo=$g(^RBC("CHACLI",rowid))
		set characteristicClinicObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCharacteristicClinic).%New()
		set characteristicClinicObj.businessrowid=rowid
		set characteristicClinicObj.CTCCCode=$p(characteristicClinicInfo,"^",1)
		set characteristicClinicObj.CTCCDesc=$p(characteristicClinicInfo,"^",2)
		set characteristicClinicObj.CTCCCodesystemCode="CT_CharacteristicClinic"
		set hospCode=""
		set hospId=$o(^CT("HOSP","0"))
		set:hospId'="" hospCode=$p(^CT("HOSP",hospId),"^",1)
		set characteristicClinicObj.CTCCHosCode=hospCode
		set characteristicClinicObj.CTCCRemarks="无"
		set characteristicClinicObj.CTCCStatus="1"
		set StartDate=$p(characteristicClinicInfo,"^",8)
		set:StartDate="" StartDate=61360
		set characteristicClinicObj.CTCCStartDate=StartDate
		set characteristicClinicObj.CTCCUpdateUserCode="无"
		d ListInfo.CTCharacteristicClinic.Insert(characteristicClinicObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCharacteristicClinic",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CharacteristicClinic",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
