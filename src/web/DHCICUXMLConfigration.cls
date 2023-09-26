Import SQLUser

Class web.DHCICUXMLConfigration Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//w ##class(web.DHCICUXMLConfigration).getXMLConfigration("N","AN","672","1")

ClassMethod GetXMLConfigration(ctcpType As %String, docType As %String, docCtloc As %String, docVersion As %Float) As %Library.String
{
	n (ctcpType,docType,docCtloc,docVersion)
	s id="",objectId="",maxVersion=docVersion
	f  s id=$o(^DHCICUXMLConfig(id)) q:id=""  d
	.Set configration = ##class(User.DHCICUXMLConfig).%OpenId(id)
	.//s ^tmpSjq("ICUXCCtcpType")=configration.ICUXCCtcpType
	.//s ^tmpSjq("ICUXCDocumentType")=configration.ICUXCDocumentType
	.i configration.ICUXCCtcpType=ctcpType,configration.ICUXCDocumentType=docType,configration.ICUXCLocationDr=docCtloc,+configration.ICUXCVersion>docVersion,+configration.ICUXCVersion>maxVersion d
	..s objectId=id
	..s maxVersion=configration.ICUXCVersion
	q objectId
}

}
