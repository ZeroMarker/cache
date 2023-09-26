Class web.Util.Config Extends (%RegisteredObject, %XML.Adaptor)
{

Property WebServiceUserName As %String [ InitialExpression = "dhwebservice" ];

Property WebServicePassword As %String [ InitialExpression = "dhwebservice" ];

Property CspUserName As %String [ InitialExpression = "dhsyslogin" ];

Property CspPassword As %String [ InitialExpression = "1q2w3e4r%T6y7u8i9o0p" ];

Property Key As %String [ InitialExpression = "iMedical" ];

/// D ##class(web.Util.Config).GenXML("dhwebservice","dhwebservice","dhsyslogin","1q2w3e4r%T6y7u8i9o0p","iMedical")
ClassMethod GenXML(wsusername, wspwd, cspusername, csppwd, key)
{
	Quit:wspwd="" -101_"^webservice password is null"
	Quit:csppwd="" -102_"^csp password is null"
	Quit:wsusername="" -103_"^webservice username is null"
	Quit:cspusername="" -104_"^csp username is null"
	Set obj = ##class(web.Util.Config).%New()
	
	Set obj.WebServiceUserName = wsusername
	Set encwspwd = ##class(web.Util.Encryption).SimpleEncrypt(wspwd,key)
	Set obj.WebServicePassword = encwspwd
	Set obj.CspUserName = cspusername
	Set enccsppwd = ##class(web.Util.Encryption).SimpleEncrypt(csppwd,key)
	set obj.CspPassword = enccsppwd
	Set xml =""
	do obj.XMLExportToString(.xml)
	Set obj=""
	Set path = ##class(ext.util.String).GetPhysicalPath("/dthealth/web","/csp/xml")
	
	Set xmlFile = ##class(%File).%New()
	
	Set xmlFile.Name = path_"iMedical.xml"
	do xmlFile.Open("NW")
	do xmlFile.Write(xml)
	do xmlFile.Flush()
	Do xmlFile.Close()
	Set xmlFile=""
}

}
