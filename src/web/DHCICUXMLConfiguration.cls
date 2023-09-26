Class web.DHCICUXMLConfiguration Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetConfigurationIdByName(docName As %String) As %String
{
	s id="",result=""
	f  s id=$o(^DHCICUXMLConfig(id)) q:id=""  d
	.s configuration=##class(User.DHCICUXMLConfig).%OpenId(id)
	.s configurationName=configuration.ICUXCDocumentName
	.q:configurationName'=docName
	.s result=configuration.%Id()
	
	q result
}

}
