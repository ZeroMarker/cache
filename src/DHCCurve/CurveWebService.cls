Class DHCCurve.CurveWebService Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "CurveWebService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://127.0.0.1/trakcare/trak/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn";

Method GetUserName(UserID As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).GetUserName(UserID)
	Quit ret
}

Method HasContraDateTime(EpisodeID As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).HasContraDateTime(EpisodeID)
	Quit ret
}

Method PatientList(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).PatientList(Input)
	Quit ret
}

Method PatientEpsoides(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).PatientEpsoides(Input)
	Quit ret
}

Method GetPatPregnancy(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).GetPatPregnancy(Input)
	Quit ret
}

Method SavePatCurve(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).SavePatCurve(Input)
	Quit ret
}

Method SavePatContration(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).SavePatContration(Input)
	Quit ret
}

Method GetPatCurve(Input As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).GetPatCurve(Input)
	Quit ret
}

Method DelPatContration(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).DelPatContration(Input)
	Quit ret
}

Method SavePatPreg(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).SavePatPreg(Input)
	Quit ret
}

Method DelPatPreg(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).DelPatPreg(Input)
	Quit ret
}

Method GetPatAllPreg(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).GetPatAllPreg(Input)
	Quit ret
}

Method GetPatAllContration(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).GetPatAllContration(Input)
	Quit ret
}

Method GetPatAllGraphData(Input As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).GetPatAllGraphData(Input)
	Quit ret
}

Method GetPatInfo(Episode As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).GetPatInfo(Episode)
	Quit ret
}

Method GetRecTitle(Episode As %String) As %String [ WebMethod ]
{
	Set ret=##Class(web.DHCCurveOperation).GetRecTitle(Episode)
	Quit ret
}

Method GetPatInfoXML(Episode As %String) As %String [ WebMethod ]
{
	//w ##Class(web.DHCCurveOperation).GetPatInfoXML("5628769")
	Set ret=##Class(web.DHCCurveOperation).GetPatInfoXML(Episode)
	Quit ret
}

Method GetBirthRec(Episode As %String, rw As %String) As %String [ WebMethod ]
{
	//w ##Class(web.DHCCurveOperation).GetPatInfoXML("5628769")
	Set ret=##Class(web.DHCCurveOperation).GetBirthRec(Episode,rw)
	Quit ret
}

Method InsertNurRecBatchSign(EpisodeID As %String, UserID As %String, RecType As %String, RecInfosHash As %String, MainSignCert As %String, MainSignValue As %String, ExpStr As %String = "") As %String [ WebMethod ]
{
	//w ##Class(web.DHCCurveOperation).GetPatInfoXML("5628769")
	Set ret=##Class(web.DHCNurSignVerify).InsertNurRecBatchSign(EpisodeID , UserID, RecType , RecInfosHash , MainSignCert, MainSignValue, ExpStr)
	Quit ret
}

Method GetPatInfoSigned(EpisodeID As %String) As %String [ WebMethod ]
{
	//w ##Class(web.DHCCurveOperation).GetPatInfoXML("5628769")
	Set ret=##Class(web.DHCCurveOperation).GetPatInfoSigned(EpisodeID)
	Quit ret
}

Method GetBirthRecSigned(EpisodeID As %String, rw As %String) As %String [ WebMethod ]
{
	//w ##Class(web.DHCCurveOperation).GetPatInfoXML("5628769")
	Set ret=##Class(web.DHCCurveOperation).GetBirthRecSigned(EpisodeID,rw)
	Quit ret
}

Method GetUsrIdByKey(UID As %String) As %String [ WebMethod ]
{
	//w ##Class(CA.UsrSignatureInfo).GetUsrIdByKey("1@5009SF0230105198311261010")
	Set ret=##Class(CA.UsrSignatureInfo).GetUsrIdByKey(UID)
	Quit ret
}

/// Creator：      panshuai
/// CreatDate：    2012-07-12
/// Description:   判断某科室是否使用CA,1为启用,0为不启用                      
/// Debug:         w ##Class(web.DHCNurCASignVerify).GetIsVerifyCA(102) 
Method GetIsVerifyCA(LocID As %String) As %String [ WebMethod ]
{
	s ret=0
	q:'$d(^CANur("Start")) 0
	q:^CANur("Start")'="Y" 0
	i $D(^CANurBirth("CTLocIDs")) d
	 .i ^CANurBirth("CTLocIDs")[("^"_LocID_"^") s ret=1
	q ret
}

Method GetFinalAccountFlag(EpisodeId As %String) As %String [ WebMethod ]
{
	
	q ##class(DHCEPRFS.BI.BIAdmMRStatus).GetFinalAccountFlag(EpisodeId)
}

}
