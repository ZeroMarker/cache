Class web.DHCENS.STBLL.DICTNew.METHOD.CTBedType Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：床位类型字典信息
/// Table：PAC_BedType
/// Input： rowid^rowid^...
/// Return：床位类型字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBedType).GetCTBedType("1").Read()
ClassMethod GetCTBedType(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTBedTypeByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中床位类型字典信息
/// Table：pac_bedType
/// Input： 
/// Return：床位类型字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBedType).SendCTBedType("")
ClassMethod SendCTBedType(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PAC("BEDTP",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTBedTypeByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_BedType",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTBedTypeByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_BedType",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTBedTypeByID(plist)
#;	b ;plist
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中床位类型字典信息
/// Table：pac_bedType
/// Input： 
/// Return：床位类型字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBedType).GetCTBedTypeByID("")
ClassMethod GetCTBedTypeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set bedTyInfo=$g(^PAC("BEDTP",rowid))
		set bedObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTBedType).%New()
		set bedObj.businessrowid=rowid
		set bedObj.CTBTCode=$p(bedTyInfo,"^",1)
		Continue:$p(bedTyInfo,"^",1)=""
		set bedObj.CTBTDesc=$p(bedTyInfo,"^",2)
		set bedObj.CTBTCodesystemCode="CT_BedType"
		set hospCode=""
		set hospId=$o(^CT("HOSP","0"))
		set:hospId'="" hospCode=$p(^CT("HOSP",hospId),"^",1)
		set bedObj.CTBTHosCode=hospCode
		set bedObj.CTBTRemarks="无"
		set bedObj.CTBTStatus="1"
		set StartDate=$p(bedTyInfo,"^",8)
		set:StartDate="" StartDate=61360
		set bedObj.CTBTStartDate=StartDate
		set bedObj.CTBTUpdateUserCode="无"
		d ListInfo.CTBedType.Insert(bedObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTBedType",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_BedType",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
