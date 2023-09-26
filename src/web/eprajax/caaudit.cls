Class web.eprajax.caaudit Extends %CSP.Page [ Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s userSignedData = $Get(%request.Data("UserSignedData",1),"")
	s userCert = $Get(%request.Data("UserCert",1),"")
	s containerName = $Get(%request.Data("ContainerName",1),"")
	
	s serverRan = %session.Get("ServerRan")
	
	d ..WriteClientInfoToSession(userSignedData,userCert,containerName)
	
	s ret = ##Class(CA.DigitalSignatureService).VerifyCertAndSignedData(userCert,serverRan,userSignedData)
	w ret
	q $$$OK
}

ClassMethod WriteClientInfoToSession(AUserSignedData As %String, AUserCert As %String, AContainerName As %String)
{
	s %session.Data("UserSignedData") = AUserSignedData
	s %session.Data("UserCert") = AUserCert
	s %session.Data("ContainerName") = AContainerName
}

}
