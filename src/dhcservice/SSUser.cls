/// dhcservice.SSUser
Class dhcservice.SSUser Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "SSUser";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// MD5
Method MD5Enc(src) As %String [ WebMethod ]
{
	Set rtn = ##class(web.Util.Encryption).MD5HexStr(src)
	Quit rtn
}

Method CacheEnc(src) As %String [ WebMethod ]
{
	Set rtn = ##class(web.SSUser).Encrypt(src)
	quit rtn
}

Method GetCASInfo(CASTicket) As %String [ WebMethod ]
{
	Set Dto = ##class(dhc.dto.CASLogin).%New()
	Set CASTicketSrc = ##class(web.Util.Encryption).SimpleDecrypt(CASTicket,$parameter("websys.cas.CASService","CASTICKETSIMPLEKEY"))
	Set CASSession = $p(CASTicketSrc,"^",1)
	Set ExpiredTime = $p(CASTicketSrc,"^",2)
	Set ^Wanghc("logon","getcas")=CASTicketSrc
	Set LogonId = $O(^SST("LOG",0,"SessionId",CASSession,""),-1)
	if LogonId'>0{
		Set Dto.RtnMsg ="错误的票据"
		Set Dto.RtnCode="-1000"
		Set sc = Dto.XMLExportToString(.xml)
		Quit xml
	}
	Set NowTime = +$h*24*3600+$P($h,",",2)
	if (ExpiredTime<NowTime){
		Set Dto.RtnMsg ="过期的票据"
		Set Dto.RtnCode="-1001"
		Set sc = Dto.XMLExportToString(.xml)
		Quit xml
	}
	Set LogonObj = ##class(User.SSUserLogin).%OpenId(LogonId,0)
	if (""=LogonObj.LOGLogoffDate){
		If $IsObject(LogonObj.LOGUserDR){
			Set Dto.UserCode = LogonObj.LOGUserDR.SSUSRInitials
		}
		If $IsObject(LogonObj.LOGLocDR){
			Set Dto.LocCode = LogonObj.LOGLocDR.CTLOCCode
		}
		Set Dto.LogonDate = LogonObj.LOGLogonDate
		Set Dto.LogonTime = LogonObj.LOGLogonTime
		Set Dto.RtnCode="1"
		Set Dto.RtnMsg="统一登录成功"
	}else{
		Set Dto.RtnMsg ="用户已过期"
		Set Dto.RtnCode="-1002"
	}
	Set sc = Dto.XMLExportToString(.xml)
	Quit xml
}

/// @param: username  用户名 <br>
/// @param: password  加密后密码,  ..MD5Enc(CacheEnc(src))<br>
/// @return : 返回字符串,如果返回大于0则成功, 否则表示验证失败<br>
Method IsVaildUser(username, password) As %String [ WebMethod ]
{
	Quit:username="" "<Rtn><Code>UserNameNull</Code></Rtn>"
	s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(username),""))
 	Q:userid="" "<Rtn><Code>UserNameError</Code></Rtn>"
	set rtn = ##class(web.SSUser).IsValidUserMd5Password(username,password)
	if (rtn>0){
 ;<SSUser><Id>159</Id><Name>程丹颖</Name><Code>742</Code><CareType>医师</CareType><Group>Inpatient Doctor</Group><Loc>NSK-内三科</Loc></SSUser>
		Set obj = ##class(User.SSUser).%OpenId(rtn,0)
		if $IsObject(obj){
			Set dao = ##class(web.dao.SSUser).%New()
			Set dao.Age = ""
			Set dao.Sex = ""
			Set dao.Code = obj.SSUSRInitials
			Set dao.Name = obj.SSUSRName
			Set dao.Id = rtn
			Set dao.CareType=""
			if $IsObject(obj.SSUSRCareProvDR) && $IsObject(obj.SSUSRCareProvDR.CTPCPCarPrvTpDR){
				Set dao.CareType = obj.SSUSRCareProvDR.CTPCPCarPrvTpDR.CTCPTDesc		
			}
			Set dao.Group=""
			if $IsObject(obj.SSUSRGroup) Set dao.Group = obj.SSUSRGroup.SSGRPDesc
			Set dao.Loc=""
			if $IsObject(obj.SSUSRDefaultDeptDR) Set dao.Loc = obj.SSUSRDefaultDeptDR.CTLOCDesc
			do dao.XMLExportToString(.xml)
			Quit xml
		}else{
			Quit "<Rtn><Code>UserOpenError</Code></Rtn>"
		}
	}else{
		Quit "<Rtn><Code>PasswordError</Code></Rtn>"
	}
	Quit rtn
}

/// @param: username  用户名 <br>
/// @param: srcpassword  源密码<br>
/// @return : 返回字符串,如果返回大于0则成功, 否则表示验证失败<br>
Method IsVaildUserName(username, srcpassword) As %String [ WebMethod ]
{
	Set password = ##class(web.Util.Encryption).MD5HexStr(##class(web.SSUser).Encrypt(srcpassword))
	set rtn = ##class(web.SSUser).IsValidUserMd5Password(username,password)
	Quit rtn
}

}
