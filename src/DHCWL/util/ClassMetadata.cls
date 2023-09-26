Class DHCWL.util.ClassMetadata Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod GetMetadataProperty(className, ByRef clsProperty)
{
	n (className, clsProperty)
	s clsObj=##class(%Dictionary.ClassDefinition).%OpenId(className)
	s count=clsObj.Properties.Count()
	f current=1:1:count d
	.s propertyName=clsObj.Properties.GetAt(current).Name
	.s clsProperty(propertyName)=""
}

}
