Class DtPortal.Common.CA.PortalCAWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "PortalCAService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// CA.01.01
/// 判断CA用户是否存在
/// w ##class(DtPortal.Common.CA.PortalCAWebService).IfCALoginByUserCode("ca")
ClassMethod IfCALoginByUserCode(UserCode As %String = "") As %String [ WebMethod ]
{
	s status="-1",data="",errMSG=""

	s jsonObj=##class(DtPortal.Common.JsonObject).%New()
	
	try{
		Set aUserCode=$$ALPHAUP^SSUTIL4(UserCode)
		Set usrID=$o(^SSU("SSUSR",0,"SSUSR_Initials",aUserCode,0))
		if (usrID="")  {
			s status="-1"
			s errMSG = "用户ID为空！"
			s data="false"
		}else {
			s ifCALogin=##Class(CA.UsrSignatureInfo).GetInUseID(usrID)
			if (+ifCALogin>0){
				s ifClose=##class(CA.UsrInUseInfo).GetInUsedByUserID(usrID)
				set status = 1
				if (ifClose=1){
					s data="false"
				}else{
					s data="true"
				}
			}else{
				s data="false"
			}
			
		}
		
		
	} catch e {
		w !,$ze
		s status="-1"
		s errMSG = "代码异常！"
		s data="false"
		
	}
	
	d jsonObj.Put("data",data).Put("errMSG",errMSG).Put("status",status)
	q jsonObj.Json()
}

// 获取CA登录信息	

// CA.01.02

// w ##class(DtPortal.Common.CA.PortalCAWebService).CALogin("ca")

