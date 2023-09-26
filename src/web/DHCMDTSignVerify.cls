Import SQLUser

Class web.DHCMDTSignVerify Extends (%RegisteredObject, %XML.Adaptor)
{

/// 判断CA是否开放  调用电子病历接口控制科室,也可以控制用户
/// Debug:         w ##Class(web.DHCMDTSignVerify).CASessionDataInit() 
ClassMethod GetCAServiceStatus(LocID As %String, UserID As %String = "") As %String
{
	set $ZTRAP = "SOAPError"
    s ret=##Class(CA.DigitalSignatureService).GetCAServiceStatus(LocID)
    q:ret'="1" 0
 	s:UserID'="" DoctorType=##class(web.SSUser).GetDefaultCareProviderType(UserID)
 	Q:$G(DoctorType)'="DOCTOR" 0 
	q 1
SOAPError
  quit 0
}

/**ClassMethod InsertBatchSign(ContentHash, CertCode, Cert, SignedData, LgUserID, mdtID, EmrCode, CertNo)
{
	s ^temoyzy("121")=$lb(ContentHash, CertCode, Cert, SignedData, LgUserID, mdtID, EmrCode, CertNo)
	;s svrRan = %session.Get("ServerRan")
	s info=##Class(CA.DigitalSignatureService).Sign(CertCode,"MDT",ContentHash,SignedData,CertNo)
	b ;1
	s ret=$p(info,"^",1)
	s err=$p(info,"^",2)
	s Obj=##class(User.DHCPueSignVerify).%New()
	i ret=1 d
	.d Obj.SLSignIDSetObjectId(err)
	.s Obj.SLIsValid="Y"
	e  d
	.s Obj.SLErrInfo=err
	.s Obj.SLIsValid="N"
	;s Obj.SLIsValid="Y"
	s Obj.SLContentHash=ContentHash
	s Obj.SLSignType=EmrCode
	s Obj.SLSourceID=mdtID
	s Obj.SLCertCode=CertCode
	s Obj.SLCert=Cert
	s Obj.SLSignedData=SignedData
	d Obj.SLUserIDSetObjectId(LgUserID)
	s Obj.SLDate=+$H
	s Obj.SLTime=$P($H,",",2)
	s sc=Obj.%Save()
	q 0
}*/
/// Description:保存签名信息
/// ExpStr:SaveType+"^"+session['LOGON.USERID']+"^"+SourceID
/// w ##Class(web.DHCMDTSignVerify).InsertBatchSign("NWoZK3kTsExUV00Ywo1G5jlUKKs=","1@5009SF0210106197806020129","102000100079237/5018201507006136","MEQCIEzQgCjkwha3eGTBZi3CqgL9IaRcOW/iFptPBNFVsOElAiBdow6t6s3vR/EU3IxTBwMHhrBGdXFvtLJ0/a3bK+zkQQ==","6774","151","MDT","102000100079237")
ClassMethod InsertBatchSign(ContentHash, CertCode, Cert, SignedData, LgUserID, mdtID, EmrCode, CertNo)
{
	s ^temoyzy("121")=$lb(ContentHash, CertCode, Cert, SignedData, LgUserID, mdtID, EmrCode, CertNo)
	;s svrRan = %session.Get("ServerRan")
	s info=##Class(CA.DigitalSignatureService).Sign(CertCode,"MDT",ContentHash,SignedData,CertNo)
	b ;1
	s ret=$p(info,"^",1)
	s err=$p(info,"^",2)
	s Obj=##class(User.DHCMDTSignVerify).%New()
	i ret=1 d
	.d Obj.MSSignIDSetObjectId(err)
	.s Obj.MSIsValid="Y"
	e  d
	.s Obj.MSErrInfo=err
	.s Obj.MSIsValid="N"
	;s Obj.SLIsValid="Y"
	s Obj.MSContentHash=ContentHash
	s Obj.MSSignType=EmrCode
	s Obj.MSSourceID=mdtID
	s Obj.MSCertCode=CertCode
	s Obj.MSCert=Cert
	s Obj.MSSignedData=SignedData
	d Obj.MSUserIDSetObjectId(LgUserID)
	s Obj.MSDate=+$H
	s Obj.MSTime=$P($H,",",2)
	s sc=Obj.%Save()
	q 0
}

/// Description:保存签名信息
/// ExpStr:SaveType+"^"+session['LOGON.USERID']+"^"+SourceID
/// w ##Class(web.DHCMDTSignVerify).InsertBatchSign()
ClassMethod InsertBatchSignS(ContentHash, CertCode, SignedData, LgUserID)
{
 
	s svrRan = %session.Get("ServerRan")
	s info=##Class(CA.DigitalSignatureService).Sign(CertCode,"DHCPUE",ContentHash,SignedData)
	s ret=$p(info,"^",1)
	s err=$p(info,"^",2)
	q 0
}

/// w ##class(web.DHCMDTSignVerify).CheckSign(27232546,"review",1614)
ClassMethod CheckSign(adm, type, lguser)
{
	s sign=0
	s pueAdm=##class(web.DHCPUECommon).GetPueAdmByAdm(adm)
	i +pueAdm'=0 d
	.s emrId=$o(^DHCPUEEMR(0,"TypeAdm",type,pueAdm,""))
	.q:+emrId=0
	.s emrUser=$p(^DHCPUEEMR(emrId),"^",7)
	.s:emrUser'=lguser sign=-8000
    
	.q:emrUser'=lguser
	.s sign=+$p(^DHCPUEEMR(emrId),"^",13)
	q sign
}

/// w ##Class(web.DHCMDTSignVerify).GetInUseSignImage("1828")
ClassMethod GetInUseSignImage(UserID As %String) As %String
{
	q:UserID="" ""
	s obj=##Class(CA.UsrSignatureInfo).GetInUseInfo(UserID)
	q obj.SignImage
}

/// w ##Class(web.DHCMDTSignVerify).GetSignIsValid("151","MDT")
ClassMethod GetSignIsValid(mdtID As %String, signtype As %String) As %String
{
	
	s slrowid=""
	s slrowid=$o(^DHCMDTSV(0,"SorType",signtype,mdtID,slrowid),-1)
	i slrowid="" q "未签名"
	s IsValid=$p(^DHCMDTSV(slrowid),"^",6)
	i IsValid'="" q IsValid
	e  q 0
}

/// w ##Class(web.DHCMDTSignVerify).GetPrintFlag("50")
ClassMethod GetPrintFlag(mdtID As %String) As %String
{
	s PrintFlag=""
	s PrintFlag=$p(^DHCMDTCON(mdtID),"^",15)   /// 打印标志
	i PrintFlag [ "Y" q 1
	e  q 0
}

/// w ##Class(web.DHCMDTSignVerify).Isgetsignmdt("155")
ClassMethod Isgetsignmdt(mdtID As %String) As %String
{
	s slrowid=""
	s suppnotes=$p(^DHCMDTCON(mdtID),"^",25)
	s slrowid=$o(^DHCMDTSV(0,"SorType","MDT",mdtID,slrowid),-1)
	s IsValid=$p(^DHCMDTSV(slrowid),"^",6)
	i suppnotes '="" D
	.s IsValid="N"

    &sql(UPDATE DHC_MDTSignVerify SET MS_IsValid=:IsValid WHERE MS_RowID=:slrowid )


	q:SQLCODE'=0 -3
	q 0
}

// w ##Class(web.DHCMDTSignVerify).IsgetsignmdtSIGNID("86||2")

ClassMethod IsgetsignmdtSIGNID(mdtID As %String) As %String
{
	
	q:+mdtID=0 ""
	s id=$o(^DHCEMSV(0,"Pointer","MDT",mdtID,""),-1)
	q:+id=0 ""
	
	s isSureCa=$p(^DHCEMSV(id),"^",9)
	q:isSureCa'="F" ""
	q 1
}

/// w ##Class(web.DHCMDTSignVerify).getIsValid("155")
ClassMethod getIsValid(mdtID As %String) As %String
{
	s slrowid=""
	s slrowid=$o(^DHCMDTSV(0,"SorType","MDT",mdtID,slrowid),-1)
	s IsValid=$p(^DHCMDTSV(slrowid),"^",6)
	
	q IsValid
}

}
