Class web.DHCPE.CA.Main Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:   判断某科室是否使用CA,1为启用,0为不启用                      
/// Debug:         w ##Class(web.DHCPE.CA.Main).GetIsVerifyCA(102) 
ClassMethod GetIsVerifyCA(LocID As %String) As %String
{
	s $ZT="IsVerifyErr"
	s ret=0
	s ret=##Class(CA.DigitalSignatureService).IsCACTLoc(LocID)
	q ret
IsVerifyErr
	q 0
}

/// Description:   输出ca所包含的前端js文件                      
/// Debug:         d ##Class(web.DHCPE.CA.Main).OutPutSecXKeyExist() 
ClassMethod OutPutSecXKeyExist(IncludePECAJS As %String = 0)
{
	i IncludePECAJS=1 d
	.w "<script type='text/javascript' src='../scripts/DHCPECACommon.js'>",!
    .w "</script>",!
    q:..GetIsVerifyCA(%session.Get("LOGON.CTLOCID"))=0 
	d ##Class(CA.DigitalSignatureService).OutPutSecXKeyExist()
}

/// 服务器端签名验证 调用电子病历的服务
/// 登录login
/// w ##Class(web.DHCPE.CA.Main).CAServiceVerify()
ClassMethod CAServiceVerify(strContainerName As %String, varCert As %String, strServerRan As %String, strClientSignedData As %String, strPicData As %String, varCertCode As %String = "", certificateNo As %String = "", UserID As %String = "") As %String
{
	s svrRan = %session.Get("ServerRan")
	//Login
	s uID = ##Class(CA.UsrSignatureInfo).GetUsrIdByKey(varCertCode)
	
	q:uID'=UserID "数字证书与当前登陆用户不匹配"
	//usrID , UsrCertCode , serverRan , userSignedData , certNo , userCert 
	s info=##Class(CA.DigitalSignatureService).Login(UserID,varCertCode,svrRan,strClientSignedData,certificateNo,varCert)
	q info
}

/// Description:   调用CA的webservice接口
/// w ##Class(web.DHCPE.CA.Main).GetCAService()
ClassMethod GetCAService() As dhcserviceclient.CA.ServiceSoap
{
	set error = 0
	s service=""
	//通过系统参数找到服务地址
	s url=##Class(EPRmeta.SysOption).GetOptionValueByName("CALocation")
	//s url="http://localhost/ca/Service.asmx"
    // 创建对象，设置服务地址
    s service=##Class(dhcserviceclient.CA.ServiceSoap).%New()
    s service.Location=url
    q service
}

/// Description:   CA初始化Session                        
/// w ##Class(web.DHCPE.CA.Main).CASessionDataInit() 
ClassMethod CASessionDataInit() As %String
{
	set $ZTRAP = "SOAPError"
	q ##Class(CA.DigitalSignatureService).CASessionDataInit()
	
SOAPError
  quit ""
}

/// Description:   第一次认证后把ukey的容器号写到IE的Session中      
/// Debug:         w ##Class(web.DHCPE.CA.Main).GenUKeySession()
ClassMethod GenUKeySession(strContainerName As %String) As %String
{
	q:strContainerName="" 0
	s %session.Data("ContainerName")=strContainerName
	q 1
}

/// Description:保存签名信息
/// ExpStr:SaveType+"^"+session['LOGON.USERID']+"^"+SourceID
/// w ##Class(web.DHCPE.CA.Main).SaveCASign()
ClassMethod SaveCASign(ContentHash, CertCode, Cert, SignedData, ExpStr, CertNo As %String = "")
{
	s ^tmpwgy("SaveCASign")= $lb(ContentHash, CertCode, Cert, SignedData, ExpStr,CertNo)
	s svrRan = %session.Get("ServerRan")
	s info=##Class(CA.DigitalSignatureService).Sign(CertCode,"DHCPE",ContentHash,SignedData,CertNo)
	s ret=$p(info,"^",1)
	s err=$p(info,"^",2)
	s Obj=##class(User.DHCPECASignLog).%New()
	i ret=1 d
	.d Obj.SLSignIDSetObjectId(err)
	.s Obj.SLIsValid="Y"
	e  d
	.s Obj.SLErrInfo=err
	.s Obj.SLIsValid="N"
	;s Obj.SLIsValid="Y"
	s Obj.SLContentHash=ContentHash
	s Obj.SLSignType=$P(ExpStr,"^",1)
	s Obj.SLSourceID=$P(ExpStr,"^",3)
	s Obj.SLCertCode=CertCode
	s Obj.SLCert=Cert
	s Obj.SLSignedData=SignedData
	d Obj.SLUserIDSetObjectId($P(ExpStr,"^",2))
	s Obj.SLDate=+$H
	s Obj.SLTime=$P($H,",",2)
	s sc=Obj.%Save()
	i $$$ISERR(sc)
	{
		s ^tmpwgy("CAerror") = $System.Status.GetErrorText(sc)
	}
	q info
}

