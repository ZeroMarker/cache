Class web.DHCClinicXMLConfiguration Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetConfigurationIdByName(docName As %String) As %String
{
	s id="",result=""
	f  s id=$o(^DHCClinicXMLConfig(id)) q:id=""  d
	.s configuration=##class(User.DHCClinicXMLConfiguration).%OpenId(id)
	.s configurationName=configuration.XCDocumentName
	.q:configurationName'=docName
	.s result=configuration.%Id()
	
	q result
}

ClassMethod GetContent(docName As %String) As %GlobalCharacterStream
{
	// w ##class(web.DHCClinicXMLConfiguration).GetContent("BPConfiguration40.xml")
	s id="",result=""
	f  s id=$o(^DHCClinicXMLConfig(id)) q:id=""  d
	.s configuration=##class(User.DHCClinicXMLConfiguration).%OpenId(id)
	.s configurationName=configuration.XCDocumentName
	.q:configurationName'=docName
	.s result=configuration.XCDocumentContent
	
	q result
}

}
