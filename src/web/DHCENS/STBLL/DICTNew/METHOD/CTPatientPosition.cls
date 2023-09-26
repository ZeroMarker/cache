Class web.DHCENS.STBLL.DICTNew.METHOD.CTPatientPosition Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：患者身份字典信息
/// Table：
/// Input： 
/// Return：患者身份字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPatientPosition).GetCTPatientPosition("")
ClassMethod GetCTPatientPosition(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTPatientPositionByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：患者身份字典信息
/// Table：
/// Input： 
/// Return：患者身份字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPatientPosition).SendCTPatientPosition("")
ClassMethod SendCTPatientPosition(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("SS",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTPatientPositionByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PatientPosition",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPatientPositionByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PatientPosition",tSC)
	.d tSC.OutputToDevice()	
	q "0" ;sc
#;	set length=plist.Count()
#;	if length>0 d
#;	.set Instream=..GetCTPatientPositionByID(plist)
#;	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	.do tSC.OutputToDevice()
#;	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PatientPosition",tSC)
#;	
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：患者身份字典信息
/// Table
/// Input： 
/// Return：患者身份字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPatientPosition).GetCTPatientPositionByID("")
ClassMethod GetCTPatientPositionByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Info=$g(^CT("SS",rowid))
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPatientPosition).%New()
		set Obj.businessrowid=rowid
		set Obj.CTPPCode=$p(Info,"^",1)
		set Obj.CTPPDesc=$p(Info,"^",2)
		set Obj.CTPPCodesystemCode="CT_PatientPosition"
		set Obj.CTPPRemarks="无"
		set Obj.CTPPStatus="1"
		set Obj.CTPPUpdateUserCode="1"
		d ListInfo.CTPatientPosition.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPatientPosition",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PatientPosition",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
