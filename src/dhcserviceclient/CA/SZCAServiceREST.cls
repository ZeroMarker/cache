Class dhcserviceclient.CA.SZCAServiceREST Extends %RegisteredObject
{

/// This is the completed URL to access the http gateway. E.g. http://ip:port/ssoworker
Parameter Location As %String = "http://120.197.49.53:8081/api";

/// This is the name of the Service
Parameter ServiceName As %String = "/api/";

/// This is the URL used to access the http gateway
Property Location As %String [ InitialExpression = {..#Location}, Transient ];

/// This is the name of the Service
Property ServiceName As %String [ InitialExpression = {..#ServiceName}, Transient ];

Method NewHttpReq() As %Net.HttpRequest
{
	s request = ##class(%Net.HttpRequest).%New()
	s request.Server = $p($p(##this.Location,"/",3),":",1)
	s request.Port   = $p($p(##this.Location,":",3),"/",1)
	q request
}

Method CreateTimeStamp(timeStampRequest As %String) As %String [ WebMethod ]
{
	w ""
}

Method CreateTimeStampRequest(originalData As %String) As %String [ WebMethod ]
{
	w ""
}

Method GetTimeStampInfo(timeStampString As %String, informationCode As %xsd.int) As %String [ WebMethod ]
{
	w ""
}

Method VerifyTimeStamp(timeStampString As %String) As %xsd.int [ WebMethod ]
{
	w ""
}

Method GenRandom() As %String [ WebMethod ]
{
	s httprequest=..NewHttpReq()
	
	d httprequest.InsertFormData("length", "16")
	d httprequest.InsertFormData("asymAlgo","RSA")
	d httprequest.Post(..ServiceName_"generateRandomData")
	
	s response=httprequest.HttpResponse
	s (ret, content, jsonObj, msg, errorCode) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {}
		else {
			while (ret.AtEnd = 0) {
				s content=content_$ZSTRIP(ret.Read(32000),"*C",,$c(1)_$c(2))
			}			
		}
	}
	
	s jsonObj    = ##class(CA.Util.Json).FromJson(content)
	s msg        = jsonObj.GetAt("msg")
	s errorCode  = jsonObj.GetAt("errorCode")
	
	q:(errorCode=0) jsonObj.GetAt("randomData")
	q msg
}

Method GetCertInfo(bstrCert As %String, type As %xsd.int) As %String [ WebMethod ]
{
}

Method GetServerCert() As %String [ WebMethod ]
{
	q ""
	s httprequest=..NewHttpReq()
	//http://100.100.99.6:8081/api/exportCert?certType=1&certCode=test
	d httprequest.InsertFormData("certType", "1")
	d httprequest.InsertFormData("certCode","test")
	d httprequest.Post(..ServiceName_"exportCert")
	
	s response=httprequest.HttpResponse
	s (ret, content, jsonObj, msg, errorCode) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {}
		else {
			while (ret.AtEnd = 0) {
				s content=content_$ZSTRIP(ret.Read(32000),"*C",,$c(1)_$c(2))
			}			
		}
	}
	
	s jsonObj    = ##class(CA.Util.Json).FromJson(content)
	s msg        = jsonObj.GetAt("msg")
	s errorCode  = jsonObj.GetAt("errorCode")
	
	q:(errorCode=0) jsonObj.GetAt("certData")
	q msg
}

Method SignData(InData As %String) As %String [ WebMethod ]
{
	q ""
	s httprequest=..NewHttpReq()
	//http://120.197.49.53:8081/api/sign?certCode=test&hashAlgo=SHA1&signMethod=P7&srcData=hello&withContent=1
	d httprequest.InsertFormData("certCode", "test")
	//d httprequest.InsertFormData("asymAlgo","RSA")
	d httprequest.InsertFormData("hashAlgo","SHA256")
	d httprequest.InsertFormData("signMethod","P7")
	d httprequest.InsertFormData("srcData",InData)
	d httprequest.InsertFormData("withContent","1")
	d httprequest.Post(..ServiceName_"sign")
	
	s response=httprequest.HttpResponse
	s (ret, content, jsonObj, msg, errorCode) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {}
		else {
			while (ret.AtEnd = 0) {
				s content=content_$ZSTRIP(ret.Read(32000),"*C",,$c(1)_$c(2))
			}			
		}
	}
	
	s jsonObj    = ##class(CA.Util.Json).FromJson(content)
	s msg        = jsonObj.GetAt("msg")
	s errorCode  = jsonObj.GetAt("errorCode")
	
	q:(errorCode=0) jsonObj.GetAt("signedData")
	q msg
}

Method ValidateCertificate(bstrCert As %String) As %xsd.int [ WebMethod ]
{
	s httprequest=..NewHttpReq()
	//http://120.197.49.53:8081/api/validateCert?asymAlgo=SM2&certData=MIIDCDCCAq2gAwIBAgINMTUyMzkzNzUxODU2MzAMBggqgRzPVQGDdQUAMHYxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ2RvbmcxEjAQBgNVBAcMCUd1YW5nemhvdTEVMBMGA1UECgwMZWRhb3RlY2guY29tMRUwEwYDVQQLDAxFZGFvVGVjaCBTTTIxETAPBgNVBAMMCEVkYW9UZWNoMCAXDTE4MDQxNzAzNTgzOFoYDzIxMTgwNDE3MDM1ODM4WjBjMQswCQYDVQQGEwJDTjESMBAGA1UECAwJR3Vhbmdkb25nMRIwEAYDVQQHDAlHdWFuZ3pob3UxFTATBgNVBAoMDGVkYW90ZWNoLmNvbTEVMBMGA1UECwwMRWRhb1RlY2ggU00yMIIBMzCB7AYHKoZIzj0CATCB4AIBATAsBgcqhkjOPQEBAiEA/////v////////////////////8AAAAA//////////8wRAQg/////v////////////////////8AAAAA//////////wEICjp+p6dn140TVqeS89lCafzl4n1FauPkt28vUFNlA6TBEEEMsSuLB8ZgRlfmQRGajnJlI/jC7/yZgvhcVpFiTNMdMe8Nzai9PZ3nFm9zuNraSFT0KmHfMYqR0AC3zLlITnwoAIhAP////7///////////////9yA99rIcYFK1O79Ak51UEjAgEBA0IABFBJDTVIgOx+uM1qj0UHRcJOvivtlnBIU1D379plgmI7pjFGSRa1svMDbyhYnKd3F1rfZPiwYwbxAUqNoMPZJBijUzBRMAwGA1UdEwEB/wQCMAAwIAYDVR0OAQH/BBYEFN0y8mSJ4bx7v5i/BZ/d13W0fb46MB8GA1UdIwQYMBaAFAF5YHWwiTTmBf3B+9ovyeADESMVMAwGCCqBHM9VAYN1BQADRwAwRAIgOPbDn0UN0YwPAzz6uiFoSqQP+H+Tg0Ipw1/SILciXZMCIGFsLOi2LuhtTaj4OFgmUuNDyMgQ8R3GgzlMKiT+s6QQ
	d httprequest.InsertFormData("asymAlgo", "SM2")
	d httprequest.InsertFormData("certData",bstrCert)
	d httprequest.Post(..ServiceName_"validateCert")
	
	s response=httprequest.HttpResponse
	s (ret, content, jsonObj, msg, errorCode) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {}
		else {
			while (ret.AtEnd = 0) {
				s content=content_$ZSTRIP(ret.Read(32000),"*C",,$c(1)_$c(2))
			}			
		}
	}
	
	s jsonObj    = ##class(CA.Util.Json).FromJson(content)
	s msg        = jsonObj.GetAt("msg")
	s errorCode  = jsonObj.GetAt("errorCode")
	
	q:(errorCode=0) ""
	q msg
}

Method VerifyCertAndSignedData(bstrCert As %String, inData As %String, signedData As %String) As %String [ WebMethod ]
{
	s validated = ..ValidateCertificate(bstrCert)
	q:(validated'="") validated
	
	s verifyRet = ..VerifySignedData(bstrCert, inData, signedData)
	q:(verifyRet=0) ""
	q verifyRet
}

Method VerifySignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int [ WebMethod ]
{
	s httprequest=..NewHttpReq()
	d httprequest.InsertFormData("signMethod","P7")
	d httprequest.InsertFormData("signedData",signedData)
	d httprequest.InsertFormData("hashAlgo","")
	d httprequest.InsertFormData("certCode", "")
	d httprequest.InsertFormData("certData", "")
	d httprequest.InsertFormData("asymAlgo", "SM2")
	d httprequest.Post(..ServiceName_"signVerify")
	//d httprequest.Post(..ServiceName_"signVerify",2)	
	s response=httprequest.HttpResponse
	s (ret, content, jsonObj, msg, errorCode) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {}
		else {
			while (ret.AtEnd = 0) {
				s content=content_$ZSTRIP(ret.Read(32000),"*C",,$c(1)_$c(2))
			}			
		}
	}
	s jsonObj    = ##class(CA.Util.Json).FromJson(content)
	s msg        = jsonObj.GetAt("msg")
	s errorCode  = jsonObj.GetAt("errorCode")
	q:(errorCode=0) 0
	q errorCode_"||"_msg
}

/// d ##Class(dhcserviceclient.CA.SZCAServiceREST).test()
ClassMethod test()
{
	//http://120.197.49.53:8081/api
	//http://100.100.99.6:8081/api/generateRandomData?length=32&asymAlgo=RSA
	s httprequest=##class(%Net.HttpRequest).%New()
	s httprequest.Server="100.100.99.6"
	s httprequest.Port=8081
	d httprequest.InsertFormData("length", "32")
	d httprequest.InsertFormData("asymAlgo","RSA")
	
	d httprequest.Post("/api/generateRandomData")
	
	s response=httprequest.HttpResponse
	w "ContentInfo:"_response.ContentInfo,!
	w "ContentLength:"_response.ContentLength,!
	s content=""
	s (ret,errinfo,rand) = ""
	if $isobject(response.Data) {
		s ret = response.Data
		if (0=ret.Size) {}
		else {
			while (ret.AtEnd = 0) {
				s content=content_$ZSTRIP(ret.Read(32000),"*C",,$c(1)_$c(2))
			}			
		}
		w "response	:	"_content,!
		
	}
	
	//d content.Rewind()
	s jsonObj = ##class(CA.Util.Json).FromJson(content)
	w "msg		    :	"_jsonObj.GetAt("msg"),!
	w "errorCode	:	"_jsonObj.GetAt("errorCode"),!
	w "randomData	:	"_jsonObj.GetAt("randomData"),!
	w "httprequest.HttpResponse.Data"
}

}
