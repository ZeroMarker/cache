Class web.DHCENS.STBLL.MEDADE.METHOD.DICTSync Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送医院院区字典到医政医师资质、不良事件系统（HIS和医师资质、不良事件分库），约定功能代码MES0032
/// Table：CT_Hospital
/// Input：
/// Output:应答xml消息
/// w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTHospitalMed("")
ClassMethod SendCTHospitalMed(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set count=1
	set hospId="0"  for  set hospId=$o(^CT("HOSP",hospId)) q:hospId=""  d
	.do plist.SetAt(hospId,count)
	.set count=count+1
	set stream=##class(%Stream.GlobalCharacter).%New()
	set stream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHospital).GetHospitalByID(plist)
	set soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0032")
	set tSC=soapObj.HIPMessageServer(actionStream,stream)
	set rtn=tSC.Read()
	Quit rtn
Exception
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送科室字典信息到医政医师资质、不良事件系统（HIS和医师资质、不良事件分库）,约定功能代码MES0033
/// Table：CT_Loc
/// Input：
/// Output:应答xml消息
/// w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTDeptMed("1")
ClassMethod SendCTDeptMed(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	set count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0033")
	if Input'=""{
		if $d(^CTLOC(Input)){
			do plist.SetAt(Input,count)
			set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetCTDeptByID(plist)
			set tSC=soapObj.HIPMessageServer(actionStream,Instream)
		}
	}else{
		set rowid="0"  for  set rowid=$o(^CTLOC(rowid)) Quit:rowid=""  d
		.do plist.SetAt(rowid,count)
		.set count=count+1
		.if count>0 do
		..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetCTDeptByID(plist)
		..set tSC=soapObj.HIPMessageServer(actionStream,Instream)
		..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Dept",tSC)
		..do tSC.OutputToDevice()
		..do Instream.Clear()
		..set count=1
		..do plist.Clear()
		set length=plist.Count()
		if length>0 d
		.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetCTDeptByID(plist)
		.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	}	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送用户字典信息到医政医师资质、不良事件系统（HIS和医师资质、不良事件分库），约定功能代码MES0045
/// Table：SS_User
/// Input：
/// Output:应答xml消息
/// w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTHisUserMed()
ClassMethod SendCTHisUserMed(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	set count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0045")
	if Input'=""{
		if $d(^SSU("SSUSR",Input)){
			do plist.SetAt(Input,count)
			set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHisUser).GetCTHisUserByID(plist)
			set tSC=soapObj.HIPMessageServer(actionStream,Instream)
		}
	}
	else{
		set rowid="0"  for  set rowid=$o(^SSU("SSUSR",rowid)) Quit:(rowid="")  d
		.do plist.SetAt(rowid,count)
		.set count=count+1
		.if count>0 d
		..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHisUser).GetCTHisUserByID(plist)
		..set tSC=soapObj.HIPMessageServer(actionStream,Instream)
		..d Instream.Clear()
		..d plist.Clear()
		..s count=1
		set length=plist.Count()
		if length>0 d
		.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHisUser).GetCTHisUserByID(plist)
		.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	}
	q tSC.Read() 
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送安全组字典信息到医政医师资质、不良事件系统（HIS和医师资质、不良事件分库），约定功能代码MES0034
/// Table：SS_Group
/// Input：
/// Output:应答xml消息
/// Others：w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTSecurityGroupMed("66")
ClassMethod SendCTSecurityGroupMed(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	set count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0034")
	if Input'=""
	{
		if $d(^SSU("SSGRP",Input)){
			do plist.SetAt(Input,count)
			set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSecurityGroup).GetCTSecurityGroupByID(plist)
			set tSC=soapObj.HIPMessageServer(actionStream,Instream)
		}
	}
	else
	{
	set rowid="0"  for  set rowid=$o(^SSU("SSGRP",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSecurityGroup).GetCTSecurityGroupByID(plist)
	..set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSecurityGroup).GetCTSecurityGroupByID(plist)
	.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	}
	q tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送医护人员职称字典信息到医政医师资质、不良事件系统（HIS和医师资质、不良事件分库），约定功能代码MES0035
