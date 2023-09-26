Class web.DHCMDTExternalServicescls Extends %RegisteredObject
{

Parameter SSTimeout = 40;

Parameter SSAddress = "ai.imedway.cn";

Parameter SSPort = 443;

Parameter IsHttps = 1;

Parameter SSLConfigName = "mdt.ssl";

Parameter AESKey = "8UMGsOpX69F4HM05";

Parameter AESIV = 0102030405060708;

Parameter Authorization = "NTNhZjJmZTktN2MzOS03YTA3LWI4YjktZTkzMjQ2M2U2NjdhOjZkNmY4ODI4MDY4MzhjM2E3ODhmNTM1NzkwNDM1YzUx";

Parameter token = "LDgzNzQwOTIzNjEsNWU0MmExOWQsYTc2NmUzNjQyMzllLTliOGItNzBhNy05M2M3LTllZjJmYTM1LDE2MzI4OTc1Mzg=";

Parameter MD5KEY = "6bYKIWr7tQgJJgw6";

Parameter appid = "53af2fe9-7c39-7a07-b8b9-e932463e667a";

Parameter appKey = "6d6f882806838c3a788f535790435c51";

/// w ##class(web.DHCMDTExternalServices).CallInterface()
ClassMethod CallInterface(Params)
{
	Set UserCode=$p(Params,"^",1)
	Set CstRUser=$p(Params,"^",2)
	Set PhoneNo=$p(Params,"^",3)
	Set CsUser=$p(Params,"^",4)
	Set CsLocDesc=$p(Params,"^",5)
	Set AdmDate=$p(Params,"^",6)
	Set AdmTime=$p(Params,"^",7)
	Set PatName=$p(Params,"^",8)
	Set MdtID=$p(Params,"^",9)
	b ;1
	Quit:PhoneNo="" 0
	b ;2
	Set dynamicObject= ##class(%Library.DynamicObject).%New()
	Do dynamicObject.%Set("toDocCode",UserCode)
	Do dynamicObject.%Set("toDocName",CstRUser)
	Do dynamicObject.%Set("toDocPhone",PhoneNo)
	Do dynamicObject.%Set("fromDocName",CsUser)
	Do dynamicObject.%Set("fromDeptName",CsLocDesc)
	Do dynamicObject.%Set("admTime",AdmDate_" "_AdmTime)
	Do dynamicObject.%Set("patName",PatName)
	Do dynamicObject.%Set("roomId",MdtID)
	Set bizContent=..GetBizContent(dynamicObject)
	Set sign=..GetSign(dynamicObject)
	
	Set SendDataObj=##class(%Library.DynamicObject).%New()
	Do SendDataObj.%Set("token_type","api_credentials")
	Do SendDataObj.%Set("token",..GetToken())
	Do SendDataObj.%Set("method","tencentcloud.trtc.consult-invite")
	Do SendDataObj.%Set("version","v1.0")
	Do SendDataObj.%Set("app_id",..#appid)
	Do SendDataObj.%Set("biz_content",bizContent)
	Do SendDataObj.%Set("nonce_str",1)
	Do SendDataObj.%Set("sign",sign)
	
	Set httpRequest=##class(%Net.HttpRequest).%New()
	Set httpRequest.Timeout=..#SSTimeout
	Set httpRequest.Server=..#SSAddress
	Set httpRequest.Port = ..#SSPort
	
	If ..#IsHttps {
		Set httpRequest.Https=1
		Set httpRequest.SSLConfiguration=..#SSLConfigName ;..GetSSLConfigurationName()
		Set httpRequest.SSLCheckServerIdentity=0  ;过期证书的服务器是否访问
	}
	Set httpRequest.ContentCharset="UTF-8"
	Set httpRequest.ContentType="application/json"
	Do httpRequest.InsertFormData("grant_type","api_credentials")
	do httpRequest.EntityBody.Write(SendDataObj.%ToJSON())
	Set retStr=httpRequest.Post("/dhccam-mediway2021/gateway/index")
	Set dataStream=httpRequest.HttpResponse.Data
	Quit:dataStream="" ""
 	;Set outputObj=##class(web.DHCMDTExternalServicesToken).%New()
 	;Do ##class(ext.util.JsonObject).JSONStreamToObject(dataStream,.outputObj,"")
 	;Quit outputObj
 	q 0
}

/// w ##class(web.DHCMDTExternalServices).CallMdtPatPayMoney("YS01^医生01^17753877386^急诊医生01^急诊内科门诊^2022-07-01^10:06^住院N1^36^2022-09-08^08:30-11:00^1^wyzj03")
ClassMethod CallMdtPatPayMoney(Params)
{
	Set CstRUserCode=$p(Params,"^",1)	;申请会诊医生Code
	Set CstRUser=$p(Params,"^",2)		;申请医生	
	Set PhoneNo=$p(Params,"^",3)		;会诊医生电话
	Set CsUser=$p(Params,"^",4)			;会诊医生姓名
	Set CsLocDesc=$p(Params,"^",5)		;会诊科室
	Set AdmDate=$p(Params,"^",6)		;就诊日期
	Set AdmTime=$p(Params,"^",7)		;就诊时间
	Set PatName=$p(Params,"^",8)		;患者姓名
	Set MdtID=$p(Params,"^",9)			;会诊ID（房间号）
	Set PreDate=$p(Params,"^",10)		;预约日期
	Set PreTime=$p(Params,"^",11)		;预约时间
	Set DocHospType=$p(Params,"^",12)	;0->本院；1->外院
	Set Method="tencentcloud.trtc.consult-pay-notify" ;$case(Type,1:"tencentcloud.trtc.consult-pay-notify",2:"tencentcloud.trtc.consult-invite-anyone")
	
	Quit:PhoneNo="" 0
	Set dynamicObject= ##class(%Library.DynamicObject).%New()
	Do dynamicObject.%Set("docCode",CstRUserCode)
	Do dynamicObject.%Set("docName",CstRUser)
	Do dynamicObject.%Set("docPhone",PhoneNo)
	Do dynamicObject.%Set("docType",DocHospType)	; 0 -> 本院；1 -> 外院
	Do dynamicObject.%Set("consultDocName",CsUser)
	Do dynamicObject.%Set("consultDeptName",CsLocDesc)
	Do dynamicObject.%Set("consultTime",PreDate_" "_PreTime)
	Do dynamicObject.%Set("patName",PatName)
	Do dynamicObject.%Set("roomId",MdtID)
	Set bizContent=..GetBizContent(dynamicObject)
	Set sign=..GetSignNew(dynamicObject,Method)
	
	Set SendDataObj=##class(%Library.DynamicObject).%New()
	Do SendDataObj.%Set("token_type","api_credentials")
	Do SendDataObj.%Set("token",..GetToken())
	Do SendDataObj.%Set("method",Method)
	Do SendDataObj.%Set("version","v1.0")
	Do SendDataObj.%Set("app_id",..#appid)
	Do SendDataObj.%Set("biz_content",bizContent)
	Do SendDataObj.%Set("nonce_str",1)
	Do SendDataObj.%Set("sign",sign)
	
	Set httpRequest=##class(%Net.HttpRequest).%New()
	Set httpRequest.Timeout=..#SSTimeout
	Set httpRequest.Server=..#SSAddress
	Set httpRequest.Port = ..#SSPort
	
	If ..#IsHttps {
		Set httpRequest.Https=1
		Set httpRequest.SSLConfiguration=..#SSLConfigName ;..GetSSLConfigurationName()
		Set httpRequest.SSLCheckServerIdentity=0  ;过期证书的服务器是否访问
	}
	Set httpRequest.ContentCharset="UTF-8"
	Set httpRequest.ContentType="application/json"
	Do httpRequest.InsertFormData("grant_type","api_credentials")
	do httpRequest.EntityBody.Write(SendDataObj.%ToJSON())
	Set retStr=httpRequest.Post("/dhccam-mediway2021/gateway/index")
	Set dataStream=httpRequest.HttpResponse.Data
	Quit:dataStream="" ""
	
 	;Set outputObj=##class(web.DHCMDTExternalServicesToken).%New()
 	;Do ##class(ext.util.JsonObject).JSONStreamToObject(dataStream,.outputObj,"")
 	;Quit outputObj
 	q 0
}

/// w ##class(web.DHCMDTExternalServices).CallDocOpenMeet("YS01^医生01^17753877386^急诊医生01^急诊内科门诊^2022-07-01^10:06^住院N1^36^2022-09-08^08:30-11:00^1^wyzj03")
ClassMethod CallDocOpenMeet(Params)
{
	Set CstRUserCode=$p(Params,"^",1)	;申请会诊医生Code
	Set CstRUser=$p(Params,"^",2)		;申请医生	
	Set PhoneNo=$p(Params,"^",3)		;会诊医生电话
	Set CsUser=$p(Params,"^",4)			;会诊医生姓名
	Set CsLocDesc=$p(Params,"^",5)		;会诊科室
	Set AdmDate=$p(Params,"^",6)		;就诊日期
	Set AdmTime=$p(Params,"^",7)		;就诊时间
	Set PatName=$p(Params,"^",8)		;患者姓名
	Set MdtID=$p(Params,"^",9)			;会诊ID（房间号）
	Set PreDate=$p(Params,"^",10)		;预约日期
	Set PreTime=$p(Params,"^",11)		;预约时间
	Set DocHospType=$p(Params,"^",12)	;0->本院；1->外院
	Set CsUserCode=$p(Params,"^",13)	;会诊医生code
	;tencentcloud.trtc.consult-invite-anyone
	Set Method="tencentcloud.trtc.consult-invite-anyone"
	Quit:PhoneNo="" 0
	Set dynamicObject= ##class(%Library.DynamicObject).%New()
	Do dynamicObject.%Set("toDocCode",CsUserCode)
	Do dynamicObject.%Set("toDocName",CsUser)
	Do dynamicObject.%Set("toDocPhone",PhoneNo)
	Do dynamicObject.%Set("toDocType",DocHospType) ;toDocType: 目标医生类型，0 -> 本院；1 -> 外院
	Do dynamicObject.%Set("consultDocName",CsUser)
	Do dynamicObject.%Set("consultDeptName",CsLocDesc)	
	Do dynamicObject.%Set("consultTime",PreDate_" "_PreTime)
	Do dynamicObject.%Set("patName",PatName)
	Do dynamicObject.%Set("roomId",MdtID)
	Set bizContent=..GetBizContent(dynamicObject)
	Set sign=..GetSignNew(dynamicObject,Method)
	
	Set SendDataObj=##class(%Library.DynamicObject).%New()
	Do SendDataObj.%Set("token_type","api_credentials")
	Do SendDataObj.%Set("token",..GetToken())
	Do SendDataObj.%Set("method",Method)
	Do SendDataObj.%Set("version","v1.0")
	Do SendDataObj.%Set("app_id",..#appid)
	Do SendDataObj.%Set("biz_content",bizContent)
	Do SendDataObj.%Set("nonce_str",1)
	Do SendDataObj.%Set("sign",sign)
	
	Set httpRequest=##class(%Net.HttpRequest).%New()
	Set httpRequest.Timeout=..#SSTimeout
	Set httpRequest.Server=..#SSAddress
	Set httpRequest.Port = ..#SSPort
	
	If ..#IsHttps {
		Set httpRequest.Https=1
		Set httpRequest.SSLConfiguration=..#SSLConfigName ;..GetSSLConfigurationName()
		Set httpRequest.SSLCheckServerIdentity=0  ;过期证书的服务器是否访问
	}
	Set httpRequest.ContentCharset="UTF-8"
	Set httpRequest.ContentType="application/json"
	Do httpRequest.InsertFormData("grant_type","api_credentials")
	do httpRequest.EntityBody.Write(SendDataObj.%ToJSON())
	Set retStr=httpRequest.Post("/dhccam-mediway2021/gateway/index")
	Set dataStream=httpRequest.HttpResponse.Data
	
	Quit:dataStream="" ""
 	;Set outputObj=##class(web.DHCMDTExternalServicesToken).%New()
 	;Do ##class(ext.util.JsonObject).JSONStreamToObject(dataStream,.outputObj,"")
 	;Quit outputObj
 	q 0
}

/// Biz加密
ClassMethod GetBizContent(contObj)
{
	Set dynamicObject= ##class(%Library.DynamicObject).%New()
	Do dynamicObject.%Set("body",contObj)
	Set contentText=dynamicObject.%ToJSON()
	Set contentText=$ZCONVERT(contentText,"O","UTF8") ;转字节
	Set bizCont = $SYSTEM.Encryption.AESCBCEncrypt(contentText,..#AESKey,..#AESIV) // CBC加密链块模式  AES加密算法
	Set bizContHex=##class(web.Util.Encryption).Byte2Hex(bizCont)
	Quit bizContHex
}

/// 签名MD5加密
ClassMethod GetSign(contObj)
{
	Set str=""
	_"app_id="_..#appid
	_"&body="_contObj.%ToJSON()
	_"&method=tencentcloud.trtc.consult-invite"
	_"&nonce_str=1"
	_"&token="_..GetToken() ;"LDAxMzg3NjMzNjEsNWU0MmExOWQsYTc2NmUzNjQyMzllLTliOGItNzBhNy05M2M3LTllZjJmYTM1LDE2MzM2NzExMTA=" ;
	_"&token_type=api_credentials"
	_"&version=v1.0"
	_..#MD5KEY
	Set sign=##class(web.Util.Encryption).MD5HexStr(str,"UTF8")
	Quit sign
}

/// 签名MD5加密
ClassMethod GetSignNew(contObj, method)
{
	Set str=""
	_"app_id="_..#appid
	_"&body="_contObj.%ToJSON()
	_"&method="_method
	_"&nonce_str=1"
	_"&token="_..GetToken() ;"LDAxMzg3NjMzNjEsNWU0MmExOWQsYTc2NmUzNjQyMzllLTliOGItNzBhNy05M2M3LTllZjJmYTM1LDE2MzM2NzExMTA=" ;
	_"&token_type=api_credentials"
	_"&version=v1.0"
	_..#MD5KEY
	Set sign=##class(web.Util.Encryption).MD5HexStr(str,"UTF8")
	Quit sign
}

/// w ##class(web.DHCMDTExternalServices).GetToken()
ClassMethod GetToken()
{
	Set tokenData = $g(^TMP("NEWPRO","Token"))
	Set remainTime=$p(tokenData,$c(2),2)
	Set createTime=$p(tokenData,$c(2),3)
	Set limitSec=$SYSTEM.SQL.DATEDIFF("ss",createTime,$h)
	If ((limitSec>remainTime)||(tokenData="")) {
		Set tokenObj=..GetTokenRemote()
		Set tokenObjReTime=tokenObj.%data("remain_time")
		Set tokenObjToken=tokenObj.%data("access_token")
		Set ^TMP("NEWPRO","Token")=tokenObjToken_$c(2)_tokenObjReTime_$c(2)_$h
	}
	
	Set retToken=$p(^TMP("NEWPRO","Token"),$c(2),1)
	Quit retToken
}

/// w ##class(web.DHCMDTExternalServices).GetTokenRemote()
ClassMethod GetTokenRemote()
{
	Set httpRequest=##class(%Net.HttpRequest).%New()
	Set httpRequest.Timeout=..#SSTimeout
	Set httpRequest.Server=..#SSAddress
	Set httpRequest.Port = ..#SSPort
	
	If ..#IsHttps {
		Set httpRequest.Https=1
		Set httpRequest.SSLConfiguration=..#SSLConfigName ;..GetSSLConfigurationName()
		Set httpRequest.SSLCheckServerIdentity=0  ;过期证书的服务器是否访问
	}
	
	Set httpRequest.ContentCharset="UTF-8"
	Do httpRequest.SetHeader("Authorization",..#Authorization)
	Do httpRequest.InsertFormData("grant_type","api_credentials")
	Set retStr=httpRequest.Post("/dhccam-mediway2021/token/generate")
	Set dataStream=httpRequest.HttpResponse.Data

	Quit:dataStream="" ""
 	Set outputObj=##class(web.DHCMDTExternalServicesToken).%New()
 	Do ##class(ext.util.JsonObject).JSONStreamToObject(dataStream,.outputObj,"")
 	
 	Quit outputObj
}

ClassMethod GetSSLConfigurationName() As %String
{
    new $namespace
    zn "%SYS"
    if ('##class(Security.SSLConfigs).Exists(..#SSLConfigName)) {
        set st = ##class(Security.SSLConfigs).Create(..#SSLConfigName)
        return:(st '= 1) "UnableToCreateSSLConfig:"_$System.Status.GetErrorText(st)
    }
    return ..#SSLConfigName
}

/// w ##class(web.DHCMDTExternalServices).Test()
ClassMethod Test()
{
	Set httpRequest=##class(%Net.HttpRequest).%New()
	Set httpRequest.Server="www.baidu.com"
	Set httpRequest.Port = "80"
	
	If ..#IsHttps {
		b ;333
		Set httpRequest.Https=1
		Set httpRequest.SSLConfiguration="qqa.me"
	}
	
	Set httpRequest.ContentCharset="UTF-8"
	Set retStr=httpRequest.Post("/")
	b ;retStr
	w retStr
	Set dataStream=httpRequest.HttpResponse.Data
	
 	Set:dataStream'="" retStr=dataStream.ReadLine()
 	Quit retStr
}

}