ClassMethod CALogin(UserCode As %String = "", Password As %String = "", varCertCode As %String = "", strServerRan As %String = "", strClientSignedData As %String = "", certificateNo As %String = "", varCert As %String = "", caLogonType As %String = "", venderCode As %String = "", ukeyPass As %String = "") As %String [ WebMethod ]
{
	set status=-1,data="",errMSG=""
	set $zt="CALoginErr"
	//s ^tempPortal("CALogin")=UserCode_"*"_Password_"*"_varCertCode_"*"_strServerRan_"*"_strClientSignedData_"*"_certificateNo_"*"_varCert_"*"_ukeyPass
	s currUserCode=""
	if (UserCode=""){
		s userInfo=##class(websys.CAInterface).GetUserIdByCert(varCertCode,certificateNo)
		s currUserCode=$p(userInfo,"^",2)
	}else{
		s currUserCode=UserCode
	}
	
	if (currUserCode="") Set errMSG = "用户名为空！" g qCALoginJson
	Set aUserCode=$$ALPHAUP^SSUTIL4(currUserCode)
	Set usrID=$o(^SSU("SSUSR",0,"SSUSR_Initials",aUserCode,0))
	//if (usrID="")  Set errMSG = "用户ID为空！"  g qCALoginJson
	
	s ifCALogin=##Class(CA.UsrSignatureInfo).GetInUseID(usrID)  //如果未开启CA登录，就不走CA的判断，开启了CA登录，必须先判断CA
	if (+ifCALogin>0){
		s ifClose=##class(CA.UsrInUseInfo).GetInUsedByUserID(usrID)
		if (ifClose=1){
			s status=1
			s data=""
			s errMSG=""
		}else{
			if (caLogonType="UKEY"){
				s resultLogin=##class(CA.DigitalSignatureService).Login(usrID,varCertCode,strServerRan,strClientSignedData,certificateNo,varCert,caLogonType,venderCode)
			}else{
				s resultLogin=##class(CA.DigitalSignatureService).Login2(usrID,varCertCode,strServerRan,strClientSignedData,certificateNo,varCert,caLogonType,venderCode)
			
			}
			
			if ($e(resultLogin,1)="{"){
				s jsonObj=##class(DtPortal.Common.JsonObject).%New()
				s obj=jsonObj.FromJSON(resultLogin)
				s retCode=obj.GetValue("retCode")
				s retMsg=obj.GetValue("retMsg")
				s hisUserName=obj.GetValue("hisUserName")
				s hisUserID=obj.GetValue("hisUserID")
				
				if (retCode="0"){
					if ((UserCode'="")&&(UserCode=hisUserName)){
						s status=1
						s data=""
						s errMSG=""
					}elseif(UserCode=""){
						s status=1
						s data=currUserCode
						
						s errMSG=""	
					}else{
						s status=-1
						s data=""
						s errMSG="用户不匹配"	
					}
				}
				
				
			}else{
				//先验证CA证书，再验证密码
				if (resultLogin=""){
					//s retStr=##class(DtPortal.Common.CasValidateService).ValidHISPassword(UserCode_$c(9812)_Password)

					if ((UserCode'="")){
						s hisUserName=##class(websys.CAInterface).GetUserIdByCert(varCertCode,certificateNo)
						s hisUserName=$p(hisUserName,"^",2)
						if (hisUserName'=UserCode){
							s status=-1
							s data=""
							s errMSG="用户不匹配"	
						}else{
							s status=1
							s data=UserCode
							s errMSG=""
						}
						
					}elseif(UserCode=""){
						s status=1
						s data=currUserCode
						
						s errMSG=""	
					}
					
				}else{
					Set status = -1
					Set errMSG = resultLogin
				}
			}
		}
		
		
	}else{
		//直接验证密码
		//s retStr=##class(DtPortal.Common.CasValidateService).ValidHISPassword(UserCode_$c(9812)_Password)
		s status=1
		s data=""
		s errMSG=""
	}
	

	g qCALoginJson
	
CALoginErr
	set $zt=""
	s errMSG=$ze,status="-1"
	g qCALoginJson
	
qCALoginJson
	s jsonObj=##class(DtPortal.Common.JsonObject).%New()
	d jsonObj.Put("status",status).Put("errMSG",errMSG).Put("data",data)
	if (caLogonType="UKEY"){
		try{
			s ukeyPass=##Class(web.Util.Encryption).SimpleEncrypt(ukeyPass,"PortalUkey")
			d jsonObj.Put("ukeyPin",ukeyPass)
		}catch{
		}
		
	}
	q jsonObj.Json()
}

// w ##class(DtPortal.Common.CA.PortalCAWebService).test()

ClassMethod test()
{
	s p=^tempPortal("CALogin")
	s p1=$p(p,"*",1),p2=$p(p,"*",2),p3=$p(p,"*",3),p4=$p(p,"*",4),p5=$p(p,"*",5),p6=$p(p,"*",6),p7=$p(p,"*",7)
	//
	//s p6="certno",p7="usercert"
	s p8="PHONE",p9="BJCA2"
	//s p1=""
	s aa= ##class(DtPortal.Common.CA.PortalCAWebService).CALogin(p1,p2,p3,p4,p5,p6,p7,p8,p9)
	w !,aa
	
	//b ;
}

/// 获取CA登陆初始化参数
/// CA.01.03
/// w ##class(DtPortal.Common.CA.PortalCAWebService).GetCAInitParams()
ClassMethod GetCAInitParams(type As %String = "") As %String [ WebMethod ]
{
	s strServerRan="",strServerSignedData="",strServerCert=""
	
	s jsonObj=##class(DtPortal.Common.JsonObject).%New()
	
	try{
		//s service=##Class(CA.DigitalSignatureService).GetService()
		//s service=##Class(CA.Adapter.NETCAV3.UKeyService).GetCAService()
		s service22=##Class(CA.Adapter.NETCAV3.UKeyService).%New()
		S service=service22.GetCAService()
		//b ;000
		s strServerRan = service.GenRandom()
		s strServerSignedData =service.SignData(strServerRan)
		s strServerCert = service.GetServerCert()
		
	} catch e {
		w !,$ze
	}
	
	d jsonObj.Put("strServerRan",strServerRan).Put("strServerSignedData",strServerSignedData).Put("strServerCert",strServerCert)
	q jsonObj.Json()
}

// 获取CA扫码登录信息	

// CA.01.04

/// w ##class(DtPortal.Common.CA.PortalCAWebService).GetCAScanInfo()
ClassMethod GetCAScanInfo(content As %String = "") As DtPortal.OutPut
{
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	Set ret.status = 1
	Set ret.errMSG = ""
	Set ret.data = ""
	try{
		s retValue=##class(websys.cas.Logon).GetLoginQR(content)
		Set ret.data = retValue
	}catch{
		Set ret.status = -1
		Set ret.errMSG = "调用接口异常"
		Set ret.data = ""
	}
	

	Quit ret
}

// 获取CA扫码登录结果	

// CA.01.05

/// w ##class(DtPortal.Common.CA.PortalCAWebService).GetCAScanResult()
ClassMethod GetCAScanResult(signGUID As %String = "") As DtPortal.OutPut
{
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	Set ret.status = 1
	Set ret.errMSG = ""
	Set ret.data = ""
	try{
		s retValue=##class(websys.cas.Logon).RollResult(signGUID)
		Set ret.data = retValue
	}catch{
		Set ret.status = -1
		Set ret.errMSG = "调用接口异常"
		Set ret.data = ""
	}
	

	Quit ret
}

// 获取CA登录token---NETCA登录使用	

/// w ##class(DtPortal.Common.CA.PortalCAWebService).GetLoginToken()
ClassMethod GetLoginToken(reqparam As %String = "") As %String
{
	
	s jsonObj=##class(DtPortal.Common.JsonObject).%New()
	d jsonObj.Put("status","-1").Put("errMSG","").Put("data","")
	s retValue=jsonObj.Json()
	try{
		s ret=##class(CA.DigitalSignatureService).GetLoginToken(reqparam)
		if ($e(ret,1)="{"){
			d jsonObj.Put("status","1").Put("errMSG","").Put("data",ret)
		}else{
			d jsonObj.Put("errMSG",ret)
		}
	}catch{
		d jsonObj.Put("errMSG","调用方法异常")
	}
	

	Quit jsonObj.Json()
}

}
