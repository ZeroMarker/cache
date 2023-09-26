Class DtPortal.Common.CA.HosCAWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "HosCAService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// 获取CA登陆初始化参数
/// w ##class(DtPortal.Common.CA.HosCAWebService).GetCAInitParams("UKEY","BJCA")
ClassMethod GetCAInitParams(loginType As %String = "", venderCode As %String = "") As %String [ WebMethod ]
{
	s strServerRan="",strServerSignedData="",strServerCert=""
	s status="-1",data="",errMSG=""
	s jsonObjRet=##class(DtPortal.Common.JsonObject).%New()
	s jsonObj=##class(DtPortal.Common.JsonObject).%New()
	try{
		s signTypeAndVender = ##class(CA.DSService).GetSignTypeAndVender(loginType, venderCode, "")
		//b ;01
		if (signTypeAndVender = "")
		{
			s errMSG = "请指定签名类型["_loginType_"]和签名厂商["_venderCode_"]"
			//q ""
		} else {
			s loginType = $p(signTypeAndVender, "^", 1)
			s venderCode = 	$p(signTypeAndVender, "^",2)
			
			s service = ##class(CA.Adapter.ServiceFactory).GetService(venderCode, loginType, .errMsg)
			if (service = ""){
				s errMSG = errMsg
			}else{
				
			
				//b ;000
				s strServerRan = service.Instance().GenRandom()
				s strServerSignedData =""
				s strServerCert = ""
				
				d jsonObj.Put("strServerRan",strServerRan).Put("strServerSignedData",strServerSignedData).Put("strServerCert",strServerCert)
				s status="1"
			}

		}
		
		
		
	} catch e {
		//b ;009
		w !,$ze
		s errMSG = "代码异常"
	}
	
	d jsonObjRet.Put("status",status).Put("data",jsonObj.Json()).Put("errMSG",errMSG)
	q jsonObjRet.Json()
}

// 获取CA登录信息	

// w ##class(DtPortal.Common.CA.HosCAWebService).CALogin("ca")

