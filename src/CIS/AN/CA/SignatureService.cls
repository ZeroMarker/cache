Class CIS.AN.CA.SignatureService Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetServerCert() As %String
{
	set service=##class(CA.BJCAService).GetCAService()
	set strServerRan = service.GenRandom()
	set strServerSignedData =service.SignData(strServerRan)
	set strServerCert = service.GetServerCert()
	set service=""
	quit "{""ServerRan"":"""_strServerRan_""",""ServerSignedData"":"""_strServerSignedData_""",""ServerCert"":"""_strServerCert_"""}"
}

ClassMethod Login(userCertCode As %String, serverRan As %String, userSignedData As %String, certNo As %String, userCert As %String) As %String
{
	set userId=##class(CA.UsrSignatureInfo).GetUsrIdByKey(userCertCode)
	set loginRet=##class(CA.DigitalSignatureService).Login(userId,userCertCode,serverRan,userSignedData,certNo,userCert)
	quit:(loginRet="") "S^"
	quit "E^"_loginRet
}

ClassMethod Sign(recordSheetId As %String, userCertCode As %String, signCode As %String, contentHash As %String, signValue As %String, CareProvType As %String = "", certNo As %String = "") As %String
{
	set $zt="Error"
	tstart
	set productCode="AN"
	set signRet=##class(CA.DigitalSignatureService).Sign(userCertCode,productCode,contentHash,signValue,certNo)
	if (+signRet=1)
	{
		set CASignatureId=$piece(signRet,"^",2)
		set extUserId=##class(CA.UsrSignatureInfo).GetUsrIdByKey(userCertCode)
		//set SSUserId=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.SSUser",extUserId)
		
		s ifCareProvType=""
		if (CareProvType'="")
		{
			set ifCareProvType=##class(CIS.AN.BL.Admission).GetCareProvTypeByAccount(accout)
		}
		q:(ifCareProvType'="")&&(ifCareProvType'=CareProvType) "医护人员类型不一致"	
		
		set ExtId=$p(signRet,"^",2)
		set saveRet=..SaveSignature(recordSheetId,contentHash,signValue,extUserId,signCode,userCertCode,ExtId,CASignatureId)
		if ($p(saveRet,"^",1)="E")
		{
			trollback
			quit saveRet	
		}
	}
	else
	{
		trollback
		quit "E^"_$p(signRet,"^",2)	
	}	
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod SaveSignature(sheetId As %String, hashData As %String, signData As %String, signUserId As %String, signCode As %String, userCertCode As %String, extId As %String = "", CASignatureId As %String = "") As %String
{
	set signId=""
	&sql(select RowId into :signId from CIS_AN.Signature where RecordSheet=:sheetId and SignCode=:signCode)
	set signature=""
	if (##class(CIS.AN.Signature).%ExistsId(signId))
	{
		set signature=##class(CIS.AN.Signature).%OpenId(signId)	
	}	
	else
	{
		set signature=##class(CIS.AN.Signature).%New()	
	}
	set signature.RecordSheet=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
	set signature.SignUser=signUserId ;;##class(CF.AN.SSUser).%OpenId(signUserId)
	set signature.HashData=hashData
	set signature.SignCode=signCode
	set signature.SignData=signData
	set signature.UserCertCode=userCertCode
	set signature.ExternalID=extId
	set signature.SignDate=+$h
	set signature.SignTime=$p($h,",",2)
	set signature.CASignatueId=CASignatureId
	set sc=signature.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	
	set signatureLog=##class(CIS.AN.SignatureLog).%New()
	set signatureLog.Signature=signature
	set signatureLog.SignDate=+$h
	set signatureLog.SignTime=$p($h,",",2)
	set signatureLog.SignUser=signUserId ;;signature.SignUser
	set sc=signatureLog.%Save()
	set signature="",signatureLog=""
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	
	quit "S^"
}

ClassMethod RemoveSignature(sheetId As %String, signCode As %String) As %String
{
	set signId=""
	&sql(select RowId into :signId from CIS_AN.Signature where RecordSheet=:sheetId and SignCode=:signCode)
	set signature=""
	if (##class(CIS.AN.Signature).%ExistsId(signId))
	{
		set sc=##class(CIS.AN.Signature).%DeleteId(signId)	
		quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	}	
	else
	{
		quit "E^未找到需要删除的签名数据"	
	}	
	
	quit "S^"
}

ClassMethod AccountSign(sheetId As %String, signCode As %String, accout As %String, pwd As %String, CareProvType As %String = "", signFlag As %String = "N") As %String
{
	set $zt="Error"
	set ifCareProvType=""
	if (CareProvType'="")
	{
		set ifCareProvType=##class(CIS.AN.BL.Admission).GetCareProvTypeByAccount(accout)
	}
	q:(ifCareProvType'="")&&(ifCareProvType'=CareProvType) "医护人员类型不一致"
	;set validateUser=##class(CIS.AN.BL.Admission).ValidateUser(accout,pwd)
	
	set validateUser=##class(web.SSUser).IsValidUser(accout,pwd)
	//set:(signFlag="Y") validateUser=##class(CIS.AN.BL.Admission).GetUserIdByInitials(accout)
	if (+validateUser>0)
	{
		tstart
		set signId=..GetSignatureId(sheetId,signCode)
		set signature=""
		if (##class(CIS.AN.Signature).%ExistsId(signId))
		{
			set signature=##class(CIS.AN.Signature).%OpenId(signId)	
		}	
		else
		{
			set signature=##class(CIS.AN.Signature).%New()	
		}
		set signUserId=validateUser
		set signature.RecordSheet=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
		set signature.SignUser=signUserId   ;##class(User.SSUser).%OpenId(signUserId)
		set signature.HashData=""
		set signature.SignCode=signCode
		set signature.SignData=""
		set signature.UserCertCode=""
		set signature.ExternalID=""
		set signature.SignDate=+$h
		set signature.SignTime=$p($h,",",2)
		set sc=signature.%Save()
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}
	
		set signatureLog=##class(CIS.AN.SignatureLog).%New()
		set signatureLog.Signature=signature
		set signatureLog.SignDate=+$h
		set signatureLog.SignTime=$p($h,",",2)
		set signatureLog.SignUser=signature.SignUser
		set sc=signatureLog.%Save()
		set signature="",signatureLog=""
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}
		tcommit
		quit "S^"	
	}	
	else
	{
		set result=$s(validateUser["UserNotFindErr":"用户不存在",validateUser["UnActiveErr":"用户未激活",validateUser["DateFromScopeErr":"未到用户启用日",validateUser["DateToScopeErr":"用户已过有效期",validateUser["PasswordErr":"密码输入错误",1:validateUser)
		quit result	
	}
	
Error
	trollback
	quit "E^"_$ze
}

ClassMethod GetSignatureId(sheetId As %String, signCode As %String) As %String
{
	set signId=""
	&sql(select RowId into :signId from CIS_AN.Signature where RecordSheet=:sheetId and SignCode=:signCode)
	quit signId
}

ClassMethod GetSignature(sheetId As %String, signCode As %String) As CIS.AN.Signature
{
	set signId=..GetSignatureId(sheetId,signCode)
	set signature=""
	if (##class(CIS.AN.Signature).%ExistsId(signId))
	{
		set signature=##class(CIS.AN.Signature).%OpenId(signId)	
	}
	quit signature
}

/// w ##class(CIS.AN.CA.SignatureService).GetSignUserName(3,"OperNurseSign")
ClassMethod GetSignUserName(sheetId As %String, signCode As %String) As %String
{
	set userName=""
	set signature=..GetSignature(sheetId,signCode)
	if ($isobject(signature))
	{
		set SignUser=signature.SignUser
		set SSUser=##class(User.SSUser).%OpenId(SignUser)
		set userName=SSUser.SSUSRName
	}
	quit userName
}

/// w ##class(CIS.AN.CA.SignatureService).GetSignImage(816,"PreOpVisitorSign")
ClassMethod GetSignImage(sheetId As %String, signCode As %String) As %String
{
	set signImage=""
	set signature=..GetSignature(sheetId,signCode)
	if ($isobject(signature))
	{
		set signInfo=##class(CA.UsrSignatureInfo).GetInUseInfo(signature.SignUser)
		if signInfo'="" set signImage=signInfo.SignImage
	}
	quit signImage
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-20
/// Description： 	获取签名数据
/// Table：        	CIS_AN.Signature
/// Input:			recordSheetId:手术麻醉表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.CA.SignatureService","FindSignature","58")
Query FindSignature(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   SignCode,
	   SignUser,
	   CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",SignUser) As FullName,
	   %ODBCOUT(SignDate)_" "_%ODBCOUT(SignTime) As SignDT
	   From CIS_AN.Signature
	   where RecordSheet=:recordSheetId
}

ClassMethod SetSignFlag(userCertCode As %String) As %String
{
	set %session.Data(userCertCode)="Y"
	quit "Y"
}

ClassMethod GetSignFlag(userCertCode As %String) As %String
{
	set ret=%session.Get(userCertCode)
	quit ret
}

/// w ##class(CIS.AN.SRV.OperAppService).GetOrdItms("367")
ClassMethod GetOrdItms(opsId As %String) As %String
{
	set orderItemID=""
    set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set orderItemID=operScheduleObj.AppOrderItem
	quit orderItemID
}

/// w ##class(CIS.AN.CA.SignatureService).GetSignUserName(3,"OperNurseSign")
ClassMethod GetSignUserAccount(sheetId As %String, signCode As %String) As %String
{
	set UserAccount=""
	set signature=..GetSignature(sheetId,signCode)
	if ($isobject(signature))
	{
		set SignUser=signature.SignUser
		set SSUser=##class(User.SSUser).%OpenId(SignUser)
		set UserAccount=SSUser.SSUSRInitials
	}
	quit UserAccount
}

}
