Class web.DHCENS.STBLL.DICTNew.METHOD.CTSecurityGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：安全组字典信息
/// Table：SS_Group
/// Input： rowid^rowid^...
/// Return：床位类型字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSecurityGroup).GetCTSecurityGroup("1").Read()
ClassMethod GetCTSecurityGroup(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTSecurityGroupByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中安全组字典信息
/// Table：SS_Group
/// Input： 
/// Return：安全组字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSecurityGroup).SendCTSecurityGroup("")
ClassMethod SendCTSecurityGroup(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^SSU("SSGRP",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTSecurityGroupByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SecurityGroup",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTSecurityGroupByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_SecurityGroup",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTSecurityGroupByID(plist)
#;	b ;plist
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中安全组字典信息
/// Table：SS_Group
/// Input： 
/// Return：安全组字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSecurityGroup).GetCTSecurityGroupByID("")
ClassMethod GetCTSecurityGroupByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set securityGroupInfo=$g(^SSU("SSGRP",rowid))
		set securityGroupObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSecurityGroup).%New()
		set securityGroupObj.businessrowid=rowid
		set securityGroupObj.CTSGCode=rowid
		set securityGroupObj.CTSGDesc=$p(securityGroupInfo,"^",1)
		set securityGroupObj.CTSGCodesystemCode="CT_SecurityGroup"
		set hospSubId=$o(^SSU("SSGRP",rowid,"HOSP","0"))
		set:hospSubId'="" hospId=$p($g(^SSU("SSGRP",rowid,"HOSP",hospSubId)),"^",1)
		set:hospId="" hospId=$o(^CT("HOSP","0"))
		set securityGroupObj.CTSGHosCode=hospId //hospCode
		set securityGroupObj.CTSGRemarks="无"
		set activeFlag=$p(securityGroupInfo,"^",151)
		set:activeFlag="Y" securityGroupObj.CTSGStatus="1"
		set:activeFlag="N" securityGroupObj.CTSGStatus="0"
		set securityGroupObj.CTSGStartDate=$p(securityGroupInfo,"^",153)
		set securityGroupObj.CTSGEndDate=$p(securityGroupInfo,"^",154)
		set securityGroupObj.CTSGUpdateUserCode="无"
		set securityGroupObj.CTSGParentCode=$p(securityGroupInfo,"^",166)
		d ListInfo.CTSecurityGroup.Insert(securityGroupObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSecurityGroup",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_SecurityGroup",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
