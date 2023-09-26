/// Desc: 网政通-圣格灵-V3-http网关服务
Class dhcserviceclient.CA.NetCAV3HttpGateway Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// This is the completed URL to access the http gateway. E.g. http://ip:port/ssoworker
Parameter Location As %String = "http://172.18.0.70:8087/v1.0/login/verifyboundvalue";

/// This is the name of the Service
Parameter ServiceName As %String = "v1.0/login/verifyboundvalue";

/// This is the URL used to access the http gateway
Property Location As %String [ InitialExpression = {..#Location}, Transient ];

/// This is the name of the Service
Property ServiceName As %String [ InitialExpression = {..#ServiceName}, Transient ];

/// CA厂商分配给东华的应用ID
Property AppID As %String;

/// CA厂商分配给医院的项目ID，大部分厂商此值为空
Property ProjectID As %String;

/// 医疗组织机构代码
Property OrganizationCode As %String;

Method NewHttpReq() As %Net.HttpRequest
{
	s request = ##class(%Net.HttpRequest).%New()
	s request.Server = $p($p(##this.Location,"/",3),":",1)
	s request.Port   = $p($p(##this.Location,":",3),"/",1)
	
	q request
}

Method Init() As %String
{
	s obj = ##class(CA.ConfigService).GetObj("NETCAV3","UKEY")
	if (obj = "") 
	{
		q 0
	}
	
	//初始化应用ID等
	s ..AppID = obj.AppID
	s ..ProjectID = obj.ProjectID
	s ..OrganizationCode = obj.OrganizationCode

	q 1
}

Method CreateTimeStamp(originalData As %String, certSN As %String = "") As %String [ WebMethod ]
{
	/*
	参数：
	1、businessOrgCode：深圳市卫生计组织机构代码
	2、businessSystemCode：深圳市 CA业务系统编码
	3、businessTypeCode：深圳市 CA业务类型编码
	4、authority：证书颁发机构 ：证书颁发机构
	5、sn：证书 sn码
	6、sourceData：签名原文 ：签名原文
	{
	"businessOrgCode":"455767873",
	"businessSystemCode":"9999",
	"businessTypeCode":"001",
	"authority":"NETCA",
	"sn":" 75EC557E2434BC2636FBA456E9ADEFD5",
	"sourceData":"MIIEfjCCA2agAwIBAgIQSD3edcGUz…"
	}
	*/
	//b "s"
	
	s initStatus = ..Init()
	q:(initStatus = "0") "请配置签名服务CA.ConfigService 厂商代码[NETCAV3] 签名类型[UKEY]"
	
	s businessOrgCode = ..OrganizationCode   ///"124403005907084468"
    s businessSystemCode = ..ProjectID
    s businessTypeCode = "007"
    s authority = "SZSGL"
    s sn = certSN
    s sourceData = originalData
	s reqparam = ..CreateTimeStampPara(businessOrgCode, businessSystemCode, businessTypeCode, authority, sn, sourceData)
	
	s request = ..NewHttpReq()
	s request.Location = "v1.0/sign/timestamp"
	
	//b "s"
	d request.SetHeader("Content-Type","application/json")
	d request.EntityBody.Write(reqparam)
	d request.Post("")
	
	s response = request.HttpResponse
	q:(response = "") "生成时间戳失败"
	q:(response.Data = "") "生成时间戳失败"
	
	s content = ""
	if $isobject(response.Data) {
		s result = response.Data
		if (0=result.Size) { }
		else {
			while (result.AtEnd = 0) {
				s content=content_result.Read(32000)
			}			
		}
	}
	k request
	
	/*
	返回时间戳 签名结果，返回格式为
	{
	"statusCode":0,
	"eventMsg":"sign timestamp successfully.",
	"eventValue":{
	"timestamp":"MIIGtAYJKoZIhvcNAQcCoIIGp......"
	}
	}
	状态码不为 0表示 时间戳 签名失败，返回格式为：
	{
	"statusCode":1,
	"eventMsg":"failed to sign timestamp, error:创建时间戳请 求失败 ."
	}
	*/
	s json = ##Class(CA.Util.Json).FromJson(content)
	s status = json.GetAt("statusCode")
	if (status = "0")
	{
		s ts = json.GetAt("eventValue").GetAt("timestamp")
		q ts
	}
	else
	{
		q ""
	}
	
	/*
	s status = $p(content, ",",1)
	s status = $p(status, ":",2)
	s status = $tr(status,"""","")
	q:(status '= "0") ""
	
	s ts = $p(content,":", 5)
	s ts = $e(ts,2,$l(ts)-3)
	q ts
	*/
	
	/*
	s jsonObj = ##class(ext.util.JsonObject).FromJSON(content)
	s ret     = jsonObj.GetValue("statusCode")
	s errinfo = jsonObj.GetValue("eventMsg")
	
	if (ret = "0")	//成功
	{
		s timeStamp = jsonObj.GetValue("eventValue").GetValue("timestamp")
		q timeStamp
	}
	else
	{
		q ""		//失败
	}
	*/
}

ClassMethod CreateTimeStampPara(businessOrgCode, businessSystemCode, businessTypeCode, authority, sn, sourceData) As %String
{
	
	s p0 = "{"
	s p0 = p0_$char(34)_"businessOrgCode"_$char(34)_":"_$char(34)_businessOrgCode_$char(34)_","
	s p0 = p0_$char(34)_"businessSystemCode"_$char(34)_":"_$char(34)_businessSystemCode_$char(34)_","
	s p0 = p0_$char(34)_"businessTypeCode"_$char(34)_":"_$char(34)_businessTypeCode_$char(34)_","
	s p0 = p0_$char(34)_"authority"_$char(34)_":"_$char(34)_authority_$char(34)_","
	s p0 = p0_$char(34)_"sn"_$char(34)_":"_$char(34)_sn_$char(34)_","
	s p0 = p0_$char(34)_"sourceData"_$char(34)_":"_$char(34)_sourceData_$char(34)
	s p0 = p0_"}"
	
    q p0
}

Method CreateTimeStampRequest(originalData As %String) As %String [ WebMethod ]
{
	q ""
}

Method GetTimeStampInfo(timeStampString As %String, informationCode As %xsd.int) As %String [ WebMethod ]
{
	q ""
}

Method VerifyTimeStamp(timeStampString As %String) As %xsd.int [ WebMethod ]
{
	q ""
}

Method GenRandom() As %String [ WebMethod ]
{
	q "FakeServerRandom"
}

Method GetCertInfo(bstrCert As %String, type As %xsd.int) As %String [ WebMethod ]
{
	q ""
}

Method GetServerCert() As %String [ WebMethod ]
{
	q "FakeServerCert"
}

Method SignData(InData As %String) As %String [ WebMethod ]
{
	q "FakeServerSign"
}

Method ValidateCertificate(bstrCert As %String) As %String [ WebMethod ]
{
	q ""
}

Method VerifyCertAndSignedData(bstrCert As %String, inData As %String, signedData As %String, certSN As %String) As %String [ WebMethod ]
{
	q ..VerifySignedData(bstrCert,inData,signedData,certSN)
}

/// 		Return: 0 验证签名成功，其他值 验证签名失败
Method VerifySignedData(bstrCert As %String, inData As %String, signedData As %String, certSN As %String) As %String [ WebMethod ]
{
	/*
	参数：
	1、businessOrgCode：深圳市卫生计组织机构代码
	2、businessSystemCode：深圳市 CA业务系统编码
	3、businessTypeCode：深圳市 CA业务类型编码
	4、authority：证书颁发机构 ：证书颁发机构
	5、sn：证书 sn码
	6、signCert：base64编码格式证书 编码格式证书
	7、sourceData：签名原文 ：签名原文
	8、signedData：签名值
	9、detach：是否带原文， ：是否带原文， 0表示带原文， 1表示不带原文
	{
	"businessOrgCode":"455767873",
	"businessSystemCode":"9999",
	"businessTypeCode":"999",
	"authority":"NETCA",
	"sn":" 75EC557E2434BC2636FBA456E9ADEFD5",
	"signCert":"MIIEfjCCA2agAwIBAgIQSD3edcGUzDg…",
	"sourceData": "abcdefg",
	"signedData": "MIIGHQYJKoZIhvcNAQcIBAgIBAg…",
	"detach":0
	}
	*/
	
	s initStatus = ..Init()
	q:(initStatus = "0") "请配置签名服务CA.ConfigService 厂商代码[NETCAV3] 签名类型[UKEY]"
	
	s businessOrgCode = ..OrganizationCode   ///"124403005907084468"
    s businessSystemCode = ..ProjectID
    s businessTypeCode = "007"
    s authority = "SZSGL"
    s sn = certSN
    s signCert = bstrCert
    s sourceData = inData
    //s signedData = signedData
    s detach = "1"
	s reqparam = ..GetVerifySignedDataPara(businessOrgCode, businessSystemCode, businessTypeCode, authority, sn, signCert, sourceData, signedData, detach)
	
	s request = ..NewHttpReq()
	s request.Location = "v1.0/verify/data"
	
	//b "s"
	d request.SetHeader("Content-Type","application/json")
	d request.EntityBody.Write(reqparam)
	d request.Post("")
	
	s response = request.HttpResponse
	q:(response = "") "验证签名失败"
	q:(response.Data = "") "验证签名失败"
	
	s content = ""
	if $isobject(response.Data) {
		s result = response.Data
		if (0=result.Size) { }
		else {
			while (result.AtEnd = 0) {
				s content=content_result.Read(32000)
			}			
		}
	}
	k request
	
	/*
	返回验证签名结果，格式为：
	{
	"statusCode":0,
	"eventMsg":"verify data successfully"
	}
	状态码不为 0表示数据验证失败，返回格式为：
	{
	"statusCode":1,
	"eventMsg":"failed to verify sign data, error: incorrect serial number."
	*/
	//b
	//s jsonObj = ##class(ext.util.JsonObject).FromJSON(content)
	//s ret     = jsonObj.GetValue("statusCode")
	//s errinfo = jsonObj.GetValue("eventMsg")
	//q:(ret = "0") "1"	//成功
	//q "0^"_errinfo		//失败
	s json = ##class(CA.Util.Json).FromJson(content)
	s status = json.GetAt("statusCode")
	s eventMsg = json.GetAt("eventMsg")
	if (status = "0")
	{
		q "1"
	}
	else
	{
		q "0^"_eventMsg
	}
	
	/*
	s status = $p(content, ",",1)
	s status = $p(status, ":",2)
	s status = $tr(status,"""","")
	if (status = "0")
	{
		q "1" //成功
	}
	else
	{
		s tc = $tr(content,"""","")
		s tc = $tr(tc,"}","")
		s errinfo = $p(tc,"eventMsg",2)
		q "0^"_errinfo //失败
	}
	*/
}

ClassMethod GetVerifySignedDataPara(businessOrgCode, businessSystemCode, businessTypeCode, authority, sn, signCert, sourceData, signedData, detach) As %String
{
	
	s p0 = "{"
	s p0 = p0_$char(34)_"businessOrgCode"_$char(34)_":"_$char(34)_businessOrgCode_$char(34)_","
	s p0 = p0_$char(34)_"businessSystemCode"_$char(34)_":"_$char(34)_businessSystemCode_$char(34)_","
	s p0 = p0_$char(34)_"businessTypeCode"_$char(34)_":"_$char(34)_businessTypeCode_$char(34)_","
	s p0 = p0_$char(34)_"authority"_$char(34)_":"_$char(34)_authority_$char(34)_","
	s p0 = p0_$char(34)_"sn"_$char(34)_":"_$char(34)_sn_$char(34)_","
	s p0 = p0_$char(34)_"signCert"_$char(34)_":"_$char(34)_signCert_$char(34)_","
	s p0 = p0_$char(34)_"sourceData"_$char(34)_":"_$char(34)_sourceData_$char(34)_","
	s p0 = p0_$char(34)_"signedData"_$char(34)_":"_$char(34)_signedData_$char(34)_","
	s p0 = p0_$char(34)_"detach"_$char(34)_":"_$char(34)_detach_$char(34)
	s p0 = p0_"}"
	
    q p0
}

Method GetLoginToken(reqparam) As %String
{
	/*
	参数：
	1、businessOrgCode：深圳市卫生计组织机构代码
	2、businessSystemCode：深圳市 CA业务系统编码
	3、businessTypeCode：深圳市 CA业务类型编码
	4、authority：证书机构
	5、sn：证书 sn码
	6、signCert：base64编码格式证书 编码格式证书
	7、pwd：证书密码
	8、boundValue：签名值，由 ：签名值，由 2.2接口获取
	
	格式示例：
	{
	"businessOrgCode":"455767873",
	"businessSystemCode":"9999",
	"businessTypeCode":"001",
	"authority":"NETCA",
	"sn":" 75EC557E2434BC2636FBA456E9ADEFD5",
	"signCert":"MIIEfjCCA2agAwIBAgIQSD3edcGUzD…",
	"pwd":"111111",
	"boundValue":"14m6KMhpjL0="
	}
	
	json格式参数由前端js组织，传到后端
	*/
	
	/*
	s authority	= "NETCA"

	s boundValue = "MIIETgYJKoZIhvcNAQcCoIIEPzCCBDsCAQExDDAKBggqgRzPVQGDETAyBgkqhkiG9w0BBwGgJQQjU3hYRHdOSno3ZWI2akNVS2ViWW8ycVVncVJYTE5udUNyQWGgggKnMIICozCCAkqgAwIBAgILEL5DISKImNwvXREwCgYIKoEcz1UBg3UwYjELMAkGA1UEBhMCQ04xJDAiBgNVBAoMG05FVENBIENlcnRpZmljYXRlIEF1dGhvcml0eTEtMCsGA1UEAwwkTkVUQ0EgU00yIFRFU1QwMSBhbmQgRXZhbHVhdGlvbiBDQTAxMB4XDTE3MDMyOTA5NDMwOFoXDTIwMDMzMTA5NDMzMVowgYExCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ2RvbmcxDzANBgNVBAcMBuW5v+W3njEVMBMGA1UECgwM5rWL6K+V5Y2V5L2NMRowGAYDVQQDDBFTTTLmtYvor5Xor4HkuaYwMTEaMBgGCSqGSIb3DQEJARYLenNAY25jYS5uZXQwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAASepWuGZz170Sn96go5U2wp4riJ2R/T+ftuNVdhUgt9gaQwk3rHKBARWBT58T42RZknrGYKHslvCGYZHUxHgKOMo4HGMIHDMDMGA1UdHwQsMCowKKAmoCSGImh0dHA6Ly90ZXN0LmNuY2EubmV0L2NybC9TTTJDQS5jcmwwHQYDVR0OBBYEFEuQfKHIGHao5D/7q0Ade+/O/pYTMA4GA1UdDwEB/wQEAwIGwDAfBgNVHSMEGDAWgBQMe+ticwN1+oxKJAz2jzshZX4X6TAMBgNVHRMBAf8EAjAAMC4GCysGAQQBgZJIAQwLBB8MHTEwMDAxQDAwMDZQTzFRMU15TURFM01ETXlPVEEwMAoGCCqBHM9VAYN1A0cAMEQCIAN/8sxyAbbZTNJqPqbFerudEoONHB60BnZV/rED4AyHAiAEBQMlnmpVBpEOp+9IYMi299LNt9X1IxtkZJgTBx7IIjGCAUcwggFDAgEBMHEwYjELMAkGA1UEBhMCQ04xJDAiBgNVBAoMG05FVENBIENlcnRpZmljYXRlIEF1dGhvcml0eTEtMCsGA1UEAwwkTkVUQ0EgU00yIFRFU1QwMSBhbmQgRXZhbHVhdGlvbiBDQTAxAgsQvkMhIoiY3C9dETAKBggqgRzPVQGDEaBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE4MDMwNTA3NDMzNFowLwYJKoZIhvcNAQkEMSIEIKfMCl4Lb+t+fq9A51ckMjf0P4kxNe0zqIrixnZrTnj0MAoGCCqBHM9VAYN1BEgwRgIhAI9iIjzdjSJzjH7b/7kp11NLLJqsV+9jMU1KXgot3iaiAiEAv5E8IP+2bN1hTwqQ7SIRXOcIH/iDFJSALYK5fiNsKf8="

	s businessOrgCode =	"455743708"

	s businessSystemCode =	"0001"

	s businessTypeCode = "001"

	s passwd =	"12345678"

	s signCert =	"MIICozCCAkqgAwIBAgILEL5DISKImNwvXREwCgYIKoEcz1UBg3UwYjELMAkGA1UEBhMCQ04xJDAiBgNVBAoMG05FVENBIENlcnRpZmljYXRlIEF1dGhvcml0eTEtMCsGA1UEAwwkTkVUQ0EgU00yIFRFU1QwMSBhbmQgRXZhbHVhdGlvbiBDQTAxMB4XDTE3MDMyOTA5NDMwOFoXDTIwMDMzMTA5NDMzMVowgYExCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ2RvbmcxDzANBgNVBAcMBuW5v+W3njEVMBMGA1UECgwM5rWL6K+V5Y2V5L2NMRowGAYDVQQDDBFTTTLmtYvor5Xor4HkuaYwMTEaMBgGCSqGSIb3DQEJARYLenNAY25jYS5uZXQwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAASepWuGZz170Sn96go5U2wp4riJ2R/T+ftuNVdhUgt9gaQwk3rHKBARWBT58T42RZknrGYKHslvCGYZHUxHgKOMo4HGMIHDMDMGA1UdHwQsMCowKKAmoCSGImh0dHA6Ly90ZXN0LmNuY2EubmV0L2NybC9TTTJDQS5jcmwwHQYDVR0OBBYEFEuQfKHIGHao5D/7q0Ade+/O/pYTMA4GA1UdDwEB/wQEAwIGwDAfBgNVHSMEGDAWgBQMe+ticwN1+oxKJAz2jzshZX4X6TAMBgNVHRMBAf8EAjAAMC4GCysGAQQBgZJIAQwLBB8MHTEwMDAxQDAwMDZQTzFRMU15TURFM01ETXlPVEEwMAoGCCqBHM9VAYN1A0cAMEQCIAN/8sxyAbbZTNJqPqbFerudEoONHB60BnZV/rED4AyHAiAEBQMlnmpVBpEOp+9IYMi299LNt9X1IxtkZJgTBx7IIg=="

	s sn =	"10BE4321228898DC2F5D11"
	
	*/
	
	//s location = "http://172.18.0.70:8087/v1.0/login/verifyboundvalue"
	//s request = ##class(%Net.HttpRequest).%New()
	//s request.Server = $p($p(location,"/",3),":",1)
	//s request.Port   = $p($p(location,"/",3),":",2)
	
	q:(reqparam = "") "参数不能为空,应为有效json串"
	
	s request = ..NewHttpReq()
	s request.Location = "v1.0/login/verifyboundvalue"
	
	//b "s"
	d request.SetHeader("Content-Type","application/json")
	d request.EntityBody.Write(reqparam)
	d request.Post("")
	
	s response = request.HttpResponse
	q:(response = "") ""
	q:(response.Data = "") ""
	
	s signedData = response.Data.Read(32000)
	s signedData = $zcvt(signedData,"i","UTF8")
	q signedData
}

Method Login(usrID As %String, UsrCertCode As %String, serverRan As %String, userSignedData As %String, certNo As %String, userCert As %String) As %String
{
	//不再校验
	q "1"
	
	//命令	certlogin //功能描述	使用证书登录
	//参数	rand	由getrand产生的随机数，该随机数只能使用一次
	//		cert	用户证书实体，base64编码
	//		signed	已签名的信息
	//返回值	ret	1：登录成功 0：登录失败
	//			errinfo	失败原因：
	//					parameter invalid：挑战字不存在 cert format invalid：证书格式错误 the cert is not of sm2 type：证书类型错误； cert was blacklisted：证书入黑名单 cert usage wrong：证书用法错误 the cert has expired：证书过期 the cert was not issued by ca：该证书非注册的根证书签发 issuer not found：根证书未在系统注册 wrong sign：挑战字签名结果错误；
	//			token	产生的sso登录令牌
	/*
	s request = ..NewHttpReq()
	
	d request.InsertFormData("cmd","certlogin")
	d request.InsertFormData("rand",serverRan)
	d request.InsertFormData("cert",userCert)
	d request.InsertFormData("signed",userSignedData)
	
	d request.Post(..ServiceName)
	
	s response = request.HttpResponse
	s content=""
	s (ret,errinfo,rand) = ""
	if $isobject(response.Data) {
		s result = response.Data
		if (0=result.Size) { }
		else {
			while (result.AtEnd = 0) {
				s content=content_$ZSTRIP(result.Read(32000),"*C",,$c(1)_$c(2))
			}			
		}
	}
	k request
	
	s jsonObj = ##class(ext.util.JsonObject).FromJSON(content)
	s ret     = jsonObj.GetValue("ret")
	s errinfo = jsonObj.GetValue("errinfo")
	s cert    = jsonObj.GetValue("token")
	q:(ret=1) jsonObj.GetValue("token")
	q errinfo
	*/
}

ClassMethod Replace(inputStr As %String, fromStr As %String, toStr As %String) As %String
{
	set count = $Length(inputStr, fromStr)
    quit:(count <= 1) inputStr
    
    set outStr = $p(inputStr,fromStr,1)
	for i = 2:1:count
	{
		set outStr = outStr_toStr_$p(inputStr,fromStr,i)
	}
	
	q outStr
}

ClassMethod GetSignPara(idCode, fpinfo, data) As %String
{
	s p0 = "{'request':{'SealSvr':{'file':'','QMImg':'','idCode':'{idCode}','Perlocations':[],'fpInfo':'{fpinfo}','isStrSign':'true','data':'{data}'}}}"
    s p0 = $tr(p0,"'",$char(34))
    
    s p1 = $p(p0,"{idCode}",1)
    s px = $p(p0,"{idCode}",2)
    s p2 = $p(px,"{fpinfo}",1)
    s px = $p(px,"{fpinfo}",2)
    s p3 = $p(px,"{data}",1)
    s p4 = $p(px,"{data}",2)
    
    s para = p1_idCode_p2_fpinfo_p3_data_p4
    q para
}

/// d ##Class(dhcserviceclient.CA.SZCAHttpGateway).test()
ClassMethod test() As %String
{
	s http = ##Class(dhcserviceclient.CA.SZCAHttpGateway).%New()
	
	s idcode = "917"
	s finger = $g(^CacheTempEPRDebug("finger"))
	s data   = "1234567890"
	
	s ret = http.LoginByPlat(idcode, finger)
	w "Login:"_ret
	
	s ret = http.UserSignByPlat(idcode, finger, data)
	w "Sign:"_ret
	
	q ret
	
	/*
	//b "s"
	//http://218.25.86.214:2010/ssoworker
	//s obj = ##Class(dhcserviceclient.CA.SZCAHttpGateway).%New()
	//s httprequest= obj.NewHttpReq() //##class(%Net.HttpRequest).%New()
	s httprequest = ##class(%Net.HttpRequest).%New()
	s httprequest.Server = "192.168.90.89"
	s httprequest.Port   ="8082"
	s httprequest.Location = "HospitalSeal/servlet/reqSealService"
	
	
	s idcode = "917"
	s finger = $g(^CacheTempEPRDebug("finger"))
	
	s finger = ..Replace(finger,$char(10),"\n")
	s finger = ..Replace(finger,$char(13),"\r")
	
	
	
	s data = "abcABC<>\r\n\0\'\/"_$char(10)_$char(13)
	s data = data_$c(0)_$c(1)_$c(2)_$c(3)_$c(4)_$c(5)_$c(6)_$c(7)_$c(8)_$c(9)_$c(11)_$c(12)_$char(14)
	s data = data_$c(34)_$c(39)
	s data = data_$c(10)_$c(13)_"xyzXYZ"
	s data = data_$c(10)_$c(13)_"中华人民共和国"
	
	s data =  "da583bd31065aea0375c314eaf35c0410f9f3cfe"  //##Class(%SYSTEM.Encryption).SHAHash(data)
	
	s path = ..GetFilePath()
	s file =  path_"tosign.txt"
	s stream = ##Class(%FileCharacterStream).%New()
	s stream.Filename = file
	
	d stream.Write(data)
	s sc = stream.SaveStream()
	if (sc '= "1")
	{
		w !,"file error"
		quit
	}
	
	w !,"file:"_file
	
	
	s data = $zcvt(data,"O","UTF8")
	s data = ##Class(%SYSTEM.Encryption).Base64Encode(data)
	s data = $tr(data,$c(10),"")
	s data = $tr(data,$c(13),"")
	
	*/
	
	/*
	s data = ..Replace(data,"\","\\")
	s data = ..Replace(data,$char(13),"\r")
	s data = ..Replace(data,$char(10),"\n")
	s data = ..Replace(data,$char(0),"\0")
	s data = ..Replace(data,$char(34),"\""")
	*/
	
	//s data = ##Class(%SYSTEM.Encryption).Base64Encode(data)
	
	/*
	s param = ..para(idcode,finger,data)
	
	w !,param
	//b "s"
	s param = ##Class(%CSP.Page).EscapeURL(param)
	
	d httprequest.EntityBody.Write(param)
	//d httprequest.InsertFormData("papam",param)
	
	//d httprequest.Post("HospitalSeal/servlet/reqSealService")
	d httprequest.Post("")
	//s param = "HospitalSeal/servlet/reqSealService?"_param
	//d httprequest.Get(param)
	
	b
	s response=httprequest.HttpResponse
	w "ContentInfo:"_response.ContentInfo,!
	w "ContentLength:"_response.ContentLength,!
	s content=""
	
	w !,"data size :"_response.Data.Size
	
	s signedData = response.Data.Read(10000)
	s a = "reposnseData:"_signedData
	w !,a
	
	s file2 =  path_"signedData.txt"
	s stream2 = ##Class(%FileCharacterStream).%New()
	s stream2.Filename = file2
	d stream2.Write(signedData)
	s sc = stream2.SaveStream()
	if (sc '= "1")
	{
		w !,"file error"
		quit
	}
	
	w !,"file1:"_file
	w !,"file2:"_file2
	
	//s ^houj("a")= a
	quit
	
	s (ret,errinfo,rand) = ""
	if $isobject(response.Data) {
		s result = response.Data
		if (0=result.Size) {
			
		}
		else {
			while (result.AtEnd = 0)
			{
				s content=content_$ZSTRIP(result.Read(32000),"*C",,$c(1)_$c(2))
			}			
		}
		w "response	:	"_content,!
		
	}
	*/
	
	/*
	//d content.Rewind()
	s jsonObj = ##class(ext.util.JsonObject).FromJSON(content)
	w "ret		:	"_jsonObj.GetValue("ret"),!
	w "errinfo		:	"_jsonObj.GetValue("errinfo"),!
	w "rand		:	"_jsonObj.GetValue("rand"),!
	w "httprequest.HttpResponse.Data"
	*/
}

}