ClassMethod CALogin(accountCode As %String = "", varCertCode As %String = "", strServerRan As %String = "", strClientSignedData As %String = "", certificateNo As %String = "", varCert As %String = "", caLogonType As %String = "", venderCode As %String = "", ukeyPass As %String = "") As %String [ WebMethod ]
{
	set status=-1,data="",errMSG=""
	set $zt="CALoginErr"
	//s ^tempPortal("CALogin")=accountCode_"*"_varCertCode_"*"_strServerRan_"*"_strClientSignedData_"*"_certificateNo_"*"_varCert_"*"_caLogonType_"*"_venderCode_"*"_ukeyPass
	s currUserCode=""
	s accountCode=$replace(accountCode,$c(0),"")
	if (accountCode=""){
		s userInfo=##class(websys.CAInterface).GetUserIdByCert(varCertCode,certificateNo)
		s currUserCode=$p(userInfo,"^",2)
	}else{
		s currUserCode=accountCode
	}
	
	if (currUserCode="") Set errMSG = "用户名为空！" g qCALoginJson
	Set aUserCode=$$ALPHAUP^SSUTIL4(currUserCode)
	Set usrID=$o(^SSU("SSUSR",0,"SSUSR_Initials",aUserCode,0))
	//if (usrID="")  Set errMSG = "用户ID为空！"  g qCALoginJson
	b ;001
	s ifCALogin=##Class(CA.UsrSignatureInfo).GetInUseID(usrID)  //如果未开启CA登录，就不走CA的判断，开启了CA登录，必须先判断CA
	if (+ifCALogin>0){
		s ifClose=##class(CA.UsrInUseInfo).GetInUsedByUserID(usrID)
		if (ifClose=1){
			s status=-1
			s data=""
			s errMSG="用户CA关闭"
		}else{
			s resultLogin=##class(CA.DigitalSignatureService).Login2(usrID,varCertCode,strServerRan,strClientSignedData,certificateNo,varCert,caLogonType,venderCode)
			if ($e(resultLogin,1)="{"){
				s jsonObj=##class(DtPortal.Common.JsonObject).%New()
				s obj=jsonObj.FromJSON(resultLogin)
				s retCode=obj.GetValue("retCode")
				s retMsg=obj.GetValue("retMsg")
				s hisUserName=obj.GetValue("hisUserName")
				s hisUserID=obj.GetValue("hisUserID")
				s hisUserCode = $p($g(^SSU("SSUSR",hisUserID)),"^",1)
				if (retCode="0"){
					if ((accountCode'="")&&(accountCode=hisUserCode)){
						s status=1
						
						d obj.Put("accountCode",accountCode)
						s data=obj.Json()
						s errMSG=""
					}elseif(accountCode=""){
						s status=1
						d obj.Put("accountCode",hisUserCode)
						s data=obj.Json()
						s errMSG=""	
					}else{
						s status=-1
						s data=""
						s errMSG="用户不匹配"	
					}
				}
				
				
			}else{
				s status=-1
				s data=""
				s errMSG="CA认证异常"
			}
		}
		
		
	}else{
		s status=-1
		s data=""
		s errMSG="用户未开启CA"
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

/// 根据用户查询支持的CA类型
/// w ##class(DtPortal.Common.CA.HosCAWebService).GetSupportCAType("ys01","UKEY&&BJCA||PHONE&&HBCA")
ClassMethod GetSupportCAType(accountCode As %String = "", caConfInfo As %String = "") As %String [ WebMethod ]
{
	s status="-1",data="",errMSG=""
	s jsonObjRet=##class(DtPortal.Common.JsonObject).%New()
	try{
		s status="1"
		
		if (accountCode '= ""){
			Set aUserCode=$$ALPHAUP^SSUTIL4(accountCode)
			Set userId = $o(^SSU("SSUSR",0,"SSUSR_Initials",aUserCode,0))
			if (userId = ""){
				s data = ""
			}else{
				s length = $l(caConfInfo,"||")
				for index = 1:1:length {
					
					//b ;111
					s info = $p(caConfInfo,"||",index)
					s venderCode = $p(info,"&&",2)
					s loginType = $p(info,"&&",1)
					s ret = ##class(CA.DigitalSignatureService).IsCAUser(userId, venderCode, loginType, "")
					
					if (ret = 1){
						if (data = ""){
							s data = info
						}else{
							s data = data_"||"_info
						}
						
					}
					//w !,"22222="_venderCode_"!!!"_loginType_"======"_ret_"======"_data
				}
							
				
			}
		}
		
		
		
		
	} catch e {
		//b ;009
		s status="-1"
		w !,$ze
		s errMSG = "代码异常"
	}
	
	d jsonObjRet.Put("status",status).Put("data",data).Put("errMSG",errMSG)
	q jsonObjRet.Json()
}

/// 根据用户查询支持的CA类型
/// w ##class(DtPortal.Common.CA.HosCAWebService).CheckIsCAOpen("ys01","UKEY","BJCA")
ClassMethod CheckIsCAOpen(accountCode As %String = "", loginType As %String = "", venderCode As %String = "") As %String [ WebMethod ]
{
	s status="-1",data="",errMSG=""
	s jsonObjRet=##class(DtPortal.Common.JsonObject).%New()
	s jsonObj=##class(DtPortal.Common.JsonObject).%New()
	try{
		
		
		d jsonObj.Put("isOpenCA","true")
		
	} catch e {
		//b ;009
		w !,$ze
		s errMSG = "代码异常"
	}
	
	d jsonObjRet.Put("status",status).Put("data",jsonObj.Json()).Put("errMSG",errMSG)
	q jsonObjRet.Json()
}

/// 获取CA登录token---NETCA登录使用	
/// w ##class(DtPortal.Common.CA.HosCAWebService).GetLoginToken("")
ClassMethod GetLoginToken(reqparam As %String = "", loginType As %String = "", venderCode As %String = "") As %String [ WebMethod ]
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

/// 获取二维码信息	
/// w ##class(DtPortal.Common.CA.HosCAWebService).GetQRInfo("PHONE","JITCA","")
ClassMethod GetQRInfo(loginType As %String = "", venderCode As %String = "", random As %String = "") As %String [ WebMethod ]
{
	s status="-1",data="",errMSG=""
	s jsonObj=##class(DtPortal.Common.JsonObject).%New()

	try{
		s status="1",errMSG=""
		s retValue = ##Class(CA.Ajax.Webservice).GetData("GetLoginQR",venderCode,loginType,random,"")
		Set data = retValue
	}catch{
		Set status = -1
		Set errMSG = "调用接口异常"
		Set ret.data = ""
	}
	
	d jsonObj.Put("status",status).Put("errMSG",errMSG).Put("data",data)

	Quit jsonObj.Json()
}

/// 获取二维码信息	
/// w ##class(DtPortal.Common.CA.HosCAWebService).GetLoginQRResult("PHONE","JITCA","fdafadsfa")
ClassMethod GetLoginQRResult(loginType As %String = "", venderCode As %String = "", signGUID As %String = "") As %String [ WebMethod ]
{
	s status="-1",data="",errMSG=""
	s jsonObj=##class(DtPortal.Common.JsonObject).%New()

	try{
		s status="1",errMSG=""
		s retValue = ##Class(CA.Ajax.Webservice).GetData("GetLoginQRResult",venderCode,loginType,signGUID)
		Set data = retValue
	}catch{
		Set status = -1
		Set errMSG = "调用接口异常"
		Set ret.data = ""
	}
	
	d jsonObj.Put("status",status).Put("errMSG",errMSG).Put("data",data)

	Quit jsonObj.Json()
}

/// 获取二维码信息	
/// w ##class(DtPortal.Common.CA.HosCAWebService).testCaLogin()
ClassMethod testCaLogin() As %String
{
	s p=^tempPortal("CALogin")
	s p1=$p(p,"*",1),p2=$p(p,"*",2),p3=$p(p,"*",3),p4=$p(p,"*",4),p5=$p(p,"*",5),p6=$p(p,"*",6),p7=$p(p,"*",7)
	s p8=$p(p,"*",8),p9=$p(p,"*",9)
	s aa= ##class(DtPortal.Common.CA.HosCAWebService).CALogin(p1,p2,p3,p4,p5,p6,p7,p8,p9)
	w !,aa
}

}