ClassMethod CancelSignData(SignType, SourceID)
{
	s LogID=""
	s SignLog=""
	f  s SignLog=$O(^User.DHCPECASignLogI("TypeSourceIndex",SignType,SourceID,SignLog),-1) q:(SignLog="")||(LogID'="")  d
	.s IsValid=$LG(^User.DHCPECASignLogD(SignLog),13)
	.q:IsValid'="Y"
	.s LogID=SignLog
	q:LogID="" "-1"
	&SQL(Update Sqluser.DHC_PE_CASignLog set SL_IsValid='N' where ID=:LogID)
	q SQLCODE
}

// 得到签名数据 SignType：0 科室录入  1 科室提交 2初检提交  3复检提交

// ExpStr：原数据ID  录入时，OE_Orditem表id 科室提交，paadm%站点id  初检、复检时PA_Adm表Id

// w ##class(web.DHCPE.CA.Main).GetSignData("1","98^2")

ClassMethod GetSignData(SignType, ExpStr)
{
	s Data=""
	i (SignType=0) d  //科室录入
	.s OEItemID=$P(ExpStr,"%",1)
	.s RltID=0
	.f  s RltID=$O(^DHCPERLT(0,"OEORI",OEItemID,RltID)) q:RltID=""  d
	..s Result=$P(^DHCPERLT(RltID),"^",4)
	..s ODID=$P(^DHCPERLT(RltID),"^",3)
	..q:Result=""
	..s OneResult=ODID_":"_Result
	..i Data="" d
	...s Data=OneResult
	..e  d
	...s Data=Data_"^"_OneResult
	
	e  i (SignType=1) d  //科室提交
	.s PAADM=$P(ExpStr,"%",1)
	.s StationID=$P(ExpStr,"%",2)
	.s SSID=##class(web.DHCPE.ResultEdit).GetSSId(PAADM,StationID)
	.b ;SSID
	.q:SSID=""
	.s Sub=0
	.f  s Sub=$O(^DHCPESS(SSID,"Diagnosis",Sub)) q:Sub=""  d
	..s EDID=$P(^DHCPESS(SSID,"Diagnosis",Sub),"^",1)
	..s Advice=$P(^DHCPESS(SSID,"Diagnosis",Sub),"^",7)
	..s ItemDesc=$p($g(^DHCPEED(EDID,"1")),"^",1)
 	..s DisplayDesc=$g(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SSID_"||"_Sub))  //Add 20080728
 	..s:DisplayDesc'="" ItemDesc=DisplayDesc
 	..s OneResult=EDID_":"_ItemDesc_":"_Advice
 	..i Data="" d
	...s Data=OneResult
	..e  d
	...s Data=Data_"^"_OneResult
	.s Sub=0
	.f  s Sub=$O(^DHCPESS(SSID,"Result",Sub)) q:Sub=""  d
	..s RltID=$P(^DHCPESS(SSID,"Result",Sub),"^",1)
	..s Result=$P(^DHCPERLT(RltID),"^",4)
	..s ODID=$P(^DHCPERLT(RltID),"^",3)
	..q:Result=""
	..s OneResult=ODID_":"_Result
	..i Data="" d
	...s Data=OneResult
	..e  d
	...s Data=Data_"^"_OneResult
	e  d  //初检、复检提交
	.s PAADM=$P(ExpStr,"%",1)
	.s UserID=$J_"^"_PAADM
	.s Data=##class(web.DHCPE.ReportGetInfor).GetGeneralAdviceByAdm(PAADM)
	
	s Data=##class(web.DHCPE.ReportGetInfor).Replace(Data,$C(10),"")
	s Data=##class(web.DHCPE.ReportGetInfor).Replace(Data,$C(13),"")
	q Data
}

/// w ##class(web.DHCPE.CA.Main).GetSignName(105)
ClassMethod GetSignName(SignType, SourceID)
{
	//q "iVBORw0KGgoAAAANSUhEUgAAAAEAAAAkCAYAAABIdFAMAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAHhJREFUeNo8zjsOxCAMBFB/KEAUFFR0Cbng3nQPw68ArZdAlOZppPFIBhH5EAB8b+Tlt9MYQ6i1BuqFaq1CKSVcxZ2Acs6406KUgpt5/LCKuVgz5BDCSb13ZO99ZOdcZGvt4mJjzMVKqcha68iIePB86GAiOv8CDADlIUQBs7MD3wAAAABJRU5ErkJggg%3D%3D"
	s CASignID=""
	s SignLog=""
	f  s SignLog=$O(^User.DHCPECASignLogI("TypeSourceIndex"," "_SignType," "_SourceID,SignLog),-1) q:(SignLog="")||(CASignID'="")  d
	.s IsValid=$LG(^User.DHCPECASignLogD(SignLog),13)
	.q:IsValid'="Y"
	.s CASignID=$LG(^User.DHCPECASignLogD(SignLog),2)
	q:CASignID="" ""
	q ##class(CA.BICAService).GetImageBySignID(CASignID)
	
	
	s UsrSignInfoID=$LG(^CA.DigitalSignatureD(CASignID),8)
	q:UsrSignInfoID="" ""
	q $LG(^CA.UsrSignatureInfoD(UsrSignInfoID),8)
}

/// Descript:根据USerID获取证书编号和介质编号
/// Creater:	wangguoying
/// CreateDate:	2019-12-11
/// Input:		
/// 				UserId：用户iD
/// Output:	证书编号/介质编号
/// Debug:w ##class(web.DHCPE.CA.Main).GetCAInfoByUserId(105)
ClassMethod GetCAInfoByUserId(UserId)
{
	q:'$D(^CA.UsrSignatureInfoI("InUseID",$C(32)_UserId,1)) ""  ;用户未关联key  或key未启用
	s caId=$O(^CA.UsrSignatureInfoI("InUseID",$C(32)_UserId,1,""),-1)
	s CertificateNo=$lg(^CA.UsrSignatureInfoD(caId),3)
	s UKeyNo=$lg(^CA.UsrSignatureInfoD(caId),9)
	q CertificateNo_"/"_UKeyNo
}

}
