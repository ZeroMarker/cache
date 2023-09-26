Class web.DHCENS.STBLL.CDRJSONV2.DOCU.Method.Content Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod getContentStream(id As %String) As %GlobalCharacterStream
{
	
	try{
		set stream=##class(%GlobalCharacterStream).%New()
		set obj=##class(User.EnsHOSDocument).%OpenId(id)
		set stream=obj.HOSDCContent
		d obj.%Save()
	}catch{
		set stream=##class(%GlobalCharacterStream).%New()
	}
	quit stream
}

}
