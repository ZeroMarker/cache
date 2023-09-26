/// 签名业务类
Class CIS.AN.BL.Signature Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2018-07-20
/// Description： 	获取签名数据
/// Table：        	CIS_AN.Signature
/// Input:			recordSheetId:手术麻醉表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Signature","FindSignature","186")
Query FindSignature(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   SignCode,
	   SignUser,
	   CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",SignUser) As SignUserName,
	   %ODBCOUT(SignDate)_" "_%ODBCOUT(SignTime) As SignDT
	   From CIS_AN.Signature
	   where RecordSheet=:recordSheetId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-20
/// Description： 	获取签名数据
/// Table：        	CIS_AN.Signature
/// Input:			recordSheetId:手术麻醉表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Signature","FindSignature","306")
Query FindSignatureForModule(opsId As %String, moduleCode As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   SignCode,
	   SignUser,
	   CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",SignUser) As SignUserName,
	   %ODBCOUT(SignDate)_" "_%ODBCOUT(SignTime) As SignDT
	   From CIS_AN.Signature
	   where RecordSheet->OperSchedule=:opsId
	   and RecordSheet->DataModule->Code=:moduleCode
}

ClassMethod GetPatSignImageBySignID(signId As %String) As %String
{
	quit:(##class(CIS.AN.Signature).%ExistsId(signId)) "E^不存在ID为："_signId_"的签名记录。"
	set patSignImage=""
	//&sql(select PatSignImage into :patSignImage from CIS_AN.Signature where RowId=:signId)
	set patFingerImage=""
	//&sql(select PatFingerImage into :patFingerImage from CIS_AN.Signature where RowId=:signId)
	w "S^"_patSignImage_"^"_patFingerImage
	quit ""
}

ClassMethod GetSignImageBySSUserID(SSUserID As %String) As %String
{
	set ret=""
	if (##class(User.SSUser).%ExistsId(SSUserID)=0) 
	{
		quit "E^不存在ID为"_SSUserID_"的用户。"	
	}	
	set SSUser=##class(User.SSUser).%OpenId(SSUserID)
	set account=SSUser.SSUSRInitials
	set account=$System.SQL.UPPER(account)
	set userId=$order(^DHCCL.Config.SecureUserI("Account"," "_account,0))
	set user=##class(DHCCL.Config.SecureUser).%OpenId(userId)
	do user.SignImage.Rewind()
	set len=1000
	w "S^"
	while(user.SignImage.AtEnd=0)
	{
		w user.SignImage.Read(.len)	
	}
	quit ""
}

ClassMethod SyncOperNurse(opsId As %String, moduleCode As %String = "OperCount") As %String
{
	set recordSheetId=""
	&sql(select rowid into :recordSheetId from CIS_AN.recordsheet where operschedule=:opsId and datamodule->code=:moduleCode)
	quit:(##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0) "E^手术清点记录单未创建"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set query=##class(%ResultSet).%New("CIS.AN.BL.Signature:FindSignature")
	set sc=query.Execute(recordSheetId)
	set scrubNurseSignCode1="",scrubNurseUserId1="",circualNurseSignCode1="",circualNurseUserId1=""
	set scrubNurseSignCode2="",scrubNurseUserId2="",circualNurseSignCode2="",circualNurseUserId2=""
	set scrubNurseSignCode3="",scrubNurseUserId3="",circualNurseSignCode3="",circualNurseUserId3=""
	while(query.%Next())
	{
		set signCode=query.Get("SignCode")
		set:(signCode=scrubNurseSignCode1) scrubNurseUserId1=query.Get("SignUser")
		set:(signCode=circualNurseSignCode1) circualNurseUserId1=query.Get("SignUser")
		set:(signCode=scrubNurseSignCode2) scrubNurseUserId2=query.Get("SignUser")
		set:(signCode=circualNurseSignCode2) circualNurseUserId2=query.Get("SignUser")
		set:(signCode=scrubNurseSignCode3) scrubNurseUserId3=query.Get("SignUser")
		set:(signCode=circualNurseSignCode3) circualNurseUserId3=query.Get("SignUser")
	}
	set scrubNurseUserId="",circualNurseUserId=""
	if (scrubNurseUserId1'="")
	{
		set:(scrubNurseUserId'="") scrubNurseUserId=scrubNurseUserId_","
		set scrubNurseUserId=scrubNurseUserId_scrubNurseUserId1
	}
	if (scrubNurseUserId2'="")
	{
		set:(scrubNurseUserId'="") scrubNurseUserId=scrubNurseUserId_","
		set scrubNurseUserId=scrubNurseUserId_scrubNurseUserId2
	}
	if (scrubNurseUserId3'="")
	{
		set:(scrubNurseUserId'="") scrubNurseUserId=scrubNurseUserId_","
		set scrubNurseUserId=scrubNurseUserId_scrubNurseUserId3
	}
	if (circualNurseUserId1'="")
	{
		set:(circualNurseUserId'="") circualNurseUserId=circualNurseUserId_","
		set circualNurseUserId=circualNurseUserId_circualNurseUserId1
	}
	if (circualNurseUserId2'="")
	{
		set:(circualNurseUserId'="") circualNurseUserId=circualNurseUserId_","
		set circualNurseUserId=circualNurseUserId_circualNurseUserId2
	}
	if (circualNurseUserId3'="")
	{
		set:(circualNurseUserId'="") circualNurseUserId=circualNurseUserId_","
		set circualNurseUserId=circualNurseUserId_circualNurseUserId3
	}
	set:(scrubNurseUserId'="") operSchedule.ScrubNurse=scrubNurseUserId
	set:(circualNurseUserId'="") operSchedule.CircualNurse=circualNurseUserId
	set sc=operSchedule.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

ClassMethod GetSignId(recordSheetId As %String, signCode As %String) As %String
{
	set signId=""
	&sql(select %ID into :signId from CIS_AN.Signature where RecordSheet=:recordSheetId and SignCode=:signCode)
	quit signId
}

ClassMethod GetUserIdByCertID(certID As %String) As %String
{
	set userId=""
	&sql(select %ID into :userId from CF_AN.SSUser where UserCert=:certID)
	quit userId
}

ClassMethod GetUserCertByUserId(userId As %String) As %String
{
	set userId=""
	&sql(select UserCert into :userId from CF_AN.SSUser where %ID=:userId)
	quit userId
}

ClassMethod GetSignImageByUserId(userId As %String) As %String
{
	set SSUser=##class(CF.AN.SSUser).%OpenId(userId)
	quit SSUser.SignImage
}

}
