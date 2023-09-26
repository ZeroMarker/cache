Class web.DHCENS.STBLL.DICTNew.METHOD.CTUserOtherLogonDept Extends %RegisteredObject
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：其他登录科室字典信息
/// Table：ss_userotherlogonloc
/// Input： rowid^rowid^...
/// Return：其他登录科室字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTUserOtherLogonDept).GetCTUserOtherLogonDept("14043||3").Read()
ClassMethod GetCTUserOtherLogonDept(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTUserOtherLogonDeptByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中其他登录科室字典信息
/// Table：ss_userotherlogonloc
/// Input： 
/// Return：其他登录科室字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTUserOtherLogonDept).SendCTUserOtherLogonDept("")
ClassMethod SendCTUserOtherLogonDept(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set userid="0"  for  set userid=$o(^SSU("SSUSR",userid)) Quit:(userid="")||(count>50)  d
	.set subid="0" for  set subid=$o(^SSU("SSUSR",userid,"OTHLL",subid)) Quit:(subid="")||(count>50)  d
	..set rowid=userid_"||"_subid
	..do plist.SetAt(rowid,count)
	..set count=count+1
	..if count>20 d
	...set Instream=..GetCTUserOtherLogonDeptByID(plist)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_UserOtherLogonDept",tSC)
	...d tSC.OutputToDevice()
	...d Instream.Clear()
	...d plist.Clear()
	...s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTUserOtherLogonDeptByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_UserOtherLogonDept",tSC)
	
	q "0" 
Exception
	Quit -1_$ze
}

/// Creator：luofanyu	
/// CreatDate：2018-11-01
/// Description：查询HIS中其他登录科室字典信息
/// Table：ss_userotherlogonloc
/// Input： 
/// Return：其他登录科室字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTUserOtherLogonDept).GetCTUserOtherLogonDeptByID("")
ClassMethod GetCTUserOtherLogonDeptByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set userRowId=$p(rowid,"||",1)
		set userSubId=$p(rowid,"||",2)
		
		set userOtherLogonDeptObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTUserOtherLogonDept).%New()
		set userOtherLogonDeptObj.CTUOLDRowId=rowid
		;set userOtherLogonDeptObj.CTUOLDUserCode=$p(^SSU("SSUSR",userRowId),"^",1)
		set userOtherLogonDeptObj.CTUOLDUserCode=userRowId
		set userOtherLogonDeptInfo=$g(^SSU("SSUSR",userRowId,"OTHLL",userSubId))  //
		set userOtherLogonDeptObj.CTUOLDSecuGroupCode=$p(userOtherLogonDeptInfo,"^",2)
		set locRowId=$p(userOtherLogonDeptInfo,"^",1)
		set userOtherLogonDeptObj.CTUOLDDeptCode=locRowId
		set userOtherLogonDeptObj.CTUOLDCodesystemCode="CT_UserOtherLogonDept"
		set hospId=$p(userOtherLogonDeptInfo,"^",3)
		set:hospId="" hospId=$o(^CT("HOSP","0"))
		set userOtherLogonDeptObj.CTUOLDHosCode=hospId
		set userOtherLogonDeptObj.CTUOLDRemarks="无"
		set userOtherLogonDeptObj.CTUOLDStatus="1"
		set StartDate=$p(userOtherLogonDeptInfo,"^",4)
		set EndDate=$p(userOtherLogonDeptInfo,"^",5)
		set userOtherLogonDeptObj.CTUOLDStartDate=StartDate
		set userOtherLogonDeptObj.CTUOLDEndDate=EndDate
		set userOtherLogonDeptObj.CTUOLDStatus="1"
		set:EndDate'="" userOtherLogonDeptObj.CTUOLDStatus="0"
		set userOtherLogonDeptObj.CTUOLDUpdateUserCode="无"
		set userOtherLogonDeptObj.businessrowid=rowid
		d ListInfo.CTUserOtherLogonDept.Insert(userOtherLogonDeptObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTUserOtherLogonDept",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_UserOtherLogonDept",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
