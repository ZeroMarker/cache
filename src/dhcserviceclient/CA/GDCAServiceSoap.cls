Class dhcserviceclient.CA.GDCAServiceSoap Extends %RegisteredObject [ ProcedureBlock ]
{

/// 广东CA代理类
Parameter LOCATION;

Parameter SOAPVERSION = 1.1;

Parameter TIMEOUT = 5;

Parameter APPID = "DHCHIS";

Parameter OPERID = "DHCHIS";

Parameter SIGNVER = "P7";

Property Location As %String [ InitialExpression = {..#LOCATION}, Transient ];

/// This service supports both SOAP 1.1 and SOAP 1.2.
Property SOPAVersion As %String [ InitialExpression = {..#SOAPVERSION}, Transient ];

Property TimeOut As %Integer [ InitialExpression = {..#TIMEOUT}, Transient ];

Property appID As %String [ InitialExpression = {..#APPID}, Transient ];

Property operID As %String [ InitialExpression = {..#OPERID}, Transient ];

Property signVer As %String [ InitialExpression = {..#SIGNVER}, Transient ];

/// http://bswg2.95105813.cn:8080/AGW/services/AGWService.AGWServiceHttpSoap11Endpoint" 
Method NewHttpSOAP() [ Internal ]
{
	Set ..Location = $p(..Location,"?",1)
	
	if ..SOPAVersion = "1.2" {
		Set httpSOAP=##Class(dhcserviceclient.CA.GDCA.AGWServiceHttpSoap12Endpoint).%New()
		Set httpSOAP.Location = ..Location_".AGWServiceHttpSoap12Endpoint/"
		Set httpSOAP.Timeout = ..TimeOut
	} else {
		Set httpSOAP=##Class(dhcserviceclient.CA.GDCA.AGWServiceHttpSoap11Endpoint).%New()
		Set httpSOAP.Location = ..Location_".AGWServiceHttpSoap11Endpoint/"
		Set httpSOAP.Timeout = ..TimeOut
	}
    
	Quit httpSOAP
}

Method CreateTimeStamp(timeStampRequest As %String) As %String [ WebMethod ]
{
	Set serv = ..NewHttpSOAP()
	
	Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.SeStampReq).%New()
	Set req.appID   = ..appID
	Set req.operID  = ..operID
	Set req.orgData = ""
	Set (ret,resp) = ""
	Set resp = serv.WSSealTimeStamp(req)
	
	if resp="" {
		Quit ""
	} elseif resp.sealData = "" {
		Set ret = resp.result
	} else {
		Set ret = resp.sealData
	}
	Quit ret
}

Method CreateTimeStampRequest(orgData As %String) As %String [ WebMethod ]
{
 	Quit orgData
}

//w ##Class(CA.GDCAServiceTst).GenRandom()

Method GenRandom(randLen As %Integer = 16) As %String [ WebMethod ]
{
	Set serv = ..NewHttpSOAP()
	
    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.RandReq).%New()
    Set req.randLen = randLen
    
	Quit serv.WSGenRand(req).randString
}

//

Method GetServerCert() As %String [ WebMethod ]
{
	Set serv = ..NewHttpSOAP()
	
    Quit serv.WSGetCert().sigCert
}

Method SignData(plainText As %String) As %String [ WebMethod ]
{
 	Set serv = ..NewHttpSOAP()
 	
    if (..signVer = "P7") {
	    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.P7SignReq).%New()
	    Set req.appID = ..appID
	    Set req.operID = ..operID
	    //Set req.sigCert = ^CF("CA","ServerCert")
	    Set req.sigCert = ..GetServerCert()
	    Set req.orgData = plainText
    
		Quit serv.WSP7Sign(req).signedData
    } else {
	    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.P1SignReq).%New()
	    Set req.appID = ..appID
	    Set req.operID = ..operID
	    //Set req.sigCert = ^CF("CA","ServerCert")
	    Set req.sigCert = ..GetServerCert()
	    Set req.orgData = plainText
    
		Quit serv.WSP1Sign(req).signedData
    }
}

Method ValidateCertificate(bstrCert As %String) As %String [ WebMethod ]
{
	Set serv = ..NewHttpSOAP()
    
    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.CkCertReq).%New()
	Set req.appID  = ..appID
	Set req.operID  = ..operID
	Set req.cert = bstrCert
	
	Quit serv.WSCheckCert(req).result
}

Method VerifyCertAndSignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int [ WebMethod ]
{
	Set serv = ..NewHttpSOAP()
    
    Set ckCert = ..ValidateCertificate(bstrCert_inData)
    Quit:(ckCert'=0) ckCert 
    if (..signVer = "P7") {
	    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.P7VerifyReq).%New()
		Set req.appID  = ..appID
		Set req.operID  = ..operID
		Set req.sigCert = bstrCert
		//Set req.orgData = inData
		Set req.signedData = signedData
	
		Quit serv.WSP7Verify(req).result
    } else {
	    	    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.P1VerifyReq).%New()
		Set req.appID  = ..appID
		Set req.operID  = ..operID
		Set req.sigCert = bstrCert
		Set req.orgData = inData
		Set req.signedData = signedData
	
		Quit serv.WSP1Verify(req).result
	}
}

Method VerifySignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int [ WebMethod ]
{
	Set serv = ..NewHttpSOAP()
    
    if (..signVer = "P7") {
	    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.P7VerifyReq).%New()
		Set req.appID  = ..appID
		Set req.operID  = ..operID
		Set req.sigCert = bstrCert
		//Set req.orgData = inData
		Set req.signedData = signedData
	
		Quit serv.WSP7Verify(req).result
    } else { 
	    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.P1VerifyReq).%New()
		Set req.appID  = ..appID
		Set req.operID  = ..operID
		Set req.sigCert = bstrCert
		Set req.orgData = inData
		Set req.signedData = signedData
	
		Quit serv.WSP1Verify(req).result
    }
}

Method VerifyTimeStamp(timeStampString As %String) As %xsd.int [ WebMethod ]
{
	Set serv = ..NewHttpSOAP()
    
    Set req = ##Class(dhcserviceclient.CA.GDCA.ax21.VeStampReq).%New()
	Set req.appID  = ..appID
	Set req.operID  = ..operID
	Set req.orgData = $p(timeStampString,"^",1)
	Set req.sealData = $p(timeStampString,"^",2)
	
	Quit serv.WSVerifyTimeStamp(req).result
}

Method test() As %String [ Internal, WebMethod ]
{
	s rand = ..GenRandom()
	s cert = ..GetServerCert()
	s sigd = ..SignData(rand)
	s tsRq = ..CreateTimeStampRequest(rand_sigd)
	s tsRp = ..CreateTimeStamp(tsRq)
	s vfcs = ..VerifyCertAndSignedData(cert, rand, sigd)
	s vfsd = ..VerifySignedData(cert, rand, sigd)
	s vfts = ..VerifyTimeStamp(tsRq)
	
	w "RandNum     :    "_rand,!
	w "Cert        :    "_cert,!
	w "SignedData  :    "_sigd,!
	w "tsResquest  :    "_tsRq,!
	w "tsResponse  :    "_tsRq,!
	w "VerifyCAS   :    "_vfcs,!
	w "VerifySign  :    "_vfsd,!
	w "VerifyTS    :    "_vfts
}

}