/// Table：CT_Title
/// Input：
/// Output:应答xml消息
/// Others：w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTTitleOfTechMed("")
ClassMethod SendCTTitleOfTechMed(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	set count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0035")
	set rowid="0"  for  set rowid=$o(^CT("TTL",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTitleOfTech).GetCTTitleOfTechByID(plist)
	.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送医护人员类型字典信息到医政医师资质、不良事件系统（HIS和医师资质、不良事件分库），约定功能代码MES0036
/// Table：CT_CarPrvTp
/// Input：
/// Output:应答xml消息
/// Others: w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTCareProvTypeMed("")
ClassMethod SendCTCareProvTypeMed(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	set count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0036")
	set rowid="0"  for  set rowid=$o(^CT("CPT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType).GetCTCareProvTypeByID(plist)
	..set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType).GetCTCareProvTypeByID(plist)
	.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	q tSC.Read() 
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送医护人员类型字典信息到医政医师资质、不良事件系统（HIS和医师资质、不良事件分库），约定功能代码MES0037
/// Table：CT_CareProv
/// Input：
/// Output:应答xml消息
/// Debug：w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTCareProvMed(29)
ClassMethod SendCTCareProvMed(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	set soapObj.Timeout=60
	set count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0037")
	if Input'=""{
		if $d(^CTPCP(Input))
		{
			do plist.SetAt(Input,count)
			set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).GetCTCareProvByID(plist)
			set tSC=soapObj.HIPMessageServer(actionStream,Instream)
		}
	}
	else
	{
	set rowid="0"  for  set rowid=$o(^CTPCP(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>0 do
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).GetCTCareProvByID(plist)
	..set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	..set count=1
	..do plist.Clear()
	
	set length=plist.Count()
	if length>0 d
	.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).GetCTCareProvByID(plist)
	.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	}
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送手术名称字典信息到医政医师资质系统（HIS和医师资质分库），约定功能代码MES0038
/// Table：CT_Operation
/// Input：
/// Output:应答xml消息
/// Debug:w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTOperationMed("")
ClassMethod SendCTOperationMed(input As %String = "") As %String
{
	set $zt="MsgErr"	
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	s count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0038")
	if input=""
	{
	s rowid="0" for  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>20 d
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperation).GetCTOperationByID(plist)
	..set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperation).GetCTOperationByID(plist)
	.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	}
	else
	{
		d plist.SetAt(input,1)
		set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperation).GetCTOperationByID(plist)
		set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	}
	q tSC.Read()
MsgErr
	Quit "-1^"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送管制药品分类字典信息到医政医师资质系统（HIS和医师资质分库），约定功能代码MES0039
/// Table：PHC_Poison
/// Input：
/// Output:应答xml消息
/// Debug：w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTPHCPoisonMed("")
ClassMethod SendCTPHCPoisonMed(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	s count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0039")
	s rowid=0 f  s rowid=$o(^PHCPO(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>100 d
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison).GetCTPHCPoisonByID(plist)
	..set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison).GetCTPHCPoisonByID(plist)
	.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	q tSC.Read()
Err
	q -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2021—11-16
/// Description：发送用户其他登录信息到医政医师资质、不良事件系统（HIS和医师资质、不良事件分库），约定功能代码MES0039
/// Table：SS_UserOtherLogonLoc
/// Input：
/// Output:应答xml消息
/// Others：w ##class(web.DHCENS.STBLL.MEDADE.METHOD.DICTSync).SendCTUserOtherLogonDeptMed("")
ClassMethod SendCTUserOtherLogonDeptMed(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.MEDADE.Soap.DocServiceMedSoap).%New()
	set count=1
	set actionStream=##class(%Stream.GlobalCharacter).%New()
	do actionStream.Write("MES0046")
	set userid="0"  for  set userid=$o(^SSU("SSUSR",userid)) Quit:(userid="")||(count>50)  d
	.set subid="0" for  set subid=$o(^SSU("SSUSR",userid,"OTHLL",subid)) Quit:(subid="")||(count>50)  d
	..set rowid=userid_"||"_subid
	..do plist.SetAt(rowid,count)
	..set count=count+1
	..if count>20 d
	...set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTUserOtherLogonDept).GetCTUserOtherLogonDeptByID(plist)
	...set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	...d Instream.Clear()
	...d plist.Clear()
	...s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTUserOtherLogonDept).GetCTUserOtherLogonDeptByID(plist)
	.set tSC=soapObj.HIPMessageServer(actionStream,Instream)
	q tSC.Read()
Exception
	Quit -1_$ze
}

}
